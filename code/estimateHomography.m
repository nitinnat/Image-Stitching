function [H] = estimateHomography(A)

    %Calculate Homography H for the A matrix obtained.
    [~,~,V] = svd(A);
    H = V(:,end);
    H = H/H(9);
    %Perform a sanity check. sum(AH) ~= 0
    fprintf('Value of sum(A*H) is %.3f \n',sum(A*H)); 
    H = reshape(H,[3 3])';

end