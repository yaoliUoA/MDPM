% combineDetLDA

addpath('../');
init;
dirName = 'det/';
conf.dataDir = strrep(conf.dataDir,dirName,'');

if ~exist(fullfile(conf.dataDir,conf.detComDir_lda),'dir')
    mkdir(fullfile(conf.dataDir,conf.detComDir_lda));
end
wCombined = [];
for i = 1:conf.numClasses
    disp(i);
    load(fullfile(conf.dataDir,conf.detDir_lda,['detector_',num2str(i),'.mat']));
    if conf.numDetSelected<size(w,1)
        wCombined = [wCombined;w(1:conf.numDetSelected,:)];
    else
        wCombined = [wCombined;w];
    end
end

save(fullfile(conf.dataDir,conf.detComDir_lda,['detCom_',num2str(conf.numDetSelected),'.mat']),'wCombined','-v7.3');