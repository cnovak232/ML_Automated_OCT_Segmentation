%% Driver file for MLSP Term Project
% Automatic Segmentatioin of OCT Images
% Members:

%% Read in spreadsheet info
oct_marks = {};
filename = './DVC_Marking_Points_10-11-2022.xlsx';
opt=detectImportOptions(filename);
shts=sheetnames(filename);

for i=1:numel(shts)
  oct_marks{i}=readtable(filename,opt,'Sheet',shts(i));
end

%% Select image to process
lc_num = 'LC504'; % use this to specify which image to process
im_name = ['./Image_Decks_wMarks/1HOCT_',lc_num,'L0_24S.tif'];

num_images = 24;
oct_ims = {};
% Read in T-Slice images
for i = 1:num_images
    oct_ims{i}= imread(im_name,1);
end

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

num_feats = 6;
train_data = [];
train_labels = [];
ims_for_class_0 = 1;
for i = 1:length(oct_ims)-1 
    sub_im = double(oct_ims{i});

    % compute features and reshape
    [gm,gd] = imgradient(sub_im,'sobel');
    avg = imboxfilt(sub_im);
    sz = size(sub_im);
    sub_im_1d = reshape(sub_im,[1 numel(sub_im)]);
    gm = reshape(gm,[1 numel(gm)]);
    gd = reshape(gd,[1 numel(gd)]);
    avg = reshape(avg,[1 numel(avg)]);

    % seperate mark locations into feature vectors with labels
    feat_vecs = cell(1,7);
    marks = mark_labels(i);
    fn = fieldnames(marks);
    marked_inds = [];
    for f = 1:length(fn)
        inds_2d = round(marks.(fn{f})); % x,y
        rows = inds_2d(:,2);
        cols = inds_2d(:,1);
        inds_1d = sub2ind(sz,rows,cols);
        feats = zeros(length(inds_1d),6);
        feats(:,1) = sub_im_1d(inds_1d); % pixel intensity
        feats(:,2) = gm(inds_1d); % gradient mag
        feats(:,3) = gd(inds_1d); % gradient dir
        feats(:,4) = avg(inds_1d); % local average
        feats(:,5) = rows; % row location   
        feats(:,6) = cols; % col location
        feat_vecs{f} = feats;
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
        feats = zeros(length(sub_im_1d),6); % make this max length for speed
        for p = 1:length(sub_im_1d)
            [row,col] = ind2sub(sz,p);
            if ( any(marked_inds(:) == p ) || row < start_row || sub_im_1d(p) == 0 )
                continue;
            end
            feats(idx,1) = sub_im(p); % intensity
            feats(idx,2) = gm(p); % gradient mag
            feats(idx,3) = gd(p); % gradient dir
            feats(idx,4) = avg(p); % local avg
            feats(idx,5) = row;
            feats(idx,6) = col;
            idx = idx + 1;
        end
        feats = feats(1:idx,:);
        feat_vecs{7} = feats;
        train_labels = [train_labels; zeros(idx,1)];
    end

    % group all pixel feature vectors from each class/lable
    all_classes = [];
    for c = 1:length(feat_vecs)
        all_classes = [all_classes; feat_vecs{c}];
    end

%     Do we want to mean center and normalize the features vecs?
%     mn = mean(feats(:,1:4),1);
%     feats(:,1:4) = feats(:,1:4) - mn;
%     feats(:,1:4) = normc(feats(:,1:4));

    train_data = [train_data; all_classes];
end


%% Knn Classification 
% Segement Test Image Pixels into feature vecs for input to KNN classifier

% use T-Slice 24 to test
im_num = 24;
test_im = oct_ims{im_num};
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
sz = size(test_im);
test_im_1d = reshape(test_im,[1 num_pix]);
gm = reshape(gm,[1 num_pix]);
gd = reshape(gd,[1 num_pix]);
avg = reshape(avg,[1 num_pix]);
test_feats = zeros(num_pix,6); 
idx = 1;
for p = 1:num_pix
    [row,col] = ind2sub(sz,p);
    if (row < start_row || test_im_1d(p) == 0 )
        continue;
    end
    test_feats(idx,1) = test_im_1d(p); % intensity
    test_feats(idx,2) = gm(p); % gradient mag
    test_feats(idx,3) = gd(p); % gradient dir
    test_feats(idx,4) = avg(p); % local avg
    test_feats(idx,5) = row;
    test_feats(idx,6) = col;
    idx=idx+1;
end
num_pts = idx;
test_feats = test_feats(1:num_pts,:);

% Mean center and normalize if done for training data
% mn = mean(test_feats,1);
% test_feats = test_feats - mn;
% test_feats = normc(test_feats);


% Run Knn Classification
knn = 1; % found using only the closest neighbore is best so far
knn_test_labels = zeros(num_pts,1);
label_inds = zeros(num_pts,2);

for p = 1:num_pts
    dists = vecnorm( test_feats(p,:) - train_data,2,2);
    dists_labeled = [dists, train_labels];
    [dists_min, ind] = mink(dists,knn);
    k_dists = [dists_min, train_labels(ind) ];
    knn_test_labels(p) = k_dists(:,2);
    label_inds(p,:) = test_feats(p,5:6);
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
test_im_cell{1} = test_im; % input must be cell array
im_marked = mark_images(test_im_cell,my_marks);

figure;
subplot(211);
imshow(marked_ims{24});
title('Marked from spreadsheet')
subplot(212);
imshow(im_marked{1});
title('Marked by algorithm')

%% SVM Training - Needs testing

% Mdl = fitcecoc(train_data,train_labels);
%% Random Forest

%% Extract Segment Features (Experimentation Section)

% % Edge/Gradient Detection
% 
% % Edge option
% edge_list = cell(1,size(oct_ims,2));
% 
% for i = 1:size(oct_ims,2)
%     sub_im = oct_ims{1,i};
%     edge_imagei = edge(sub_im,'canny',[0.05,0.3],1.7);
%     edge_list{1,i} = edge_imagei;
%     % figure 
%     % imshow(sub_imagei)
% end
% 
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





