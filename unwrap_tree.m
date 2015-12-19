function [y] = unwrap_tree(tree_cfs, m,n,J)
%UNWARP_TREE Unwrap 5-D DTCWT tree into a vector (mainly for LASSO)
%   Inputs:
%           tree_cfs: DTCWT tree, comprising of J x 5-D cells, and 1 4-D cell
%           param: composes of several fields:
%               .m: size 1 of image, column
%               .n: size 2 of image, row
%               .J: level of decomposition for tree
%   Output:
%           y: 1-D complex vector, with 4x redundancy on the size of the
%           original image

%% We decompose into 3D matrix 
y = zeros(m,n,4);
for s1 = 1:2 %Tree 1 and 2
    for s2 = 1:2 %'Real' or 'Complex'
        y_dim = (s1-1)*2 + s2; %choosing index in dim(3) of y
        for j = 1:J %Scale
            jsize = 2^j;
            for s3 = 1:3 %Orientation
                y(mod(s3,2)*(m/jsize) + [1:m/jsize], floor(s3/2)*(n/jsize) + [1:n/jsize], y_dim) = squeeze(tree_cfs{j}(:,:,s3,s2,s1));               
            end         
        end
        %Fill in the 'DC' bits
        y(1:m/jsize, 1:n/jsize, y_dim) = tree_cfs{j+1}(:,:,s2,s1);
    end
end

y = y(:); %Rasterize
return