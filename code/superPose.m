%function [compImage] = superPose(im1,im2)
%Keeping image 1 constant
%{
[im2t,xdataim2t,ydataim2t]=imtransform(im2,T);
xdataout=[min(1,xdataim2t(1)) max(size(im1,2),xdataim2t(2))];
ydataout=[min(1,ydataim2t(1)) max(size(im1,1),ydataim2t(2))];
im2t=imtransform(im2,T,'XData',xdataout,'YData',ydataout);
im1t=imtransform(im1,maketform('affine',eye(3)),'XData',xdataout,'YData',ydataout);
ims=im1t/2+im2t/2;
figure,imshow(ims)
%}
%canvas = zeros(size(im1Transformed,1),size(im1Transformed,1));
%canvas2 = zeros(size(im1Transformed,1),size(im1Transformed,1));

%canvas = zeros(346,400+400);
%canvas(1:346,1:438) = im1Transformed;   
%canvas(46:346-1,200:600-1) = im2;

%canvas2(1:300,1:400) = im2;
%canvas = canvas1 + canvas2;
%overlap = canvas1 & canvas2;
%canvas(overlap) = canvas(overlap)/2;
%imshow(canvas);


T = maketform('projective', best_H);
    [img_left,xdata_range,ydata_range]=imtransform(im1_orig,T, 'nearest');
    xdataout=[min(1,xdata_range(1)) max(size(im2_orig,2),xdata_range(2))];
    ydataout=[min(1,ydata_range(1)) max(size(im2_orig,1),ydata_range(2))];
    img_left=imtransform(im1_orig,T,'nearest','XData',xdataout,'YData',ydataout);
    img_right=imtransform(im2_orig,maketform('affine',eye(3)),'nearest','XData',xdataout,'YData',ydataout);
    [new_height, new_width, tmp] = size(img_left);
    output = img_left;
    for i = 1:new_height*new_width*tmp
        
            if(output(i) == 0)
                output(i) = img_right(i);
            elseif(output(i) ~= 0 && img_right(i) ~= 0)
                output(i) = img_left(i)/2 + img_right(i)/2;
            end
    end
  
    figure();
    imshow(output);
   