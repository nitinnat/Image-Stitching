function [fp1MatchInds,fp2MatchInds] = findPutativeMatches(im1,im2,threshold,kernel)




    sigma = 2;
    thresh = 0.02;
    radius = 2;
    
    
    [~,r1,c1] = harris(im1, sigma, thresh, radius,0);
    fp1 = [r1,c1];  %Feature points of image 1
    [~,r2,c2] = harris(im2, sigma, thresh, radius,0);
    fp2 = [r2,c2] ; %Feature points of image 2
    %Column of I holds the distance vectors for each image
    %Initialize a distance vector of the length of the feature points to
    %hold the flattened neighbourhoods 
    
    
    dists1 = [];
    dists2 = [];
    %Store indices of those 
    %points where distance is lesser than threshold.
    fp1Valid = [];
    fp2Valid = [];

    %Pad the image array by floor(kernel/2)
   
    hk = floor(kernel/2); %Half kernel size
    
    for i = 1:length(fp1)
        if fp1(i,1) - hk > 0 && fp1(i,2) - hk > 0 ...
            && fp1(i,1) + hk <= size(im1,1) && fp1(i,2) + hk <= size(im1,2)
            neigh = im1(fp1(i,1)-hk:fp1(i,1)+hk,fp1(i,2)-hk:fp1(i,2)+hk);
            vec = neigh(:)';
            dists1 = [dists1;(vec - mean(vec))/std(vec)];
            fp1Valid = [fp1Valid;fp1(i,1),fp1(i,2)];
        end
    end
    fprintf('Done with fp1 \n');  
    
    for i = 1:length(fp2)
        if fp2(i,1) - hk > 0 && fp2(i,2) - hk > 0 ...
            && fp2(i,1) + hk <= size(im2,1) && fp2(i,2) + hk <= size(im2,2)
            neigh = im2(fp2(i,1)-hk:fp2(i,1)+hk,fp2(i,2)-hk:fp2(i,2)+hk);
            vec = neigh(:)';
            dists2 = [dists2;(vec - mean(vec))/std(vec)];
            fp2Valid = [fp2Valid;fp2(i,1),fp2(i,2)];
        end
    end
    fprintf('Done with fp2 \n');

dists = dist2(dists1,dists2);

[match_fp1,match_fp2] = find(dists <= threshold);
fp1MatchInds = fp1Valid(match_fp1,1:2);
fp2MatchInds = fp2Valid(match_fp2,1:2);
plotfps(im1,im2,fp1MatchInds,fp2MatchInds);
end