addpath('..');
data = getDataSample();

%%%%%% temporarily remove this person with high SV count
%idx14 = find(data.SV==14);
%data = data([1:idx14-1 idx14+1:end],:);

% here bigrams are consecutive pairs (i.e. unordered adjacent activity states)

bigrams = [data.missmiss data.missS+data.Smiss data.missL+data.Lmiss data.missM+data.Mmiss data.missV+data.Vmiss data.SS data.SL+data.LS data.SM+data.MS data.SV+data.VS data.LL data.LM+data.ML data.LV+data.VL data.MM data.MV+data.VM  data.VV];
bigrams = mat2dataset(bigrams);
%bigrams.Properties.VarNames = {'miss,miss', 'missS,Smiss', 'missL,Lmiss', 'missM,Mmiss', 'missV,Vmiss', 'SS','SL,LS','SM,MS','SV,VS','LL','LM,ML','LV,VL','MM','MV,VM','VV'};

%% how many SV u-bigrams
%ux = unique(bigrams.bigrams9);
%for i=1:size(ux); fprintf('%d: %d \n', ux(i), size(find(bigrams.bigrams9==ux(i)))); end

%%%%%%%%% HACK TO SET SV bigram to binary TEMPORARY TEST **********************
%idxHasSVBinary = find(bigrams.bigrams9>0);
%bigrams.bigrams9(idxHasSVBinary) = 7;
%%%%%%%%% ******************************

myVarNames = {'miss/miss', 'missS/Smiss', 'missL/Lmiss', 'missM/Mmiss', 'missV/Vmiss', '[SS]','[SL]','[SM]','[SV]','[LL]','[LM]','[LV]','[MM]','[MV]','[VV]'};

confounders = data(:,{'ethnicity', 'parity', 'matSmPreg', 'hhsoc', 'mated', 'sex', 'age11'});

h=figure('units','inches','position',[.1 .1 12 4.8]);
plot([1 10], [0 0], '--', 'color', 'black');
xlim([1 10]);
ylim([-10 10]);
set(gca,'XTick',[1:10]+0.35);
set(gca,'XTickLabel',{'[SL]', '[SM]','[SV]','[LL]','[LM]','[LV]','[MM]','[MV]','[VV]'});
set(gca,'fontsize',20);
%xlabel('Consecutive activity states');
xlabel(strcat('Unordered bigram comparator (baseline: ', myVarNames(6), ')'), 'FontSize',20);
ylabel('Change of BMI', 'FontSize',20);


%colorx = {'[1.0 0.6 0.0]';'[0.5 0.8 0.0]';'[0.0 0.0 0.0]'; '[0.9 0.9 0.0]'; '[1.0 0.0 0.0]'; '[0.0 1.0 1.0]'; '[0.0 0.0 1.0]';'[0.0 1.0 0.0]';'[0.2 0.6 0.1]';'[1.0 0.6 0.0]';'[0.5 0.8 0.0]';'[0.0 0.0 0.0]'; '[0.9 0.9 0.0]'; '[1.0 0.0 0.0]'; '[0.0 1.0 1.0]'; '[0.0 0.0 1.0]';'[0.0 1.0 0.0]';'[0.2 0.6 0.1]';'[1.0 0.5 0.5]'; '[0.5 0.5 0.0]'; '[0.5 0.0 0.5]'; '[1.0 0.0 1.0]'; '[0.2 0.5 0.2]';'[0.8 0.6 1.0]';'[0.2 0.2 0.5]'};
colorx = {'[1.0 0.6 0.0]';'[0.5 0.8 0.0]';'[0.8 0.2 0.2]'; '[0.1 0.1 0.6]'; '[1.0 0.3 0.75]'};
markersx = {'o';'x';'s';'*'};
markersizex = [10;10;10;10;10];
numBigrams=size(bigrams,2);



for j=6:size(bigrams,2) % baseline

	count = 1;

	for i=6:size(bigrams,2) % comparison

		if (j==i)
			continue;
		end

		fprintf('%s \t %s \t', myVarNames{j}, myVarNames{i});

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

		% model 3 results only (table in main paper)
		%if (test==3)
		%	fprintf('%.3f [%.3f, %.3f] \t', B(1), BINT(1,1), BINT(1,2));
		%end
		% full results (sup table)

		fprintf('%.3f [%.3f, %.3f] \t', B(1), BINT(1,1), BINT(1,2));

		%fprintf(' %s test %d: b=%.3f [%.3f, %.3f] n=%d \n', char(bigrams.Properties.VarNames(:,i)), test, B(1), BINT(1,1), BINT(1,2), size(data,1));
		hold on; plot([count+test*0.18 count+test*0.18], [BINT(1,1) BINT(1,2)], 'color', colorx{test}, 'linewidth', 3);
		hold on;plot(count+test*0.18, B(1), markersx{test}, 'markersize', markersizex(test), 'color', colorx{test}, 'linewidth', 3, 'MarkerEdgeColor', 'black'); 
	
		end

		fprintf('\n');	

		count = count + 1;
	end

	%fprintf('\n');

	set(h,'Units','Inches');
	pos = get(h,'Position');
	set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
	saveas(h, strcat('figure-u-bigram-assoc-baseline', num2str(j),'.pdf'));

	if (j<size(bigrams,2))
	if (j==size(bigrams,2)-1) % last new figure
		%labelsx = bigrams.Properties.VarNames(6:size(bigrams,2));
		labelsx = myVarNames(6:size(bigrams,2));
	else
		%labelsx = bigrams.Properties.VarNames([6:j j+2:size(bigrams,2)]);
		labelsx = myVarNames([6:j j+2:size(bigrams,2)]);
	end

	h=figure('units','inches','position',[.1 .1 12 4.8]);
	plot([1 10], [0 0], '--', 'color', 'black');
	xlim([1 10]);
	ylim([-10 10]);
	set(gca,'XTick',[1:10]+0.3);
	set(gca,'XTickLabel',labelsx);
	xlabel(strcat('Unordered bigram comparator (baseline: ', myVarNames(j+1), ')'), 'FontSize',20);
	ylabel('Change of BMI', 'FontSize',20);
	set(gca,'fontsize',20);

	end
end


set(h,'Units','Inches');
pos = get(h,'Position');

set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
saveas(h, strcat('../figure-ubigram-assoc', num2str(j),'.pdf'));

