function [ P ] = triangulate( M1, p1, M2, p2 )
% Triangulate a set of 2D coordinates in the image to a set of 3D points
% with the signature
% Inputs:
% M1, M2 - 3*4 camera matrices
% p1, p2 - N*2 matrices with the 2D image coordinates
% Outputs:
% P - N*3 matrix with the corresponding 3D points

% convert to homogenous
p1 = [ p1'; ones(1, size(p1, 1))];
p2 = [ p2'; ones(1, size(p2, 1))];

P = zeros(4, size(p1,2));

for i = 1: size(p1, 2)
    p = convert(p1(:, i));
    q = convert(p2(:, i));
    
    T = [p*M1; q*M2];
    
    % do SVD
    [~, ~, V] = svd(T);
    vtemp = V(:, end);
    P(:, i) = vtemp/vtemp(4);
end

P = P';
P = P(:, 1:3);
end

function Y = convert(X)
Y = [0 X(3) -X(2);
       -X(3) 0 X(1);
       X(2) -X(1) 0];
end