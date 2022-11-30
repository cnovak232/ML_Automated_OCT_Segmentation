%% Driver file for MLSP Term Project
% Automatic Segmentatioin of OCT Images
% Members:

%% Read in spreadsheet info
oct_marks = {};
filename = './DVC_Marking_Points_10-11-2022.xlsx';
opt=detectImportOptions(filename);
shts=sheetnames(filename);

for i=1:numel(shts)
  oct_marks{i} = readtable(filename,opt,'Sheet',shts(i));
  % Suppress warnings???
end

%% Select image to process
lc_num = 'LC504'; % use this to specify which image to process
im_name = ['./Image_Decks_wMarks/1HOCT_',lc_num,'L0_24S.tif'];

num_images = 24;
oct_ims = {};
oct_ims_rs = {};
% Read in T-Slice images
for i = 1:num_images
    oct_ims{i}= imread(im_name,i);
    oct_ims_rs{i} = imresize(oct_ims{i},1/3);
end

%% Import all images
% imdir = './Image_Decks_wMarks';
% listname = dir(imdir);
% num_people = 8;
% num_images = 24;
% 
% oct_ims = cell(num_people,num_images);
% for p = 1:length(listname)
%     im_file = [imdir listname(p)];
%     for i = 1:num_images
%         oct_ims{i,p} = imread(im_file,i);
%     end
% end


%% Sort labels and images 
labels = ["bruch_op","bruch_mem_left","bruch_mem_right","ant_lam_lim",...
    "chor_scl_left","chor_scl_right"];

lc_ind = find(lc_num == shts);
im_marks = oct_marks{lc_ind};

mark_labels = sort_markings(im_marks,labels);

marked_ims = mark_images(oct_ims,mark_labels);

%% Pre process images
% Pass each images through a bilateral filter which removes noise while
% preserving edges. Most of the images should be low noise due pre
% processing from the data holder, but just in case. 

for i = 1:length(oct_ims)
    oct_ims{i} = imbilatfilt(oct_ims{i});
end

%% Seperate Features for Segmentation: Working
% For each pixel (or set of pixels) in a image create a feature vector:
% [pixel intesity, grad mag, grad dir,local_avg, xloc, yloc]
% Assign it a label based on marking lables 1-6: corresponding to the 6
% fields of the labels struct
% If not part of marking labels mark with a 0
% Create large matrix of these feature values for all the images
% with markings - use a variable number of data points with 0 label

tic

num_feats = 6;
train_data = [];
train_labels = [];
ims_for_class_0 = [1];

resize = 1;

oct = oct_ims;
% Resizing
if resize 
    oct = oct_ims_rs;
end

for i = 1:num_images-1
    sub_im = double(oct{i});

    % compute all features and reshape
    [gm,gd] = imgradient(sub_im,'sobel');
    %W = graydiffweight(sub_im,refGrayVal)
    W = gradientweight(sub_im);
    avg = imboxfilt(sub_im);
    [rows,cols] = ndgrid(1:size(sub_im,1),1:size(sub_im,2));
    rows = reshape(rows,[numel(rows) 1]);
    cols = reshape(cols,[numel(cols) 1]);
    sz = size(sub_im);
    sub_im_1d = reshape(sub_im,[numel(sub_im),1]);
    gm = reshape(gm,[numel(gm) 1]);
    gd = reshape(gd,[numel(gd) 1]);
    avg = reshape(avg,[numel(avg) 1]);
    feats = [sub_im_1d,gm,gd,avg,rows,cols];

    % mean center and normalize
    mn = mean(feats,1);
    feats = feats - mn;
    feats = normc(feats);

    % seperate mark locations into feature vectors with labels
    feat_vecs = cell(1,7);
    marks = mark_labels(i);
    if resize 
        % Resizing marks
        marks.bruch_op = marks.bruch_op / 3;
        marks.ant_lam_lim = marks.ant_lam_lim / 3;
        marks.bruch_mem_left = marks.bruch_mem_left / 3;
        marks.bruch_mem_right = marks.bruch_mem_right / 3;
        marks.chor_scl_left = marks.chor_scl_left / 3;
        marks.chor_scl_right = marks.chor_scl_right / 3;
    end
    fn = fieldnames(marks);
    marked_inds = [];
    for f = 1:length(fn)
        inds_2d = ceil(marks.(fn{f})); % x,y
        rows = inds_2d(:,2);
        cols = inds_2d(:,1);
        inds_1d = sub2ind(sz,rows,cols);
        feat_vecs{f} = feats(inds_1d,:);
        train_labels = [train_labels; f*ones(length(inds_1d),1)];
        marked_inds = [marked_inds; inds_1d];
    end

    % Assign feature vector to all the other non-desired cells. This will
    % be considered class 0. Do this only for the image inds in
    % 'ims_for_class_0'. The amount of data here can get very large. 
    if ( any(i == ims_for_class_0) )

        % find the major edge of the image to reduce amount of data
        edge_im = edge(sub_im,'canny',[0.05,0.3]);
        [~, r_ind] = max(edge_im,[],1);
        r_ind(r_ind == 1) = size(edge_im,1);
        start_row = min(r_ind) - 1;

        % loop through rest of pixels assigning feature vecs
        idx = 1;
        for p = 1:length(sub_im_1d)
            [row,col] = ind2sub(sz,p);
            if ( any(marked_inds(:) == p ) || row < start_row || sub_im_1d(p) == 0 )
                continue;
            end
            feat_vecs{7}(idx,:) = feats(p,:);
            idx = idx + 1;
        end
        train_labels = [train_labels; zeros(idx-1,1)];
    end

    % group all pixel feature vectors from each class/label
    all_classes = [];
    for c = 1:length(feat_vecs)
        all_classes = [all_classes; feat_vecs{c}];
    end

    train_data = [train_data; all_classes];
