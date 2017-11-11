clear
%Main function
sigma = 2;
thresh = 0.05;
radius = 2;
kernelSize = 7;
iters = 2000;
dist_threshold = 3;

%Cell array to hold rows,columns and modified image
im1_orig = rgb2gray(imread('../data/part1/hill/1.jpg'));
im2_orig = rgb2gray(imread('../data/part1/hill/2.jpg'));
im1 = im2double(rgb2gray(imread('../data/part1/hill/1.jpg')));
im2 = im2double(rgb2gray(imread('../data/part1/hill/2.jpg')));

%Find putative matches between the two images.
[fp1MatchInds,fp2MatchInds] = findPutativeMatches(im1,im2,dist_threshold,kernelSize);

numRandInds = 4;
[best_H, least_error,H_collection] = ransac_proper2(fp1MatchInds,fp2MatchInds,2000,10,numRandInds);
output = best_H*[fp2MatchInds';ones(1,size(fp2MatchInds,1))];
output = output ./ output(3,:);
output = output(1:2,:);
U = [1,1;...
     1,size(im2_orig,2);...
     size(im2_orig,1),1;...
     size(im2_orig,1),size(im2_orig,2);
     ];
 X = best_H*[1,1,1;1,size(im1_orig,2),1;size(im1_orig,1),1,1;...
     size(im1_orig,1),size(im1_orig,2),1]';
 X = X ./ X(3,:);
 X = X';
 X = X(:,1:2)
T = maketform('projective',U,X)
im1Transformed = imtransform(im1,T);
figure,imshow(im1Transformed);

