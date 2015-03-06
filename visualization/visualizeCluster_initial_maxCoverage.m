function visualizeCluster_initial_maxCoverage(classId)
addpath('../');
init;
dirName = 'visualization/';
conf.dataDir = strrep(conf.dataDir,dirName,'');
imdb = load(fullfile(conf.dataDir, conf.imdb));

cluster = [];
load(fullfile(conf.dataDir,conf.clusterDir_init,['clusterClean_',num2str(classId),'.mat']));
load(fullfile(conf.dataDir,conf.cnnDir_Combined,['indexImg_',num2str(classId)]));

%% ranking all the initial clusters based on number of images they cover
imID = cell(length(cluster),1);
for i = 1:length(cluster)
    temp = cluster{i};
    imID{i} = unique(indexImg(temp));
end
numIm = cellfun(@length,imID);
[maxCoverage,clusterId] = max(numIm);
%% 
cluster = cluster{clusterId};
imIDAll = indexImg(cluster);
imID = unique(imIDAll);
fprintf('Elements are from %d images\n',length(imID));
% start image index 
imIndex = unique(indexImg);
indexStart = zeros(1,length(imIndex));
for i = 1:length(imIndex)
indexStart(i) = find(indexImg==imIndex(i), 1);
end
imIDStart = indexStart(imIDAll);
linearIndex = cluster-imIDStart+1;
%[row,col] = ind2sub([13,13],linearIndex);
trainList = find(imdb.images.isTrain & imdb.images.class==classId);
imCropped = cell(length(imID),1);
k = 1;
for i = 1:length(imID)
    %imID2 = imID+(classId-1)*conf.numSamples;
    im = imread(fullfile(conf.imgDir, imdb.images.name{trainList(imID(i))}));
     if size(im,3)~=3
         im = cat(3,im,im,im);
     end
     [imHeight,imWidth,imDepth] = size(im);
     index = find(imIDAll==imID(i));
     if imHeight>imWidth
         im = imresize(im,[NaN,256],'bilinear');        
     else
         im = imresize(im,[256,NaN],'bilinear');
%         [row,col] = ind2sub([5,floor((size(im,1)-conf.patchSize)/conf.stepSize)+1,floor((size(im,2)-conf.patchSize)/conf.stepSize)+1],linearIndex(index));
     end
     [row,col] = ind2sub([floor((size(im,1)-conf.patchSize)/conf.stepSize)+1,floor((size(im,2)-conf.patchSize)/conf.stepSize)+1],linearIndex(index));
    for j = 1:length(index)
        try box = [(col(j)-1)*conf.stepSize+1,(row(j)-1)*conf.stepSize+1,conf.patchSize-1,conf.patchSize-1];
        catch err 
            keyboard;
        end
        imCropped{k} = imcrop(im,box);
        k = k+1;
    end
end
[H,W,N] = size(imCropped{1});
num = length(imCropped);
cols = round(sqrt(num));
rows = ceil(num/cols);  
imageColor= uint8(ones(rows*(H+1), cols*(W+1), N)*255);
for i = 1:num
    r= floor((i-1) / cols);
    c= mod(i-1, cols);
    imageColor((r*(H+1)+1):((r+1)*(H+1))-1,(c*(W+1)+1):((c+1)*(W+1))-1,:) = imCropped{i};
 end
figure,imshow(imageColor);
title(sprintf('class %d:%s, cluster %d',classId,imdb.images.class(classId),clusterId));

