

function data = getDataSampleValidDaysOnly()


	data = dataset('file','../../data/derived/main-datasetValidDaysOnly.csv', 'delimiter', ',');

	fprintf(strcat('Num: ', num2str(size(data,1)), '\n'));

	%% BMI
	i = find(~isnan(data.bmi11));
        numRemoved = size(data,1) - size(i,1);
        data = data(i,:);

        fprintf(strcat('Num with no BMI11: ', num2str(numRemoved), '\n'));
        fprintf(strcat('Num: ', num2str(size(data,1)), '\n'));

	%% numValidDays
	i = find(data.numValidDays>=3);	
	numRemoved = size(data,1) - size(i,1);
	data = data(i,:);

	fprintf(strcat('Num with <3 valid days: ', num2str(numRemoved), '\n'));
	fprintf(strcat('Num: ', num2str(size(data,1)), '\n'));

	%% mCPM <= 1500
	i = find(data.mCPM<=1500);
	numRemoved = size(data,1) - size(i,1);
        data = data(i,:);

        fprintf(strcat('Num with mCPM>1500: ', num2str(numRemoved), '\n'));
        fprintf(strcat('Num: ', num2str(size(data,1)), '\n'));

	%% remove relateds
	cc = unique(data.aln);
	[n, bin] = histc(data.aln, cc);      
	dupAlns = cc(find(n>1));

	for i=1:size(dupAlns,1)
		ix = find(data.aln == dupAlns(i));
		data.aln(ix(2))= NaN;
	end
	i = find(~isnan(data.aln));
	numRemoved = size(data,1) - size(i,1);
        data = data(i,:);

        fprintf(strcat('Num relateds: ', num2str(numRemoved), '\n'));
        fprintf(strcat('Num: ', num2str(size(data,1)), '\n'));
	


	%%%
	%%% Confounders

	%%  remove ethnicity
	i = find(~isnan(data.ethnicity));
	numRemoved = size(data,1) - size(i,1);
        data = data(i,:);
        fprintf(strcat('Num with no ethnicity: ', num2str(numRemoved), '\n'));
        fprintf(strcat('Num: ', num2str(size(data,1)), '\n'));

	%% remove parity
	i = find(~isnan(data.parity));
        numRemoved = size(data,1) - size(i,1);
        data = data(i,:);
        fprintf(strcat('Num with no parity: ', num2str(numRemoved), '\n'));
        fprintf(strcat('Num: ', num2str(size(data,1)), '\n'));


	%% remove matSmPreg
        i = find(~isnan(data.matSmPreg));
        numRemoved = size(data,1) - size(i,1);
        data = data(i,:);
        fprintf(strcat('Num with no matSmPreg: ', num2str(numRemoved), '\n'));
        fprintf(strcat('Num: ', num2str(size(data,1)), '\n'));

	%% remove hhsoc
        i = find(~isnan(data.hhsoc));
        numRemoved = size(data,1) - size(i,1);
        data = data(i,:);
        fprintf(strcat('Num with no hhsoc: ', num2str(numRemoved), '\n'));
        fprintf(strcat('Num: ', num2str(size(data,1)), '\n'));

	%% remove mated
        i = find(~isnan(data.mated));
        numRemoved = size(data,1) - size(i,1);
        data = data(i,:);
        fprintf(strcat('Num with no mated: ', num2str(numRemoved), '\n'));
        fprintf(strcat('Num: ', num2str(size(data,1)), '\n'));

	%% remove sex
        i = find(~isnan(data.sex));
        numRemoved = size(data,1) - size(i,1);
        data = data(i,:);
        fprintf(strcat('Num with no sex: ', num2str(numRemoved), '\n'));
        fprintf(strcat('Num: ', num2str(size(data,1)), '\n'));

	%% remove age11
        i = find(~isnan(data.age11));
        numRemoved = size(data,1) - size(i,1);
        data = data(i,:);
        fprintf(strcat('Num with no age11: ', num2str(numRemoved), '\n'));
        fprintf(strcat('Num: ', num2str(size(data,1)), '\n'));





