function mergingDetectors(classId)
% train exemplar svm for each class
addpath('../');
init;
dirName = 'det/';
conf.dataDir = strrep(conf.dataDir,dirName,'');

if ~exist(fullfile(conf.dataDir,conf.detDir_lda),'dir')
    mkdir(fullfile(conf.dataDir,conf.detDir_lda));
end
if ~exist(fullfile(conf.dataDir,conf.clusterDir_merge),'dir')
    mkdir(fullfile(conf.dataDir,conf.clusterDir_merge));
end

cluster = [];
load(fullfile(conf.dataDir,conf.clusterDir_init,['clusterClean_',num2str(classId),'.mat']));
load(fullfile(conf.dataDir,conf.cnnDir_Combined,['cnnFea_',num2str(classId),'.mat']));
load(fullfile(conf.dataDir,conf.cnnDir_Combined,['indexImg_',num2str(classId)]));
%models = cell(length(cluster),1);
w = [];%zeros(length(cluster),4096);

load(fullfile(conf.dataDir,['mean_',num2str(conf.patchSize),'.mat']));
load(fullfile(conf.dataDir,['cov_',num2str(conf.patchSize),'.mat']));
cnnCov = cnnCov + 0.01 * (eye(size(cnnCov)));

%% ranking all the initial clusters based on number of images they cover
imID = cell(length(cluster),1);
for i = 1:length(cluster)
    temp = cluster{i};
    imID{i} = unique(indexImg(temp));
end
numIm = cellfun(@length,imID);
numIm(numIm==1)=0; % remove rules only fire at one image
%[numImSorted,indexSort] = sort(numIm,'descend');
%% train detector
%flag = true(length(cluster),1);
numDet = 0;
maxIter = 10;
numDetMax = 100;
clusterMerge = cell(length(cluster),1);
while max(numIm)>0 && numDet<numDetMax
     numDet = numDet+1;
     fprintf('Detector %d\n',numDet);
     [imMax,indexMax] = max(numIm);
    
    % initial detector
    numIm(indexMax) = 0;
    clusterSelected = cluster{indexMax};
 %   fprintf('cluster %d selected\n',indexMax);
    cnnFeaSelected = cnnFeaCombined(:,clusterSelected);
    flag = 1;
    numIter = 1;
    while flag % greedy adding positive detections as positive training data to retrain the detector
    cnnMeanSelected = mean(cnnFeaSelected,2);
    wTemp = cnnCov\(cnnMeanSelected-cnnMean); 
    % detecting on all remained rules
    indexScore = find(numIm>0);
    score = ones(length(indexScore),1);
    for i = 1:length(score)
        clusterTest = cluster{indexScore(i)};
        cnnFeaTest = cnnFeaCombined(:,clusterTest);
        score(i) = mean(wTemp'*cnnFeaTest);
    end
    
    % check if positive detection exists
    indexScorePos = find(score>conf.detLDATh);
    if isempty(indexScorePos) || numIter>=maxIter
        flag = 0;
        w = [w;wTemp'];
        clusterMerge{numDet} = clusterSelected;
           
    else % positive detection found 
           fprintf('Detector %d, Iter %d\n',numDet,numIter);
           clusterSelected = unique([clusterSelected,cluster{indexScore(indexScorePos)}]);
           cnnFeaSelected = cnnFeaCombined(:,clusterSelected);
           numIm(indexScore(indexScorePos)) = 0;
           numIter = numIter+1;
    end
    end
end

clusterMerge = clusterMerge(~cellfun('isempty',clusterMerge));


imCover = zeros(length(clusterMerge),1);
for i = 1:length(clusterMerge)
cluster = clusterMerge{i};
imIDAll = indexImg(cluster);
imID = unique(imIDAll);
imCover(i) = length(imID);
end

[imCoverRank,rankIndex] = sort(imCover,'descend');
w = w(rankIndex,:);
save(fullfile(conf.dataDir,conf.detDir_lda,['detector_',num2str(classId),'.mat']),'w');
clusterMerge = clusterMerge(rankIndex);
save(fullfile(conf.dataDir,conf.clusterDir_merge,['cluster_',num2str(classId),'.mat']),'clusterMerge');





                