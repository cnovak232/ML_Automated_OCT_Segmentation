function [feats,m_inds] = extractFeaturesMasked(sub_im,center_norm,option)
    if option == 1
        mask = imbinarize(sub_im);
    else
        mask = gradientEdgeDetection(sub_im,0.3);
    end
    mask = double(mask);
    mask = reshape(mask,[numel(mask) 1]);
    m_inds = find(mask);
    % compute all features and reshape
    [gm,gd] = imgradient(sub_im,'sobel');
    %W = graydiffweight(sub_im,refGrayVal)
    %gw = gradientweight(sub_im);
    [~,SI] = graycomatrix(sub_im);
    avg = double(imboxfilt(sub_im));
    [rows,cols] = ndgrid(1:size(sub_im,1),1:size(sub_im,2));
    rows = reshape(rows,[numel(rows) 1]);
    cols = reshape(cols,[numel(cols) 1]);
    sub_im = double(sub_im);
    sub_im_1d= reshape(sub_im,[numel(sub_im),1]);
    intensity = sub_im_1d;
    gm = reshape(gm,[numel(gm) 1]);
    gd = reshape(gd,[numel(gd) 1]);
    %gw = reshape(gw,[numel(gw) 1]);
    SI = reshape(SI,[numel(SI) 1]);
    avg = reshape(avg,[numel(avg) 1]);
    feats = [intensity(m_inds),gm(m_inds),gd(m_inds),avg(m_inds),rows(m_inds),cols(m_inds)];

    if center_norm
        mn = mean(feats,1);
        feats = feats - mn;
        feats = normc(feats);
    end
end

