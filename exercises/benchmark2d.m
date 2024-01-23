% benchmark2d
%
% Test deconvolution methods
%
% Jerome Boulanger

clear all
addpath('../utils');

N = 256; % image size
max_photons = 100;

H = generate_otf(N, 4);
u = max_photons * generate_test_image('fibers',N) / 255;
Hu = real(ifft2((fft2(u) .* H)));
f = double(imnoise(uint16(Hu), 'poisson'));

% Deconvolve the image with all methods
method = {'Inverse','Wiener','Gold','Richardson Lucy','Tikhonov','TV','Richardson Lucy-TV'};
uest = zeros(size(u,1),size(u,2),numel(method));
fprintf('Testing %d methods\n', numel(method));
tic
parfor k = 1:numel(method)
    if strcmpi(method{k}, 'Gold')
        uest(:,:,k) = optimize_parameter(f,H,u,method{k},'max_iter',3:8);
    elseif strcmpi(method{k}, 'Richardson Lucy')
        uest(:,:,k) = optimize_parameter(f,H,u,method{k},'max_iter',[5 10 15 25 35 50 100]);
    elseif max(strcmpi(method{k}, {'Inverse','Tikhonov','TV','Richardson Lucy-TV'}))
        uest(:,:,k) = optimize_parameter(f,H,u,method{k},'regularization',logspace(-2,0,20));
    else
        uest(:,:,k) = deconvolve(f,H,method{k});
    end
end
toc
% Compute the root mean square error
rmse = sqrt(sum(sum( (uest-repmat(u,1,1,numel(method))).^2 )) / (N*N));
[~,p] = sort(rmse);
% Display results sorted by RMSE
for k = 1:numel(method)
  subplot(2, ceil(numel(method)/2), k)
  imshow(uest(:,:,p(k)),[]);
  title(sprintf('%s (RMSE:%.3f)', method{p(k)}, rmse(p(k))))
end

