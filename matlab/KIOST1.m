clear all;
clc;

%% Read Raw Image

ref = multibandread('2013_0808_ref', [7921 7771 7], ...
    'float', 0 ,'bsq','ieee-le');

%% Make Image(result1 : RGB, result2 : IR)

result1(:,:,1) = (ref(:,:,1) + ref(:,:,2))/2;
result1(:,:,2) = ref(:,:,3);
result1(:,:,3) = ref(:,:,4);


result2(:,:,1) = ref(:,:,5);
result2(:,:,2) = ref(:,:,6);
result2(:,:,3) = ref(:,:,7);

clear ref 

%% Read label imaage
label0 = multibandread('2013_0808_label0', [7921 7771 1], ...
    'int8', 0 ,'bsq','ieee-le');


label1 = multibandread('2013_0808_label1', [7921 7771 1], ...
    'int8', 0 ,'bsq','ieee-le');


%% Calculate angle

AD = sqrt(3885^2 + 3950^2);
AC = sqrt(2280^2 + 3950^2);
AB = 3950;

theta1 = acos(AB/AD);
theta2 = acos(AB/AC);

theta = (theta1 - theta2)*180/pi;

%% Rotate Image
result1 = imrotate(result1, theta, 'bilinear', 'crop');
result1(result1 < 0) = 0;

result2 = imrotate(result2, theta, 'bilinear', 'crop');
result2(result2 < 0) = 0;

label0 = imrotate(label0, theta, 'bilinear', 'crop');
label0(label0 > 0) = 0.5;

label1 = imrotate(label1, theta, 'bilinear', 'crop');
label1(label1 > 0) = 1;

label = label1 + label0;

clear label0 label1
%% Crop Image
train1 = imcrop(result1, [2271 1046 3071 3071]);
train2 = imcrop(result2, [2271 1046 3071 3071]);
trainannot = imcrop(label, [2271 1046 3071 3071]);

%% Make label dataset
% in 'label' folder 
k=1;

for i=1:23:2945
    for j = 1:23:2945
        imwrite(imcrop(trainannot,[i j 127 127]), sprintf('red%05d.jpg',k));
        k = k + 1;
    end
end

%% Make result1 dataset
% in 'result1' folder
k=1;

for i=1:23:2945
    for j = 1:23:2945
        imwrite(imcrop(train1,[i j 127 127]), sprintf('red%05d.jpg',k));
        k = k + 1;
    end
end

%% Make result2 dataset
% in 'result2' folder
k=1;

for i=1:23:2945
    for j = 1:23:2945
        imwrite(imcrop(train2,[i j 127 127]), sprintf('red%05d.jpg',k));
        k = k + 1;
    end
end

%% Test set

%% Crop image
test1 = imcrop(result1, [5226 2217 311 311]);
test2 = imcrop(result2, [5226 2217 311 311]);
testannot = imcrop(label, [5226 2217 311 311]);
%% Make label dataset
% in 'label' folder 
k=1;

for i=1:8:185
    for j = 1:8:185
        imwrite(imcrop(testannot,[i j 127 127]), sprintf('red%05d.jpg',k));
        k = k + 1;
    end
end

%% Make result1 dataset
% in 'result1' folder
k=1;

for i=1:8:185
    for j = 1:8:185
        imwrite(imcrop(test1,[i j 127 127]), sprintf('red%05d.jpg',k));
        k = k + 1;
    end
end

%% Make result2 dataset
% in 'result2' folder
k=1;

for i=1:8:185
    for j = 1:8:185
        imwrite(imcrop(test2,[i j 127 127]), sprintf('red%05d.jpg',k));
        k = k + 1;
    end
end
