clear all;clf;
addpath('../utils');

dims = [128,128,128]; % image size
px = [80, 80, 100]; % pixel size
NA = 1; % numerical aperture
wavelength = 500; % wavelength
n = 1.33; % medium refractive index
sa = 0.2;
% generate the OTF
H = generate_otf3d(dims,px,NA,wavelength,n,sa);
h = otf2psf(H);
subplot(121), imshow3(sqrt(fftshift(abs(H))),[]), title('OTF')
subplot(122), imshow3(log(0.0000001+h),[],'slice'), title('PSF')

if H(1)~=1
    warning('The OTF is not normalized');
end