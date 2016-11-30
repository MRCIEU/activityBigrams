
data = getDataSample();

confounders = data(:,{'ethnicity', 'parity', 'matSmPreg', 'hhsoc', 'mated', 'sex', 'age11'});

colorx = {'[1.0 0.6 0.0]';'[0.5 0.8 0.0]';'[0.8 0.2 0.2]'; '[0.1 0.1 0.6]'; '[1.0 0.3 0.75]'};

h=figure('units','normalized','position',[.1 .1 .8 .4]);
plot([0 5], [0 0], '--', 'color', 'black');
xlim([1 5]);
set(gca,'fontsize',12);
set(gca,'XTick',[1.25 1.5 1.75 2.25 2.5 2.75 3.25 3.5 3.75 4.25 4.5 4.75]);
set(gca,'XTickLabel',{'S vs L', 'S vs M', 'S vs V', 'L vs S', 'L vs M', 'L vs V', 'M vs S', 'M vs L', 'M vs V', 'V vs S', 'V vs L', 'V vs M'});

%set(gca,'XTickLabel',{'sedentary','low','moderate ','vigorous'});
%set(gca,'XTick',[1:4]+0.3);

xlabel('Physical activity state comparison (baseline vs comparison)');
ylabel('Change of BMI');

% mean minutes in each state per day
data.countMissing = data.countMissing/7;
data.countSed = data.countSed/7;
data.countLow = data.countLow/7;
data.countMod = data.countMod/7;
data.countVig = data.countVig/7;

unigrams = data(:,{'countSed', 'countLow', 'countMod', 'countVig', 'countMissing'});

for i=1:4

	count = 1;

	for j=1:4 % inner loop for comparison unigram

		if (i==j)
			continue;
		end

		indVar = unigrams(:,j);
		% unigram at index i is the baseline

		otherUnigrams = unigrams;

		if (i>j) % need to delete highest index first as once delete indexes after change
			otherUnigrams(:,i) = [];
			otherUnigrams(:,j) = [];
		else
			otherUnigrams(:,j) = [];
        	       	otherUnigrams(:,i) = [];	
		end
	
		sumOther = sum(double(otherUnigrams),2);
		testx = double(sumOther) + double(indVar) + double(unigrams(:,i));
%		fprintf('TEST %f\n', testx(1));

		%%%%%%%%%%%%%%%%%% unadjusted

		[B,BINT,R,RINT,STATS] = regress(data.bmi11, [double(indVar) double(sumOther) repmat(1,size(data.bmi11, 1), 1)]);
		B = B*10; BINT = BINT*10;
	
		fprintf('%s \t %s \t Model 1 \t %.3f \t %.3f, %.3f \n', char(unigrams.Properties.VarNames(i)), char(unigrams.Properties.VarNames(j)), B(1), BINT(1,1), BINT(1,2));
		hold on;plot(i+count*0.25, B(1), 'o', 'color', colorx{1}, 'markersize', 10);
		hold on;plot([i+count*0.25 i+count*0.25], BINT(1,:), '-', 'color', colorx{1});
	
		%%%%%%%%%%%%%%%%% confounder adjusted

		[B,BINT,R,RINT,STATS] = regress(data.bmi11, [double(indVar) double(sumOther) double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
        	B = B*10; BINT = BINT*10;
	
        	fprintf('%s \t %s \t Model 2 \t %.3f \t %.3f, %.3f \n', char(unigrams.Properties.VarNames(i)), char(unigrams.Properties.VarNames(j)), B(1), BINT(1,1), BINT(1,2));
        	hold on;plot(i+count*0.25+0.1, B(1), 'x', 'color', colorx{2}, 'markersize', 10);
     		hold on;plot([i+count*0.25+0.1 i+count*0.25+0.1], BINT(1,:), '-', 'color', colorx{2});

		count = count + 1;		
	end

end

set(h,'Units','Inches');
pos = get(h,'Position');

set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
saveas(h, 'figure-unigram-assoc2.pdf');
