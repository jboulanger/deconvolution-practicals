function u = deconvolve_tikhonov(f,H,options)
% u = deconvolve_tikhonov(u,H,options)
% u = deconvolve_tikhonov(u,H)
%
% Deconvolve an image using a tikhonov regularization
%
% The energy is:
%  |H u -f| + |nabal u|^2
%
% The update equation is:
%  u = P(u - alpha (H'(Hu-f) - lambda Lu))
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
% Jerome Boulanger (2011-2018)

if(~isfield(options,'max_iter'))
    options.max_iter = 500;
end
if(~isfield(options,'step_size'))
    options.step_size = 5;
end
if(~isfield(options,'regularization'))
    options.regularization = 1e-3;
end

% compute the laplacian filter
L = fspecial('laplacian');

% initialization
Hf = real(ifftn(H .* fftn(f)));
HtH = conj(H).*H;
u = Hf;
for iter = 1:options.max_iter
  du = real(ifftn(HtH.*fftn(u))) - Hf - options.regularization * imfilter(u, L);
  du = du ./ max(abs(du(:)));
  u = max(0, u - options.step_size * du);
end
