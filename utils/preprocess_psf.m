function psf = preprocess_psf(img,dim,symmetrize)
%  psf = preprocess_psf(img,dim,symmetrize)
%
% Process an image of a single bead to create a point spread function
% - center the bead
% - symmetrize
% - normalize
%
% Jerome Boulanger

if nargin < 3
    symmetrize = true;
end

% Find the maximum of the image
[val, idx] = max(img(:));

img = img - (median(img(:)) + 0.5*noise_std(img(:)));
img = max(0,img);

% draw the centered psf into the destination image
[M(1) M(2) M(3)] = ind2sub(size(img),idx);
A = max(1, round(dim / 2 - M) + 1);
B = min(dim, round(A + size(img)));
C = max(1, M - round((B - A)/2));
D = min(size(img), M + round((B - A)/2));
B = A + D - C;

psf = zeros(dim);
psf(A(1):B(1),A(2):B(2),A(3):B(3)) = img(C(1):D(1), C(2):D(2), C(3):D(3));

if symmetrize     
    ny = size(psf,1);
    nx = size(psf,2);
    [x,y] = meshgrid(-nx/2+1:nx/2,-ny/2+1:ny/2);        
    d = round(sqrt(x.^2+y.^2));
    for r = 1:round(max(d(:)))
        msk = (d == r);
        for k = 1:size(psf,3)
            plane = psf(:,:,k);
            plane(msk) = mean(plane(msk));
            psf(:,:,k) = plane;
        end
    end    
end

for iter=1:10
    % remove small values
    psf = max(psf-5e-7,0);
    % Normalize the psf
    psf = psf / sum(psf(:));
end
