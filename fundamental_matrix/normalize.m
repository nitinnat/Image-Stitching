function [ tform, normInds ] = normalize( matchIndsHomo )

%Inputs a matrix of m x 3 size containing m points of [x,y,1] vectors,
%i.e. homogeneous coordinates
%Returns normalized coordinates given a set of homogeneous coordinates.

%Form scale and translate matrices

    
    S = [1,0,0;0,1,0;0,0,1];
    S(1,1)=1/max(abs(matchIndsHomo(:,1)));
    S(2,2)=1/1/max(abs(matchIndsHomo(:,2)));         
    
    T = [1,0,0;0,1,0;0,0,1];
    T(1,3) = -mean(matchIndsHomo(:,1));
    T(2,3) = -mean(matchIndsHomo(:,2)); 

                
    tform = S * T;
    normInds = (tform * matchIndsHomo')';
end