
data = getDataSample();

%bigrams = data(:, {'missmiss', 'missS', 'missL', 'missM', 'missV', 'Smiss', 'SS', 'SL', 'SM', 'SV', 'Lmiss', 'LS', 'LL', 'LM', 'LV', 'Mmiss', 'MS', 'ML', 'MM', 'MV', 'Vmiss', 'VS', 'VL', 'VM', 'VV'});

% no missing states
bigrams = data(:, {'SS', 'SL', 'SM', 'SV','LS', 'LL', 'LM', 'LV','MS', 'ML', 'MM', 'MV','VS', 'VL', 'VM', 'VV'});

h=figure;
i=4;j=4;

for k=1:size(bigrams,2)
	subplot(i,j,k);
	hist(double(bigrams(:,k))/7);	
	set(get(gca,'child'),'FaceColor',[0.9 0.9 0.1], 'EdgeColor','[0.3 0.3 0.3]');
	title(bigrams.Properties.VarNames{k});
	xlabel('mins/day');
end

saveas(h, 'figure-bigramDistributions.pdf');

xxxxxx

h=figure;
i=4;j=4;

bigrams = [data.missmiss data.missS+data.Smiss data.missL+data.Lmiss data.missM+data.Mmiss data.missV+data.Vmiss data.SS data.SL+data.LS data.SM+data.MS data.SV+data.VS data.LL data.LM+data.ML data.LV+data.VL data.MM data.MV+data.VM  data.VV];

for k=1:size(bigrams,2)
        subplot(i,j,k);
        hist(double(bigrams(:,k)));
	ylabel(bigrams.Properties.VarNames{k});
end

saveas(h, 'figure-consecutiveDistributions.pdf');



