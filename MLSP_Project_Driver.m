%% Driver file for MLSP Term Project
% Automatic Segmentatioin of OCT Images
% Members:

%% Read in Data
num_images = 24;
oct_ims = {};
% Read in images
for i = 1:num_images
    oct_ims{i}= imread('1HOCT_LC266L0_24S.tif',1);
end

% Read in labels

%% Pre process images
% apply filters

%% Extract Segment Features

% Edge/Gradient Detection

% Graph Search

%% Classify Feautres for Segmentation

% Random Forest
% KNN
% SVM





