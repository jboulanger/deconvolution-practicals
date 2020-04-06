function otf = generate_otf3d(dims,px,NA,wavelength,n,sa)
% otf = generate_otf3d(dim,px,NA,wavelength,n)
%
% Generate a 3D widefield PSF
%
% Input:
% dim : size of the image as an array
% px: pixel size in 1st and 2nd dimensions
% NA : numerical aperture
% wavelength : emission wavelength
% n : refractive index
% sa : spherical aberation (4th order in rho)
%
% Output :
% psf : Point spread function centered in (1,1,1)
%
% Example
%
% psf = generate_psf3d([128,128,256],[100,100,100],1.1,500,1.33);
% subplot(121), imshow(fftshift((squeeze(psf(:,:,1)))),[]);colormap jet
% subplot(122), imshow(fftshift((squeeze(psf(:,1,:))))',[]);colormap jet
%
% Jerome Boulanger 2020

if numel(dims) ~= 3
    error('first parameter (dims) need 3 elements')
end

if numel(px) ~= 3
    error('second parameter (px) need 3 elements')
end

% define the frequency space in x and y and direct space in z
fx = [0:floor(dims(2)/2)-1, floor(-dims(2)/2):-1] / (dims(2)*px(2));
fy = [0:floor(dims(1)/2)-1, floor(-dims(1)/2):-1] / (dims(1)*px(1));
ez = [0:floor(dims(3)/2)-1, floor(-dims(3)/2):-1] * px(3);
[kx,ky,z] = meshgrid(fx,fy,ez);
rho = sqrt(kx.^2+ky.^2) * wavelength / NA;
% define the pupil function such that the it correspond to the cutoff in
% pixel for the PSF (hence the 0.5/p)
P = rho <= 1;
% compute the psf as the square of the inverse Fourier transform of the
% pupil function (autocorrelation of the pupil function)
defocus = exp(-2*pi*1i*z.*sqrt( max(0, (n/wavelength).^2 - kx.^2 - ky.^2 )));
spherical = exp(-2*pi*1i*sa*(6*rho.^4-6*rho.^2+1));
psf = abs(fft2(P .* defocus .* spherical )).^2;
% convert the PSF to an OTF
otf = fftn(psf);
% normalize the OTF
otf(abs(otf)<1e-6) = 0;
otf = otf ./ otf(1,1,1);

