img = imread('./1HOCT_LC266L0_24S.tif');
subplot(1,3,1)
% figure;
imagesc(img); colormap gray;
title('Orginal Image')

% blur image
img = imgaussfilt(img,1.5);

subplot(1,3,2)
% figure;
imagesc(img); colormap gray;
title('Gaussian Filtered Image')

[BW,thesh,Gx,Gy] = edge(img,'sobel',.05);


subplot(1,3,3)
% figure;
imagesc(BW); colormap gray;
title('Sobel Edge Detection')

figure()
subplot(2,1,1)
imagesc(Gx); colormap gray;
title('Horizontal Gradient')
subplot(2,1,2)
imagesc(Gy); colormap gray;
title('Vertical Gradient')
%% Graph Based

img = imread('./1HOCT_LC266L0_24S.tif');
% pad image with vertical column on both sides
szImg = size(img);
imgNew = zeros([szImg(1) szImg(2)+2]);
imgNew(:,2:1+szImg(2)) = img;

szImgNew = size(imgNew);

% get  vertical gradient image
gradImg = nan(szImgNew);
for i = 1:szImgNew(2)
    gradImg(:,i) = -1*gradient(imgNew(:,i),2);
end

%normalize the image
gradImg = (gradImg-min(gradImg(:)))/(max(gradImg(:))-min(gradImg(:)));

% get the "invert" of the gradient image.
gradImgMinus = gradImg*-1+1; 

for i = 1: size(gradImg,1)
    for j = 1:size(gradImg,2)
        if gradImg(i,j) <= 0.5
            gradImgNew(i,j) = gradImg(i,j);
        else 
            gradImgNew(i,j) = 0;
        end 
    end 
end 

%inverse = -1*(gradImgNew);


%grayImage = imread('image.jpeg');
binaryImage = gradImgNew(:,1) > 200;
% Crop off huge white frame surrounding the image.
%binaryImage = binaryImage(46:1058, 1094:1295);
subplot(1, 2, 1);
imshow(img);
fontSize = 15;
title('Binary Image', 'FontSize', fontSize);
% Label each blob with 8-connectivity, so we can make measurements of it
[labeledImage, numberOfBlobs] = bwlabel(gradImgNew, 4);

% for i = 1: size(labeledImage,1)
%     for j = 1:size(labeledImage,2)
%         if labeledImage(i,j) ~= 0
%             labeledImage(i,j) = 0;
%         else 
%             labeledImage(i,j) = 1;
%         end 
%     end 
% end 


% Apply a variety of pseudo-colors to the regions.
coloredLabelsImage = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
% Display the pseudo-colored image.
subplot(1, 2, 2);
imshow(coloredLabelsImage);
title('Labeled Image', 'FontSize', fontSize);


