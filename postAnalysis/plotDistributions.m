
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
end

saveas(h, '../out/figure-bigramDistributions.pdf');


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



