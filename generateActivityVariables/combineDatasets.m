


pa=dataset('file','../../data/derived/activity-phenotypes.csv', 'delimiter', ',');

phenotypes = dataset('file', '../../data/derived/alspac/alspac-variables.csv', 'delimiter', ',');

% fix different encoding for qlet
phenotypes.qlet = phenotypes.qlet - 1;

dataAll = join(pa,phenotypes, 'type', 'leftouter', 'keys', {'aln','qlet'}, 'MergeKeys',true);

export(dataAll, 'file','../../data/derived/main-dataset.csv', 'delimiter', ',');




