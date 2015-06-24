function train_VOC(classId)
addpath('../');
init;
dirName = 'classify/';
conf.dataDir = strrep(conf.dataDir,dirName,'');
if ~exist(fullfile(conf.dataDir,conf.modelDir),'dir')
    mkdir(fullfile(conf.dataDir,conf.modelDir));
end
imdb = load(fullfile(conf.dataDir, conf.imdb));
if strcmp(conf.modelName,'CaffeRef')
   load(fullfile(conf.dataDir,conf.feaDir,['feaTrain_',num2str(conf.numDetSelected),'_CaffeRef.mat']));
elseif strcmp(conf.modelName,'VGGVD')
    load(fullfile(conf.dataDir,conf.feaDir,['feaTrain_',num2str(conf.numDetSelected),'_VGGVD.mat']));
else

end
fid = fopen(fullfile(conf.splitDir,[imdb.classes{classId},'_trainval.txt']));
C_train = textscan(fid,'%s %d');
trainLabel = double(C_train{2});
feaTrain = sparse(double(feaTrain(:,trainLabel~=0)))';
trainLabel = trainLabel(trainLabel~=0);
% 5-fold cross validation
disp('Cross Validation');
%C = [0.001,0.005,0.01,0.05,0.1,0.2,0.5,1,2,5,10,50,100];
C = [0.01,0.1,0.2,0.5,1,1.2,1.5,2,5,10,50,100]*0.000001;
acc = zeros(length(C),1);
% train 67 one-vs-all svm
for i = 1:length(C)
    fprintf('Iteration %d:',i);
    acc(i) = train(trainLabel,feaTrain,['-c ',num2str(C(i)),' -q -v 5']);
end
[maxValue,maxIndex] = max(acc);
C_final = C(maxIndex);

model = train(trainLabel,feaTrain,['-q -c ',num2str(C_final)]);
if strcmp(conf.modelName,'CaffeRef')
save(fullfile(conf.dataDir,conf.modelDir,['model_MDPM_',num2str(conf.numDetSelected),'_',num2str(classId),'_CaffeRef.mat']),'model');
elseif strcmp(conf.modelName,'VGGVD')
save(fullfile(conf.dataDir,conf.modelDir,['model_MDPM_',num2str(conf.numDetSelected),'_',num2str(classId),'_VGGVD.mat']),'model');
end
    


