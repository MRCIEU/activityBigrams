addpath('..');
data = getDataSample();

% here bigrams are consecutive pairs (i.e. unordered adjacent activity states)
bigrams = [data.missmiss data.missS+data.Smiss data.missL+data.Lmiss data.missM+data.Mmiss data.missV+data.Vmiss data.SS data.SL+data.LS data.SM+data.MS data.SV+data.VS data.LL data.LM+data.ML data.LV+data.VL data.MM data.MV+data.VM  data.VV];
bigrams = mat2dataset(bigrams);
myVarNames = {'miss/miss', 'missS/Smiss', 'missL/Lmiss', 'missM/Mmiss', 'missV/Vmiss', '[SS]','[SL]','[SM]','[SV]','[LL]','[LM]','[LV]','[MM]','[MV]','[VV]'};
confounders = data(:,{'ethnicity', 'parity', 'matSmPreg', 'hhsoc', 'mated', 'sex', 'age11'});

bigramSDs = std(double(bigrams));

h=figure('units','inches','position',[.1 .1 12 4.8]);
plot([1 10], [0 0], '--', 'color', 'black');
xlim([1 10]);
ylim([-10 10]);
set(gca,'XTick',[1:10]+0.35);
set(gca,'XTickLabel',{'[SL]', '[SM]','[SV]','[LL]','[LM]','[LV]','[MM]','[MV]','[VV]'});
set(gca,'fontsize',20);
xlabel(strcat('Unordered bigram comparator (baseline: ', myVarNames(6), ')'), 'FontSize',20);
ylabel('Difference in BMI', 'FontSize',20);

colorx = {'[1.0 0.6 0.0]';'[0.5 0.8 0.0]';'[0.8 0.2 0.2]'; '[0.1 0.1 0.6]'; '[1.0 0.3 0.75]'};
markersx = {'o';'x';'s';'*'};
markersizex = [10;10;10;10;10];
numBigrams=size(bigrams,2);

fileID = fopen('../out/ubigram-assoc-SD.csv','w');
fprintf(fileID, 'Baseline \t Comparison \t Model \t Beta test1 \t CIlow, CIhigh test1 \t Beta test2 \t CIlow, CIhigh test2 \t Beta test3 \t CIlow, CIhigh test3 \t Beta test4 \t CIlow, CIhigh test4 \n');

for j=6:size(bigrams,2) % baseline

	count = 1;

	for i=6:size(bigrams,2) % comparison

		if (j==i)
			continue;
		end

		fprintf(fileID, '%s \t %s \t', myVarNames{j}, myVarNames{i});

		for test=1:4

		indVar = bigrams(:,i);
		comparisonBigramSD = bigramSDs(i);
		baselineBigramSD = bigramSDs(j);

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
		
		if (test==1)
			[B,BINT,R,RINT,STATS] = regress(data.bmi11, [double(indVar)/7 sumOther repmat(1,size(data.bmi11, 1), 1)]);
		elseif (test==2)
			[B,BINT,R,RINT,STATS] = regress(data.bmi11, [double(indVar)/7 sumOther double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
		elseif (test==3)
			[B,BINT,R,RINT,STATS] = regress(data.bmi11, [double(indVar)/7 sumOther double(stateCounts) double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
		elseif (test==4)
			[B,BINT,R,RINT,STATS] = regress(data.bmi11, [double(indVar)/7 sumOther double(data.mCPM) double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
		end

		if (baselineBigramSD<=comparisonBigramSD)
			B = B*baselineBigramSD; BINT = BINT*baselineBigramSD;

			fprintf(fileID, '%.3f [%.3f, %.3f] \t', B(1), BINT(1,1), BINT(1,2));
			hold on; plot([count+test*0.18 count+test*0.18], [BINT(1,1) BINT(1,2)], 'color', colorx{test}, 'linewidth', 3);
			hold on;plot(count+test*0.18, B(1), markersx{test}, 'markersize', markersizex(test), 'color', colorx{test}, 'linewidth', 3, 'MarkerEdgeColor', 'black'); 
		end
	
		end % end for loop

		fprintf(fileID, '\n');	

		count = count + 1;
	end

	% save figure for this baseline and start new figure for next baseline
	set(h,'Units','Inches');
	pos = get(h,'Position');
	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
	saveas(h, strcat('../out/figure-ubigram-assoc-SD', num2str(j),'.pdf'));

	if (j<size(bigrams,2))
		if (j==size(bigrams,2)-1) % last new figure
			labelsx = myVarNames(6:size(bigrams,2));
		else
			labelsx = myVarNames([6:j j+2:size(bigrams,2)]);
		end

		h=figure('units','inches','position',[.1 .1 12 4.8]);
		plot([1 10], [0 0], '--', 'color', 'black');
		xlim([1 10]);
		ylim([-10 10]);
		set(gca,'XTick',[1:10]+0.3);
		set(gca,'XTickLabel',labelsx);
		xlabel(strcat('Unordered bigram comparator (baseline: ', myVarNames(j+1), ')'), 'FontSize',20);
		ylabel('Difference in BMI', 'FontSize',20);
		set(gca,'fontsize',20);

	end
end

fclose(fileID);

set(h,'Units','Inches');
pos = get(h,'Position');

set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
saveas(h, strcat('../out/figure-ubigram-assoc-SD', num2str(j),'.pdf'));

