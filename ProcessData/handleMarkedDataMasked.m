function [feat_vecs,train_labels,marked_inds] = handleMarkedData(feats,marks,m_inds,sz,scale)

% Resizing marks
marks.bruch_op = marks.bruch_op / scale;
marks.ant_lam_lim = marks.ant_lam_lim / scale;
marks.bruch_mem_left = marks.bruch_mem_left / scale;
marks.bruch_mem_right = marks.bruch_mem_right / scale;
marks.chor_scl_left = marks.chor_scl_left / scale;
marks.chor_scl_right = marks.chor_scl_right / scale;

fn = fieldnames(marks);
feat_vecs = cell(1,7);
marked_inds = [];
train_labels = [];
for f = 1:length(fn)
    inds_2d = ceil(marks.(fn{f})); % x,y
    rows = inds_2d(:,2);
    cols = inds_2d(:,1);
    inds_1d = sub2ind(sz,rows,cols);
    [~,~,new_inds] = intersect(inds_1d,m_inds);
    feat_vecs{f} = feats(new_inds,:);
    train_labels = [train_labels; f*ones(length(new_inds),1)];
    marked_inds = [marked_inds; new_inds];
end

end