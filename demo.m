%% Mid-level Deep Pattern Mining, CVPR 2015
% Yao Li, University of Adelaide, March 2015


% This is a demo file for MIT Indoor dataset, it is suggested to run the whole program on a
% cluster, the *.sh files are scripts for submitting jobs on a cluster

if_visualize_initial_element = true;
if_visualize_merged_element = true;

addpath('mining');
addpath('cnn');
addpath('visualization');
addpath('det');
addpath('encoding');
addpath('classify');
init;

assert(strcmp(conf.dataset,'MIT67'),'This demo file is only for MIT Indoor dataset');

%% Extracting cnn feature from image patches
for i = 1:conf.numClasses
    fprintf('Extracting cnn feature from class %d\n',i);
    cnnFeaExtraction(i);
    cnnFeaExtraction_L2(i);
    cnnFeaExtraction_L3(i);
end

for i = 1:conf.numClasses
    fprintf('Combining level one cnn feature of class %d\n',i);
    cnnFeaCombineCls(i);
end

%% assoication rule mining 
for i = 1:conf.numClasses
    fprintf('Creating invert index file of class %d\n',i);
    getInvertFileCls(i);
end

for i = 1:conf.numClasses
    fprintf('Creating transaction file of class %d\n',i);
    getTransFileCls(i);
end

for i = 1:conf.numClasses
    fprintf('Mining association rules of class %d\n',i);
    mineRules(i);
end

%% Retrieving mid-level visual elements
for i = 1:conf.numClasses
    fprintf('Retrieving mid-level visual elements of class %d\n',i);
    retrieveCluster(i);
end

%% visualizing initial elements (optional)
if if_visualize_initial_element
    classId = 1; % you can change
    clusterId = 1; % you can change
    fprintf('Visualizing initial element %d of class %d\n',clusterId,classId);
    visualizeCluster_initial(classId,clusterId);
    fprintf('Visualizing initial element of class %d which has the maximum coverage\n',classId);
    visualizeCluster_initial_maxCoverage(classId);
end

%% merging and training element detectors
disp('Computing the mean and covariance matrix of cnn features');
computeMeanCov; 
for i = 1:conf.numClasses
    fprintf('training detectors of class %d\n',i);
    mergingDetectors(i);
end
disp('Stacking detectors together');
combineDetLDA;

%% visualizing merged elements (optional)
if if_visualize_merged_element
    classId = 1; % you can change
    clusterId = 1; % you can change
    fprintf('Visualizing merged element %d of class %d\n',clusterId,classId);
    visualizeCluster_merge(classId,clusterId);
end

%% encoding images using stacked detectors
for i = 1:conf.numClasses
    fprintf('encoding images in class %d using detectors\n',i);
    feaEncodingMultiscaleSPM_lda(i);
end
disp('Stacking image representations');
retrieveFeaFinal;

%% classification
disp('Multi-class classification');
classify;


    


    





    


