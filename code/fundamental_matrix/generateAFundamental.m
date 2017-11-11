function [A] = generateAFundamental(fp1MatchInds,fp2MatchInds)


%Inputs : fp1MatchInds = [x1,y1;.....] from the first image.
%         fp2MatchInds = [x1,y1;.....] from the second image.

%Output : A matrix of the form:
%first_row  = [X,Y,1,0,0,0,-X1*X,-X1*Y,-X1];
%second_row = [0,0,0,X,Y,1,-Y1*X,-Y1*Y,-Y1];
% All four inputs must be of the same length 
    A = [];
    u = fp1MatchInds(:,1);
    v = fp1MatchInds(:,2);
    u1 = fp2MatchInds(:,1);
    v1 = fp2MatchInds(:,2);
    
    A = [u1.*u,u1.*v,u1,v1.*u,v1.*v,v1,u,v,ones(size(u1,1),1)];
       


end
