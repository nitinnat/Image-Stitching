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
    
    
    
    
    cartDistX = fp2MatchIndsPred(:,1)  - fp2MatchInds(:,1);
    cartDistY = fp2MatchIndsPred(:,2)  - fp2MatchInds(:,2);
    residuals = cartDistX .* cartDistX + cartDistY .* cartDistY;
    size(residuals)
end