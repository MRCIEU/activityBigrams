
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

%h=figure;
%boxplot(double(bigrams)/7, 'Labels', {'SS', 'SL', 'SM', 'SV','LS', 'LL', 'LM', 'LV','MS', 'ML', 'MM', 'MV','VS', 'VL', 'VM', 'VV'}, 'outliersize', 2, 'colors', [0.8 0.3 0.9], 'symbol', '');
%xlabel('Bigram');
%ylabel('mins/day');
%saveas(h, '../out/figure-bigramDistributions-box.pdf')

% bigram summary statistics for paper table
% iqr
for i=1:size(bigrams,2) 
	b = double(bigrams(:,i))/7; 
	bx = sort(b); 
	n=size(bx,1); 
	l=bx(round(n/4));h=bx(round(3*n/4)); 
	fprintf('%.3f, %.3f \n', l, h); 
end
% median
median(double(bigrams)/7)


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



