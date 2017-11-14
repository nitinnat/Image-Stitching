function [best_H,leastError,bestInlierInds,bestInlierResidual] = ransac_proper2(fp1MatchInds,fp2MatchInds,iters, t)

%{
RANSAC function for homography
Inputs: Both sets of matching points, number of iterations and error threshold t
Outputs: best homography, least residual error, inlier indices, inlier residual error

%}
numRandInds = 4;

d = floor(length(fp1MatchInds) * 0.40);

best_H = [];

bestInlierInds = 0;
bestInlierResidual = Inf;
count = 1;

H_collection = cell(0);
for iter = 1:iters
    %Pick 4 random points.
    matchInds = randperm(length(fp1MatchInds),numRandInds);
    fprintf('%d random indices selected. \n',length(matchInds));
    %Fit the model to the set of hypothetical inliers
    A = generateA(fp1MatchInds(matchInds,:),fp2MatchInds(matchInds,:));
    %Calculate Homography H for the A matrix obtained.
    H = estimateHomography(A);
    
    %Find the distance of structure from other points.
    new_inds = setdiff(1:length(fp1MatchInds),matchInds);
    
    fp1OtherInds = [fp1MatchInds(new_inds,:)';ones(1,length(new_inds))];
    fp2OtherInds = [fp2MatchInds(new_inds,:)';ones(1,length(new_inds))];
    fprintf('Size of Input Matrix for other points is [%d,%d] \n',...
        size(fp1OtherInds,1),size(fp1OtherInds,2)); 
    
    fp2OtherIndsPred = H*fp1OtherInds;
    fp2OtherIndsPred = fp2OtherIndsPred ./ fp2OtherIndsPred(3,:);
    fprintf('Size of Predicted Output Matrix for other points is [%d,%d] \n',...
        size(fp2OtherIndsPred,1),size(fp2OtherIndsPred,2));
    
    %sqError = (fp2OtherInds' - fp2OtherIndsPred').^2;
    %ssdError = (sqError(:,1) + sqError(:,2));
    %ssdError,t;
    
    %residual function expects columnwise inputs of size N x 3
    ssdError = calcResiduals(H,fp1OtherInds',fp2OtherInds')
    inlierInds = find(ssdError < t);
    size(inlierInds)
    if length(inlierInds) > d
        fprintf('No. of inliers obtained: %d ',size(inlierInds));
        %Refit on all these inlier points.
        fp1RefitInds = fp1OtherInds(:,inlierInds)';
        fp2RefitInds = fp2OtherInds(:,inlierInds)';
        
        A = generateA(fp1RefitInds,fp2RefitInds);
        H = estimateHomography(A);
        H_collection{count,1} = H;
        
        %Estimate best fit error on all the points
        fp1allPointsInput = [fp1MatchInds';ones(1,size(fp1MatchInds,1))];
        size(fp1allPointsInput),size(fp2MatchInds)
        ssdError = calcResiduals(H,fp1allPointsInput',[fp2MatchInds,ones(length(fp2MatchInds),1)]);
        ssdErrorInliers = calcResiduals(H,fp1RefitInds,fp2RefitInds);

        H_collection{count,2} = mean(ssdError);
        H_collection{count,4} = mean(ssdErrorInliers);
        %Store the inlier matches
        H_collection{count,3} = [fp1OtherInds(:,inlierInds)', fp2OtherInds(:,inlierInds)'];
        %H_collection{count,4} = fp2allPointsPred(1:2,:)';
        count = count + 1;
    end
end
leastError = Inf;
for i = 1:size(H_collection,1)
    if H_collection{i,2} < leastError
        leastError = H_collection{i,2};
        best_H = H_collection{i,1};
        bestInlierInds = H_collection{i,3};
        bestInlierResidual = H_collection{i,4};
    end
    
end
 

end