function u = deconvolve_richardsonlucy_boundary(f,H,options)
% u = deconvolve_richardsonlucy_boundary(u,H,options)
% u = deconvolve_richardsonlucy_boundary(u,H)
%
% Deconvolve an image using the richardson lucy algorithm and boundary
% correction proposed by M. Bertero and P. Boccacci, Astronomy and Astrophysics 2005
%
% The model is:
%  f = H u
%
% The update equation is:
%  u = u * H (f / Hu)
%
% Input:
%  f       : input image
%  H       : optical transfer function
%  options : structure with field 'max_iter' (default 30) and padsize [32
%  32 16] or [32 32]
%
% Output:
% u         :  deconvolved image
%
% Jerome Boulanger

if(~isfield(options, 'max_iter'))
    options.max_iter = 50;
end
if(~isfield(options, 'padsize'))
    if numel(size(f)) == 3
        options.padsize = [32 32 16];
    else
        options.padsize = [32 32];
    end
end
if(~isfield(options, 'zoom'))
    options.zoom=1;
end
if(~isfield(options, 'background'))
    f = f - options.background;
end

shape = round(options.zoom * size(f));
%M = ones(size(f));
%M = imresize3(M,options.zoom);
%M = padarray(M,options.padsize);
M = padarray(ones(shape),options.padsize);
H = abs(psf2otf(padarray(otf2psf(H,shape),options.padsize)));
%f = padarray(imresize3(f, shape), options.padsize);

f = padarray(f, options.padsize / options.zoom);


% compute correction
alpha = real(ifftn( fftn(M) .* conj(H)));
w = ones(size(alpha));
w(alpha>0.001) = 1./alpha(alpha>0.001);
w = w.^0.5;

% initialize the estimate by a constant (important)
u = mean(f(:))*ones(size(H));
ushape = size(u);

for iter = 1:options.max_iter    
    Hu = imresize3(real(ifftn(H .* fftn(u))), 1/options.zoom,'lanczos3');
    Hu = max(0.1,Hu);
    u =  w .* u .* real(ifftn(conj(H) .* fftn(imresize3(f./ Hu, options.zoom,'lanczos3') )));    
    %Hu = f1(H,u);
    %u = w .* u .* f2(H,f./Hu);
    %imshow(squeeze(max(u,[],1))',[]); drawnow
end

% crop the data
if numel(size(f)) == 3
    u = u(options.padsize(1)+1:end-options.padsize(1),options.padsize(2)+1:end-options.padsize(2),options.padsize(3)+1:end-options.padsize(3));
else
    u = u(options.padsize(1)+1:end-options.padsize(1),options.padsize(2)+1:end-options.padsize(2));
end


function f = f1(H,u)
tmp = fftshift(H .* fftn(u));
sz = size(u)/4;
f = real(ifftn(ifftshift(tmp(sz(1)+1:3*sz(1),sz(2)+1:3*sz(2),sz(3)+1:3*sz(3)))));

function u = f2(H,f)
u = real(ifftn(conj(H).*ifftshift(padarray(fftshift(fftn(f)),size(f)/2))));

