function [test_feats,label_inds] = computeTestFeatsMask(test_im)

sz = size(test_im);


[test_feats, m_inds] = extractFeaturesMasked(test_im,1);

[row,col] = ind2sub(sz,m_inds);
label_inds = [row, col];

end
