


function bigrams = generateBigramsValidDaysOnly(seq)

     	% row idx indicates first activity category in bigram (M,S,L,M,V) and col idx indicates second category
        % e.g. bigrams(3,2) corresponds to bigram LS
	bigrams = zeros(5,5);

	% process each day (1 row in seq)
	for i=1:size(seq,1)

		% parse accel seq of day and count bigrams		
		prevState = seq(i,1);
		for j = 2:size(seq,2)

			% current activity category at point j of day i
			currentState = seq(i,j);

			% increment occurence of this bigram (+2 because state values are -1,0,1,2,3)
			bigrams(prevState+2,currentState+2) = bigrams(prevState+2,currentState+2) + 1;

			prevState = currentState;

		end
	end
	
