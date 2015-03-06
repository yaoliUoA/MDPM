function mineRules(classId)
% mining assoication rules
addpath('../');
init;
dirName = 'mining/';
conf.dataDir = strrep(conf.dataDir,dirName,'');
if ~exist(fullfile(conf.dataDir,conf.ruleDir_init),'dir')
    mkdir(fullfile(conf.dataDir,conf.ruleDir_init));
end

% create appearance file
%fprintf('%s\n',pwd);
if isempty(strfind(pwd,'mining'))
    cd('mining');
end
%fprintf('%s\n',pwd);


appFile = './appFile.txt';
if ~exist(appFile,'file')
fid = fopen(appFile,'w');
fprintf(fid,'in\n');
fprintf(fid,'%d out',4097);
end

% input file output file
inputFile = fullfile(conf.dataDir,conf.transFileDir,['transFile_',num2str(classId),'.txt']);
outputFile = fullfile(conf.dataDir,conf.ruleDir_init,['rule_',num2str(classId),'.txt']);
options = ['./apriori -tr -s',num2str(conf.supp),' -m',num2str(conf.minLength),' -n',num2str(conf.maxLength),' -c',num2str(conf.confid),' -R',appFile];
system([options,' ',inputFile,' ',outputFile]);

cd('../');
end
