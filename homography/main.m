clear
%Main function
sigma = 2;
thresh = 0.05;
radius = 5;
kernelSize = 9;
iters = 4000;
dist_threshold = 7;
t = 1;

%Cell array to hold rows,columns and modified image
im1_orig = rgb2gray(imread('../data/part1/uttower/left.jpg'));
im2_orig = rgb2gray(imread('../data/part1/uttower/right.jpg'));
im1 = im2double(rgb2gray(imread('../data/part1/uttower/left.jpg')));
im2 = im2double(rgb2gray(imread('../data/part1/uttower/right.jpg')));

%Find putative matches between the two images.
[fp1MatchInds,fp2MatchInds] = findPutativeMatches(im1,im2,dist_threshold,kernelSize);

numRandInds = 4;
[best_H, bestFitError,bestInlierInds,bestInlierResidual] = ransac_proper2(fp1MatchInds,fp2MatchInds,iters,t);
best_H
bestInlierResidual
%figure, plotfps(im1,im2,bestInlierInds(:,1:2),bestInlierInds(:,4:5));
output = best_H*[fp2MatchInds';ones(1,size(fp2MatchInds,1))];
output = output ./ output(3,:);
output = output(1:2,:);
%%
T = maketform('projective',inv(best_H)');
[im1Transformed,xdata,ydata] = imtransform(im1_orig,T,'bicubic');
figure,imshow(im1Transformed);
%T = maketform('projective',inv(best_H)');
%[im2Transformed,xdata,ydata] = imtransform(im2_orig,T,'bicubic');
%figure,imshow(im2Transformed);

r = max(size(im1Transformed,1),size(im2,1));
c = size(im1Transformed,2) + size(im2,2);
canvas = zeros(r,c);
size(canvas);
%Place im2 on the right side
im2Xmin = r - size(im2,1); 
im2Xmax = r;
im2Ymin =c- size(im2,2);
im2Ymax = c;

ydata
%{
canvas(im2Xmin+1+xdata(1):im2Xmax+xdata(1),...
    im2Ymin+1+ydata(1):im2Ymax+ydata(1)) = im2_orig(:,:,1);


canvas(1:size(im1Transformed,1),1+xdata(2):size(im1Transformed,2)+xdata(2)) = im1Transformed;
imshow(uint8(canvas))

hold on;
%}


