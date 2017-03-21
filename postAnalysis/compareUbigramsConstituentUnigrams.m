

addpath('..');
data = getDataSample();

%% just so the values we use below are per day not per week
data(:,6:35) = mat2dataset(double(data(:,6:35))./7);


fileID = fopen('../out/bigram-constit-compare.csv','w');
fprintf(fileID, 'bigram1 \t bigram2 \t corr \t (IQR)\n');

[r,p,rl,ru] = corrcoef(double(data(:,{'SL'})), double(data(:,{'LS'})));
fprintf(fileID, 'SL \t LS \t %.3f [%.3f, %.3f] %.3f \n', r(1,2), rl(1,2),ru(1,2), p(1,2));

[r,p,rl,ru] = corrcoef(double(data(:,{'SM'})), double(data(:,{'MS'})));
fprintf(fileID, 'SM \t MS \t %.3f [%.3f, %.3f] %.3f \n', r(1,2), rl(1,2),ru(1,2), p(1,2));

[r,p,rl,ru] = corrcoef(double(data(:,{'SV'})), double(data(:,{'VS'})));
fprintf(fileID, 'SV \t VS \t %.3f [%.3f, %.3f] %.3f \n', r(1,2), rl(1,2),ru(1,2), p(1,2));

[r,p,rl,ru] = corrcoef(double(data(:,{'LM'})), double(data(:,{'ML'})));
fprintf(fileID, 'LM \t ML \t %.3f [%.3f, %.3f] %.3f \n', r(1,2), rl(1,2),ru(1,2), p(1,2));

[r,p,rl,ru] = corrcoef(double(data(:,{'LV'})), double(data(:,{'VL'})));
fprintf(fileID, 'LV \t VL \t %.3f [%.3f, %.3f] %.3f \n', r(1,2), rl(1,2),ru(1,2), p(1,2));

[r,p,rl,ru] = corrcoef(double(data(:,{'MV'})), double(data(:,{'VM'})));
fprintf(fileID, 'MV \t VM \t %.3f [%.3f, %.3f] %.3f \n', r(1,2), rl(1,2),ru(1,2), p(1,2));

fclose(fileID);

