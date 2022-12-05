function [train_data, train_labels] = computeTrainingDataMask(oct,mark_labels,scale,num_zero_data)

% inits
train_data = [];
train_labels = [];
ims_for_class_0 = [1:num_zero_data];
center_norm = true;


for i = 1:length(oct)-1
    sub_im = oct{i};
    sz = size(sub_im);
    
    sub_im_1d= reshape(sub_im,[numel(sub_im),1]);

    [feats, m_inds] = extractFeaturesMasked(sub_im,center_norm,0);

    % seperate mark locations into feature vectors with labels
    marks = mark_labels(i);
    [feat_vecs,mlabels,marked_inds] = handleMarkedDataMasked(feats,marks,m_inds,sz,scale);
    train_labels = [train_labels; mlabels];

    % Assign feature vector to all the other non-desired cells. This will
    % be considered class 0. Do this only for the image inds in
    % 'ims_for_class_0'. The amount of data here can get very large. 
    if ( any(i == ims_for_class_0) )

        % loop through rest of pixels assigning feature vecs
        idx = 1;
        for p = 1:length(feats)
            if ( any(marked_inds(:) == p ) )
                continue;
            end
            feat_vecs{7}(idx,:) = feats(p,:);
            idx = idx + 1;
        end
        train_labels = [train_labels; zeros(idx-1,1)];
    end

    % group all pixel feature vectors from each class/label
    all_classes = [];
    for c = 1:length(feat_vecs)
        all_classes = [all_classes; feat_vecs{c}];
    end

    train_data = [train_data; all_classes];
end
