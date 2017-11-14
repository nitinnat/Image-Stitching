function [] = plotfps(im1,im2,fp1,fp2)

    x1 = fp1(:,1);
    y1 = fp1(:,2);
    x2 = fp2(:,1);
    y2 = fp2(:,2);
    im_to_plot =[im1,im2];
    imshow(im_to_plot);
    hold on;
    x_plotting = [y1',y2' + size(im1,2)];
y_plotting = [x1',x2'];
plot(x_plotting,y_plotting,'r*', 'LineWidth', 2, 'MarkerSize', 2)
hold on;
x_plotting = [y1';y2' + size(im1,2)];
y_plotting = [x1';x2'];
plot(x_plotting,y_plotting)
end