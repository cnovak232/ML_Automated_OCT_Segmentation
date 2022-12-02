function [oct_ims,oct_ims_rs,mark_labels,marked_ims] = loadSingleImDeck(lc_num,oct_marks,shts,scale)

im_name = ['./Image_Decks_wMarks/1HOCT_',lc_num,'L0_24S.tif'];

num_images = 24;
oct_ims = {};
oct_ims_rs = {};
% Read in T-Slice images
for i = 1:num_images
    im = imbilatfilt(imread(im_name,i));
    % zero out the little icon in the bottom left
    im(434:end,1:60) = 0;
    oct_ims{i} = im;
    oct_ims_rs{i} = imresize(im,1/scale);
end

% Sort labels and images 
labels = ["bruch_op","bruch_mem_left","bruch_mem_right","ant_lam_lim",...
    "chor_scl_left","chor_scl_right"];

lc_ind = find(lc_num == shts);
im_marks = oct_marks{lc_ind};

mark_labels = sort_markings(im_marks,labels);

marked_ims = mark_images(oct_ims,mark_labels);

end

