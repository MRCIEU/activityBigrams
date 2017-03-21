files = dir('../../data/derived/activityBigrams/accel/F11-processed/*.csv');

idx=1;
aln=files(idx).name;
file = files(idx);
[~,userId,~] = fileparts(file.name);

% discrete version of accelerometer sequence
x = dlmread(strcat('../../data/derived/activityBigrams/accel/F11-processed/', aln));
seq = reshape(x',1,size(x,1)*size(x,2));
h=figure;plot(1:length(seq), seq, '.');
xlim([0 10080]);
xlabel('Day');
ylabel('Activity level');

set(gca,'XTick',[1:7]*1440 - 900);
set(gca,'XTickLabel',{'1','2','3','4','5','6','7'});

saveas(h, strcat('../out/accel-',userId,'.pdf'));

