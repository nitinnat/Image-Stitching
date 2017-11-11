im1_orig = imread('../../data/part2/library1.jpg');
im2_orig = imread('../../data/part2/library2.jpg');

im1 = im2double(rgb2gray(im1_orig));
im2 = im2double(rgb2gray(im2_orig));
groundTruthMatches = load('../../data/part2/library_matches.txt');
fp1MatchInds = groundTruthMatches(:,1:2);
fp2MatchInds = groundTruthMatches(:,3:4);

%Generate A
%Fit Fundamental Matrix on the Ground Truth matches
F = estimateFundamentalMatrix(fp1MatchInds,fp2MatchInds);