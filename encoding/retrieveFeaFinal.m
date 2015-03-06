%function combineFeaFinal

addpath('../');
init;
dirName = 'encoding/';
conf.dataDir = strrep(conf.dataDir,dirName,'');
feaTrainCombined = [];
feaTestCombined = [];

for i = 1:conf.numClasses
    disp(i);
    if ~exist(fullfile(conf.dataDir,conf.feaDir,num2str(i),['feaTrain_spmMulti_lda_',num2str(conf.numDetSelected),'.mat']),'file')
        disp('File does not exist');
    else
    load(fullfile(conf.dataDir,conf.feaDir,num2str(i),['feaTrain_spmMulti_lda_',num2str(conf.numDetSelected),'.mat']));
    feaTrainCombined = [feaTrainCombined,feaTrain];
    load(fullfile(conf.dataDir,conf.feaDir,num2str(i),['feaTest_spmMulti_lda_',num2str(conf.numDetSelected),'.mat']));
    feaTestCombined = [feaTestCombined,feaTest];
    end
end

save(fullfile(conf.dataDir,conf.feaDir,['feaTrainCombined_spmMulti_lda_',num2str(conf.numDetSelected),'.mat']),'feaTrainCombined','-v7.3');
save(fullfile(conf.dataDir,conf.feaDir,['feaTestCombined_spmMulti_lda_',num2str(conf.numDetSelected),'.mat']),'feaTestCombined','-v7.3');