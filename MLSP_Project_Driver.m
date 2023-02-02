%% Driver file for MLSP Term Project
% Automatic Segmentatioin of OCT Images
% Members:

%% Read in spreadsheet info and images
%Use the path to the "Eyes_Processed_2D_Final" folder location on your
%machine for the folder1 variable.
%Use the path to the "Drops Eyes (Preprocessed & Marked)" folder for the 
%folder2 variable. 
% folder1 = "C:\Users\Kelly Clingo\OneDrive - Johns Hopkins\MLSP\Eyes_Processed_2D_Final\";
% folder2 = "C:\Users\Kelly Clingo\OneDrive - Johns Hopkins\MLSP\Drops Eyes (Preprocessed & Marked)\";
% [images,oct_marks] = load_data(folder1,folder2);

%% Section 1: Read in spreadsheet info and init paths
addpath('./HandleImages/');
addpath('./ProcessData/');
oct_marks = {};
filename = './DVC_Marking_Points_10-11-2022.xlsx';
opt=detectImportOptions(filename);
shts=sheetnames(filename);

for i=1:numel(shts)
  oct_marks{i} = readtable(filename,opt,'Sheet',shts(i));
  % Suppress warnings???
end

%% Section 2a: Run this section to load 1 image deck and it's labels
load in single image
lc_num = 'LC504'; % use this to specify which image to process
scale = 3; % resize parameter for processing smaller images

[oct_ims,oct_ims_rs,mark_labels,marked_ims] = ...
     loadSingleImDeck(lc_num,oct_marks,shts,scale);

%% Section 2b: Run this section to load all image decks and labels
scale = 3;
[oct_ims,oct_ims_rs,mark_labels,marked_ims] = ...
    loadAllImDecks(oct_marks,shts,scale);

%% Section 3a: Seperate Features for Segmentation - Single Person (LC)
% Uses 23 LC images for training, images 24 for testing
% For each pixel (or set of pixels) in a image create a feature vector:
% [pixel intesity, grad mag, grad dir,local_avg, xloc, yloc]
% Assign it a label based on marking lables 1-6: corresponding to the 6
% fields of the labels struct
% If not part of marking labels mark with a 0
% Create large matrix of these feature values for all the images
% with markings - use a variable number of data points with 0 label

% oct = oct_ims;
% % Resizing
% if scale > 1 
%     oct = oct_ims_rs;
% end
% num_zero_ims = 2;
% 
% [train_data,train_labels] = computeTrainingDataMask(oct,mark_labels,scale,num_zero_ims);
% 
% % Segement Test Image Pixels into feature vecs 
% test_im_num = 24;
% test_im = oct{test_im_num};

% [test_feats, label_inds] = computeTestFeatsMask(test_im);

%% Section 3b: Seperate Features for SegmentationRun - All LC persons images
% Uses images 1:23 for each lc person (total of 8) for training
% Can select any of the 8 people's 24th images for testing
oct = oct_ims;
% Resizing
if scale > 1 
    oct = oct_ims_rs;
end

num_zero_ims = 1; % how many images to take 0 label pixels from per LC num
                  % i've found 1 works best
train_data = [];
train_labels = [];

for lc = 1:length(mark_labels)
    oct_lc = oct(:,lc);
    [train_data_lc,train_labels_lc] = computeTrainingDataMask(oct_lc,mark_labels{lc},scale,num_zero_ims);
    
    train_data = [train_data; train_data_lc];
    train_labels = [train_labels; train_labels_lc];
end

%notes
% 1 pretty good
% 2 not great
% 3 decent - non curve fit good - curve makes little weird
% 4 pretty good - gets bottom well
% 5 not great
% 6 good random forest
% 7 not great
% 8 decent - curve fit not optimal
test_im_loc = 8; % which lc person to test on (value 1 - 8) 
                 % view order of input folder for corresponding lc 

test_im_options = oct(24,:);
test_im = test_im_options{test_im_loc};

[test_feats, label_inds] = computeTestFeatsMask(test_im);

%% Section 4a: KNN Classification 
% Run Knn Classification
num_pts = size(test_feats,1);
knn = 9; % how many neighbors
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
alg_marks = sort_alg_markings(knn_labs,knn_locs,mark_labels{1},scale);
test_im_cell = oct_ims(24,test_im_loc); % input must be cell array
im_marked = mark_images(test_im_cell,alg_marks);

