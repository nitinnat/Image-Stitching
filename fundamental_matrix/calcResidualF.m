function [residualF] = calcResidualF(F,fp1MatchIndsHomo,fp2MatchIndsHomo)

%Accepts Homomgenous points in the form [x,y,1;x1,y1,1...]
%Calculates fundamental matrix loss function

residualF = zeros(length(fp1MatchIndsHomo),1);
for i = 1:length(fp1MatchIndsHomo)
    line = fp1MatchIndsHomo(i,:) * F;
    a = line(1,1);
    b = line(1,2);
    c = line(1,3);
    x = fp2MatchIndsHomo(i,1)/fp2MatchIndsHomo(i,3);
    y = fp2MatchIndsHomo(i,2)/fp2MatchIndsHomo(i,3);
    err = abs(a*x + b*y + c)/sqrt(a^2 + b^2);
    residualF(i,1) = err;
end

end