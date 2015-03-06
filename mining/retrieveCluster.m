function retrieveCluster(classId)
% retrive cluster members based on mined assiociation rules
addpath('../');
init;
dirName = 'mining/';
conf.dataDir = strrep(conf.dataDir,dirName,'');
if ~exist(fullfile(conf.dataDir,conf.clusterDir_init),'dir')
    mkdir(fullfile(conf.dataDir,conf.clusterDir_init));
end
% read association rule file
fid = fopen(fullfile(conf.dataDir,conf.ruleDir_init,['rule_',num2str(classId),'.txt']),'r');
C = textscan(fid,'%s','delimiter','\n');
numRow = length(C{1});
rule = cell(numRow,1);
cluster = cell(numRow,1);
clusterString = cell(numRow,1);
fclose(fid);
fid = fopen(fullfile(conf.dataDir,conf.ruleDir_init,['rule_',num2str(classId),'.txt']),'r');
for i = 1:numRow
    line = fgetl(fid);
    en = strfind(line,'(');
    st = strfind(line,' ');
    substr = line(st(2)+1:en-1);
    rule{i} = str2num(substr);
end
fclose(fid);

% load invert file
load(fullfile(conf.dataDir,conf.invertFileDir,['invertFile_',num2str(classId),'.mat']));
file = full(file);
for i = 1:numRow
    numPatt = length(rule{i});
    index = true(1,size(file,2));
    for j = 1:numPatt
        index = index & file(rule{i}(j),:);
    end
    cluster{i} = find(index);    
    clusterString{i} = num2str(cluster{i});
%    fprintf('number = %d\n',length(cluster{i}));
end
fprintf('%d cluster found in class %d\n',numRow,classId);
%save(fullfile(conf.dataDir,conf.clusterDir_init,['cluster_',num2str(classId),'.mat']),'cluster');

%clusterString = num2str(cluster);
clusterString = unique(clusterString,'rows'); % remove rules fire on the same patches
fprintf('After clean %d cluster found in class %d\n',length(clusterString),classId);

cluster = cell(length(clusterString),1);
for i = 1:length(clusterString)
     cluster{i} = str2num(clusterString{i});
end
save(fullfile(conf.dataDir,conf.clusterDir_init,['clusterClean_',num2str(classId),'.mat']),'cluster');




end