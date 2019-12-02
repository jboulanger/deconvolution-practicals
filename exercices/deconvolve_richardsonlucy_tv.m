function u = deconvolve_richardsonlucy_tv(f,H,options)
% u = deconvolve_richardsonlucy(u,H,options)
% u = deconvolve_richardsonlucy(u,H)
%
% Deconvolve an image using the richardson lucy - TV algorithm from (Dey et
% al. 2006)
%
% The model is:
%  v = H u and f ~ Poisson(v)
% The functional is
%  J(u) = sum -f log(Hu) + Hu + lambda sum |Du|
%
% The update equation is:
%  u = ( H (f / Hu) ) * (u / (1 - lambda * div(Du/|Du|))
%
% Input:
%  f       : input image
%  H       : optical transfer function
%  options : structure with field 'max_iter' (default 30)
%
% Output:
% u         :  deconvolved image
%
% N. Dey et al., ‘Richardson-Lucy algorithm with total variation
% regularization for 3D confocal microscope deconvolution’, Microsc. Res.
% Tech., vol. 69, no. 4, pp. 260–266, Apr. 2006.
%
% Jerome Boulanger (2011-2019)

if nargin < 3
    options.method = 'richardsonlucy-TV';
end

if ~isfield(options,'max_iter')
    options.max_iter = 100;
end

if ~isfield(options,'regularization')
    options.regularization = 0.03;
end

if ~isfield(options,'epsilon')
    options.epsilon = eps;
end

f = max(f,eps);

gx_filter = [0 -1 1];
gy_filter = gx_filter';
gz_filter = reshape(gx_filter, [1 1 3]);
dx_filter = [-1 1 0];
dy_filter = dx_filter';
dz_filter = reshape(dx_filter, [1 1 3]);

% initialize the estimate
u =  real(ifftn( fftn(f) .* H));

for iter = 1:options.max_iter    
  % ...
end
