% this is for PASCAL VOC 2012 dataset, the generated .txt file can be
% submitted to the evaluation server (http://host.robots.ox.ac.uk:8080/accounts/login/?next=/eval/upload/) 
function test_VOC_txt(classId)
addpath('../');
init;
dirName = 'classify/';
conf.dataDir = strrep(conf.dataDir,dirName,'');
imdb = load(fullfile(conf.dataDir, conf.imdb));
wCombined = [];
if ~exist(fullfile(conf.dataDir,conf.APDir),'dir')
    mkdir(fullfile(conf.dataDir,conf.APDir));
end

if strcmp(conf.modelName,'CaffeRef')
load(fullfile(conf.dataDir,conf.modelDir,['model_MDPM_',num2str(conf.numDetSelected),'_',num2str(classId),'_CaffeRef.mat']));
load(fullfile(conf.dataDir,conf.feaDir,['feaTest_',num2str(conf.numDetSelected),'_CaffeRef.mat']));
elseif strcmp(conf.modelName,'VGGVD')
load(fullfile(conf.dataDir,conf.modelDir,['model_MDPM_',num2str(conf.numDetSelected),'_',num2str(classId),'_VGGVD.mat']));
load(fullfile(conf.dataDir,conf.feaDir,['feaTest_',num2str(conf.numDetSelected),'_VGGVD.mat']));
end

scores = model.w*feaTest;
imTestList = find(~imdb.images.isTrain);
fid = fopen(fullfile(conf.dataDir,conf.APDir,['comp1_cls_test_',imdb.classes{classId},'.txt']),'w');
for i = 1:length(imTestList)
    imName = imdb.images.name{imTestList(i)};
    fprintf(fid,'%s %f\n',imName(1:end-4),scores(i));
end
fclose(fid);
