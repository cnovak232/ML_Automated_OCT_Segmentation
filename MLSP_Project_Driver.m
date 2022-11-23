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
lc_num = 'LC471';
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
% apply filters

%% Extract Segment Features

% Edge/Gradient Detection

% Edge option
edge_list = cell(1,size(oct_ims,2));

for i = 1:size(oct_ims,2)
    sub_imagei = oct_ims{1,i};
    edge_imagei = edge(sub_image2,'canny',[0.05,0.3],1.7);
    edge_list{1,i} = edge_imagei;
    % figure 
    % imshow(sub_imagei)
end

% Gradient Option
magnitude_list = cell(1,size(oct_ims,2));
direction_list = cell(1,size(oct_ims,2));

for i = 1:size(oct_ims,2)
    sub_imagei = oct_ims{1,i};
    [Gmag,Gdir] = imgradient(sub_image2,"prewitt");
    magnitude_list{1,i} = Gmag;
    direction_list{1,i} = Gdir;
%     figure
%     imshowpair(Gmag,Gdir,'montage')
end
% Graph Search

%% Classify Feautres for Segmentation

% Random Forest
% KNN
% for l = 1:length(test_labels)
%     dists = vecnorm( test_weights(:,l) - train_weights);
%     dists_labeled = [dists', train_labels];
%     dists_sort = sortrows(dists_labeled);
%     k_dists = dists_sort(1:Knn(j),:);
%     knn_test_labels(l) = mode(k_dists(:,2));
% end
% SVM





