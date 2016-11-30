
data = getDataSample();

data.mVar = data.mSD.^2;

bigrams = data(:, {'missmiss', 'missS', 'missL', 'missM', 'missV', 'Smiss', 'Lmiss', 'Mmiss', 'Vmiss', 'SS', 'SL', 'SM', 'SV', 'LS', 'LL', 'LM', 'LV', 'MS', 'ML', 'MM', 'MV', 'VS', 'VL', 'VM', 'VV'});

confounders = data(:,{'ethnicity', 'parity', 'matSmPreg', 'hhsoc', 'mated', 'sex', 'age11'});

h=figure('units','inches','position',[.1 .1 12 4.8]);
plot([1 16], [0 0], '--', 'color', 'black');
xlim([1 16]);
ylim([-15 15]);
set(gca,'XTick',[1:16]+0.3);
set(gca,'XTickLabel',{'SL', 'SM', 'SV', 'LS', 'LL', 'LM', 'LV', 'MS', 'ML', 'MM', 'MV', 'VS', 'VL', 'VM', 'VV'});
set(gca,'fontsize',20);

xlabel(strcat('Bigram comparator (baseline: ', bigrams.Properties.VarNames(10), ')'), 'FontSize',20);
ylabel('Change of BMI', 'FontSize',20);

colorx = {'[1.0 0.6 0.0]';'[0.5 0.8 0.0]';'[0.8 0.2 0.2]'; '[0.1 0.1 0.6]'; '[1.0 0.3 0.75]'};
markersx = {'o';'x';'s';'*'};
markersizex = 10;
numBigrams=size(bigrams,2);



for j=10:size(bigrams,2) % baseline

	count = 1;

	for i=10:size(bigrams,2) % comparison

		if (j==i)
			continue;
		end

		fprintf('%s \t %s \t', bigrams.Properties.VarNames{j}, bigrams.Properties.VarNames{i});

		for test=1:4

		indVar = bigrams(:,i);
		stateCounts = [data.countSed data.countLow data.countMod data.countVig];

		otherBigrams = bigrams;

		if (i>j) % need to delete highest index first as once delete indexes after change
			otherBigrams(:,i) = [];
			otherBigrams(:,j) = [];
		else
			otherBigrams(:,j) = [];
                        otherBigrams(:,i) = [];	
		end
	
		sumOther = sum(double(otherBigrams),2)/7;
		testx = double(sumOther) + double(indVar)/7 + double(bigrams(:,j))/7;
%		fprintf('TEST %f\n', testx(1));
		
		if (test==1)
			[B,BINT,R,RINT,STATS] = regress(data.bmi11, [double(indVar)/7 sumOther repmat(1,size(data.bmi11, 1), 1)]);
		elseif (test==2)
			[B,BINT,R,RINT,STATS] = regress(data.bmi11, [double(indVar)/7 sumOther double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
		elseif (test==3)
			[B,BINT,R,RINT,STATS] = regress(data.bmi11, [double(indVar)/7 sumOther double(stateCounts) double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
		elseif (test==4)
			[B,BINT,R,RINT,STATS] = regress(data.bmi11, [double(indVar)/7 sumOther double(data.mCPM) double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
		end

		B = B*10; BINT = BINT*10;

		fprintf('%.3f [%.3f, %.3f] \t', B(1), BINT(1,1), BINT(1,2));
		%fprintf(' %s test %d: b=%.3f [%.3f, %.3f] n=%d \n', char(bigrams.Properties.VarNames(:,i)), test, B(1), BINT(1,1), BINT(1,2), size(data,1));
		hold on; plot([count+test*0.18 count+test*0.18], [BINT(1,1) BINT(1,2)], 'color', colorx{test}, 'linewidth', 3);
		hold on;plot(count+test*0.18, B(1), markersx{test}, 'markersize', markersizex, 'color', colorx{test}, 'linewidth', 3, 'MarkerEdgeColor', 'black');
                		
		end

		fprintf('\n');	

		count = count + 1;
	end

	set(h,'Units','Inches');
	pos = get(h,'Position');
	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
	saveas(h, strcat('figure-bigram-assoc-basicTEST-baseline', num2str(j),'.pdf'));


	if (j<size(bigrams,2))
	if (j==size(bigrams,2)-1) % last new figure
		labelsx = bigrams.Properties.VarNames(10:size(bigrams,2));
	else
		labelsx = bigrams.Properties.VarNames([10:j j+2:size(bigrams,2)]);
	end

	h=figure('units','inches','position',[.1 .1 12 4.8]);
	plot([1 16], [0 0], '--', 'color', 'black');
	xlim([1 16]);
	ylim([-15 15]);
	set(gca,'XTick',[1:16]+0.3);
	set(gca,'XTickLabel',labelsx);
	set(gca,'fontsize',20);

	xlabel(strcat('Bigram comparator (baseline: ', bigrams.Properties.VarNames(j+1), ')'), 'FontSize',20);
	ylabel('Change of BMI', 'FontSize',20);
	end
end


set(h,'Units','Inches');
pos = get(h,'Position');

set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
saveas(h, strcat('figure-bigram-assoc-basicTEST-baseline', num2str(j),'.pdf'));

