


function bigrams = generateBigrams(seq)

	bigrams = zeros(5,5);

	prevState = seq(1);

	for j = 2:size(seq,2)

		currentState = seq(j);

		% increment occurence of this bigram (+2 because state values are -1,0,1,2,3)
		bigrams(prevState+2,currentState+2) = bigrams(prevState+2,currentState+2) + 1;

		prevState = currentState;

	end

	
