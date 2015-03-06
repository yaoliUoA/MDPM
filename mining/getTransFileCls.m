function getTransFileCls(classId)

addpath('../');
init;
dirName = 'mining/';
conf.dataDir = strrep(conf.dataDir,dirName,'');
if ~exist(fullfile(conf.dataDir,conf.transFileDir),'dir')
    mkdir(fullfile(conf.dataDir,conf.transFileDir));
end

fileName = fullfile(conf.dataDir,conf.transFileDir,['transFile_',num2str(classId),'.txt']);
fid = fopen(fileName,'w');


load(fullfile(conf.dataDir,conf.invertFileDir,['invertFile_',num2str(classId),'.mat']));
pos = size(file,1)+1;
neg = size(file,1)+2;
for i = 1:size(file,2)
    v = find(file(:,i));
    for j = 1:length(v)
        fprintf(fid,'%d ',v(j));
    end
    fprintf(fid,'%d',pos);
    fprintf(fid,'\n');
end

for tt = 1:conf.numClasses
    if tt == classId
        continue;
    else
        load(fullfile(conf.dataDir,conf.invertFileDir,['invertFile_',num2str(tt),'.mat']));
        for i = 1:size(file,2)
            v = find(file(:,i));
            for j = 1:length(v)
                fprintf(fid,'%d ',v(j));
            end
            fprintf(fid,'%d',neg);
            fprintf(fid,'\n');
        end
    end
end
end