end


%% Knn Classification 
% Segement Test Image Pixels into feature vecs for input to KNN classifier

% use T-Slice 24 to test
im_num = 24;
test_im = oct_ims{im_num};
if resize
    test_im = oct_ims_rs{im_num};
end
test_im = double(test_im);
num_pix = numel(test_im);

% find the main edge to reduce num test pixels
edge_im = edge(test_im,'canny',[0.05,0.3]);
[~, r_ind] = max(edge_im,[],1);
zero_cols = find(r_ind == 1);
r_ind(zero_cols) = size(edge_im,1);
start_row = min(r_ind) - 1;

% seperate test im into features
[gm,gd] = imgradient(test_im,'sobel');
avg = imboxfilt(test_im);
[rows,cols] = ndgrid(1:size(sub_im,1),1:size(sub_im,2));
rows = reshape(rows,[numel(rows) 1]);
cols = reshape(cols,[numel(cols) 1]);
sz = size(test_im);
test_im_1d = reshape(test_im,[num_pix 1]);
gm = reshape(gm,[num_pix 1]);
gd = reshape(gd,[num_pix 1]);
avg = reshape(avg,[num_pix 1]);
feats = [test_im_1d,gm,gd,avg,rows,cols];
mn = mean(feats,1);
feats = feats - mn;
feats = normc(feats);

test_feats = zeros(size(feats));
idx = 1;
label_inds = [];
for p = 1:num_pix
    [row,col] = ind2sub(sz,p);
    if (row < start_row || test_im_1d(p) == 0 )
        continue;
    end
    test_feats(idx,: ) = feats(p,:);
    label_inds = [label_inds; row, col];
    idx=idx+1;
end
num_pts = idx;
test_feats = test_feats(1:num_pts,:);

% Run Knn Classification
knn = 1; % found using only the closest neighbor is best so far
knn_test_labels = zeros(num_pts,1);

for p = 1:num_pts
    dists = vecnorm( test_feats(p,:) - train_data,2,2);
    dists_labeled = [dists, train_labels];
    [dists_min, ind] = mink(dists,knn);
    k_dists = [dists_min, train_labels(ind) ];
    knn_test_labels(p) = mode(k_dists(:,2));
end

% Resolve labels and their locations 
knn_inds = find(knn_test_labels);
knn_labs = knn_test_labels(knn_inds);
knn_locs = label_inds(knn_inds,:);
knn_marks = cell(1,6); 
for i = 1:length(knn_labs)
    label = knn_labs(i);
    col_row = [ knn_locs(i,2),knn_locs(i,1)]; 
    knn_marks{label} = [knn_marks{label}; col_row]; % x,y
end

% Convert cell vec to struct for the mark_images() function
fn = fieldnames(mark_labels(1));
my_marks = cell2struct(knn_marks,fn,2);
if resize 
    % Resizing marks
    my_marks.bruch_op = my_marks.bruch_op * 3;
    my_marks.ant_lam_lim = my_marks.ant_lam_lim * 3;
    my_marks.bruch_mem_left = my_marks.bruch_mem_left * 3;
    my_marks.bruch_mem_right = my_marks.bruch_mem_right * 3;
    my_marks.chor_scl_left = my_marks.chor_scl_left * 3;
    my_marks.chor_scl_right = my_marks.chor_scl_right * 3;
end
test_im_cell{1} = oct_ims{im_num}; % input must be cell array
% Resize images
% test_im_cell{1} = imresize(test_im_cell{1},3);
im_marked = mark_images(test_im_cell,my_marks);

figure;
imshow(marked_ims{24});
title('Marked from spreadsheet')
figure;
imshow(im_marked{1});
title('Marked by algorithm')
toc

%% SVM Training - Needs testing

Mdl = fitcecoc(train_data,train_labels,"Coding","onevsall");
%% 

svm_labels = predict(Mdl,test_feats);
%% Random Forest

%% Extract Segment Features (Experimentation Section)

% Edge/Gradient Detection

% Edge option
edge_list = cell(1,size(oct_ims,2));

sub_im = oct_ims{24};
edge_imagei = edge(sub_im,'sobel',.05);
edge_list{1,i} = edge_imagei;
figure;
imshow(edge_imagei);

% % Gradient Option
% mag_list = cell(1,size(oct_ims,2));
% Gdir = cell(1,size(oct_ims,2));
% 
% for i = 1:size(oct_ims,2)
%     sub_im = oct_ims{1,i};
%     [Gmag,Gdir] = imgradient(sub_im,"sobel");
%     mag_list{1,i} = Gmag;
%     Gdir{1,i} = Gdir;
%     figure
%     imshowpair(Gmag,Gdir,'montage')
% end
% Graph Search





