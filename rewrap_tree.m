function [tree_cfs] = rewrap_tree(y, m,n,J)
%REWRAP_TREE Rewrap the DTCWT back into the 5-D DTCWT tree (for
%reconstruction)
%   Inputs:
%           y: 1-D complex vector, with 4x redundancy on the size of the
%           original image
%               .m: size 1 of image, column
%               .n: size 2 of image, row
%               .J: level of decomposition for tree
%   Output:
%           tree_cfs: DTCWT tree, comprising of J x 5-D cells, and 1 4-D cell
%           param: composes of several fields:

%% Pre-allocate memory
%%%%%%%%%%%%%%%%%%%%%%%
tree_cfs = cell(1,J+1);
for j = 1:J
    tree_cfs{1,j} = zeros(m/(2^j),n/(2^j),3,2,2);
end
tree_cfs{1,J+1} = zeros(m/(2^J),n/(2^J),2,2);

%% Construct the tree
y = reshape(y,[m n 4]);
for s1 = 1:2 %Tree 1 and 2
    for s2 = 1:2 %'Real' or 'Complex'
        y_dim = (s1-1)*2 + s2; %choosing index in dim(3) of y
        for j = 1:J %Scale
            jsize = 2^j;
            for s3 = 1:3 %Orientation
                tree_cfs{j}(:,:,s3,s2,s1) = y(mod(s3,2)*(m/jsize) + [1:m/jsize], floor(s3/2)*(n/jsize) + [1:n/jsize], y_dim); 
            end         
        end
        %Fill in the 'DC' bits
        tree_cfs{J+1}(:,:,s2,s1) = y(1:m/jsize, 1:n/jsize, y_dim);
    end
end

return