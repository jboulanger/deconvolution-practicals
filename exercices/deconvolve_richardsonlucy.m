function u = deconvolve_richardsonlucy(f,H,options)
% u = deconvolve_richardsonlucy(u,H,options)
% u = deconvolve_richardsonlucy(u,H)
%
% Deconvolve an image using the richardson lucy algorithm
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
%  options : structure with field 'max_iter' (default 30)
%
% Output:
% u         :  deconvolved image
%
% Jerome Boulanger (2011-2018)

if(~isfield(options,'max_iter'))
    options.max_iter = 50;
end

f = max(f,0);

% initialize the estimate
u =  real(ifftn( fftn(f) .* H));

for iter = 1:options.max_iter
  Hu = real(ifftn(H .* fftn(u)));
  u = % TODO
end
