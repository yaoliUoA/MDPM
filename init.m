%% Mid-level Deep Pattern Mining, CVPR 2015
% Yao Li, University of Adelaide, March 2015

%% paths to some libraries
% path to liblinear, change this based on your configuration
conf.pathToLiblinear = '~/Vision/lib/liblinear-1.94/'; 
addpath(genpath(conf.pathToLiblinear));

% path to Caffe, change this based on your configuration
conf.pathToCaffe = '/home/yao/Project/CNN/caffe-master'; 
% path to Caffe's ImageNet model, you need to download it first 
conf.pathToModel = [conf.pathToCaffe,'/models/bvlc_reference_caffenet']; 
% path to Caffe's matlab interface, you need to compile it using "make matcaffe"
conf.pathToMatCaffe = [conf.pathToCaffe,'/matlab/caffe']; 

%% dataset 
conf.dataset = 'MIT67';
conf.imgDir   = ['~/Vision/dataset/',conf.dataset]; % path the dataset, change this based on your configuration
conf.imdb     = 'MIT67-imdb.mat';%; % train/test splits of the dataset.  'paris_traintest.mat'
conf.numClasses = 67 ;
conf.numSamples = 100;


% assoication rule mining 
conf.numTop = 20;
conf.numTopActivation = 20;
conf.numDetSelected = 50;
conf.stepSize = 32;
conf.minLength = 3;
conf.maxLength = 6;

conf.patchSize = 128;
conf.patchSizeL2 = 160;
conf.patchSizeL3 = 192;

conf.supp = 0.01;
conf.confid = 30;


conf.svmC = 0.5; % C value for training svm detector
conf.detLDATh = 150;
conf.detTh = 50;
conf.overlap = 0.1;

% cnn directories 
conf.cnnDir_Local = ['cnn_',num2str(conf.patchSize),'_',num2str(conf.stepSize)];
conf.cnnDir_Local_L2 = ['cnn_',num2str(conf.patchSizeL2),'_',num2str(conf.stepSize)];
conf.cnnDir_Local_L3 = ['cnn_',num2str(conf.patchSizeL3),'_',num2str(conf.stepSize)];
conf.cnnDir_Combined = ['cnnCom_',num2str(conf.patchSize),'_',num2str(conf.stepSize)];

% data directories
conf.dataDir = [pwd,'/data/',conf.dataset];
conf.invertFileDir = ['invert_',num2str(conf.patchSize),'_',num2str(conf.stepSize),'_',num2str(conf.numTopActivation)];
conf.transFileDir = ['trans_',num2str(conf.patchSize),'_',num2str(conf.stepSize),'_',num2str(conf.numTopActivation)];
conf.ruleDir_init = ['rule_init_',num2str(conf.patchSize),'_',num2str(conf.stepSize),'_',num2str(conf.numTopActivation),'_',num2str(conf.supp),'_',num2str(conf.confid)];
conf.clusterDir_init = ['cluster_init_',num2str(conf.patchSize),'_',num2str(conf.stepSize),'_',num2str(conf.numTopActivation),'_',num2str(conf.supp),'_',num2str(conf.confid)];
conf.clusterDir_merge = ['cluster_merge_',num2str(conf.patchSize),'_',num2str(conf.stepSize),'_',num2str(conf.detLDATh),'_',num2str(conf.numTopActivation),'_',num2str(conf.supp),'_',num2str(conf.confid)];
conf.detDir_lda = ['detFinal_lda_',num2str(conf.patchSize),'_',num2str(conf.stepSize),'_',num2str(conf.detLDATh)];
conf.detComDir_lda = ['detCom_lda_',num2str(conf.patchSize),'_',num2str(conf.stepSize),'_',num2str(conf.detLDATh)];


% image representation directories
conf.feaDir = ['feaFinal_',num2str(conf.patchSize),'_',num2str(conf.stepSize),'_',num2str(conf.detLDATh)];



