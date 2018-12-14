function u = deconvolve_tv(f,H,options)
% u = deconvolve_tv(u,H,options)
% u = deconvolve_tv(u,H)
%
% Deconvolve an image using a TV regularization
%
% The energy is:
%  |H u -f| + |nabal u|_1
%
% The update equation is:
%   u = P(u - alpha (H'(Hu-f) - lambda div(grad(u)/(|grad(u)|+epsilon)))
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
    options.step_size = 1;
end
if(~isfield(options,'regularization'))
    options.regularization = 0.01;
end
if(~isfield(options,'epsilon'))
    options.epsilon = eps;
end

% compute the gradient and divergence filters
gx_filter = [0 -1 1];
gy_filter = [0 -1 1]';
gz_filter = reshape(gx_filter, [1 1 3]);
dx_filter = [-1 1 0];
dy_filter = [-1 1 0]';
dz_filter = reshape(dx_filter, [1 1 3]);

% initialization
Hf = real(ifftn(H .* fftn(f)));
HtH = conj(H).*H;
u = Hf;
for iter = 1:options.max_iter
  % compute div(grad(u)/|grad(u)|)
  if (size(u, 3) == 1)
    gx = imfilter(u, gx_filter);
    gy = imfilter(u, gy_filter);
    n = sqrt(gx.^2 + gy.^2) + options.epsilon;
    curv = imfilter(gx./n, dx_filter) + imfilter(gy./n, dy_filter);
  else
    gx = imfilter(u, gx_filter);
    gy = imfilter(u, gy_filter);
    gz = imfilter(u, gz_filter);
    n = sqrt(gx.^2 + gy.^2 + gz.^2) + options.epsilon;
    curv = imfilter(gx./n, dx_filter) + imfilter(gy./n, dy_filter) + imfilter(gz./n, dz_filter);
  end
  du = real(ifftn(HtH.*fftn(u))) - Hf - options.regularization * curv;
  du = du ./ max(abs(du(:)));
  u = max(0, u - options.step_size * du);
end
