function [ F ] = eightpoint( pts1, pts2, M )
% 8 points algorithm for estimating the fundamental matrix
% Inputs:
% pts1, pts2 - corresponding coordinates of the points in two images
% M - scale parameter
% Outputs:
% F - fundamental matrix

% first normalize the coordinates
T = [1/M 0 0; 0 1/M 0; 0 0 1];
pts1_norm = pts1 ./ M;
pts2_norm = pts2 ./ M;
%pts1_norm = [pts1 ones(length(pts1), 1)]';
%pts2_norm = [pts2 ones(length(pts2), 1)]';
%pts1_norm = (T * pts1_norm)';
%pts2_norm = (T * pts2_norm)';

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
%U = [x1.*x2, y1.*x2, x2, ...
%        x1.*y2, y1.*y2, y2, ...
%        x1,       y1,     ones(N,1)];
    
% compute the SVD
[~, ~, V] = svd(U);
F = reshape(V(:,9), 3, 3)';
[FU, FS, FV] = svd(F);
FS(3,3) = 0;
F = FU*FS*FV';

% rescale fundamental matrix
F = T' * F * T;

end



