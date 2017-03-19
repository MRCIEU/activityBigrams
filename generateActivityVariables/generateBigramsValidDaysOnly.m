


function bigrams = generateBigramsValidDaysOnly(seq)

	bigrams = zeros(5,5);

	% process each day (1 row in seq)
	for i=1:size(seq,1)

		prevState = seq(i,1);

		for j = 2:size(seq,2)

			currentState = seq(i,j);

			% increment occurence of this bigram (+2 because state values are -1,0,1,2,3)
			bigrams(prevState+2,currentState+2) = bigrams(prevState+2,currentState+2) + 1;

			prevState = currentState;

		end
	end
	
