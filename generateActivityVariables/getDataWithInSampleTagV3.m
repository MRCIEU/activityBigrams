
% phenotypes datset contains all people who came to F11 clinic
phenotypes = dataset('file', '../data/myvars-for-bigramsV2.csv', 'delimiter', ',');

% our sample
addpath('..');
data = getDataSample();
data(:,'insample') = mat2dataset(repmat(1,size(data,1),1));

% join so that all row without an insample value are from the phenotypes file and not in the sample
phenotypes.qlet = phenotypes.qlet - 1;
C = join(data,phenotypes,'Keys', {'aln','qlet'},'MergeKeys',true, 'Type', 'outer');
size(C)
                                                      
size(find(C.insample == 1))
size(find(C.insample == 0))
size(find(isnan(C.insample)))
ix = find(isnan(C.insample));
C.insample(ix) = 0;
size(find(isnan(C.insample)))
size(find(C.insample == 0))  

export(C, 'file', '../../data/derived/datasetWithInSampleForStataV3.csv', 'delimiter', ',');


