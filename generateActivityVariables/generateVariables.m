

f1 = '../../data/derived/accel/alspac-7days-discretised.csv';
seqDiscretised = dlmread(f1);
f2 = '../../data/derived/accel/alspac-7days-missingRecoded.csv';
seqMissRec = dlmread(f2);


%% calculate mCPM for each person and whether their sequence is valid or now (>= 3 days with >=8 hours wear time)
data1 = [];
for i=1:size(seqMissRec,1)

	aln = seqMissRec(i,1);
	qlet = seqMissRec(i,2);
	seq = seqMissRec(i,3:end);
	
	% mCPM
	ix = find(seq>=0);
	numEpochs = size(ix,2);
	average = mean(seq(ix));
	sd = std(seq(ix));

	% num valid days
	numValidDays = 0;
	for j=1:7
		seqDay = seq(1,1+(j-1)*60*24:j*60*24);
        	numValidMinutes = size(find(seqDay>=0),2);
        
        	if (numValidMinutes>=8*60)
        	    numValidDays = numValidDays +1;
        	end
	end

	data1 = [data1;[aln qlet average sd numValidDays]];

end

ds1 = mat2dataset(data1);
ds1.Properties.VarNames = {'aln', 'qlet', 'mCPM', 'mSD', 'numValidDays'};

%% calculate bigrams and prior probability of each state

data2 = [];
for i=1:size(seqDiscretised,1)

	aln = seqDiscretised(i,1);
        qlet = seqDiscretised(i,2);
	seq = seqDiscretised(i,3:end);

	% state prior probabilities
	imiss = find(seq==-1);
	i0 = find(seq==0);
	i1 = find(seq==1);
	i2 = find(seq==2);
	i3 = find(seq==3);

	bigrams = generateBigrams(seq);

	data2 =	[data2;	[aln qlet size(imiss,2) size(i0,2) size(i1,2) size(i2,2) size(i3,2) reshape(bigrams',1,25)]];

end

ds2 = mat2dataset(data2);
ds2.Properties.VarNames = {'aln', 'qlet', 'countMissing', 'countSed','countLow','countMod','countVig','missmiss','missS','missL','missM','missV','Smiss','SS','SL','SM','SV','Lmiss','LS','LL','LM','LV','Mmiss','MS','ML','MM','MV','Vmiss','VS','VL','VM','VV'};

ds = join(ds1, ds2, {'aln', 'qlet'});

export(ds, 'file','../../data/derived/activity-phenotypes.csv', 'delimiter', ',');







