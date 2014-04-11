function [x2, y2] = epipolarCorrespondence(im1, im2, F, x1, y1)
% This function takes in the x and y coordinates of a pixel on im1 and
% fundamental matrix F, and returns the coordinates of the pixel on im2
% which correspond to the input point
% Inputs:
% im1, im2 - two base images
% F - fundamental matrix
% x1, y1 - coordinates of pixels in im1
% Outputs:
% x2, y2 - coordinates of pixels in im2

% first compute the epipolar line
p1 = [x1; y1; 1];
line1 = F*p1;
scale = sqrt(line1(1)^2 + line1(2)^2);
line1 = line1/scale;

% find approximate point
% of search region
line2=[-line1(2) line1(1) line1(2)*x1-line1(1)*y1]';
proj=round(cross(line1,line2));  

% set parameter
windowsize=10;
kernelSize = 2*windowsize+1;
patch1 = double(im1((y1-windowsize):(y1+windowsize), (x1-windowsize):(x1+windowsize)));
minerror=1000;
sigma = 3;
weight = fspecial('gaussian', [kernelSize kernelSize], sigma);

% compute the difference
for i=proj(1)-20:1:proj(1)+20
    for j=proj(2)-20:1:proj(2)+20 
           patch2=double(im2(j-windowsize:j+windowsize,i-windowsize:i+windowsize));
           distance = patch1 - patch2;
           error = norm(weight .* distance); 
           if error<minerror
                minerror=error;
                x2=i;
                y2=j;
           end   
    end
end