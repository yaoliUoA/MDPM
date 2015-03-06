function feaEncodingMultiscaleSPM_lda(classId)

addpath('../');
init;
dirName = 'encoding/';
conf.dataDir = strrep(conf.dataDir,dirName,'');

if ~exist(fullfile(conf.dataDir,conf.feaDir,num2str(classId)),'dir')
    mkdir(fullfile(conf.dataDir,conf.feaDir,num2str(classId)));
end
load(fullfile(conf.dataDir,conf.detComDir_lda,['detCom_',num2str(conf.numDetSelected),'.mat']));
feaTrain = [];
feaTest = [];

imdb = load(fullfile(conf.dataDir, conf.imdb));
imIndex = find(imdb.images.class == classId);
imList = imdb.images.class==classId;
labelList = imdb.images.isTrain(imList);
trainList = find(labelList);
testList = find(~labelList);
% compute SPM linear index at different scales

indexSPM = cell(4,1);

fprintf('%d/%d training/testing\n',length(trainList),length(testList));

feaTrain = [];
%get training feature
for i = 1:length(trainList)
    disp(i);
     imName = imdb.images.name{imIndex(trainList(i))};
     im = imread(fullfile(conf.imgDir,imName));
     if size(im,3)~=3
         im = cat(3,im,im,im);
     end
     [imHeight,imWidth,imDepth] = size(im);
     if imHeight>imWidth
         im = imresize(im,[NaN,256],'bilinear');
     else
         im = imresize(im,[256,NaN],'bilinear');
     end
     [imHeight,imWidth,imDepth] = size(im);
     
     
     %level one
    load(fullfile(conf.dataDir,conf.cnnDir_Local,num2str(classId),['cnnFea_',num2str(trainList(i)),'.mat']));
    feaDim = [floor((imHeight-conf.patchSize)/conf.stepSize)+1,floor((imWidth-conf.patchSize)/conf.stepSize)+1];
    index = sub2ind([feaDim(1),feaDim(2)],repmat([1:floor(feaDim(1)/2)]',[1,floor(feaDim(2)/2)]),repmat(1:floor(feaDim(2)/2),[floor(feaDim(1)/2),1]));
    indexSPM(1) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([floor(feaDim(1)/2)+1:feaDim(1)]',[1,floor(feaDim(2)/2)]),repmat(1:floor(feaDim(2)/2),[feaDim(1)-floor(feaDim(1)/2),1]));
    indexSPM(2) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([1:floor(feaDim(1)/2)]',[1,feaDim(2)-floor(feaDim(2)/2)]),repmat(floor(feaDim(2)/2)+1:feaDim(2),[floor(feaDim(1)/2),1]));
    indexSPM(3) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([floor(feaDim(1)/2)+1:feaDim(1)]',[1,feaDim(2)-floor(feaDim(2)/2)]),repmat(floor(feaDim(2)/2)+1:feaDim(2),[feaDim(1)-floor(feaDim(1)/2),1]));
    indexSPM(4) = {index(:)};
    scores = wCombined*cnnFea;%+repmat(biasCombined,[1,size(cnnFea,2)]);
    scoresMax = max(scores,[],2);
    feaTrainTempL1 = [scoresMax;max(scores(:,indexSPM{1}),[],2);...
        max(scores(:,indexSPM{2}),[],2);max(scores(:,indexSPM{3}),[],2);max(scores(:,indexSPM{4}),[],2)];

    %level two
    load(fullfile(conf.dataDir,conf.cnnDir_Local_L2,num2str(classId),['cnnFea_',num2str(trainList(i)),'.mat']));
    feaDim = [floor((imHeight-conf.patchSizeL2)/conf.stepSize)+1,floor((imWidth-conf.patchSizeL2)/conf.stepSize)+1];
    index = sub2ind([feaDim(1),feaDim(2)],repmat([1:floor(feaDim(1)/2)]',[1,floor(feaDim(2)/2)]),repmat(1:floor(feaDim(2)/2),[floor(feaDim(1)/2),1]));
    indexSPM(1) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([floor(feaDim(1)/2)+1:feaDim(1)]',[1,floor(feaDim(2)/2)]),repmat(1:floor(feaDim(2)/2),[feaDim(1)-floor(feaDim(1)/2),1]));
    indexSPM(2) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([1:floor(feaDim(1)/2)]',[1,feaDim(2)-floor(feaDim(2)/2)]),repmat(floor(feaDim(2)/2)+1:feaDim(2),[floor(feaDim(1)/2),1]));
    indexSPM(3) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([floor(feaDim(1)/2)+1:feaDim(1)]',[1,feaDim(2)-floor(feaDim(2)/2)]),repmat(floor(feaDim(2)/2)+1:feaDim(2),[feaDim(1)-floor(feaDim(1)/2),1]));
    indexSPM(4) = {index(:)};
    scores = wCombined*cnnFea;%+repmat(biasCombined,[1,size(cnnFea,2)]);
    scoresMax = max(scores,[],2);
    feaTrainTempL2 = [scoresMax;max(scores(:,indexSPM{1}),[],2);...
    max(scores(:,indexSPM{2}),[],2);max(scores(:,indexSPM{3}),[],2);max(scores(:,indexSPM{4}),[],2)];

    %level three
    load(fullfile(conf.dataDir,conf.cnnDir_Local_L3,num2str(classId),['cnnFea_',num2str(trainList(i)),'.mat']));
    feaDim = [floor((imHeight-conf.patchSizeL3)/conf.stepSize)+1,floor((imWidth-conf.patchSizeL3)/conf.stepSize)+1];
    index = sub2ind([feaDim(1),feaDim(2)],repmat([1:floor(feaDim(1)/2)]',[1,floor(feaDim(2)/2)]),repmat(1:floor(feaDim(2)/2),[floor(feaDim(1)/2),1]));
    indexSPM(1) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([floor(feaDim(1)/2)+1:feaDim(1)]',[1,floor(feaDim(2)/2)]),repmat(1:floor(feaDim(2)/2),[feaDim(1)-floor(feaDim(1)/2),1]));
    indexSPM(2) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([1:floor(feaDim(1)/2)]',[1,feaDim(2)-floor(feaDim(2)/2)]),repmat(floor(feaDim(2)/2)+1:feaDim(2),[floor(feaDim(1)/2),1]));
    indexSPM(3) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([floor(feaDim(1)/2)+1:feaDim(1)]',[1,feaDim(2)-floor(feaDim(2)/2)]),repmat(floor(feaDim(2)/2)+1:feaDim(2),[feaDim(1)-floor(feaDim(1)/2),1]));
    indexSPM(4) = {index(:)};
    scores = wCombined*cnnFea;%+repmat(biasCombined,[1,size(cnnFea,2)]);
    scoresMax = max(scores,[],2);
    feaTrainTempL3 = [scoresMax;max(scores(:,indexSPM{1}),[],2);...
    max(scores(:,indexSPM{2}),[],2);max(scores(:,indexSPM{3}),[],2);max(scores(:,indexSPM{4}),[],2)];
    

    feaTrain = [feaTrain,max([feaTrainTempL1,feaTrainTempL2,feaTrainTempL3],[],2)];
end

save(fullfile(conf.dataDir,conf.feaDir,num2str(classId),['feaTrain_spmMulti_lda_',num2str(conf.numDetSelected),'.mat']),'feaTrain','-v7.3');

feaTest = [];
for i = 1:length(testList)
    disp(i);
     imName = imdb.images.name{imIndex(testList(i))};
     im = imread(fullfile(conf.imgDir,imName));
     if size(im,3)~=3
         im = cat(3,im,im,im);
     end
     [imHeight,imWidth,imDepth] = size(im);
     if imHeight>imWidth
         im = imresize(im,[NaN,256],'bilinear');
     else
         im = imresize(im,[256,NaN],'bilinear');
     end
     [imHeight,imWidth,imDepth] = size(im);
     %level one
    load(fullfile(conf.dataDir,conf.cnnDir_Local,num2str(classId),['cnnFea_',num2str(testList(i)),'.mat']));
    feaDim = [floor((imHeight-conf.patchSize)/conf.stepSize)+1,floor((imWidth-conf.patchSize)/conf.stepSize)+1];
    index = sub2ind([feaDim(1),feaDim(2)],repmat([1:floor(feaDim(1)/2)]',[1,floor(feaDim(2)/2)]),repmat(1:floor(feaDim(2)/2),[floor(feaDim(1)/2),1]));
    indexSPM(1) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([floor(feaDim(1)/2)+1:feaDim(1)]',[1,floor(feaDim(2)/2)]),repmat(1:floor(feaDim(2)/2),[feaDim(1)-floor(feaDim(1)/2),1]));
    indexSPM(2) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([1:floor(feaDim(1)/2)]',[1,feaDim(2)-floor(feaDim(2)/2)]),repmat(floor(feaDim(2)/2)+1:feaDim(2),[floor(feaDim(1)/2),1]));
    indexSPM(3) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([floor(feaDim(1)/2)+1:feaDim(1)]',[1,feaDim(2)-floor(feaDim(2)/2)]),repmat(floor(feaDim(2)/2)+1:feaDim(2),[feaDim(1)-floor(feaDim(1)/2),1]));
    indexSPM(4) = {index(:)};
    scores = wCombined*cnnFea;%+repmat(biasCombined,[1,size(cnnFea,2)]);
    scoresMax = max(scores,[],2);
    feaTestTempL1 = [scoresMax;max(scores(:,indexSPM{1}),[],2);...
        max(scores(:,indexSPM{2}),[],2);max(scores(:,indexSPM{3}),[],2);max(scores(:,indexSPM{4}),[],2)];

    %level two
    load(fullfile(conf.dataDir,conf.cnnDir_Local_L2,num2str(classId),['cnnFea_',num2str(testList(i)),'.mat']));
    feaDim = [floor((imHeight-conf.patchSizeL2)/conf.stepSize)+1,floor((imWidth-conf.patchSizeL2)/conf.stepSize)+1];
    index = sub2ind([feaDim(1),feaDim(2)],repmat([1:floor(feaDim(1)/2)]',[1,floor(feaDim(2)/2)]),repmat(1:floor(feaDim(2)/2),[floor(feaDim(1)/2),1]));
    indexSPM(1) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([floor(feaDim(1)/2)+1:feaDim(1)]',[1,floor(feaDim(2)/2)]),repmat(1:floor(feaDim(2)/2),[feaDim(1)-floor(feaDim(1)/2),1]));
    indexSPM(2) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([1:floor(feaDim(1)/2)]',[1,feaDim(2)-floor(feaDim(2)/2)]),repmat(floor(feaDim(2)/2)+1:feaDim(2),[floor(feaDim(1)/2),1]));
    indexSPM(3) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([floor(feaDim(1)/2)+1:feaDim(1)]',[1,feaDim(2)-floor(feaDim(2)/2)]),repmat(floor(feaDim(2)/2)+1:feaDim(2),[feaDim(1)-floor(feaDim(1)/2),1]));
    indexSPM(4) = {index(:)};
    scores = wCombined*cnnFea;%+repmat(biasCombined,[1,size(cnnFea,2)]);
    scoresMax = max(scores,[],2);
    feaTestTempL2 = [scoresMax;max(scores(:,indexSPM{1}),[],2);...
    max(scores(:,indexSPM{2}),[],2);max(scores(:,indexSPM{3}),[],2);max(scores(:,indexSPM{4}),[],2)];

    %level three
    load(fullfile(conf.dataDir,conf.cnnDir_Local_L3,num2str(classId),['cnnFea_',num2str(testList(i)),'.mat']));
    feaDim = [floor((imHeight-conf.patchSizeL3)/conf.stepSize)+1,floor((imWidth-conf.patchSizeL3)/conf.stepSize)+1];
    index = sub2ind([feaDim(1),feaDim(2)],repmat([1:floor(feaDim(1)/2)]',[1,floor(feaDim(2)/2)]),repmat(1:floor(feaDim(2)/2),[floor(feaDim(1)/2),1]));
    indexSPM(1) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([floor(feaDim(1)/2)+1:feaDim(1)]',[1,floor(feaDim(2)/2)]),repmat(1:floor(feaDim(2)/2),[feaDim(1)-floor(feaDim(1)/2),1]));
    indexSPM(2) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([1:floor(feaDim(1)/2)]',[1,feaDim(2)-floor(feaDim(2)/2)]),repmat(floor(feaDim(2)/2)+1:feaDim(2),[floor(feaDim(1)/2),1]));
    indexSPM(3) = {index(:)};
    index = sub2ind([feaDim(1),feaDim(2)],repmat([floor(feaDim(1)/2)+1:feaDim(1)]',[1,feaDim(2)-floor(feaDim(2)/2)]),repmat(floor(feaDim(2)/2)+1:feaDim(2),[feaDim(1)-floor(feaDim(1)/2),1]));
    indexSPM(4) = {index(:)};
    scores = wCombined*cnnFea;%+repmat(biasCombined,[1,size(cnnFea,2)]);
    scoresMax = max(scores,[],2);
    feaTestTempL3 = [scoresMax;max(scores(:,indexSPM{1}),[],2);...
    max(scores(:,indexSPM{2}),[],2);max(scores(:,indexSPM{3}),[],2);max(scores(:,indexSPM{4}),[],2)];
    

    feaTest = [feaTest,max([feaTestTempL1,feaTestTempL2,feaTestTempL3],[],2)];
end

save(fullfile(conf.dataDir,conf.feaDir,num2str(classId),['feaTest_spmMulti_lda_',num2str(conf.numDetSelected),'.mat']),'feaTest','-v7.3');
%clear feaTest;