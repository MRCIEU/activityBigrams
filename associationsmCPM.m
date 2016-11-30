

data = getDataSample();

data.mVar = data.mSD.^2;

%% unadjusted

colorx = {'[1.0 0.6 0.0]';'[0.5 0.8 0.0]';'[0.8 0.2 0.2]'; '[0.1 0.1 0.6]'; '[1.0 0.3 0.75]'};

h=figure;

[B,BINT,R,RINT,STATS] = regress(data.bmi11, [data.mCPM repmat(1,size(data.bmi11, 1), 1)]);
B = B*100; BINT = BINT*100;
fprintf('mCPM param b=%.3f [%.3f - %.3f] n=%d \n', B(1), BINT(1,1), BINT(1,2), size(data,1));
plot([1 1], BINT(1,:), '-', 'color', colorx{1});hold on;
plot([1], B(1), 'o', 'MarkerEdgeColor', 'black');hold on;

%% adjusted

confounders = data(:,{'ethnicity', 'parity', 'matSmPreg', 'hhsoc', 'mated', 'sex', 'age11'});


[B,BINT,R,RINT,STATS] = regress(data.bmi11, [data.mCPM double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
B = B*100; BINT = BINT*100;
fprintf('mCPM param b=%.3f [%.3f - %.3f] n=%d \n', B(1), BINT(1,1), BINT(1,2), size(data,1));
plot([1.2 1.2], BINT(1,:), '-', 'color', colorx{2});hold on;
plot([1.2], B(1), 's', 'MarkerEdgeColor', 'black');hold on;



%% unadjusted

[B,BINT,R,RINT,STATS] = regress(data.bmi11, [zscore(data.mVar) repmat(1,size(data.bmi11, 1), 1)]);
fprintf('vCPM param b=%.3f [%.3f - %.3f] n=%d \n', B(1), BINT(1,1), BINT(1,2), size(data,1));
plot([2 2], BINT(1,:), '-', 'color', colorx{1});hold on;
plot([2], B(1), 'o', 'MarkerEdgeColor', 'black');hold on;

%% adjusted

[B,BINT,R,RINT,STATS] = regress(data.bmi11, [zscore(data.mVar) double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
fprintf('vCPM param b=%.3f [%.3f - %.3f] n=%d \n', B(1), BINT(1,1), BINT(1,2), size(data,1));
plot([2.2 2.2], BINT(1,:), '-', 'color', colorx{2});hold on;
plot([2.2], B(1), 's', 'MarkerEdgeColor', 'black');hold on;




%% unadjusted

%[B,BINT,R,RINT,STATS] = regress(data.bmi11, [data.mCPM zscore(data.mVar) repmat(1,size(data.bmi11, 1), 1)]);
%B(1) = B(1)*100; BINT(1,:) = BINT(1,:)*100;
%fprintf('mCPM param b=%.3f [%.3f - %.3f] n=%d \n', B(1), BINT(1,1), BINT(1,2), size(data,1));
%fprintf('vCPM param b=%.3f [%.3f - %.3f] n=%d \n', B(2), BINT(2,1), BINT(2,2), size(data,1));

%% adjusted

[B,BINT,R,RINT,STATS] = regress(data.bmi11, [data.mCPM zscore(data.mVar) double(confounders) repmat(1,size(data.bmi11, 1), 1)]);
B(1) = B(1)*100; BINT(1,:) = BINT(1,:)*100;
fprintf('mCPM param b=%.3f [%.3f - %.3f] n=%d \n', B(1), BINT(1,1), BINT(1,2), size(data,1));
fprintf('vCPM param b=%.3f [%.3f - %.3f] n=%d \n', B(2), BINT(2,1), BINT(2,2), size(data,1));

plot([1.4 1.4], BINT(1,:), '-', 'color', colorx{3});hold on;
plot([1.4], B(1), 'x', 'MarkerEdgeColor', 'black');hold on;
plot([2.4 2.4], BINT(2,:), '-', 'color', colorx{3});hold on;
plot([2.4], B(2), 'x', 'MarkerEdgeColor', 'black');hold on;

plot([0 3], [0 0], '--', 'color', [0.6 0.6 0.6]);

set(gca,'XTick',[1.2 2.2]);
set(gca,'XTickLabel',{'mCPM', 'vCPM'});
set(gca,'fontsize',14);
xlabel('Physical activity measure');
ylabel('Change of BMI');
xlim([0.9 2.5]);

saveas(h, 'figure-mCPM-vCPM-associations.pdf');


%% association of mCPM and vCPM
[r,p] = corrcoef(data.mCPM, data.mVar);

h=figure;
plot(data.mCPM, data.mVar, '.');
xlabel('mCPM');
ylabel('vCPM');
saveas(h, 'figure-mCPM-vs-vCPM.pdf');    
