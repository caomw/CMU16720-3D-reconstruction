load('../data/some_corresp.mat');
load('../data/intrinsics.mat');
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');

M = max(size(im1));

% compute fundamental matrix
F = eightpoint(pts1, pts2, M);

% compute essential matrix
E = essentialMatrix(F, K1, K2);

% compute possible M2s
M2s = camera2(E);

M1 = [1 0 0 0; 0 1 0 0; 0 0 1 0];

% check the right M2
for i = 1:4
    P = triangulate(K1*M1, pts1, K2*M2s(:,:,i), pts2);
    if all(P(:,3) > 0)
        sprintf('correct M2 is: %d\n', i)
        Pfinal = P;
        M2 = M2s(:,:,i);
        %break;
    end
end
p1 = pts1;
p2 = pts2;
P = Pfinal;
save('q2_5.mat', 'M2', 'p1', 'p2', 'P');
