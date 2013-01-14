% This function shrinks a matrix to a certian factor
% A_shrink = shrink(A, shrinkage);
function A_shrink = shrink(A, shrinkage)

    [n m] = size(A);

    %% Cutoff pixles, such that mod(n, shrinkage == 0)
    while mod(n,shrinkage) ~= 0 
        A = A(1:n-1,:);
        n = n-1;

    end

    while mod(m,shrinkage) ~= 0 
        A = A(:,1:m-1);
        m = m-1;
    end

    A_shrink = zeros(n/shrinkage, m/shrinkage);
    
    A(A<0) = -9999999;
    %%%% Set all values that are not in the roi to something very negative

    new_i = 0;

    for i = 1 : shrinkage : n
        new_i = new_i + 1;
        new_j = 0;
        for j = 1 : shrinkage : m
            new_j = new_j + 1;        
            A_shrink(new_i, new_j) = sum(sum(A(i:i+shrinkage-1, j:j + shrinkage-1)))/shrinkage/shrinkage;        
        end
    end
   %%%% Set all values that are negative to -1!!!
    
    A_shrink(A_shrink<0) = -1;
    
    %%%%% Set the size of the map to an odd value (add -1's)
    A_shrink(:,size(A_shrink,2) + mod(size(A_shrink,2),2) ) = -1;
    A_shrink(size(A_shrink,1) + mod(size(A_shrink,1),2),: ) = -1;   

end



