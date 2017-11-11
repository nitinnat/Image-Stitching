function [A] = generateA(fp1MatchInds,fp2MatchInds)
%Inputs : fp1MatchInds = [x1,y1;.....] from the first image.
%         fp2MatchInds = [x1,y1;.....] from the second image.

%Output : A matrix of the form:
%first_row  = [X,Y,1,0,0,0,-X1*X,-X1*Y,-X1];
%second_row = [0,0,0,X,Y,1,-Y1*X,-Y1*Y,-Y1];
% All four inputs must be of the same length 
    A = [];
    x1 = fp1MatchInds(:,1);
    y1 = fp1MatchInds(:,2);
    x2 = fp2MatchInds(:,1);
    y2 = fp2MatchInds(:,2);
    for i = 1:length(x1)
        
        first_row  = [x1(i),y1(i),1,0,0,0,-x1(i)*x2(i),-y1(i)*x2(i),-x2(i)];
        second_row = [0,0,0,x1(i),y1(i),1,-y2(i)*x1(i),-y2(i)*y1(i),-y2(i)];
        A = [A;first_row;second_row];   
    end


end