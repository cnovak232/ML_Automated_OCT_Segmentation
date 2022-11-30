%% Graph Based

%read in image
img = imread('./1HOCT_LC504L0_24S.tif');

% pad image with vertical column on both sides
szImg = size(img);
imgNew = zeros([szImg(1) szImg(2)+2]);
imgNew(:,2:1+szImg(2)) = img;


% get  vertical gradient image
gradImg = nan(szImgNew);
for i = 1:szImgNew(2)
    gradImg(:,i) = -1*gradient(imgNew(:,i),2);
end

%normalize the image
gradImg = (gradImg-min(gradImg(:)))/(max(gradImg(:))-min(gradImg(:)));

% get the "invert" of the gradient image.
gradImgMinus = gradImg*-1+1; 

%if gradient is above threshold keep value if not set to zero
for i = 1: size(gradImg,1)
    for j = 1:size(gradImg,2)
        if gradImgMinus(i,j) >= 0.505
            gradImgNew(i,j) = gradImgMinus(i,j);
        else 
            gradImgNew(i,j) = 0;
        end 
    end 
end 





figure()
imshow(img);
fontSize = 15;
title('Orginal Image');

% Label each blob with 4-connectivity, so we can make measurements of it
[labeledImage, numberOfBlobs] = bwlabel(gradImgNew, 4);



% Apply a variety of pseudo-colors to the regions.
coloredLabelsImage = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
% Display the pseudo-colored image.
%subplot(1, 2, 2);
figure(2)
imshow(coloredLabelsImage);
title('Labeled Image', 'FontSize', fontSize);



%% 
x = labeledImage;
% For a vector x:
mode(x(find(x ~= mode(x))))
% In general, if x is a matrix (valid from R2018b onwards)- ignore most
% common (assuming background)

%save the top 4 most commone "blobs"
one = mode(x(find(x ~= mode(x, 'all'))), 'all');

x(find(x == one)) = 0;

two = mode(x(find(x ~= mode(x, 'all'))), 'all');

x(find(x == two)) = 0;

three = mode(x(find(x ~= mode(x, 'all'))), 'all');

x(find(x == three)) = 0;

four = mode(x(find(x ~= mode(x, 'all'))), 'all');

x(find(x == four)) = 0;

five = mode(x(find(x ~= mode(x, 'all'))), 'all');


%if the pixel isnt part of majors blobs set to 0
for i = 1: size(labeledImage,1)
    for j = 1:size(labeledImage,2)
        if labeledImage(i,j) == one || labeledImage(i,j) == two || labeledImage(i,j) == three || labeledImage(i,j) == four || labeledImage(i,j) == five
            New(i,j) = labeledImage(i,j);
        else 
            New(i,j) = 0;
        end 
    end 
end 

figure()
coloredLabelsImage = label2rgb (New, 'hsv', 'k', 'shuffle');
imshow(coloredLabelsImage)
title('Major Edges')