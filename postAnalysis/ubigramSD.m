
addpath('..');
data = getDataSample();


ubigrams = [data.SS data.SL+data.LS data.SM+data.MS data.SV+data.VS data.LL data.LM+data.ML data.LV+data.VL data.MM data.MV+data.VM  data.VV];
ubigrams = mat2dataset(ubigrams);
ubigrams.Properties.VarNames = {'SS', 'SL', 'SM', 'SV', 'LL', 'LM', 'LV', 'MM', 'MV', 'VV'};  


fileID = fopen('../out/ubigram-sd.csv','w');
fprintf(fileID, 'bigram \t median \t (IQR)\n');

for i=1:size(ubigrams,2)

	fprintf(fileID, '%s \t %.3f \n', ubigrams.Properties.VarNames{i}, std(double(ubigrams(:,i))));

end

fclose(fileID);



