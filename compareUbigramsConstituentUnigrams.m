


%data = dataset('file', '../data/main-dataset.csv', 'delimiter', ',');
data = getDataSample();

%% just so the values we use below are per day not per week
data(:,6:35) = mat2dataset(double(data(:,6:35))./7);

[r,p,rl,ru] = corrcoef(double(data(:,{'SL'})), double(data(:,{'LS'})));
fprintf('SL LS %.3f [%.3f, %.3f] %.3f \n', r(1,2), rl(1,2),ru(1,2), p(1,2));

[r,p,rl,ru] = corrcoef(double(data(:,{'SM'})), double(data(:,{'MS'})));
fprintf('SM MS %.3f [%.3f, %.3f] %.3f \n', r(1,2), rl(1,2),ru(1,2), p(1,2));

[r,p,rl,ru] = corrcoef(double(data(:,{'SV'})), double(data(:,{'VS'})));
fprintf('SV VS %.3f [%.3f, %.3f] %.3f \n', r(1,2), rl(1,2),ru(1,2), p(1,2));

[r,p,rl,ru] = corrcoef(double(data(:,{'LM'})), double(data(:,{'ML'})));
fprintf('LM ML %.3f [%.3f, %.3f] %.3f \n', r(1,2), rl(1,2),ru(1,2), p(1,2));

[r,p,rl,ru] = corrcoef(double(data(:,{'LV'})), double(data(:,{'VL'})));
fprintf('LV VL %.3f [%.3f, %.3f] %.3f \n', r(1,2), rl(1,2),ru(1,2), p(1,2));

[r,p,rl,ru] = corrcoef(double(data(:,{'MV'})), double(data(:,{'VM'})));
fprintf('MV VM %.3f [%.3f, %.3f] %.3f \n', r(1,2), rl(1,2),ru(1,2), p(1,2));





xxxxxxxxxx

map = colormap(parula(10));
map(1,:) = [1 1 1];

m=3;n=2;
bin=40;

colx = [0.4 0.4 0.4];

h=figure;
subplot(m,n,1);
plot(data(:,{'SL'}), data(:,{'LS'}),'.','color',colx); hold on;
xlabel('Bigram SL'); ylabel('Bigram LS');
[values, centers] = hist3([ double(data(:,{'LS'})), double(data(:,{'SL'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; axis tight; colormap(map);colorbar;

subplot(m,n,2);
plot(data(:,{'SM'}), data(:,{'MS'}),'.','color',colx); hold on;
xlabel('Bigram SM'); ylabel('Bigram MS');
[values, centers] = hist3([ double(data(:,{'MS'})), double(data(:,{'SM'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; axis tight; colormap(map);colorbar;


subplot(m,n,3);
plot(data(:,{'SV'}), data(:,{'VS'}),'.','color',colx); hold on;
xlabel('Bigram SV'); ylabel('Bigram VS');
[values, centers] = hist3([ double(data(:,{'VS'})), double(data(:,{'SV'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; axis tight; colormap(map);colorbar;


subplot(m,n,4);
plot(data(:,{'LM'}), data(:,{'ML'}),'.','color', colx); hold on;
xlabel('Bigram LM'); ylabel('Bigram ML');
[values, centers] = hist3([ double(data(:,{'ML'})), double(data(:,{'LM'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; axis tight; colormap(map);colorbar;

subplot(m,n,5);
plot(data(:,{'LV'}), data(:,{'VL'}),'.','color',colx); hold on;
xlabel('Bigram LV'); ylabel('Bigram VL');
[values, centers] = hist3([ double(data(:,{'VL'})), double(data(:,{'LV'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; axis tight; colormap(map);colorbar;


subplot(m,n,6);
plot(data(:,{'MV'}), data(:,{'VM'}),'.','color',colx); hold on;
xlabel('Bigram MV'); ylabel('Bigram VM');
[values, centers] = hist3([ double(data(:,{'VM'})), double(data(:,{'MV'}))],[bin bin]);
imagesc(centers{:,2},centers{:,1}, values);; axis xy; axis tight; colormap(map);colorbar;


saveas(h, 'figure-compare-u-bigram-constituent-bigrams.pdf');




