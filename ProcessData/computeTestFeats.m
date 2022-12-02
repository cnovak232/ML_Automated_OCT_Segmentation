function [test_feats,label_inds] = computeTestFeats(test_im)

num_pix = numel(test_im);
sz = size(test_im);
test_im_1d = reshape(test_im,[num_pix 1]);

% find the main edge to reduce num test pixels
edge_im = edge(test_im,'canny',[0.05,0.3]);
[~, r_ind] = max(edge_im,[],1);
zero_cols = find(r_ind == 1);
r_ind(zero_cols) = size(edge_im,1);
start_row = min(r_ind) - 1;

feats = extractFeatures(test_im,1);

test_feats = zeros(size(feats));
idx = 1;
label_inds = [];
for p = 1:num_pix
    [row,col] = ind2sub(sz,p);
    if (row < start_row || test_im_1d(p) == 0 )
        continue;
    end
    test_feats(idx,: ) = feats(p,:);
    label_inds = [label_inds; row, col];
    idx=idx+1;
end
num_pts = idx;
test_feats = test_feats(1:num_pts,:);
end

