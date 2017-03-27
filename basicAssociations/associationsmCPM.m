
addpath('..');
data = getDataSample();

sdSD = std(data.mSD);
fprintf('Standard deviation of sdCPM %.3f \n', sdSD);

confounders = data(:,{'ethnicity', 'parity', 'matSmPreg', 'hhsoc', 'mated', 'sex', 'age11'});

colorx = {'[1.0 0.6 0.0]';'[0.5 0.8 0.0]';'[0.8 0.2 0.2]'; '[0.1 0.1 0.6]'; '[1.0 0.3 0.75]'};

fileID = fopen('../out/mCPM-sdCPM-assoc.txt','w');

h=figure;

%% unadjusted mCPM

[B,BINT,R,RINT,STATS] = regress(data.bmi11, [data.mCPM repmat(1,size(data.bmi11, 1), 1)]);
B = B*100; BINT = BINT*100;
fprintf(fileID, 'unadjusted mCPM param b=%.3f [%.3f - %.3f] n=%d \n', B(1), BINT(1,1), BINT(1,2), size(data,1));
plot([1 1], BINT(1,:), '-', 'color', colorx{1});hold on;
plot([1], B(1), 'o', 'MarkerEdgeColor', 'black');hold on;

%% adjusted mCPM

[B,BINT,R,RINT,STATS] = regress(data.bmi11, [data.mCPM double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
B = B*100; BINT = BINT*100;
fprintf(fileID, 'confounder adjusted mCPM param b=%.3f [%.3f - %.3f] n=%d \n', B(1), BINT(1,1), BINT(1,2), size(data,1));
plot([1.2 1.2], BINT(1,:), '-', 'color', colorx{2});hold on;
plot([1.2], B(1), 's', 'MarkerEdgeColor', 'black');hold on;



%% unadjusted vCPM
[B,BINT,R,RINT,STATS] = regress(data.bmi11, [zscore(data.mSD) repmat(1,size(data.bmi11, 1), 1)]);
fprintf(fileID, 'unadjusted sdCPM param b=%.3f [%.3f - %.3f] n=%d \n', B(1), BINT(1,1), BINT(1,2), size(data,1));
plot([2 2], BINT(1,:), '-', 'color', colorx{1});hold on;
plot([2], B(1), 'o', 'MarkerEdgeColor', 'black');hold on;

%% adjusted vCPM
[B,BINT,R,RINT,STATS] = regress(data.bmi11, [zscore(data.mSD) double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
fprintf(fileID, 'confounder adjusted sdCPM param b=%.3f [%.3f - %.3f] n=%d \n', B(1), BINT(1,1), BINT(1,2), size(data,1));
plot([2.2 2.2], BINT(1,:), '-', 'color', colorx{2});hold on;
plot([2.2], B(1), 's', 'MarkerEdgeColor', 'black');hold on;


%% adjusted for each other (mCPM for coeffOV, and vice versa)
[B,BINT,R,RINT,STATS] = regress(data.bmi11, [data.mCPM zscore(data.mSD) double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
B(1) = B(1)*100; BINT(1,:) = BINT(1,:)*100;
fprintf(fileID, '\nAdjusted for each other: \n');
fprintf(fileID, 'mCPM param b=%.3f [%.3f - %.3f] n=%d \n', B(1), BINT(1,1), BINT(1,2), size(data,1));
fprintf(fileID, 'sdCPM param b=%.3f [%.3f - %.3f] n=%d \n', B(2), BINT(2,1), BINT(2,2), size(data,1));

plot([1.4 1.4], BINT(1,:), '-', 'color', colorx{3});hold on;
plot([1.4], B(1), 'x', 'MarkerEdgeColor', 'black');hold on;
plot([2.4 2.4], BINT(2,:), '-', 'color', colorx{3});hold on;
plot([2.4], B(2), 'x', 'MarkerEdgeColor', 'black');hold on;


fclose(fileID);


% finish making the plot and then save it

plot([0 3], [0 0], '--', 'color', [0.6 0.6 0.6]);

set(gca,'XTick',[1.2 2.2]);
set(gca,'XTickLabel',{'mCPM', 'sdCPM'});
set(gca,'fontsize',14);
xlabel('Physical activity measure');
ylabel('Difference in BMI');
xlim([0.9 2.5]);
ylim([-0.6 0.2]);

saveas(h, '../out/figure-mCPM-sdCPM-associations.pdf');

[r,p] = corrcoef([data.mCPM, data.mSD]);
r
p
