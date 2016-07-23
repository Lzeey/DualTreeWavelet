% Unwrapping test

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
X_ori = idddtree2(dt);

cfs_unwrap = unwrap_tree(cfs,m,n,Depth);
cfs_rewrap = rewrap_tree(cfs_unwrap,m,n,Depth);

dt1 = dt;
dt1.cfs = cfs_rewrap;
X_rewrap = idddtree2(dt1);

figure;
subplot(121); imshow(abs(X_ori));
subplot(122); imshow(abs(X_rewrap));


%%Attempt cpx dual tree function
X = randn(2^12) + 1j*randn(2^12);
Wx = perform_cpx_dualtree_transform(X,4);
X_recov = perform_cpx_dualtree_transform(Wx,4);


% %% Attempt to denoise
% % loop through scales:
% thr = 1; %arbitrary
% for j = 1:Depth
%     % loop through subbands
%     for s1 = 1:2
%         for s2 = 1:3
%             for s3 = 1:2 %'real' and 'img'
%                 cfs{j}(:,:,s2,s1,1) = wthresh(cfs{j}(:,:,s2,s1,s3),'s',thr); %Perform soft thresholding
%             end
%         end
%     end
% end
% dt.cfs = cfs;
% y_dtcwt = idddtree2(dt);