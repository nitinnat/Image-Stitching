%RANSAC for fundamental matrix estimation
sigma = 2;
thresh = 0.05;
radius = 3;
kernelSize = 7;

dist_threshold = 10;
iters = 2000;
t = 30;

bestInlierResidual = Inf;
%Cell array to hold rows,columns and modified image
im1_orig = imread('../data/part2/house1.jpg');
im2_orig = imread('../data/part2/house2.jpg');
im1 = im2double(rgb2gray(im1_orig));
im2 = im2double(rgb2gray(im2_orig));

%Find putative matches between the two images.
[fp1MatchInds,fp2MatchInds] = findPutativeMatches(im1,im2,dist_threshold,kernelSize);
matches = [fp1MatchInds,fp2MatchInds];
N = length(matches);
[best_F,leastError,bestInlierInds,bestInlierResidual] = ransacFund2(fp1MatchInds,fp2MatchInds,iters,t);
fprintf('Best error obtained is: %.2f',bestInlierResidual);


L = (best_F * [matches(:,1:2) ones(N,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to putative matches of second
% image
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [matches(:,3:4) ones(N,1)],2);
closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

% display points and segments of corresponding epipolar lines
clf;
imshow(im1_orig); hold on;
figure, imshow(im2_orig); hold on;
plot(matches(:,3), matches(:,4), '+r');
line([matches(:,3) closest_pt(:,1)]', [matches(:,4) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');