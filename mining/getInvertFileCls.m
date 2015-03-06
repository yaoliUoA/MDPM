function getInvertFileCls(classId)

addpath('../');
init;
dirName = 'mining/';
conf.dataDir = strrep(conf.dataDir,dirName,'');
if ~exist(fullfile(conf.dataDir,conf.invertFileDir),'dir')
    mkdir(fullfile(conf.dataDir,conf.invertFileDir));
end

load(fullfile(conf.dataDir,conf.cnnDir_Combined,['cnnFea_',num2str(classId)]));

[feaSorted,feaIndex] = sort(cnnFeaCombined,'descend');
file = false(size(cnnFeaCombined));

for i = 1:size(cnnFeaCombined,2)
    file(feaIndex(1:conf.numTopActivation,i),i)=1;
end

save(fullfile(conf.dataDir,conf.invertFileDir,['invertFile_',num2str(classId),'.mat']),'file','-v7.3');