function labeled_marks = sort_markings(markings,labels)
% returns a 1x24 struct where each entry corresponds to the 
% markings of a T-slice. Each member of the struct holds the pixel coords
% of it's corresponding label. 

num_slices = 24;
num_segs = 6; % 0 to five

labeled_marks = struct;
for seg = 0:num_segs-1
    if seg == 0
        r = 'R_pixel_';
        z = 'Z_pixel_';
        T = 'T_Slice_';
    else
        r = ['R_pixel__' num2str(seg)];
        z = ['Z_pixel__' num2str(seg)];
        T = ['T_Slice__' num2str(seg)];
    end

    lab = labels(seg+1);
    for slice = 1:num_slices
        ind = find(slice == markings.(T));
        rs = markings.(r)(ind);
        zs = markings.(z)(ind);
        rs(rs <=0 ) = 1;
        zs(zs <= 0 ) = 1;
        labeled_marks(slice).(lab) = [rs,zs];
    end
end

end

