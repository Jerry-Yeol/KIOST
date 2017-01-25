clear all;
clc;

%% Read Image

ref = multibandread('2013_0808_ref', [7921 7771 7], ...
    'float', 0 ,'bsq','ieee-le');


label0 = multibandread('2013_0808_label0', [7921 7771 1], ...
    'int8', 0 ,'bsq','ieee-le');


label1 = multibandread('2013_0808_label1', [7921 7771 1], ...
    'int8', 0 ,'bsq','ieee-le');
%% result1 : RGB, result2 : IR

result1(:,:,1) = (ref(:,:,1) + ref(:,:,2))/2;
result1(:,:,2) = ref(:,:,3);
result1(:,:,3) = ref(:,:,4);


result2(:,:,1) = ref(:,:,5);
result2(:,:,2) = ref(:,:,6);
result2(:,:,3) = ref(:,:,7);

clear ref label0 label1;
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


%% Crop Image
result1 = imcrop(result1, [688 710 6345 6572]);
result2 = imcrop(result2, [688 710 6345 6572]);
%%

annot1 = result + label0.*20;
annot2 = result + label1.*20;
%%
