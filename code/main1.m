clear

threshold = 1;
%[rs1, cs1, rads1,im1,orig_im1] = BlobDetector2('../data/part1/hill/1.jpg',1,1.8,8,0.02);
%[rs2, cs2, rads2,im2,orig_im2] = BlobDetector2('../data/part1/hill/2.jpg',1,1.8,8,0.02);


%For each value of (cs1[i],rs1[i]) found, extract local neighbourhoods and
%contract into a 1D vector

kernel = 3;
dists1 = zeros(length(rs1),kernel^2);
dists2 = zeros(length(rs2),kernel^2);

inds_im1_x = [];
inds_im1_y = [];

% Find neighbourhoods and flattern
for i = 1:length(rs1)
    for j = 1:length(cs1)
        if i >floor(kernel/2) && j > floor(kernel/2) ...
            && i <= size(im1,1)-floor(kernel/2) ...
            && j <= size(im1,2) - floor(kernel/2)
         
            neigh = im1(i-1:i+1,j-1:j+1);
            vec = neigh(:);
            dists1(i,:) = (vec - mean(vec))/std(vec);
            inds_im1_x = [inds_im1_x;i];
            inds_im1_y = [inds_im1_y;j];
        end
        
    end
end



inds_im2_x = [];
inds_im2_y = [];

%Running only for valid pixels
for i = 1:length(rs2)
    for j = 1:length(cs2)
        if i >floor(kernel/2) && j > floor(kernel/2) ...
            && i <= size(im2,1)-floor(kernel/2) ...
            && j <= size(im2,2) - floor(kernel/2)
            neigh = im2(i-1:i+1,j-1:j+1);
            vec = neigh(:);
            dists2(i,:) = (vec - mean(vec))/std(vec);
            inds_im2_x = [inds_im2_x;i];
            inds_im2_y = [inds_im2_y;j];
        end
        
    end
end


%Find distance between every vector and every other vector

desc_dists = dist2(dists1, dists2);
desc_dists(desc_dists == 0) = 100;

%Find which distances lie below the threshold
[fp1, fp2] = find(desc_dists <= threshold);
%fp1 represents the feature points found in image 1
%fp2 represents the feature points found in image 1

x1 = inds_im1_x(fp1);  %Pixel values corresponding to Image 1 that have close matches with image 2 Fps
y1 = inds_im1_y(fp1);
x2 = inds_im2_x(fp2);
y2 = inds_im2_y(fp2);

x = [x1;x2];
y = [y1;y2];
%Run ransac to get the best m and c parameters
[m_fit, b_fit, min_err, inliners, B_collection,errors] = ransac(x1,y1,x2, y2,4,20,0.1,150);

figure, imshow(orig_im1);
hold on;
xs = 1:size(im1,2);
ys = m_fit*xs + b_fit;

plot(xs,ys)