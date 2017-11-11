dest = [141, 131;...
        480, 159 ;...
        493, 630;...
        64, 601];...
src = [318, 256;...
        534, 372;...
        316, 670;...
        73, 473];...
%src = [src';ones(1,4)]
%dest = [dest';ones(1,4)]
x = src(:,1)';
y = src(:,2)';
xd = dest(:,1)';
yd = dest(:,2)';
nPoints = length(x);
A = zeros(2*nPoints,9);
for i = 1:nPoints
    A(2*i-1,:) = [x(i),y(i),1,0,0,0, -x(i)*xd(i), -xd(i)*y(i), -xd(i)];
    A(2*i, :) = [0,0,0,x(i),y(i),1, -x(i)*yd(i), -yd(i)*y(i), -yd(i)];
end
   
   A = generateA(x,y,xd,yd);
  
      [U,S,V] = svd(A);
      H = V(:,end);
      H = H/H(9);
    fprintf('Value of sum(A*H) is %.3f \n',sum(A*H)); 
  
    H = reshape(H,[3 3])';
  
  
   
 