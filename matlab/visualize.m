load('../data/templeCoords.mat');
load('../data/intrinsics.mat');
load('q2_1.mat');

im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
number = size(x1,1);

x2 = zeros(number, 1);
y2 = zeros(number, 1);

% get corresponding points
for i = 1:number
    [x, y] = epipolarCorrespondence(im1, im2, F, x1(i), y1(i));
    x2(i) = x;
    y2(i) = y;
end

% compute essential matrix
E = essentialMatrix(F, K1, K2);

% compute possible M2s
M2s = camera2(E);

M1 = [1 0 0 0; 0 1 0 0; 0 0 1 0];
point1 = zeros(number, 2);
point2 = zeros(number, 2);
point1(:,1) = x1;
point1(:,2) = y1;
point2(:,1) = x2;
point2(:,2) = y2;

% check the right M2
for i = 1:4
    P = triangulate(K1*M1, point1, K2*M2s(:,:,i), point2);
    if all(P(:,3) > 0)
        sprintf('correct M2 is: %d\n', i)
        Pfinal = P;
        M2 = M2s(:,:,i);
    end
end

% visualize 3D data
M1 = K1*M1;
M2 = K2*M2;
save('q2_7.mat','F', 'M1', 'M2');
scatter3(Pfinal(:,1),Pfinal(:,2),Pfinal(:,3));