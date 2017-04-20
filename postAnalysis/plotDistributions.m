
addpath('..');
data = getDataSample();

% no missing states
bigrams = data(:, {'SS', 'SL', 'SM', 'SV','LS', 'LL', 'LM', 'LV','MS', 'ML', 'MM', 'MV','VS', 'VL', 'VM', 'VV'});

%%
%% bigram distributions

h=figure;
i=4;j=4;

for k=1:size(bigrams,2)
	subplot(i,j,k);
	hist(double(bigrams(:,k))/7);	
	set(get(gca,'child'),'FaceColor',[0.9 0.9 0.1], 'EdgeColor','[0.3 0.3 0.3]');
	title(bigrams.Properties.VarNames{k});
	xlabel('mins/day');
	%xlim([0 500]);
	%ylim([0 5000]);
end

saveas(h, '../out/figure-bigramDistributions.pdf');


% bigram summary statistics for paper table
% iqr
fileID = fopen('../out/bigram-distributions.csv','w');
fprintf(fileID, 'bigram \t median \t (IQR)\n');
labels = {'SS', 'SL', 'SM', 'SV','LS', 'LL', 'LM', 'LV','MS', 'ML', 'MM', 'MV','VS', 'VL', 'VM', 'VV'};
for i=1:size(bigrams,2) 
	b = double(bigrams(:,i))/7; 
	bx = sort(b); 
	n=size(bx,1); 
	liqr=bx(round(n/4));
	hiqr=bx(round(3*n/4)); 
	m = median(b);
	fprintf(fileID, '%s \t%.2f \t(%.2f, %.2f) \n', labels{i}, m, liqr, hiqr); 
end
fclose(fileID);

%%
%% ubigram distributions

h=figure;
i=4;j=4;

ubigrams = [data.SS data.SL+data.LS data.SM+data.MS data.SV+data.VS data.LL data.LM+data.ML data.LV+data.VL data.MM data.MV+data.VM  data.VV];
ubigrams = mat2dataset(ubigrams);
ubigrams.Properties.VarNames = {'SS', 'SL', 'SM', 'SV', 'LL', 'LM', 'LV', 'MM', 'MV', 'VV'};  

for k=1:size(ubigrams,2)
        subplot(i,j,k);
        hist(double(ubigrams(:,k)));
	ylabel(ubigrams.Properties.VarNames{k});
end

saveas(h, '../out/figure-ubigramDistributions.pdf');



