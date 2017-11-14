function [F] = estimateFundamentalMatrix(fp1MatchInds,fp2MatchInds)

%Generate A matrix
A = generateAFundamental(fp1MatchInds,fp2MatchInds);

[~,~,V] = svd(A);
F = V(:,9);

F = reshape(F, 3,3)'; %reshape the 9x1 vec into the 3x3 fund matrix
%Enforce rank 2 constraint
[U1, S1, V1] = svd(F);
%throw out the smallest singular value
S1(3,3) = 0;
%recalculate F matrix 
F = U1*S1*V1';
    

end