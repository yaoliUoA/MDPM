function cnnFeaCombineCls(classId)
addpath('../');
init;
addpath(conf.pathToMatCaffe);
dirName = 'cnn/';
conf.dataDir = strrep(conf.dataDir,dirName,'');
if ~exist(fullfile(conf.dataDir,conf.cnnDir_Combined),'dir')
    mkdir(fullfile(conf.dataDir,conf.cnnDir_Combined));
end
cnnFeaCombined = [];
indexImg = [];
imdb = load(fullfile(conf.dataDir, conf.imdb));
%trainList = find(imdb.images.isTrain==1 & imdb.images.class==classId);
imList = imdb.images.class==classId;
labelList = imdb.images.isTrain(imList);
trainList = find(labelList);
for i = 1:length(trainList)
%    disp(i);
    load(fullfile(conf.dataDir,conf.cnnDir_Local,num2str(classId),['cnnFea_',num2str(trainList(i)),'.mat']));
%    load(fullfile(conf.dataDir,conf.cnnDir_L2,num2str(classId),['cnnFea_',num2str(i),'.mat']));
%    load(fullfile(conf.dataDir,conf.cnnDir_L3,num2str(classId),['cnnFea_',num2str(i),'.mat']));
    cnnFeaCombined = [cnnFeaCombined,cnnFea];
    indexImg = [indexImg,i*ones(1,size(cnnFea,2))];
end

save(fullfile(conf.dataDir,conf.cnnDir_Combined,['cnnFea_',num2str(classId),'.mat']),'cnnFeaCombined','-v7.3');
save(fullfile(conf.dataDir,conf.cnnDir_Combined,['indexImg_',num2str(classId),'.mat']),'indexImg','-v7.3');

