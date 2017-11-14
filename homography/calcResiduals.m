function residuals = calcResiduals(H, fp1MatchInds, fp2MatchInds)
fprintf('Size of fp1MatchInds is [%d,%d] and of fp2MatchInds is [%d,%d] \n',size(fp1MatchInds), size(fp2MatchInds))

%Convert coordinates into homogeneous coordinates
N = size(fp1MatchInds,1);
fp1MatchIndsHomo =  fp1MatchInds';%[fp1MatchInds';ones(1,N)];
fp2MatchIndsHomo =  fp2MatchInds';%[fp2MatchInds';ones(1,N)];
fprintf('Multiplying size [%d,%d] with [%d,%d] \n',size(H), size(fp1MatchIndsHomo))
    %Find predicted points
    fp2MatchIndsPred =  H * fp1MatchIndsHomo;
    fp2MatchIndsPred = fp2MatchIndsPred';
    fp2MatchIndsPred = fp2MatchIndsPred ./ fp2MatchIndsPred(:,3);
    
    
    
    
    X1 = fp2MatchIndsPred(:,1)  - fp2MatchInds(:,1);
    Y1 = fp2MatchIndsPred(:,2)  - fp2MatchInds(:,2);
    residuals = X1 .* X1 + Y1 .* Y1;

end