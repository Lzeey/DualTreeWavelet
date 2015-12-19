%% Testing complex wavelets

%% Prepare input
% Load a real valued image, give random complex noise
% m = 128;
% n = 256;
% X = 1/sqrt(2) * (randn(m,n) + 1j*randn(m,n)); %our image
load porche %Image in X and map
[m,n] = size(X);
noise_power = 0.3; %sigma^2
X = X/max(abs(X(:))); %normalize
X = X - mean(X(:)); %and center
X = X + noise_power/sqrt(2) * (randn(m,n) + 1j*randn(m,n));

%% Performing Dual Tree CWT decomposition
Depth = 4; %3 level decomp
FDf = dtfilters('FSfarras'); %first level filter
Df   = dtfilters('qshift10'); %second level filter
dt = dddtree2('cplxdt',X,Depth,FDf,Df); %the actual decomposition
cfs = dt.cfs;
%% Attempt to denoise
% loop through scales:
thr = 1; %arbitrary
for j = 1:Depth
    % loop through subbands
    for s1 = 1:2
        for s2 = 1:3
            for s3 = 1:2 %'real' and 'img'
                cfs{j}(:,:,s2,s1,1) = wthresh(cfs{j}(:,:,s2,s1,s3),'s',thr); %Perform soft thresholding
            end
        end
    end
end
dt.cfs = cfs;
y_dtcwt = idddtree2(dt);

%% Double Density Dual-tree Complex Wavelet Transform
FDf = dtfilters('FSdoubledualfilt');
Df = dtfilters('doubledualfilt');        
dt = dddtree2('cplxdddt',X,Depth,FDf,Df);
cfs = dt.cfs;
% loop through scales:
for j = 1:Depth
    % loop through subbands
    for s1 = 1:2
        for s2 = 1:8
            for s3 = 1:2
                cfs{j}(:,:,s2,s1,1) = wthresh(cfs{j}(:,:,s2,s1,s3),'s',thr); %Perform soft thresholding
            end
        end
    end
end
dt.cfs = cfs;
y_dddtcwt = idddtree2(dt);

%% DWT
Df = dtfilters('farras');
dt = dddtree2('dwt',X,Depth,Df);
cfs = dt.cfs;
% loop through scales:
for j = 1:Depth
    % loop through subbands
    for s = 1:3
        cfs{j}(:,:,s) = wthresh(cfs{j}(:,:,s),'s',thr);
    end
end
dt.cfs = cfs;
y_dwt = idddtree2(dt);

%% Compare against all
figure;
subplot(231); imshow(abs(X)); title('Original with noise')
subplot(232); imshow(abs(y_dtcwt)); title('DWCWT')
subplot(233); imshow(abs(y_dddtcwt)); title('DDDTCWT')
subplot(234); imshow(abs(y_dwt)); title('DWT');