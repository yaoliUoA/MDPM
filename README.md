## MDPM: *Mid-level Deep Pattern Mining*

### Introduction
This is the source code package of the algorithm described in the paper [Mid-level Deep Pattern Mining](http://arxiv.org/abs/1411.6382) which
has been accepted by [CVPR 2015](http://www.pamitc.org/cvpr15/). More details are provided on the [project page](https://cs.adelaide.edu.au/~yaoli/?page_id=234).
This package has been tested using Matlab 2014a on a 64-bit Linux machine. 

### Citing MDPM

If you find MDPM useful in your research, please consider citing:

    @inproceedings{LiLSH15CVPR,
        author = {Yao Li and Lingqiao Liu and Chunhua Shen and Anton van den Hengel},
        title = {Mid-level Deep Pattern Mining},
        booktitle = {Computer Vision and Pattern Recognition},
        year = {2015}
    }

### Installing MDPM
0. **Prerequisites** 
 0. [Caffe](http://caffe.berkeleyvision.org/): install Caffe by following its [installation instructions](http://caffe.berkeleyvision.org/installation.html). 
    Do not forget to run `make matcaffe` to compile Caffe's Matlab interface. You also need to download Caffe's reference model (run `download_model_binary.py models/bvlc_reference_caffenet` from `scripts`)
    and the ImageNet mean file (run `get_ilsvrc_aux.sh` from `data/ilsvrc12 `). 
 0. [Apriori algorithm](http://en.wikipedia.org/wiki/Apriori_algorithm): we use [this implementation](http://www.borgelt.net/src/apriori.tar.gz). Click the link to download this package. You need 
    to uncompress it and run `make` to compile it in the `apriori/apriori/src` directory. 
    Detailed usage of this package can be found [here](http://www.borgelt.net/doc/apriori/apriori.html).
 0. [Liblinear](http://www.csie.ntu.edu.tw/~cjlin/liblinear/): download liblinear and compile it by following its instructions. 
 0. [KSVDS-Box v11](http://www.cs.technion.ac.il/~ronrubin/Software/ksvdsbox11.zip): we use the `im2colstep` function in this toolbox, 
     so you need to download and compile it (`im2colstep` is found in `ksvdsbox11/private`).
0. **Configuring MDPM**
 0. Download MDPM: `git clone https://github.com/yaoliUoA/MDPM`.
 0. Download MIT Indoor dataset from [here](http://web.mit.edu/torralba/www/indoor.html).
 0. Open `init.m` in the Matlab. Change values of sereval variables, including `conf.pathToLiblinear`, `conf.pathToCaffe`, `conf.dataset` and `conf.imgDir` based on your
    local configuration. 
 0. Copy the executable file `aprior` under directory `apriori/apriori/src` and paste it under `mining` directory.    
 0. Copy the mex file `im2colstep` and paste it under `cnn` directory. 
0. **Runing MDPM**
 0. Run the `demo.m`. It should be working properly if you have followed aforementioned instructions. 
 0. **Important:** It may takes some time to get the final classification result, so it is suggested to run MDPM on a cluster 
   where jobs can be run in parallel. The `*.sh` scripts are provided to submit jobs on a cluster. 

### Pre-computed models
 For MIT Indoor dataset, we have provided some pre-computed models
 0. [Pre-trained element detectors](http://cs.adelaide.edu.au/~yaoli/wp-content/projects/MDPM/data/detector.zip). After uncompressing the downloaded file,
    copy the `.mat` files to `data/MIT67/detCom_lda_128_32_150` directory (create it by yourself), you should be able to run the `feaEncodingMultiscaleSPM_lda.m`
    from `encoding` to generate image features if cnn features have already been extracted.  
 0. [Pre-computed image features](http://cs.adelaide.edu.au/~yaoli/wp-content/projects/MDPM/data/feature-MDPM.zip).
    After uncompressing the downloaded file,  copy the `.mat` files to `data/MIT67/feaFinal_128_32_150` directory (create it by yourself), you should be able to run `classify.m`
    from `classify` directly to reproduce the classification result in the paper.  

### Feedback

If you have any issues (question, feedback) or find bugs in the code, please contact yao.li01@adelaide.edu.au.

