%this is for PASCAL VOC 2007 dataset
addpath('../');
init;
dirName = 'classify/';
conf.dataDir = strrep(conf.dataDir,dirName,'');
imdb = load(fullfile(conf.dataDir, conf.imdb));
wCombined = [];
if strcmp(conf.modelName,'CaffeRef')
for i = 1:length(imdb.classes)
    load(fullfile(conf.dataDir,conf.modelDir,['model_MDPM_',num2str(conf.numDetSelected),'_',num2str(i),'_CaffeRef.mat']));
    wCombined = [wCombined; single(model.w)];
end
load(fullfile(conf.dataDir,conf.feaDir,['feaTest_',num2str(conf.numDetSelected),'_CaffeRef.mat']));
elseif strcmp(conf.modelName,'VGGVD')
for i = 1:length(imdb.classes)
    load(fullfile(conf.dataDir,conf.modelDir,['model_MDPM_',num2str(conf.numDetSelected),'_',num2str(i),'_VGGVD.mat']));
    wCombined = [wCombined; single(model.w)];
end
load(fullfile(conf.dataDir,conf.feaDir,['feaTest_',num2str(conf.numDetSelected),'_VGGVD.mat']));
end
 
gtLabel = zeros(size(feaTest,2),length(imdb.classes));
for i = 1:length(imdb.classes)
    fid = fopen(fullfile(conf.splitDir,[imdb.classes{i},'_test.txt']));
    C_train = textscan(fid,'%s %d');
    gtLabel(:,i) = double(C_train{2});
end

scores = wCombined*feaTest;
AP = zeros(length(imdb.classes),1);
for i = 1:length(imdb.classes)
    scoreCls = scores(i,:)';
    gtLabelCls = gtLabel(:,i);
    scoreCls = scoreCls(gtLabelCls~=0);
    gtLabelCls = gtLabelCls(gtLabelCls~=0);
    AP(i) = EvalAP(scoreCls,gtLabelCls);
    fprintf('%s: %.4f\n',imdb.classes{i},AP(i)*100);
end
fprintf('Mean AP: %.4f\n',mean(AP)*100);
%save(fullfile(conf.dataDir,conf.APDir,['AP_spm_',num2str(conf.numDetSelected),'.mat']),'AP');



