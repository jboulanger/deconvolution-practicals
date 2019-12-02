function u = deconvolve_inverse(f, H, options)
% u = deconvolve_inverse(f, H, options)
% u = deconvolve_inverse(f, H)
%
% Deconvolve an image using an inverse filter
%
% The model is:
%  f = H u
%
% The filter is H' / (H'H + eps^2)
%
% Input:
%  f       : input image
%  H       : optical transfer function
%  options : structure with field 'regularization'
%
% Output:
%  u       :  deconvolved image
%
% Jerome Boulanger (2011-2018)


if(~isfield(options,'regularization'))
  options.regularization = 0.25;
end

% Compute the regularized inverse filter
filter = conj(H) ./ (conj(H) .* H + options.regularization.^2);

% Apply the filter
u = real(ifftn(filter .* fftn(f)));
