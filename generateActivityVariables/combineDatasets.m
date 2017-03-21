


pa=dataset('file','../../data/derived/activityBigrams/accel/activity-phenotypes.csv', 'delimiter', ',');

phenotypes = dataset('file', '../../data/derived/activityBigrams/alspac/alspac-variables.csv', 'delimiter', ',');

% fix different encoding for qlet
phenotypes.qlet = phenotypes.qlet - 1;

dataAll = join(pa,phenotypes, 'type', 'leftouter', 'keys', {'aln','qlet'}, 'MergeKeys',true);

export(dataAll, 'file','../../data/derived/activityBigrams/main-dataset.csv', 'delimiter', ',');




