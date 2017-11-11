function [rs,cs, rads,im,orig_im] = BlobDetector2(impath,scale, k,num_filters, threshold)

orig_im = imread(impath);
im = im2double(rgb2gray(orig_im));
rows = size(im,1);
cols = size(im,2);

filt_ims = zeros(rows,cols,num_filters);
%Since we can keep the value of scale constant, create the filter once for
%speed improvements.
filter = (scale^2) * fspecial('log',2*ceil(scale*3+1), scale);
ords = zeros(size(filt_ims));
for i = 1:num_filters
        new_im = imresize(im, 1/(k^(i-1)),'bicubic');       
        new_im_resp = imfilter(new_im,filter,'same','replicate');
        new_im_resp = new_im_resp .^ 2;
        filt_ims(:,:,i) = imresize(new_im_resp,[rows cols],'bicubic');
        
        %Non max suppression
        ords(:,:,i) = ordfilt2(filt_ims(:,:,i), 25, ones(5));
        %filt_ims(:,:,i) = filt_ims(:,:,i) .* (ord == filt_ims(:,:,i));
        
        %Update the size of the image to convolve over
        
end



for i = 1:num_filters
    
        ords(:,:,i) = max(ords(:,:,1:num_filters),[],3);
    
end
ords = ords .* (ords == filt_ims);

%Now we can go through each layer and pick out the circles to be drawn
rs = [];   
cs = [];   
rads = [];
for i=1:num_filters
    [rows, cols] = find(ords(:,:,i) >= threshold);
    rs = [rs; rows];
    cs = [cs; cols];
    radii =  scale * k^(i-1) * sqrt(2); 
    radii = repmat(radii, size(rows,1), 1);
    rads = [rads; radii];
end


%{
%%
if length(cs) <= 4000
    show_all_circles(orig_im,cs, rs, rads,threshold,k,scale,num_filters,'r',1);
end
%}
end