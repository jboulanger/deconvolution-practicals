% benchmark2d
%
% Test deconvolution methods
%
% Jerome Boulanger (2018)

clear all
addpath('utils');
addpath('solutions');

N = 256; % image size
sigma = 5; % noise level

H = generate_otf(N, 4);
u = generate_test_image('wavy',N);
f = real(ifft2((fft2(u) .* H))) + sigma * randn(size(u));

method = {'inverse','wiener','gold','richardsonlucy','tikhonov','tv'};

for k = 1:numel(method)
  uest = deconvolve(f, H, method{k});
  mse(k) = sqrt(mean((uest(:)-u(:)).^2));
  subplot(2,ceil(numel(method)/2),k)
  imshow(uest,[]);
  title(sprintf('%s (%.2f)', method{k}, mse(k)))
end
