%
%
% Illustration of image deconvolution on 2D test images
%
%
%  Jerome Boulanger 2018

clear all;
addpath('../utils');


N = 256; % image size
type = 'fibers'; % test image type (ave/fibers)

% generate the OTF
H = generate_otf(N, 4);

% generate the test image (ground truth)
u = 256 * generate_test_image(type, N);

% convolve the test image by the OTF
Hu = real(ifft2((H .* fft2(u))));

% generate Poisson noise
f = double(imnoise(uint16(Hu), 'poisson'));

% deconvolve the image
tic
method = 'Gold';
options.max_iter = 100;
uest = deconvolve(f, H, method, options);
toc

% compute mean square error
mse1 = sqrt(mean((f(:)-u(:)).^2));
mse2 = sqrt(mean((uest(:)-u(:)).^2));
fprintf('%s MSE[after/before]: %.2f/%.2f (%.2f%%)\n', ...
    method, mse2, mse1, 100*mse2/mse1);

% display the results
figure(1)
subplot(221), imshow(f,[]), title('Blurred & Noisy Image')
subplot(222), fftshow(f,H), title('Log Power Spectrum')
subplot(223), imshow(uest,[]), title(sprintf('Deconvolved (%s)', method))
subplot(224), fftshow(uest,H), title('Log Power Spectrum')
