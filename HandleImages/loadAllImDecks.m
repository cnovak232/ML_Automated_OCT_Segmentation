function [oct_ims,oct_ims_rs,mark_labels,marked_ims] = loadAllImDecks(oct_marks,shts,scale)
%Import all images
imdir = './Image_Decks_wMarks/';
listname = dir(imdir);
num_people = 8;
num_images = 24;

% Sort labels and images 
labels = ["bruch_op","bruch_mem_left","bruch_mem_right","ant_lam_lim",...
    "chor_scl_left","chor_scl_right"];

oct_ims = cell(num_people,num_images);
oct_ims_rs = cell(num_people,num_images);
mark_labels = cell(1,num_people);
marked_ims = cell(num_people,num_images);
listname = listname(4:end);
for p = 1:length(listname)
    im_name = listname(p).name;
    im_file = [imdir im_name];
    for i = 1:num_images
        im = imbilatfilt(imread(im_file,i));
        % zero out the little icon in the bottom left
        im(434:end,1:60) = 0;
        oct_ims{i,p} = im;
        oct_ims_rs{i,p} = imresize(im,1/scale);
    end
    lc_num = im_name(7:11);
    lc_ind = find(lc_num == shts);
    im_marks = oct_marks{lc_ind};
    
    mark_labels{p} = sort_markings(im_marks,labels);
    
    oct = oct_ims(:,p)';
    marked_ims(p,:) = mark_images(oct,mark_labels{p});
end
 
end

