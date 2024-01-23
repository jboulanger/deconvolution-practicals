function [otf,psf,phi] = generate_otf3d(dims,px,NA,wavelength,n,coefficients,sigma)
% [otf,psf,phi] = generate_otf3d(dim,px,NA,wavelength,n)
%
% Generate a 3D widefield PSF
%
% Input:
% dim : size of the image as an array
% px: pixel size in 1st and 2nd dimensions
% NA : numerical aperture
% wavelength : emission wavelength
% n : refractive index
% coefficients : 15 first coefficients of the zernike polynomial describing the phase 
% sigma : gaussian profile of the magnitude
%
% Output :
% otf : optical transfer function centered in (1,1,1)
% psf : Point spread function centered in (1,1,1)
% pupil : pupil function
%
% Example
%
% psf = generate_psf3d([128,128,256],[100,100,100],1.1,500,1.33);
% subplot(121), imshow(fftshift((squeeze(psf(:,:,1)))),[]);colormap jet
% subplot(122), imshow(fftshift((squeeze(psf(:,1,:))))',[]);colormap jet
%
% Jerome Boulanger

if numel(dims) ~= 3
    error('first parameter (dims) need 3 elements')
end

if numel(px) ~= 3
    error('second parameter (px) need 3 elements')
end

if nargin < 6
    coefficients = zeros(1,15);
end

if nargin < 7
    sigma = 0;
end
% define the frequency space in x and y and direct space in z
fx = [0:floor(dims(2)/2)-1, floor(-dims(2)/2):-1] / (dims(2)*px(2));
fy = [0:floor(dims(1)/2)-1, floor(-dims(1)/2):-1] / (dims(1)*px(1));
fz = [0:floor(dims(3)/2)-1, floor(-dims(3)/2):-1] / (dims(3)*px(3));
ez = [0:floor(dims(3)/2)-1, floor(-dims(3)/2):-1] * px(3);
[kx,ky,z] = meshgrid(fx,fy,ez);
[~,~,kz] = meshgrid(fx,fy,fz);
rho = sqrt(kx.^2+ky.^2) * wavelength / NA;
theta = atan2(ky,kx);
obj = exp(-0.5*(kx.^2 + ky.^2 + kz.^2) * sigma.^2); % gaussian object

% define the pupil function such that the it correspond to the cutoff in
% pixel for the PSF (hence the 0.5/p)
P = double(rho <= 1);
% compute the psf as the square of the inverse Fourier transform of the
% pupil function (autocorrelation of the pupil function)
defocus = z .* sqrt(max(0, (n / wavelength).^2 - kx.^2 - ky.^2 ));
phi = zernike_poly(rho, theta, coefficients);
psf = abs(fft2(P .* exp(-2*pi*1i* (defocus + phi)))).^2;
% convert the PSF to an OTF
otf = fftn(psf) .* obj;
% normalize the OTF
otf = otf ./ otf(1,1,1);
%otf(abs(otf) < 1e-4) = 0;
phi = fftshift(phi);
psf = otf2psf(otf);