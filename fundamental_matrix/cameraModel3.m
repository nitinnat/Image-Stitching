%Camera Model 3
im1 = rgb2gray(imread('../../data/part2/house1.jpg'));
im2 = rgb2gray(imread('../../data/part2/house2.jpg'));
m1 = load('../../data/part2/house1_camera.txt');
m2 = load('../../data/part2/house2_camera.txt');
%m1 = [m1;0,0,0,1]
%m2 = [m2;0,0,0,1]

%Extract camera centres
[~,~,V] = svd(m1);
c1 = V(:,end);
c1 = c1/c1(4);
[~,~, V] = svd(m2);
c2 = V(:,end);
c2 = c2/c2(4);

%Calculate epipoles
e1 = m1*c2; 
e2 = m2*c1; 

groundTruthMatches = load('../../data/part2/library_matches.txt');
N = size(groundTruthMatches,1);
im1MatchesHomo = [groundTruthMatches(:,1:2),ones(N,1)];
im2MatchesHomo = [groundTruthMatches(:,3:4), ones(N,1)];

N = length(im1MatchesHomo);
points3D = zeros(N,3);
residuals1 = zeros(N,1);
residuals2 = zeros(N,1);
for i = 1:N
  %Create the cross product transformation matrices
  mat1 = [0,-im1MatchesHomo(i,3),im1MatchesHomo(i,2);...
          im1MatchesHomo(i,3),0,-im1MatchesHomo(i,1);...
          -im1MatchesHomo(i,2),im1MatchesHomo(i,1),0];
  mat2 = [0,-im2MatchesHomo(i,3),im2MatchesHomo(i,2);...
          im2MatchesHomo(i,3),0,-im2MatchesHomo(i,1);...
          -im2MatchesHomo(i,2),im2MatchesHomo(i,1),0];
  %Stack them
  mat = [mat1*m1;mat2*m2];
  %Compute SVD
  [~,~,V] = svd(mat);
  V = V(:,end);
  %Unhomogenize
  V = V / V(4);
  %Stack the obtained 3D points
  points3D(i,:) = V(1:3,:)';
  
  
  %Store the residual error
  pointResidual1 = m1*V;
  pointResidual1 = pointResidual1/pointResidual1(3);
  pointResidual2 = m2*V;
  pointResidual2 = pointResidual2/pointResidual2(3);
  residuals1(i,:) = sum((pointResidual1(1:2,:) - im1MatchesHomo(i,1:2)').^2);
  residuals2(i,:) = sum((pointResidual2(1:2,:) - im2MatchesHomo(i,1:2)').^2);  
end

%axis equal;  


figure; axis equal; hold on;

 scatter3(points3D(:,1)', points3D(:,2)', points3D(:,3)', '.r');
grid on; xlabel('x'); ylabel('y'); zlabel('z'); axis equal;
plot3(-c1(1), c1(2), c1(3),'*g');
plot3(-c2(1), c2(2), c2(3),'*b');
grid on; xlabel('x'); ylabel('y'); zlabel('z'); axis equal;


