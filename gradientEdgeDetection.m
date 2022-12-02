function [index] = gradientEdgeDetection(img,threshold)
%GRADIENTEDGEDETECTION: takes in an image, uses its vertical graident to
%detect strong edges and saves the index of those edge pixels

img = double(img);
szImg = size(img);
gradImg = zeros(szImg);

%get the vertical gradient of the image
for i = 1:size(img,2)
    gradImg(:,i) = -1*gradient(img(:,i),2);
end

%normalize the image
gradImg = (gradImg-min(gradImg(:)))/(max(gradImg(:))-min(gradImg(:)));

% get the "invert" of the gradient image- not using currently
gradImgMinus = gradImg*-1+1; 

%if gradient is above threshold keep value if not set to zero
for i = 1: size(gradImg,1)
    for j = 1:size(gradImg,2)
        if gradImgMinus(i,j) >= threshold
            gradImgNew(i,j) = gradImg(i,j);
        else 
            gradImgNew(i,j) = 0;
        end 
    end 
end 


figure()
subplot(2,2,1)
imshow(uint8(img));
fontSize = 15;
title('Orginal Image');

% Label each blob with 8-connectivity, so we can make measurements of it
[labeledImage, numberOfBlobs] = bwlabel(gradImgNew, 8);



% Apply a variety of pseudo-colors to the regions.
coloredLabelsImage = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
% Display the pseudo-colored image.
%subplot(1, 2, 2);
subplot(2,2,2)
imshow(coloredLabelsImage);
title('Labeled Image', 'FontSize', fontSize);



%% Get the top 5most common blobs
x = labeledImage;
% For a vector x:
mode(x(find(x ~= mode(x))));
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

x(find(x == five)) = 0;

six = mode(x(find(x ~= mode(x, 'all'))), 'all');

count = 0;
%if the pixel isnt part of majors blobs set to 0
for i = 1: size(labeledImage,1)
    for j = 1:size(labeledImage,2)
        if labeledImage(i,j) == one || labeledImage(i,j) == two || labeledImage(i,j) == three || labeledImage(i,j) == four || labeledImage(i,j) == five || labeledImage(i,j) == six 
            New(i,j) = labeledImage(i,j);
            count = count +1;
            index(count,1) = i;
            index(count,2) = j;
            
        else 
            New(i,j) = 0;
        end 
    end 
end 

subplot(2,2,3)
coloredLabelsImage = label2rgb (New, 'hsv', 'k', 'shuffle');
imshow(coloredLabelsImage)
title('Major Edges')

subplot(2,2,4)
%plot index on image
imshow(uint8(img))
hold on
%sparse indeces
plot(index(1:20:end,2),index(1:20:end,1),'b*')
hold off



end

