


function seq2 = recodeMissing(sequence)

	nonWearThreshold = 60; % 1 hour (1 minute epochs)

	totalzeros=0; % reset
        seq2 = repmat(-2,1,length(sequence));

        for i=1:length(sequence)

            if (sequence(i)==0) % count number of zeros in a row
                totalzeros = totalzeros+1;

            else
                if (totalzeros>=nonWearThreshold) % missing values
                    seq2(1,i-totalzeros:i-1) = repmat(-1, 1, totalzeros);
                elseif (totalzeros>0) % fill with the zeros because not missing
                    seq2(1,i-totalzeros:i-1) = repmat(0, 1, totalzeros);
                end

                % not a zero so resetting zero count
                totalzeros = 0;

		seq2(i) = sequence(i);
                
            end

        end
        
        % last run of zeros
        if (totalzeros>=nonWearThreshold) % missing values
            seq2(1,i-totalzeros+1:i) = repmat(-1, 1, totalzeros);
        elseif (totalzeros>0) % fill with the zeros because not missing
            seq2(1,i-totalzeros+1:i) = repmat(0, 1, totalzeros);
        end

