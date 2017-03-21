


function bigrams = generateBigrams(seq)

	% row idx indicates first activity category in bigram (M,S,L,M,V) and col idx indicates second category
	% e.g. bigrams(3,2) corresponds to bigram LS
	bigrams = zeros(5,5);

	% parse accel seq and count bigrams
	prevState = seq(1);
	for j = 2:size(seq,2)

		currentState = seq(j);

		% increment occurence of this bigram (+2 because state values are -1,0,1,2,3)
		bigrams(prevState+2,currentState+2) = bigrams(prevState+2,currentState+2) + 1;

		prevState = currentState;

	end

	
