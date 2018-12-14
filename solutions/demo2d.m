%
%
% Illustration of image deconvolution on 2D test images
%
%
%  Jerome Boulanger 2018

clear all
close all
addpath('../utils');


N = 256; % image size
sigma = 5; % noise level
type = 'fibers'; % test image type (ave/fibers)

% generate the OTF
H = generate_otf(N, 4);

% generate the test image (ground truth)
u = generate_test_image(type, N);

% convolve the test image by the OTF
Hu = real(ifft2((H .* fft2(u))));

% generate Poisson noise
f = double(imnoise(uint16(Hu), 'poisson'));

% deconvolve the image
tic
uest = deconvolve(f, H, 'wiener');
toc

% compute mean square error
mse1 = sqrt(mean((f(:)-u(:)).^2));
mse2 = sqrt(mean((uest(:)-u(:)).^2));
fprintf('mean squared error [after/before]: %.2f/%.2f (%.2f%%)\n', mse2, mse1, 100*mse2/mse1);

% display the results
figure(1)
subplot(221), imshow(f,[]);
subplot(222), fftshow(f,H);
subplot(223), imshow(uest,[]);
subplot(224), fftshow(uest,H);
