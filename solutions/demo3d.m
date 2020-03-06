% Demo of 3D deconvolution using synthetic data

clear all;
addpath('../utils');

dims = [128, 128, 64]; % image size
px = [80, 80, 100]; % pixel size
NA = 1.0; % numerical aperture
wavelength = 500; % wavelength
n = 1.33; % medium refractive index
type = 'fibers'; % test image type (ave/fibers)

% generate the 3D OTF
H = generate_otf3d(dims, px, NA, wavelength, n);

% generate the test image (ground truth)
u = generate_test_image(type, dims);

% convolve the test image by the OTF
Hu = real(ifftn((H .* fftn(u))));

% generate Poisson noise
f = double(imnoise(uint16(50*Hu), 'poisson'));

% deconvolve the image
tic
method = 'Richardson Lucy-tv';
options.max_iter = 100;
options.regularization = 0.0001;
uest = deconvolve(f, H, method, options);
toc

% compute mean square error
mse1 = sqrt(mean((f(:)-u(:)).^2));
mse2 = sqrt(mean((uest(:)-u(:)).^2));
fprintf('%s MSE [after/before]: %.2f/%.2f (%.2f%%)\n', ...
    method, mse2, mse1, 100*mse2/mse1);

% display the results
figure(1)
subplot(221), imshow3(f,[]), title('Blurred & Noisy Image')
subplot(222), fftshow(f,H), title('Log Power Spectrum')
subplot(223), imshow3(uest,[]), title(sprintf('Deconvolved (%s)', method))
subplot(224), fftshow(uest,H), title('Log Power Spectrum')
