function [best_F,leastError,bestInlierInds,bestInlierResidual] = ransacFund2(fp1MatchInds,fp2MatchInds,iters, t)

%Number of points to consider. 8 in the case of Fundamental Matrix.
numRandInds = 8;


d = floor(length(fp1MatchInds) * 0.30); %Inlier threshold
best_F = []; %To store the value of the best F matrix
bestInlierInds = 0; %Indices of inliers
bestInlierResidual = Inf;
count = 1;

F_collection = cell(0);
for iter = 1:iters
    %Pick 4 random points.
    matchInds = randperm(length(fp1MatchInds),numRandInds);
    fprintf('%d random indices selected. \n',length(matchInds));
    %Fit the model to the set of hypothetical inliers
    %Normalize the coordinates and calculate F
    fp1MatchIndsHomo = [fp1MatchInds,ones(size(fp1MatchInds,1),1)];
    fp2MatchIndsHomo = [fp2MatchInds,ones(size(fp2MatchInds,1),1)];
    
    [transformMat1, fp1Normalized] = normalize(fp1MatchIndsHomo);
    [transformMat2, fp2Normalized] = normalize(fp2MatchIndsHomo);
    %Calculate F for the obtained A using Normalized algorithm
    F = estimateFundamentalMatrix(fp1Normalized,fp2Normalized);
    F = transformMat2' * F' * transformMat1;
    F = F';
    
    %Find the distance of structure from other points.
    new_inds = setdiff(1:length(fp1MatchInds),matchInds);
    
    fp1OtherInds = [fp1MatchInds(new_inds,:)';ones(1,length(new_inds))];
    fp2OtherInds = [fp2MatchInds(new_inds,:)';ones(1,length(new_inds))];
    fprintf('Size of Input Matrix for other points is [%d,%d] \n',...
        size(fp1OtherInds,1),size(fp1OtherInds,2)); 
    
    
    %residual function expects columnwise inputs of size N x 3
    ssdErrorF = calcResidualF(F,fp1OtherInds',fp2OtherInds');
    
    inlierInds = find(ssdErrorF < t);
    size(inlierInds)
    if length(inlierInds) > d
        fprintf('No. of inliers obtained: %d ',size(inlierInds));
        %Refit on all these inlier points.
        fp1RefitInds = fp1OtherInds(:,inlierInds)';
        fp2RefitInds = fp2OtherInds(:,inlierInds)';
        fprintf('Fitting on all other inliers');
        [transformMat1, fp1Normalized] = normalize(fp1RefitInds);
        [transformMat2, fp2Normalized] = normalize(fp2RefitInds);
        F = estimateFundamentalMatrix(fp1Normalized,fp2Normalized);
        F = transformMat2' * F * transformMat1;
        F = F';
        F_collection{count,1} = F;
        
        %Estimate best fit error on all the points
        fp1allPointsInput = [fp1MatchInds';ones(1,size(fp1MatchInds,1))];
        size(fp1allPointsInput),size(fp2MatchInds)
        ssdErrorF = calcResidualF(F,fp1allPointsInput',[fp2MatchInds,ones(length(fp2MatchInds),1)]);
        ssdErrorInliers = calcResiduals(F,fp1RefitInds,fp2RefitInds);

        F_collection{count,2} = mean(ssdErrorF);
        F_collection{count,4} = mean(ssdErrorInliers);
        %Store the inlier matches
        F_collection{count,3} = [fp1OtherInds(:,inlierInds)', fp2OtherInds(:,inlierInds)'];
        %H_collection{count,4} = fp2allPointsPred(1:2,:)';
        count = count + 1;
    end
end
d
leastError = Inf;
for i = 1:size(F_collection,1)
    if F_collection{i,2} < leastError
        leastError = F_collection{i,2};
        best_F = F_collection{i,1};
        bestInlierInds = F_collection{i,3};
        bestInlierResidual = F_collection{i,4};
    end
    
end
 

end