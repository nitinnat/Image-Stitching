%function [best_H,leastError,H_collection] = ransacFundamental(fp1MatchInds,fp2MatchInds,iters, t)
iters = 5
numRandInds = 8;
t = 10;
d = floor(length(fp1MatchInds) * 0.60);

best_H = [];

best_inliers = 0;
count = 1;

H_collection = cell(0);
for iter = 1:iters
    %Pick 8 random points.
    matchInds = randperm(length(fp1MatchInds),numRandInds);
    fprintf('%d random indices selected. \n',length(matchInds));
    %Fit the model to the set of hypothetical inliers
    A = generateAFundamental(fp1MatchInds(matchInds,:),fp2MatchInds(matchInds,:))
    %Calculate Homography H for the A matrix obtained.
    %H = estimateHomography(A);
    
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
    sqError = (fp2OtherInds' - fp2OtherIndsPred').^2;
    ssdError = (sqError(:,1) + sqError(:,2));
    ssdError,t
    inlierInds = find(ssdError < t);
    if inlierInds >= d
        %Refit on all these inlier points.
        fp1RefitInds = fp1OtherInds(:,inlierInds)';
        fp2RefitInds = fp2OtherInds(:,inlierInds)';
        
        A = generateAFundamental(fp1RefitInds,fp2RefitInds);
        H = estimateHomography(A);
        H_collection{count,1} = H;
        
        %Estimate best fit error on all the points
        fp1allPointsInput = [fp1MatchInds';ones(1,size(fp1MatchInds,1))];
        fp2allPointsPred = H*fp1allPointsInput;
        fp2allPointsPred = fp2allPointsPred ./ fp2allPointsPred(3,:);
        fp2allPointsPred = fp2allPointsPred(1:2,:)';
        sqError = (fp2allPointsPred' - fp2MatchInds').^2;
        ssdError = sum(sqError(:,1) + sqError(:,2));
        H_collection{count,2} = ssdError;
        H_collection{count,3} = fp2OtherInds(:,inlierInds)';
        H_collection{count,4} = fp2allPointsPred(1:2,:)';
        count = count + 1;
    end
end
leastError = Inf;
for i = 1:size(H_collection,1)
    if H_collection{i,2} < leastError
        leastError = H_collection{i,2}
        best_H = H_collection{i,1};
    end
    
end
 fp1allPointsInput = [fp1MatchInds';ones(1,size(fp1MatchInds,1))];

end