alg_line = linefind(alg_marks,size(oct_ims{1}),14);
im_fitted = mark_images(test_im_cell,alg_line);

figure;
imshow(marked_ims{24,test_im_loc});
title('Marked from spreadsheet');
imwrite(marked_ims{24,test_im_loc},'Sheet_Marked.png');

figure;
imshow(im_marked{1});
title('Marked by KNN algorithm');
imwrite(im_marked{1},'Knn_Marked.png');
pause(1); % there's a timing issues with the titles 

figure;
imshow(im_fitted{1});
title('KNN Curve Fit');
imwrite(im_fitted{1},'Knn_fit.png');

%% Section 4b:Random Forest
rng(1);
Mdl = TreeBagger(100,train_data,train_labels);

rf_labels = predict(Mdl,test_feats);

rf_labels = str2num(cell2mat(rf_labels));

% Resolve labels and their locations 
rf_inds = find(rf_labels);
rf_labs = rf_labels(rf_inds);
rf_locs = label_inds(rf_inds,:);
alg_marks = sort_alg_markings(rf_labs,rf_locs,mark_labels{1},scale);

test_im_cell = oct_ims(24,test_im_loc); % input must be cell array
alg_line = linefind(alg_marks,size(oct_ims{1}),12);
im_marked = mark_images(test_im_cell,alg_marks);
im_fitted = mark_images(test_im_cell,alg_line);

figure;
imshow(marked_ims{24,test_im_loc});
title('Marked from spreadsheet');

figure;
imshow(im_marked{1});
title('Random Forest'); 
imwrite(im_marked{1},'RF_marked.png');
pause(1); % there's a timing issues with the titles 

figure;
imshow(im_fitted{1});
title('Random Forest Linearized');
imwrite(im_fitted{1},'RF_Fit.png');

%% SVM Training - Doesn't work well
% 
% t = templateSVM('KernelFunction','gaussian');
% Mdl = fitcecoc(train_data,train_labels,'Learners',t);
% 
% svm_labels = predict(Mdl,test_feats);
% 
% % Resolve labels and their locations 
% svm_inds = find(svm_labels);
% svm_labs = svm_labels(svm_inds);
% svm_locs = label_inds(svm_inds,:);
% alg_marks = sort_alg_markings(svm_labs,svm_locs,mark_labels,3);
% 
% test_im_cell{1} = oct_ims{test_im_num}; % input must be cell array
% im_marked = mark_images(test_im_cell,alg_marks);
% figure;
% imshow(marked_ims{24});
% title('Marked from spreadsheet')
% figure;
% imshow(im_marked{1});
% title('Marked by algorithm')


%% Section for testing

% Edge/Gradient Detection

% sub_im = oct_ims{1};
% edge_im = edge(sub_im,'canny',.04);
% figure; 
% imshow(sub_im);
% title('Normal Image')
% figure;
% imshow(edge_im);
% title('Edge Image')
% mask = imbinarize(sub_im);
% emask = mask & edge_im;
% 
% figure;
% imshow(emask);
% 
% [gmag,gdir] = imgradient(sub_im,'sobel');
% 
% figure;
% imagesc(gmag);
% gmag_mask = gmag .* double(emask);
% figure;
% imagesc(gmag_mask);
% [gx,gy] = imgradientxy(gx,'central');
% figure;
% imagesc(gx);

% 
% mask = imbinarize(sub_im);
% % A = bwboundaries(sub_im);
% subplot(132);
% imshow(mask);
% title('Binary Mask based on Image');
% im_masked = sub_im .* uint8(mask);
% subplot(133)
% imshow(im_masked);
% title('Binary Mask applied to Image');
% [gm_mask_pre,gd_mask_pre] = imgradient(im_masked,'sobel');
% gm_masked = gm .* double(mask);
% figure; imagesc(gm_masked);
% figure; imagesc(gm_mask_pre);

% imw = abs(fft2(double(sub_im)));
% figure; 
% imagesc(db(imw));

% [G,SI] = graycomatrix(sub_im);
% figure;
% imagesc(SI);

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





