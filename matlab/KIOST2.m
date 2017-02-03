clear all;
clc;

%% Read Raw Image

ref = multibandread('2013_0808_ref', [7921 7771 7], ...
    'float', 0 ,'bsq','ieee-le');

label1 = multibandread('2013_0808_label1', [7921 7771 1], ...
    'int8', 0 ,'bsq','ieee-le');

%% Crop Data

for i=1:7
    cropref(:,:,i) = imcrop(ref(:,:,i), [5586 2624 342 342]);
end

croplabel(:,:) = imcrop(label1(:,:), [5586 2624 342 342]);

clear ref label1

%% Thresholding 

[col row] = find(rgb2gray(cropref(:,:,5:7))>0.06);

for i = 1:size(col,1)
    cropref(col(i),row(i),:) = 0;
end

%% Make data

for i=1:7
    imwrite(cropref(:,:,i), sprintf('ref%d.jpg',i));
end

imwrite(croplabel, 'label.jpg');
