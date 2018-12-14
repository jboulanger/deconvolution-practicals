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
% Jerome Boulanger (2011-2018)

if(~isfield(options,'max_iter'))
    options.max_iter = 5;
end
if(~isfield(options,'acceleration'))
    options.acceleration = 1.3;
end

f = max(f,0);
% initialize the estimate
u = real(ifftn( fftn(f) .* H));
for iter = 1:options.max_iter
  Hu = real(ifftn(H .* fftn(u)));
  u = % TODO
end
