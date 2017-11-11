function [m_fit, b_fit,min_err, inliners, B_collection,errors] = ransac(x1,y1,x2,y2, k,iters,r_thresh,d)
%{
Finds best slope and intercept and slope from a given set of points
Arguments:
    1. x1m, y1m -> x and y coordinates of random matching points selected
    from image 1.
    2. x2m, y2m -> Same as above but for image 2.
Returns slope m and y-intercept b
%}

%%
min_error = inf;
m_fit = 'Garbage';
b_fit = 'Garbage';
n = length(x);
B_collection = [];
inliners = {};
%iters = 10
%k= 4
%r_thresh = 0.1
%d = 100
for iter = 1:iters
    %Randomly pick k matching points using randperm
    match_inds = randperm(length(x),k);
    x1m = x1(match_inds);
    y1m = y1(match_inds);
    x2m = x2(match_inds);
    y2m = y2(match_inds);
    
    %Create the A matrix in the homography solution.
    
    
    
    
    %Fit model on xm and ym
    xm = cat(2,xm,ones(length(xm),1));
    
    B = pinv(xm)*ym;
    m = B(1);
    b = B(2);
    
    %Now find the error with all other points in both Images
    
    dists_from_line = pdist2(y,m*x + b,'euclidean');
    [inds,vals] = find(dists_from_line <= r_thresh);
    
    %Since error was found for all the points, we need to subtract the
    %ones that were taken to fit the line.
    if length(inds) > d - k
        
        %Refit the structure using all the points
        temp_x = [x(inds),ones(length(inds),1)];
        temp_y = y(inds);
        B = pinv(temp_x)*temp_y;
        
        B_collection = [B_collection,B];
        
        inliners{end+1} = inds;
    end
    



end

errors = [];
B_collection = transpose(B_collection);
for i = 1:length(B_collection)
   m = B_collection(i,1);
   b = B_collection(i,2);
   err = sum((m*temp_x(:,1) + b - temp_y).^2);
   errors = [errors ,err];
end

[min_err, min_ind] = min(errors);
m_fit = B_collection(min_ind,1);
b_fit = B_collection(min_ind,2);
inliners = inliners{min_ind};
end