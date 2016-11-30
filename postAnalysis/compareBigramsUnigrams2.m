

%data = dataset('file', '../data/main-dataset.csv', 'delimiter', ',');
data = getDataSample();

%% just so the values we use below are per day not per week
data(:,6:35) = mat2dataset(double(data(:,6:35))./7);

map = colormap(parula(10));
map(1,:) = [1 1 1];

m=3;n=3;
bin=40;

h=figure;
subplot(m,n,1);
plot(data(:,{'countSed'}), data(:,{'SS'}),'.','color',[0.9 0.9 0.9]); hold on;
xlabel('Count sedentary'); ylabel('Bigram SS');
[values, centers] = hist3([ double(data(:,{'SS'})), double(data(:,{'countSed'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;

subplot(m,n,2);
plot(data(:,{'countSed'}), data(:,{'SL'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'SL'})), double(data(:,{'countSed'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count sedentary');
ylabel('Bigram SL');

subplot(m,n,3);
plot(data(:,{'countSed'}), data(:,{'SM'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'SM'})), double(data(:,{'countSed'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count sedentary');
ylabel('Bigram SM');

subplot(m,n,4);
plot(data(:,{'countSed'}), data(:,{'SV'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'SV'})), double(data(:,{'countSed'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count sedentary');
ylabel('Bigram SV');

subplot(m,n,5);
plot(data(:,{'countSed'}), data(:,{'LS'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'LS'})), double(data(:,{'countSed'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count sedentary');
ylabel('Bigram LS');

subplot(m,n,6);
plot(data(:,{'countSed'}), data(:,{'MS'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'MS'})), double(data(:,{'countSed'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count sedentary');
ylabel('Bigram MS');

subplot(m,n,7);
plot(data(:,{'countSed'}), data(:,{'VS'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'VS'})), double(data(:,{'countSed'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count sedentary');
ylabel('Bigram VS');

saveas(h, 'figure-sedentary-bigram-unigram-comp2.pdf');

%%%%%%%%%
%%%%%%%%%

h=figure;
subplot(m,n,1);
plot(data(:,{'countLow'}), data(:,{'LS'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'LS'})), double(data(:,{'countLow'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count low');
ylabel('Bigram LS');

subplot(m,n,2);
plot(data(:,{'countLow'}), data(:,{'LL'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'LL'})), double(data(:,{'countLow'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count low');
ylabel('Bigram LL');

subplot(m,n,3);
plot(data(:,{'countLow'}), data(:,{'LM'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'LM'})), double(data(:,{'countLow'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count low');
ylabel('Bigram LM');

subplot(m,n,4);
plot(data(:,{'countLow'}), data(:,{'LV'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'LV'})), double(data(:,{'countLow'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count low');
ylabel('Bigram LV');

subplot(m,n,5);
plot(data(:,{'countLow'}), data(:,{'SL'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'SL'})), double(data(:,{'countLow'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count low');
ylabel('Bigram SL');

subplot(m,n,6);
plot(data(:,{'countLow'}), data(:,{'ML'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'ML'})), double(data(:,{'countLow'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count low');
ylabel('Bigram ML');

subplot(m,n,7);
plot(data(:,{'countLow'}), data(:,{'VL'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'VL'})), double(data(:,{'countLow'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count low');
ylabel('Bigram VL');

saveas(h, 'figure-low-bigram-unigram-comp2.pdf');

%%%%%%%%%
%%%%%%%%%

h=figure;
subplot(m,n,1);
plot(data(:,{'countMod'}), data(:,{'MS'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'MS'})), double(data(:,{'countMod'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count mod');
ylabel('Bigram MS');

subplot(m,n,2);
plot(data(:,{'countMod'}), data(:,{'ML'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'ML'})), double(data(:,{'countMod'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count mod');
ylabel('Bigram ML');

subplot(m,n,3);
plot(data(:,{'countMod'}), data(:,{'MM'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'MM'})), double(data(:,{'countMod'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count mod');
ylabel('Bigram MM');

subplot(m,n,4);
plot(data(:,{'countMod'}), data(:,{'MV'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'MV'})), double(data(:,{'countMod'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count mod');
ylabel('Bigram MV');

subplot(m,n,5);
plot(data(:,{'countMod'}), data(:,{'SM'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'SM'})), double(data(:,{'countMod'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count mod');
ylabel('Bigram SM');

subplot(m,n,6);
plot(data(:,{'countMod'}), data(:,{'LM'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'LM'})), double(data(:,{'countMod'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count mod');
ylabel('Bigram LM');

subplot(m,n,7);
plot(data(:,{'countMod'}), data(:,{'VM'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'VM'})), double(data(:,{'countMod'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; colormap(map);colorbar;
xlabel('Count mod');
ylabel('Bigram VM');

saveas(h, 'figure-moderate-bigram-unigram-comp2.pdf');

%%%%%%%%%
%%%%%%%%%

h=figure;
subplot(m,n,1);
plot(data(:,{'countVig'}), data(:,{'VS'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'VS'})), double(data(:,{'countVig'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; axis tight; colormap(map);colorbar;
xlabel('Count vig');
ylabel('Bigram VS');

subplot(m,n,2);
plot(data(:,{'countVig'}), data(:,{'VL'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'VL'})), double(data(:,{'countVig'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; axis tight; colormap(map);colorbar;
xlabel('Count vig');
ylabel('Bigram VL');

subplot(m,n,3);
plot(data(:,{'countVig'}), data(:,{'VM'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'VM'})), double(data(:,{'countVig'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; axis tight; colormap(map);colorbar;
xlabel('Count vig');
ylabel('Bigram VM');

subplot(m,n,4);
plot(data(:,{'countVig'}), data(:,{'VV'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'VV'})), double(data(:,{'countVig'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; axis tight; colormap(map);colorbar;
xlabel('Count vig');
ylabel('Bigram VV');

subplot(m,n,5);
plot(data(:,{'countVig'}), data(:,{'SV'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'SV'})), double(data(:,{'countVig'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; axis tight; colormap(map);colorbar;
xlabel('Count vig');
ylabel('Bigram SV');

subplot(m,n,6);
plot(data(:,{'countVig'}), data(:,{'LV'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'LV'})), double(data(:,{'countVig'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; axis tight; colormap(map);colorbar;
xlabel('Count vig');
ylabel('Bigram LV');

subplot(m,n,7);
plot(data(:,{'countVig'}), data(:,{'MV'}),'.','color',[0.9 0.9 0.9]); hold on;
[values, centers] = hist3([ double(data(:,{'MV'})), double(data(:,{'countVig'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; axis tight; colormap(map);colorbar;
xlabel('Count vig');
ylabel('Bigram MV');

saveas(h, 'figure-vigorous-bigram-unigram-comp2.pdf');


