function [F] = estimateFundamentalMatrix(groundTruthMatches,normalizeOrNot)
fp1MatchInds = groundTruthMatches(:,1:2);
fp2MatchInds = groundTruthMatches(:,3:4);
 fp1MatchIndsHomo = [fp1MatchInds,ones(size(fp1MatchInds,1),1)];
 fp2MatchIndsHomo = [fp2MatchInds,ones(size(fp2MatchInds,1),1)];
normalizeOrNot = 1;
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