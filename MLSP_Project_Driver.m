%% Driver file for MLSP Term Project
% Automatic Segmentatioin of OCT Images
% Members:

%% Read in Data
num_images = 24;
oct_ims = {};
% Read in images
for i = 1:num_images
    oct_ims{i}= imread('./Image_Decks/1HOCT_LC266L0_24S.tif',1);
end

% Read in labels

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
% SVM





