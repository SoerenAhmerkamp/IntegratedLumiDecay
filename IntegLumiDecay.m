%% Processing Integrated Luminescence Yield

files = dir('*.tif');
temp = imread(files(1).name);
N = length(files);

imgIntLum = ones(size(temp,1),size(temp,2),100).*nan;
imgIntLum_Norm = ones(size(temp,1),size(temp,2),N).*nan;

m = 0;
for n = 1:2:N
    m = m+1;
    A = im2double(imread(files(n).name));
    B = im2double(imread(files(n+1).name));

    imgIntLum(:,:,m) = (B-A);
    imgIntLum_Norm(:,:,m) = (B-A)./(A);
    n
end

%% Plot results
figure
title('Integrated Luminescence Decay')
avg = nanmean((imgIntLum),3);
pcolor(medfilt2(flipud(avg),[3 3])), colorbar, shading flat
caxis([0 0.1]), axis equal, axis tight

figure
title('Norm. Integrated Luminescence Decay')
avg = nanmean((imgIntLum_Norm),3);
pcolor(medfilt2(flipud(avg),[3 3])), colorbar, shading flat
caxis([0 0.3]), axis equal, axis tight


%% Stern Volmer Relationship
P0 = 0.3;
P100 = 0.1;
KSV = P0/P100;

calib = @(val) (P0  ./ val-1) ./ (KSV);

%% Plot Calibrated Results
figure
title('Integrated Phosphorescence')
avg = calib(nanmean(imgIntLum_Norm,3))*100;
imagesc(medfilt2(avg,[3 3])), colorbar
axis equal, axis tight
