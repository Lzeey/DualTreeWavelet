% Timing test

X = randn(2^12) + 1j*randn(2^12);
Wx = perform_cpx_dualtree_transform(X,4);
X_recov = perform_cpx_dualtree_transform(Wx,4);

% FDf = dtfilters('FSfarras'); %first level filter
% Df   = dtfilters('qshift10'); %second level filter
% dt = dddtree2('cplxdt',X,4,FDf,Df); %the actual decomposition
% X_ori = idddtree2(dt);
