%Take a cell array of image paths and use that inside the loop.
sigma = 2;
thresh = 0.05;
radius = 2;
kernel = 5;
threshold = 0.5;
num_images = 2;
image_paths = cell(num_images);
image_paths{1} = '../data/part1/hill/1.jpg';
image_paths{2} = '../data/part1/hill/2.jpg';
%Cell array to hold rows,columns and modified image
I = cell(num_images,3); 


for k = 1:num_images
    im = im2double(rgb2gray(imread(image_paths{k})));
    rs = size(im,1);
    cs = size(im,2);
    %Each row of I holds the information pertaining to an image
    %Column 1 holds the image obtained from the Harris detector
    %Column 2 holds the x values of the pixels of the feature points 
    %Column 3 holds the y values of the pixels of the feature points
    [I{k,1}, I{k,2}, I{k,3}] = harris(im, sigma, thresh, radius,0);
    I{k,1} = im;
    inds_im_x = [];
    inds_im_y = [];
    %Column of I holds the distance vectors for each image
    %Initialize a distance vector of the length of the feature points to
    %hold the flattened neighbourhoods 
    dists = zeros(length(I{k,2}),kernel^2);
    %Pad the image array by floor(kernel/2)
    im = padarray(im,[floor(kernel/2), floor(kernel/2)]);
    r_temp = I{k,2};
    c_temp = I{k,3};
    for i = floor(kernel/2):length(r_temp)
        hk = floor(kernel/2); %Half kernel size
        neigh = im(r_temp(i)-hk:r_temp(i)+hk,c_temp(i)-hk:c_temp(i)+hk);
        vec = neigh(:);
        dists(i,:) = (vec - mean(vec))/std(vec);
             
    end
    

I{k,4} = dists;
end

%Now find the distances between each of the two distance vectors

%Now we start using images two at a time.

%Concerned Images, select top two images from I cell array
CI = I(1:2,:);

dists = dist2(CI{1,4},CI{2,4});
%Find which distances lie below the threshold
[fp1, fp2] = find(dists <= threshold);
%fp1 represents the feature points found in image 1
%fp2 represents the feature points found in image 2

inds_im1_x = CI{1,2};
inds_im1_y = CI{1,3};
inds_im2_x = CI{2,2};
inds_im2_y = CI{2,3};

%Store the matching points
x1 = inds_im1_x(fp1);  %Pixel values corresponding to Image 1 that have close matches with image 2 Fps
y1 = inds_im1_y(fp1);   
x2 = inds_im2_x(fp2);
y2 = inds_im2_y(fp2);



%Plot these points on the two images side by side.
im_to_plot =[CI{1,1},CI{2,1}];
imshow(im_to_plot);
hold on;
x_plotting = [y1',y2' + size(CI{1,1},2)];
y_plotting = [x1',x2'];
plot(x_plotting,y_plotting,'r*', 'LineWidth', 2, 'MarkerSize', 2)
hold on;
x_plotting = [y1';y2' + size(CI{1,1},2)];
y_plotting = [x1';x2'];

plot(x_plotting,y_plotting)
%Store these feature point coordinates in the Cell Array CI for easier
%access. 
CI{1,5} = x1; CI{1,6} = y1; CI{2,5} = x2; CI{2,6} = y2;


%%
%Need to run RANSAC on these points.
x1 = CI{1,5}; 
y1 = CI{1,6};
x2 = CI{2,5};
y2 = CI{2,6};
iters = 20000;
thresh = 1;
num_rand_inds = 4;
[best_H, best_inliers,residual] = ransac_proper(x1,y1,x2,y2,iters,num_rand_inds);
disp('Best H matrix obtained from RANSAC:')
best_H


%Now to transform Image 2 corners by applying homography.
im1 = rgb2gray(imread(image_paths{1}));
im2 = rgb2gray(imread(image_paths{2}));





corners_in = [1,1;...
            1,size(im1,2);...
            size(im1,1),1;...
            size(im1,1),size(im1,2);
            ];
corners_out = best_H*[corners_in(:,2)';corners_in(:,1)';ones(1,4)];
corners_out = corners_out ./ corners_out(3,:)
corners_out = round(corners_out)
corners_out = corners_out'

T = maketform('projective',corners_in,corners_out(:,1:2))
i = imtransform(im1,T,'bicubic');
imshow(i)