function [ F ] = sevenpoint( pts1, pts2, M )
% seven points algorithm for estimating fundamental matrix
% Inputs:
% pts1, pts2 - corresponding coordinates of the points in two images
% M - scale parameter
% Outputs:
% F - fundamental matrix

% first normalize the coordinates
pts1_norm = pts1 ./ M;
pts2_norm = pts2 ./ M;

% get the coordinate points
x1 = pts1_norm(:, 1);
y1 = pts1_norm(:, 2);
x2 = pts2_norm(:, 1);
y2 = pts2_norm(:, 2);

% generate the U matrix
N = size(pts1, 1);
U = [x1.*x2, x1.*y2, x1, ...
        y1.*x2, y1.*y2, y1, ...
        x2,       y2,     ones(N,1)];
size(U)
    
% compute the SVD
[~, ~, V] = svd(U);
F1 = reshape(V(:,9), 3, 3);
F2 = reshape(V(:,8), 3, 3);

% compute the alpha
syms a;
S = solve(0 == det(a*F1 + (1-a)*F2));
S = real(double(S));

% compute fundamental matrix
T = [1/M 0 0; 0 1/M 0; 0 0 1];
F = cell(1,3);
for i = 1: length(F)
    F{i} = S(i)*F1 + (1-S(i))*F2;
    F{i} = T'*F{i}*T;
end
    
end
