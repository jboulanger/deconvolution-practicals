% Demo3d
%
% Illustrate 3D deconvolution of microscopy images
%
% Jerome Boulanger (2018)
%

clear all; close all;

addpath('../utils','../data');

% Define the input image and bead image
imgname = '../data/img-gfp-tubuline.tif';
psfname = '../data/psf-gfp.tif';

% load the image
f = imread3(imgname);

% display the image
figure(1), imshow3(f,[]), title('Original image')

% load an image of a fluorescent bead
b = imread3(psfname);

% preprocess the PSF (center & symmetrize)
h = preprocess_psf(b, size(f), false);

% display the PSF
figure(2), imshow3(sqrt(h),[]), title('Point Spread Function (PSF)')

% convert the PSF to an OTF
H = psf2otf(h);

% correc the OTF by the size of the beads (100nm beads, [65,65,200]nm voxels)
H = correct_otf(H, 100./[65 65 200]);

% display the otf
figure(3), imshow3(log(fftshift(abs(H))),[]), title('Optical transfer function (OTF)')

% deconvolve the image
tic
options.regularization = 0.01;
options.max_iter = 5;
method = 'gold';
uest = deconvolve(f, H, method, options);
toc
figure(4)
imshow3(max(0,uest),[])
title(sprintf('Deconvolve image (%s)', method))

% Reconstruction error analysis
e = f - real(ifftn(H .* fftn(uest)));
fprintf('reconstruction error norm %.2f%%\n', 100*sqrt(mean(e(:).^2) / mean(f(:).^2)));
figure(5);
imshow3(e,[]), 
title(sprintf('Error (%.2f%%)', 100*sqrt(mean(e(:).^2) / mean(f(:).^2))))
