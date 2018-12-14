function u = deconvolve_wiener(f,H,options)
% u = deconvolve_wiener(f, H, options)
% u = deconvolve_wiener(f, H)
%
% Deconvolve an image using a Wiener filter
%
% The model is:
%  f = H u
%
% The filter is  H'S  / ( H'H S + N^2);
%
% Input:
%  f       : input image
%  H       : optical transfer function
%  options : structure with field 'sigma' (noise level) and 'oracle'
%
% Output:
%  u       :  deconvolved image
%
% Jerome Boulanger (2011-2018)

m = mean(f(:));
f = f - m;
F = fftn(f);

if(~isfield(options,'noise_level'))
  N = noise_std(f);
else
  N = options.noise_level;
end

if(~isfield(options,'oracle'))
  gamma = 2;
  S = (max(0, conj(F) .* F - N) ./ (conj(H) .* H + N)).^(1 / gamma);
else
  S = abs(fftn(options.oracle));
end
F = fftn(f);

%  Compute the Wiener filter
filter = (conj(H) .* S) ./ (conj(H).*H .* S  + N.^2);

% Apply the filter
u = real(ifftn(filter .* F));

% recenter the result
u = u + m;
