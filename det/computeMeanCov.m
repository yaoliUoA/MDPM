% compute mean and covariance
addpath('../');
init;
cnnFeaRandom = [];
dirName = 'det/';
conf.dataDir = strrep(conf.dataDir,dirName,'');

for classId = 1:conf.numClasses
    fprintf('Random sampling from class %d\n',classId);
    load(fullfile(conf.dataDir,conf.cnnDir_Combined,['cnnFea_',num2str(classId),'.mat']));
    index = randsample(size(cnnFeaCombined,2),2000);
    cnnFeaRandom = [cnnFeaRandom,cnnFeaCombined(:,index)];
end

disp('Computing covariance matrix');
cnnCov = cov(cnnFeaRandom');
disp('Computing mean');
cnnMean = mean(cnnFeaRandom,2);

save(fullfile(conf.dataDir,['mean_',num2str(conf.patchSize),'.mat']),'cnnMean');
save(fullfile(conf.dataDir,['cov_',num2str(conf.patchSize),'.mat']),'cnnCov');
