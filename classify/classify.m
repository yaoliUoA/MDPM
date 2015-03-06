clear all;
addpath('../');
init;
dirName = 'classify/';
conf.dataDir = strrep(conf.dataDir,dirName,'');
imdb = load(fullfile(conf.dataDir, conf.imdb));

load(fullfile(conf.dataDir,conf.feaDir,['feaTrainCombined_spmMulti_lda_',num2str(conf.numDetSelected),'.mat']));
load(fullfile(conf.dataDir,conf.feaDir,['feaTestCombined_spmMulti_lda_',num2str(conf.numDetSelected),'.mat']));


trainLabel = [];
testLabel = [];
for i = 1:conf.numClasses
    trainLabel = [trainLabel,imdb.images.class(imdb.images.isTrain==1 & imdb.images.class==i)];
    testLabel = [testLabel,imdb.images.class(imdb.images.isTrain==0 & imdb.images.class==i)];
end
trainLabel = trainLabel';
% testLabel = repmat(1:conf.numClasses,[conf.numSamples-conf.numTrain,1]);
testLabel = testLabel';
feaTrain = sparse(double(feaTrainCombined))';
feaTest = sparse(double(feaTestCombined))';

% 5-fold cross validation
disp('Cross Validation');
%C = [0.001,0.005,0.1,0.5,1,5,10,50]*0.000001;
C = [0.1,0.2,0.5,1,1.2,1.5,2,5]*0.000001;
acc = zeros(length(C),1);
% train 67 one-vs-all svm
for i = 1:length(C)
    fprintf('Iteration %d:',i);
    acc(i) = train(trainLabel,feaTrain,['-c ',num2str(C(i)),' -q -v 5']);
end
[maxValue,maxIndex] = max(acc);
C_final = C(maxIndex);

disp('Training multiclass classifier');
model = train(trainLabel,feaTrain,['-q -c ',num2str(C_final)]);
disp('Testing');
[predict_label, accuracy, dec_values] = predict(testLabel,feaTest, model,'-q');

% accuracy of each class
accCls = zeros(conf.numClasses,1);
predLabelCls = cell(conf.numClasses,1);
for i = 1:conf.numClasses
    predLabelCls{i} = predict_label(testLabel==i);
    accCls(i) = length(find(predLabelCls{i}==i))/length(predLabelCls{i});
end
fprintf('Accuracy using %d detectors per class: %.4f\n',conf.numDetSelected,mean(accCls));
    
    