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
% Jerome Boulanger (2019)

if(~isfield(options,'max_iter'))
    options.max_iter = 50;
end
if(~isfield(options,'padsize'))
    if numel(size(f)) == 3
        options.padsize = [32 32 16];
    else
        options.padsize = [32 32];
    end
end
f = max(f,0);

M = padarray(ones(size(f)),options.padsize);
H = psf2otf(padarray(otf2psf(H,size(f)),options.padsize));
f = padarray(f,options.padsize);

% compute correction
w = real(ifftn( fftn(M) .* H));
alpha = 0 * w + 1;
alpha(w>0.01) = 1./w(w>0.01);

% initialize the estimate
u =  real(ifftn( fftn(f) .* H));

for iter = 1:options.max_iter
    Hu = real(ifftn(H .* fftn(u)));
    u = alpha .* u .* real(ifftn(conj(H) .* fftn(f./ Hu )));
end

% crop the data
if numel(size(f)) == 3
    u = u(options.padsize(1):end-options.padsize(1)-1,options.padsize(2):end-options.padsize(2)-1,options.padsize(3):end-options.padsize(3));
else
    u = u(options.padsize(1):end-options.padsize(1)-1,options.padsize(2):end-options.padsize(2)-1);
end
