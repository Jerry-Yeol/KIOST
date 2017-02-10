clear all;
clc;

%% Read Raw Image

ref = multibandread('2013_0808_ref', [7921 7771 7], ...
    'float', 0 ,'bsq','ieee-le');
%%
label = multibandread('2013_0808_label1', [7921 7771 1], ...
    'int8', 0 ,'bsq','ieee-le');


%% Thresholding 

[col row] = find(rgb2gray(ref(:,:,5:7))>0.06);

for i = 1:size(col,1)
    ref(col(i),row(i),:) = 0;
end
%%
[col row] = find(ref(:,:,1)<0);

for i = 1:size(col,1)
    ref(col(i),row(i),:) = 0;
end
%% Make data


for i=1:7
    cropref(:,:,i) = imcrop(ref(:,:,i), [4817 3900 188 188]);
    testimage(:,i) = reshape(cropref(:,:,i), [size(cropref,1)*size(cropref,2), 1]);
    
    cropref2(:,:,i) = imcrop(ref(:,:,i), [5628 2648 250 250]);
    testimage2(:,i) = reshape(cropref2(:,:,i), [size(cropref2,1)*size(cropref2,2), 1]);
    
    trainimage(:,i) = reshape(ref(:,:,i), [size(ref,1)*size(ref,2), 1]);
end
%%
croplab=imcrop(label, [4817 3900 188 188]);
testlabel(:,2) = reshape(croplab, [size(croplab,1)*size(croplab,2), 1]);
testlabel(:,1) = ~testlabel(:,2);

croplab2=imcrop(label, [5628 2648 250 250]);
testlabel2(:,2) = reshape(croplab2, [size(croplab2,1)*size(croplab2,2), 1]);
testlabel2(:,1) = ~testlabel2(:,2);

trainlabel(:,2) = reshape(label, [size(label,1)*size(label,2), 1]);
trainlabel(:,1) = ~trainlabel(:,2);
