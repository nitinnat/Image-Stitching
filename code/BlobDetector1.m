
function [rs,cs, rads] = BlobDetector1(impath,scale, k,num_scales, threshold)

%trying with both ordfilt2 and then nlfilter
tic
%Inputting image, converting to grayscale and double.
orig_im = imread(impath);
im = im2double(rgb2gray(orig_im));

%% Setting Parameters
%threshold = 0.03;  %Threshold to filter the image responses by.
start_scale = scale; %Scale to start the filter for the first layer of the scale space.
rows = size(im,1); 
cols = size(im,2);
%num_scales = 8;  %Size of scale space.
%k = 2; %Multiplier
filt_ims = zeros(rows,cols,num_scales);
ords = zeros(size(filt_ims));
tic
for i = 1:num_scales
        %Create filter
        filter = (scale^2) * fspecial('log',2*ceil(3*scale)+1, scale);
        %Apply filter on image
        im_resp = imfilter(im,filter,'same','replicate');
        
        
        %Store the square of the LoG response.
        filt_ims(:,:,i) = im_resp.^2;        
        
        
        %Do non maximum suppression in the 2D scale.
        ords(:,:,i) = ordfilt2(filt_ims(:,:,i), 25, ones(5));
        %ords(:,:,i) = ords(:,:,i) .* (ords(:,:,i) == filt_ims);
        %Modify scale for next iteration
        scale = k*scale;
        
end



for i = 1:num_scales
        ords(:,:,i) = max(ords(:,:,1:num_scales),[],3);
end
ords = ords .* (ords == filt_ims);

%Now we can go through each layer and pick out the circles to be drawn
rs = [];   
cs = [];   
rads = [];
for i=1:num_scales
    [rows, cols] = find(ords(:,:,i) >= threshold);
    rs = [rs; rows];
    cs = [cs; cols];
    radii =  start_scale * k^(i-1) * sqrt(2); 
    radii = repmat(radii, size(rows,1), 1);
    rads = [rads; radii];
end

%%
if length(cs) <= 4000
   show_all_circles(orig_im,cs, rs, rads,threshold,k,start_scale,num_scales,'r',1);
end

end