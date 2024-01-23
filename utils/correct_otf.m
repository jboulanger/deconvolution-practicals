function otf = correct_otf(otf,bead_size)
% otf = correct_otf(otf,voxel_size, bead_size)
% 
% Correct the OTF by the size of the beads used to acquire the experimental
% point spread function.
%
% The bead is approximated by a Gaussian function.
%
% Jerome Boulanger
nx = size(otf,2);
ny = size(otf,1);
nz = size(otf,3);
[x,y,z] = meshgrid(-nx/2+1:nx/2,-ny/2+1:ny/2,-nz/2+1:nz/2); 

s = [nx ny nz] ./ bead_size;

d = exp(-0.5 * ( (x/s(1)).^2 + (y/s(2)).^2 + (z/s(3)).^2 ));

d = fftshift(d);

otf = otf ./ max(eps, d);

