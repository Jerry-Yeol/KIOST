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

label = label1 + 0.5*label0;

clear label0 label1
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

label = imrotate(label, theta, 'bilinear', 'crop');
label(label < 0) = 0;

%% Crop Image
result1 = imcrop(result1, [688 710 6345 6572]);
result2 = imcrop(result2, [688 710 6345 6572]);
label = imcrop(label, [688 710 6345 6572]);

%% Make dataset
for i=1:6446
    for j = 6219
        imwrite(label([i:i+127],[j:j+127]), sprintf('red%05d.jpg',i));
    end
end