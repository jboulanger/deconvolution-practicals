%
%
% Illustration of image deconvolution on 2D test images
%
%
%  Jerome Boulanger 2018

clear all;
clc
addpath('../utils');
%%
zoom = 1;
bg = 100;
dim = [128,128,16]; % image size

type = 'fibers'; % test image type (ave/fibers)

% generate the OTF
H = generate_otf3d(dim, [39,39,200],1.49,500,1.5);

% generate the test image (ground truth)
u = 100000 * generate_test_image(type,dim);

% convolve the test image by the OTF
Hu = real(ifftn((H .* fftn(u))));
Hu = imresize3(Hu,1/zoom);
% generate Poisson noise
f = double(imnoise(uint16(Hu), 'poisson'))+bg;
imshow3(f,[],'max');
%%
% deconvolve the image
tic
method = 'Richardson Lucy ';
options.max_iter = 100;
options.background = 0;
options.padsize = [8,8,4];
options.zoom = zoom;
uest = deconvolve_richardsonlucy_boundary(f, H, options);
%uest = deconvolve_gold_boundary(f, H, options);
%uest = deconvolve_gold(f, H, options);
%uest = deconvolve_richardsonlucy(f, H, options);
toc

% compute mean square error
mse1 = sqrt(mean((f(:)-u(:)).^2));
mse2 = sqrt(mean((uest(:)-u(:)).^2));
fprintf('%s MSE[after/before]: %.2f/%.2f (%.2f%%)\n', ...
    method, mse2, mse1, 100*mse2/mse1);

% display the results
figure(1)
subplot(221), imshow3(f,[]), title('Blurred & Noisy Image')
subplot(222), fftshow(f,H), title('Log Power Spectrum')
subplot(223), imshow3(uest,[]), title(sprintf('Deconvolved (%s)', method))
subplot(224), fftshow(uest,H), title('Log Power Spectrum')


%%
filename = '/media/micro-nas-1/Baum lab/Frederik/20211019-01a_MW001/ch2_crop.tif';
img = imread3(filename);
%img = img(128:128+64,128:128+64,:);
% generate an ISM psf by multiplying the emission and detection psf
options.zoom = 2;
[H,h1] = generate_otf3d(options.zoom*size(img), [39,39,219]/options.zoom, 1.49, 495, 1.5);
[H,h2] = generate_otf3d(options.zoom*size(img), [39,39,219]/options.zoom, 1.49, 519, 1.5);
h = h1 .* h2;
h = h / sum(h(:));
H = psf2otf(h);
options.background = 100;
options.padsize = [8,8,10];
options.max_iter = 150;
tic
uest = deconvolve_richardsonlucy_boundary(img, H, options);
toc
%options.max_iter = 5;
%uest = deconvolve_gold_boundary(img-100, H, options);
subplot(121); imshow3(img,[],'max');
subplot(122); imshow3(uest,[],'max');

%%
ofile = replace(filename,'.tif','-matlab-deconv.tif');
disp(ofile)
imsave3(uint16(65000*(uest-min(uest(:)))./(max(uest(:))-min(uest(:)))), ofile);
