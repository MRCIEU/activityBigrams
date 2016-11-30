


pa=dataset('file','../data/activity-phenotypes.csv', 'delimiter', ',');

phenotypes = dataset('file', '../data/myvars-for-bigrams.csv', 'delimiter', ',');

% fix different encoding for qlet
phenotypes.qlet = phenotypes.qlet - 1;

dataAll = join(pa,phenotypes, 'type', 'leftouter', 'keys', {'aln','qlet'}, 'MergeKeys',true);

export(dataAll, 'file','../data/main-dataset.csv', 'delimiter', ',');




