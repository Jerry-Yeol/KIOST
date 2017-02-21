%%
ref = multibandread('2013_0808_ref', [7921 7771 7], ...
    'float', 0 ,'bsq','ieee-le');


label = multibandread('2013_0808_label1', [7921 7771 1], ...
    'int8', 0 ,'bsq','ieee-le');


%% Thresholding 

[col row] = find(rgb2gray(ref(:,:,5:7))>0.06);

for i = 1:size(col,1)
    ref(col(i),row(i),:) = 0;
end

[col row] = find(ref(:,:,1)<0);

for i = 1:size(col,1)
    ref(col(i),row(i),:) = 0;
end


%% Make test data from full image
for i=1:7
    testfullimg(:,:,i) = imcrop(ref(:,:,i), [47 59 7676 7804]);
end
testfulllab =  imcrop(label, [47 59 7676 7804]);


k = 0;
for i=1:125:7679
    for j=1:125:7550
        k = k + 1;
        trainfullimg(:,:,:,k) = testfullimg(i:i+127,j:j+127,:);
        trainfulllab(:,:,k) = testfulllab(i:i+127,j:j+127);

    end
end
%% Save data
save('trainfullimg.mat', 'trainfullimg', '-v7.3');

save('trainfulllabel.mat', 'trainfulllab');

clear trainfullimg trainfulllab

%% train image1

for i=1:7
    trref(:,:,i) = imcrop(ref(:,:,i), [5072 2349 1002 1002]);
end

trlabel = imcrop(label, [5072 2349 1002 1002]);

k = 0;
for i=1:125:876
    for j=1:125:876
        k = k + 1;
        trainimg(:,:,:,k) = trref(i:i+127,j:j+127,:);
        trainlab(:,:,k) = trlabel(i:i+127,j:j+127);

    end
end

save('trainimg1.mat', 'trainimg');

save('trainlabel1.mat', 'trainlab');

clear trainimg trainlab
%% train image2


for i=1:7
    teref(:,:,i) = imcrop(ref(:,:,i), [4670 3730 386 386]);
end

telabel = imcrop(label, [4670 3730 386 386]);

k = 0;
for i=1:125:260
    for j=1:125:260
        k = k + 1;
        trainimg(:,:,:,k) = teref(i:i+127,j:j+127,:);
        trainlab(:,:,k) = telabel(i:i+127,j:j+127);

    end
end


save('trainimg2.mat', 'trainimg');

save('trainlabel2.mat', 'trainlab');