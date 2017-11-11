function [m_fit,b_fit,min_error] = least_squares(x1,y1,x2,y2,k,iters,r_thresh)
%{
Finds best slope and intercept and slope from a given set of points
Arguments:
    1. x1m, y1m -> x and y coordinates of random matching points selected
    from image 1.
    2. x2m, y2m -> Same as above but for image 2.
Returns slope m and y-intercept b
%}

if nargin < 5
    k = 4;
    iters = 100;
    r_thresh = 0.01;
end

if nargin < 6
    iters = 100;
    r_thresh = 0.01;
end


if nargin < 7
    r_thresh = 0.01;
end
n = length(x1);

%Combine x1,x2 and y1,y2 to compute errors later
x = [x1;x2];
y = [y1;y2];
min_error = inf;
m_fit = 'Garbage';
b_fit = 'Garbage';

for iter = 1:iters
    %Randomly pick k matching points using randperm
    match_inds = randperm(length(x1),k);
    x1m = x1(match_inds);
    y1m = y1(match_inds);
    x2m = x2(match_inds);
    y2m = y2(match_inds);

    
    for i = 1:length(x1m)
        %Fit a line between the two points
        m = (y2m(i) - y1m(i))/(x2m(i) - x1m(i));
        b = y2m(i) - m*x2m(i);
        %Now find the error with all other points in both Images
        error = sum(((m*x + b) - y).^2);
        if error < min_error
            min_error = error;
            m_fit = m;
            b_fit = b;
        end
    end



end


end