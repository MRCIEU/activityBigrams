
data = getDataSample();

% here bigrams are consecutive pairs (i.e. unordered adjacent activity states)
%bigrams = data(:, {'missmiss', 'missS', 'missL', 'missM', 'missV', 'Smiss', 'SS', 'SL', 'SM', 'SV', 'Lmiss', 'LS', 'LL', 'LM', 'LV', 'Mmiss', 'MS', 'ML', 'MM', 'MV', 'Vmiss', 'VS', 'VL', 'VM', 'VV'});
bigrams = data(:, {'SS', 'SL', 'SM', 'SV', 'LS', 'LL', 'LM', 'LV', 'MS', 'ML', 'MM', 'MV', 'VS', 'VL', 'VM', 'VV'});
%bigrams = mat2dataset(bigrams);
%bigrams.Properties.VarNames = {'SS','SL','SM','SV','LL','LM','LV','MM','MV','VV'};

%stateCounts1 = [repmat(data.countSed,1,4) repmat(data.countLow,1,4) repmat(data.countMod,1,4) repmat(data.countVig,1,4)];
%stateCounts2 = [repmat([data.countSed data.countLow data.countMod data.countVig], 1, 4)];

confounders = data(:,{'ethnicity', 'parity', 'matSmPreg', 'hhsoc', 'mated', 'sex', 'age11'});
%stateCounts = data(:,{'countMissing', 'countSed', 'countLow', 'countMod', 'countVig'});
stateCounts = data(:,{'countSed', 'countLow', 'countMod', 'countVig'});

h=figure('units','inches','position',[.1 .1 12 4.8]);
%h=figure('units','inches','position',[.1 .1 15 10]);
plot([0 size(bigrams,2)+2], [0 0], '--', 'color', 'black');
xlim([1 size(bigrams,2)+1]);
ylim([-9 9]);
set(gca,'XTick',[1:size(bigrams,2)]+0.3);
set(gca,'XTickLabel',bigrams.Properties.VarNames)
set(gca,'fontsize',20);
xlabel('Bigram', 'FontSize',20);
ylabel('Change of BMI', 'FontSize',20);

%colorx = {'[1.0 0.6 0.0]';'[0.5 0.8 0.0]';'[0.0 0.0 0.0]'; '[0.9 0.9 0.0]'; '[1.0 0.0 0.0]'; '[0.0 1.0 1.0]'; '[0.0 0.0 1.0]';'[0.0 1.0 0.0]';'[0.2 0.6 0.1]';'[1.0 0.6 0.0]';'[0.5 0.8 0.0]';'[0.0 0.0 0.0]'; '[0.9 0.9 0.0]'; '[1.0 0.0 0.0]'; '[0.0 1.0 1.0]'; '[0.0 0.0 1.0]';'[0.0 1.0 0.0]';'[0.2 0.6 0.1]';'[1.0 0.5 0.5]'; '[0.5 0.5 0.0]'; '[0.5 0.0 0.5]'; '[1.0 0.0 1.0]'; '[0.2 0.5 0.2]';'[0.8 0.6 1.0]';'[0.2 0.2 0.5]'};
colorx = {'[1.0 0.6 0.0]';'[0.5 0.8 0.0]';'[0.0 0.0 0.0]'; '[0.1 0.1 0.9]'};
markersx = {'o';'x';'s';'*'};
markersizex = [10;10;10;10];
numBigrams=size(bigrams,2);

for i=1:size(bigrams,2)

	for test=1:4

		indVar = bigrams(:,i);

		if (test==1)
			[B,BINT,R,RINT,STATS] = regress(data.bmi11, [double(indVar)/7 repmat(1,size(data.bmi11, 1), 1)]);
		elseif (test==2)
			[B,BINT,R,RINT,STATS] = regress(data.bmi11, [double(indVar)/7 double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
		elseif (test==3)
			[B,BINT,R,RINT,STATS] = regress(data.bmi11, [double(indVar)/7 double(stateCounts) double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
		elseif (test==4)
			[B,BINT,R,RINT,STATS] = regress(data.bmi11, [double(indVar)/7 double(data.mCPM) double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
		end

		B = B*10; BINT = BINT*10;

		fprintf('%.3f \t %.3f, %.3f \t', B(1), BINT(1,1), BINT(1,2));
		%fprintf(' %s test %d: b=%.3f [%.3f, %.3f] n=%d \n', char(bigrams.Properties.VarNames(:,i)), test, B(1), BINT(1,1), BINT(1,2), size(data,1));
		hold on;plot(i+test*0.2, B(1), markersx{test}, 'markersize', markersizex(test), 'color', colorx{test}, 'linewidth', 3); 
		hold on; plot([i+test*0.2 i+test*0.2], [BINT(1,1) BINT(1,2)], 'color', colorx{test}, 'linewidth', 3);

	end

	fprintf('\n');

end


set(h,'Units','Inches');
pos = get(h,'Position');

set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
saveas(h, 'figure-bigram-assoc-basic.pdf');

