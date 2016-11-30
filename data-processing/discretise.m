


function seq2 = discretise(sequence)

	sedentaryThreshold = 100;
	middleThreshold = 2019;
	vigorousThreshold = 5998;

        seq2 = repmat(-2,1,length(sequence));

        for i=1:length(sequence)

		% discretise sequence		
		if (sequence(i)==-1) % keep missing as missing
			seq2(i) = -1;
            	elseif (sequence(i)<=sedentaryThreshold)
            	    seq2(i) = 0;
            	elseif (sequence(i)<=middleThreshold)
            	    seq2(i) = 1;
            	elseif (sequence(i)<=vigorousThreshold)
            	    seq2(i) = 2;
            	elseif (sequence(i)>vigorousThreshold)
            	    seq2(i) = 3;
		end

        end
        
