
### This code is not used in our final analysis.
### This is a basic test of association of each bigram with BMI. 
### It looks at whether a change in the frequency of a bigram is associated with BMI.
### It doesn't look at the associations when one bigram freq increases, coupled with a
### decrease in freq of another bigram - this is what we look at in the paper.


addpath('..');
data = getDataSample();

% here bigrams are consecutive pairs (i.e. unordered adjacent activity states)
bigrams = data(:, {'SS', 'SL', 'SM', 'SV', 'LS', 'LL', 'LM', 'LV', 'MS', 'ML', 'MM', 'MV', 'VS', 'VL', 'VM', 'VV'});

confounders = data(:,{'ethnicity', 'parity', 'matSmPreg', 'hhsoc', 'mated', 'sex', 'age11'});
stateCounts = data(:,{'countSed', 'countLow', 'countMod', 'countVig'});

h=figure('units','inches','position',[.1 .1 12 4.8]);
plot([0 size(bigrams,2)+2], [0 0], '--', 'color', 'black');
xlim([1 size(bigrams,2)+1]);
ylim([-9 9]);
set(gca,'XTick',[1:size(bigrams,2)]+0.3);
set(gca,'XTickLabel',bigrams.Properties.VarNames)
set(gca,'fontsize',20);
xlabel('Bigram', 'FontSize',20);
ylabel('Change of BMI', 'FontSize',20);

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
		hold on;plot(i+test*0.2, B(1), markersx{test}, 'markersize', markersizex(test), 'color', colorx{test}, 'linewidth', 3); 
		hold on; plot([i+test*0.2 i+test*0.2], [BINT(1,1) BINT(1,2)], 'color', colorx{test}, 'linewidth', 3);

	end

	fprintf('\n');

end


set(h,'Units','Inches');
pos = get(h,'Position');

set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
saveas(h, '../out/figure-bigram-assoc-basic.pdf');

