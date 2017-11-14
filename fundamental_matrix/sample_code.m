
Normalize = 0;
im1_orig = imread('../data/part2/house1.jpg');
im2_orig = imread('../data/part2/house2.jpg');

% first, fit fundamental matrix to the groundTruthMatches
groundTruthMatches = load('../data/part2/house_matches.txt');

matches = groundTruthMatches;
fp1MatchInds = groundTruthMatches(:,1:2);
fp2MatchInds = groundTruthMatches(:,3:4);

fp1MatchIndsHomo = [fp1MatchInds,ones(size(fp1MatchInds,1),1)];
fp2MatchIndsHomo = [fp2MatchInds,ones(size(fp2MatchInds,1),1)];

N = size(matches,1);

if Normalize == 0
%Without Normalization
F = estimateFundamentalMatrix(matches(:,1:2),matches(:,3:4)); % this is a function that you should write
residualUnNorm = mean(calcResidualF(F,fp1MatchIndsHomo,fp2MatchIndsHomo));
fprintf('The average residual for the Unnormalized algorithm is: %.3f \n',residualUnNorm);
elseif Normalize == 1
%With Normalization
    [transformMat1, fp1Normalized] = normalize(fp1MatchIndsHomo);
    [transformMat2, fp2Normalized] = normalize(fp2MatchIndsHomo);
    F = estimateFundamentalMatrix(fp1Normalized,fp2Normalized); % this is a function that you should write
    %Need to convert back to original coordinates
    F = transformMat2' * F * transformMat1;
    residualNorm = mean(calcResidualF(F,fp1Normalized,fp2Normalized));
    fprintf('The average residual for the Normalized algorithm is: %.3f',residualNorm);
end




% the first image to get epipolar lines in the second image
L2 = (F * [matches(:,1:2) ones(N,1)]')'; % transform points from 

% find points on epipolar lines L closest to matches(:,3:4)
L2 = L2 ./ repmat(sqrt(L2(:,1).^2 + L2(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L2 .* [matches(:,3:4) ones(N,1)],2);
L2closest_pt = matches(:,3:4) - L2(:,1:2) .* repmat(pt_line_dist, 1, 2);

% find endpoints of segment on epipolar line (for display purposes)
L2pt1 = L2closest_pt - [L2(:,2) -L2(:,1)] * 10; % offset from the closest point is 10 pixels
L2pt2 = L2closest_pt + [L2(:,2) -L2(:,1)] * 10;

% display points and segments of corresponding epipolar lines on image 2
clf;
imshow(im2_orig); hold on; 
plot(matches(:,3), matches(:,4), '+r');
line([matches(:,3) L2closest_pt(:,1)]', [matches(:,4) L2closest_pt(:,2)]', 'Color', 'r');
line([L2pt1(:,1) L2pt2(:,1)]', [L2pt1(:,2) L2pt2(:,2)]', 'Color', 'g');
title('Image 2')


%{
L1 = (F * [matches(:,3:4) ones(N,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L1 = L1 ./ repmat(sqrt(L1(:,1).^2 + L1(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L1 .* [matches(:,1:2) ones(N,1)],2);
L1closest_pt = matches(:,1:2) - L1(:,1:2) .* repmat(pt_line_dist, 1, 2);

% find endpoints of segment on epipolar line (for display purposes)
L1pt1 = L1closest_pt - [L1(:,2) -L1(:,1)] * 10; % offset from the closest point is 10 pixels
L1pt2 = L1closest_pt + [L1(:,2) -L2(:,1)] * 10;

% display points and segments of corresponding epipolar lines
clf;
imshow(im1_orig); hold on;
plot(matches(:,1), matches(:,2), '+r');
line([matches(:,1) L1closest_pt(:,1)]', [matches(:,2) L1closest_pt(:,2)]', 'Color', 'r');
line([L1pt1(:,1) L1pt2(:,1)]', [L1pt1(:,2) L1pt2(:,2)]', 'Color', 'g');
title('Image 1');
%}