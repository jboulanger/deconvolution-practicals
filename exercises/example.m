% Demo3d
%
% Illustrate 3D deconvolution of microscopy images
%
% Jerome Boulanger 
%

clear all

addpath('../utils', '../data');

% Define the input image and bead image
imgname = './data/img-gfp-tubuline.tif';
psfname = './data/psf-gfp.tif';

% load the image
f = imread3(imgname);

% display the image
figure(1), imshow3(f, []);

% load an image of a fluorescent bead
b = imread3(psfname);

% preprocess the PSF (center & symmetrize)
h = preprocess_psf(b, size(f), false);

% display the PSF
figure(2), imshow3(sqrt(h), []);

% convert the PSF to an OTF
H = psf2otf(h);

% correct the OTF by the size of the beads (100nm beads, [65,65,200]nm voxels)
H = correct_otf(H, 100./[65 65 200]);

% display the otf
figure(3), imshow3(log(fftshift(abs(H))), [])

% deconvolve the image
tic
% modify the options
method = 'inverse';
options.regularization = 0.01;
%options.max_iter = 5;
uest = deconvolve(f, H, method, options);
toc

figure(4)
imshow3(uest,[])

% Reconstruction error analysis
figure(5);
e = f - real(ifftn(H .* fftn(uest)));
fprintf('reconstruction error norm %.2f%%\n', 100*sqrt(mean(e(:).^2) / mean(f(:).^2)));
imshow3(e,[])
