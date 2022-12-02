function alg_marks = sort_alg_markings(labs,locs,st_names,scale)
marks = cell(1,6); 
for i = 1:length(labs)
    label = labs(i);
    col_row = [ locs(i,2),locs(i,1)]; 
    marks{label} = [marks{label}; col_row]; % x,y
end

% Convert cell vec to struct for the mark_images() function
fn = fieldnames(st_names(1));
alg_marks = cell2struct(marks,fn,2);

% Resizing marks
alg_marks.bruch_op = alg_marks.bruch_op * scale;
alg_marks.ant_lam_lim = alg_marks.ant_lam_lim * scale;
alg_marks.bruch_mem_left = alg_marks.bruch_mem_left * scale;
alg_marks.bruch_mem_right = alg_marks.bruch_mem_right * scale;
alg_marks.chor_scl_left = alg_marks.chor_scl_left * scale;
alg_marks.chor_scl_right = alg_marks.chor_scl_right * scale;


end

