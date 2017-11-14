T = maketform('projective',inv(best_H)');
[im1Transformed,xdata,ydata] = imtransform(im1_orig,T,'bicubic');
figure,imshow(im1Transformed);
[im1t,xdataim1t,ydataim1t]=imtransform(im1,T);
xdataout=[min(1,xdataim1t(1)) max(size(im2,2),xdataim1t(2))];
ydataout=[min(1,ydataim1t(1)) max(size(im2,1),ydataim1t(2))];
xx = ceil(max(size(im2,2),(xdataim1t(2) - xdataim1t(1))))
yy = ceil(max(size(im2,1),(ydataim1t(2) - ydataim1t(1))))
canvas = zeros(xx,...
    yy);
canvas(1:size(im1t,1),1:size(im1t,2)) = im1t;
%figure,imshow(canvas)

%%
im1t=imtransform(im1,T,'XData',xdataout,'YData',ydataout);
im2t=imtransform(im2,maketform('affine',eye(3)),'XData',xdataout,'YData',ydataout);
ims=im1t/2+im2t/2;
figure,imshow(ims)