function u = deconvolve(f, H, method, options)
% function u = deconvolve(f, method, options)
%
% Generic deconvolution function
%
% Jerome Boulanger

if nargin < 4
    options.method_name = method;
end

if strcmpi(method, 'gold')
    u = deconvolve_gold(f, H, options);
elseif strcmpi(method, 'inverse')
    u = deconvolve_inverse(f, H, options);
elseif strcmpi(method, 'wiener')
    u = deconvolve_wiener(f, H, options);
elseif strcmpi(method, 'richardson lucy')
    u = deconvolve_richardsonlucy(f, H, options);
elseif strcmpi(method, 'tikhonov')
    u = deconvolve_tikhonov(f, H, options);
elseif strcmpi(method, 'tv')
    u = deconvolve_tv(f, H, options);
elseif strcmpi(method, 'richardson lucy-tv')
    u = deconvolve_richardsonlucy_tv(f, H, options);
else   
    error('Unknown method %s', method);
end
