
% phenotypes datset contains all people who came to F11 clinic
phenotypes = dataset('file', '../../data/derived/alspac/alspac-variables.csv', 'delimiter', ',');

% our sample
addpath('..');
data = getDataSample();

% set insample indicator variable
data(:,'insample') = mat2dataset(repmat(1,size(data,1),1));

% join so that all row without an insample value are from the phenotypes file and not in the sample
phenotypes.qlet = phenotypes.qlet - 1;
C = join(data,phenotypes,'Keys', {'aln','qlet'},'MergeKeys',true, 'Type', 'outer');
size(C)
                                         
% should be same size as data dataset
size(find(C.insample == 1))

% should be zero
size(find(C.insample == 0))

% all those not in sample have insample=0
size(find(isnan(C.insample)))
ix = find(isnan(C.insample));
C.insample(ix) = 0;

size(find(isnan(C.insample)))
size(find(C.insample == 0))  

export(C, 'file', '../../data/derived/datasetWithInSampleForStata.csv', 'delimiter', ',');


