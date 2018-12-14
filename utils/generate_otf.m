function otf = generate_otf(n,p)
% otf = generate_otf(n,p)
% generate an ideal 2d optical transfert function
%
% n is the size of the image
% p is the cutoff period in pixels
%
% Jerome Boulanger (2018)

v0 = n/p;
[x, y] = meshgrid(-n/2 : n/2-1, -n/2 : n/2-1);
v = min(1,  sqrt(x.^2 + y.^2) / v0);
otf = 2 / pi * (acos(v) - v .* sqrt(1-v.*v));
otf = fftshift(otf);
otf = otf ./ max(otf(:));
