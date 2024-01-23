function u = deconvolve_gold(f,H,options)
% u = deconvolve_gold(u,H,options)
% u = deconvolve_gold(u,H)
%
% Deconvolve an image using the Gold algorithm
% Use the Meinel acceleration technique (>1)
%
% The model is:
%  f = H u
%
% The update equation is:
%  u = u (f / Hu)^(p)
%
% Input:
%  f       : input image
%  H       : optical transfer function
%  options : structure with field 'max_iter' (default 5) and 'acceleration'
%           (default 1.3)
%
% Output:
% u         :  deconvolved image
%
% Jerome Boulanger

if(~isfield(options,'max_iter'))
    options.max_iter = 3;
end
if(~isfield(options,'acceleration'))
    options.acceleration = 1.3;
end
if(~isfield(options,'padsize'))
    if numel(size(f)) == 3
        options.padsize = [32 32 16];
    else
        options.padsize = [32 32];
    end
end
if(~isfield(options,'zoom'))    
        options.zoom = 1;    
end

M = padarray(ones(size(f)),options.padsize);
H = psf2otf(padarray(otf2psf(H,size(f)),options.padsize));
f = padarray(f,options.padsize);

% compute correction
alpha = real(ifftn( fftn(M) .* conj(H)));
w = 0*alpha+1;
w(alpha>0.001) = 1. / alpha(alpha>0.001);
w(M>0) = 1.0;

f = max(f,0);
% initialize the estimate
u = real(ifftn( fftn(f) .* H));
for iter = 1:options.max_iter
    Hu = real(ifftn(H .* fftn(u)));
    Hu = max(Hu,1e-6);
    u = alpha .* u .* (f ./ Hu).^options.acceleration;    
end

% crop the data
if numel(size(f)) == 3
    u = u(options.padsize(1)+1:end-options.padsize(1),options.padsize(2)+1:end-options.padsize(2),options.padsize(3)+1:end-options.padsize(3));
else
    u = u(options.padsize(1)+1:end-options.padsize(1),options.padsize(2)+1:end-options.padsize(2));
end
