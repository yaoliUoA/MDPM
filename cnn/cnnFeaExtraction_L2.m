function cnnFeaExtraction_L2(classId)
addpath('../');
init;
addpath(conf.pathToMatCaffe);
dirName = 'cnn/';
conf.dataDir = strrep(conf.dataDir,dirName,'');
if isempty(strfind(pwd,'cnn'))
    cd('cnn');
end
if ~exist(fullfile(conf.dataDir,conf.cnnDir_Local_L2,num2str(classId)),'dir')
    mkdir(fullfile(conf.dataDir,conf.cnnDir_Local_L2,num2str(classId)));
end
imdb = load(fullfile(conf.dataDir, conf.imdb));
imIndex = find(imdb.images.class == classId);
model_def_file = 'deploy1_fc6.prototxt';
% NOTE: you'll have to get the pre-trained ILSVRC network
model_file = [conf.pathToModel,'/bvlc_reference_caffenet.caffemodel'];
caffe('init',model_def_file,model_file,'test');
caffe('set_mode_cpu');
d = load('ilsvrc_2012_mean.mat');
IMAGE_MEAN = d.image_mean;
IMAGE_DIM = 256;
CROPPED_DIM = 227;
 for i = 1:length(imIndex)
     fprintf('Image %d\n',i);
     imName = imdb.images.name{imIndex(i)};
     fprintf('%s\n',imName);
     im = imread(fullfile(conf.imgDir,imName));
     if size(im,3)~=3
         im = cat(3,im,im,im);
     end
     [imHeight,imWidth,imDepth] = size(im);
     if imHeight>imWidth
         im = im2double(imresize(im,[NaN,256],'bilinear'));
     else
         im = im2double(imresize(im,[256,NaN],'bilinear'));
     end
     imCropAll = [im2colstep(im(:,:,1),[conf.patchSizeL2,conf.patchSizeL2],[conf.stepSize,conf.stepSize]);...
               im2colstep(im(:,:,2),[conf.patchSizeL2,conf.patchSizeL2],[conf.stepSize,conf.stepSize]);...
               im2colstep(im(:,:,3),[conf.patchSizeL2,conf.patchSizeL2],[conf.stepSize,conf.stepSize])];
     images = zeros(CROPPED_DIM, CROPPED_DIM, 3, size(imCropAll,2), 'single');
     cnnFea = single(zeros(4096,size(imCropAll,2)));
     for j = 1:size(imCropAll,2)
        imCrop = im2uint8(reshape(imCropAll(:,j),[conf.patchSizeL2,conf.patchSizeL2,3])); 
        imCrop = single(imCrop);
        imCrop = imresize(imCrop, [IMAGE_DIM IMAGE_DIM], 'bilinear');
        imCrop = imCrop(:,:,[3 2 1]) - IMAGE_MEAN;
        imCrop = imresize(imCrop, [CROPPED_DIM CROPPED_DIM], 'bilinear');
        images(:,:,:,j) = permute(imCrop,[2 1 3]);
        score = caffe('forward', {images(:,:,:,j)});
        cnnFea(:,j) = score{1};
     end 
     save(fullfile(conf.dataDir,conf.cnnDir_Local_L2,num2str(classId),['cnnFea_',num2str(i),'.mat']),'cnnFea');
 end
 cd('..');