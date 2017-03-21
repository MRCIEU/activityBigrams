



%% read in each persons data, keep only first 7 days and recode missingness


files = dir('../../data/derived/activityBigrams/accel/F11-processed/*.csv');

file1 = '../../data/derived/activityBigrams/accel/alspac-7days-missingRecoded.csv';
file2 = '../../data/derived/activityBigrams/accel/alspac-7days-discretised.csv';

% make new files
fid = fopen(file1,'w');
fclose(fid);
fid = fopen(file2,'w');
fclose(fid);

for file=files'

	% get aln and qlet from file name
	[~,userId,~] = fileparts(file.name);
	aln = str2num(userId(1:size(userId,2)-1));
	if (size(findstr(userId,'A'),2)==1)
                qlet = 0;
        elseif (size(findstr(userId,'B'),2)==1)
                qlet = 1;
        elseif (size(findstr(userId,'C'),2)==1)
                qlet = 2;
        elseif (size(findstr(userId,'D'),2)==1)
                qlet = 3;
        end
	
	x = dlmread(strcat('../../data/derived/activityBigrams/accel/F11-processed/',file.name));

	% make into 1 long row
	seq = reshape(x',1,size(x,1)*size(x,2));

	% get first 7 days and ignore those without enough data	
	days7 = 7*24*60;
	if (size(seq,2)>=days7)

		% first 7 days only
		seq = seq(1:7*24*60);

		% recode missing (lengths of 1 hour with zero values) and discretise
		seq2 = recodeMissing(seq);

		dlmwrite(file1, [aln qlet seq2], '-append');

		seq3 = discretise(seq2);
		dlmwrite(file2, [aln qlet seq3], '-append');
	else
		fprintf(strcat(file.name, ': sequence too short, length=', num2str(size(seq,2)), '\n'));

	end
end




