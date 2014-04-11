function [ E ] = essentialMatrix( F, K1, K2 )
% compute essential matrix by fundamental matrix
% Inputs:
% F - fundamental matrix
% K1, K2 - calibration matrix
% Outputs:
% E - essential matrix

E = K2' * F * K1;

end

