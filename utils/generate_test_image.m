function u = generate_test_image(type,n,varargin)
% u = generate_test_image(type,n,varargin)
%
% Generate a random test image
%
% Input
%  type : 'wavy'  or 'fibers'
%  n    : size of the image
%
% for the wavy pattern, the next parameters are the
%    bandwidth/smoothness (default 1)
%    frequency            (default 8)
% for the fibers pattern, the next parameters are
%    number of fibers     (default 10)
%    length of the fibers (default 2n)
%    smoothness/curvature (default 2)
%    smoothness/bluriness (default 1)
%
% Jerome Boulanger (2018)


if strcmpi(type,'wavy')
  if (nargin < 3)
    a = 1;
  else
    a = varargin{1};
  end
  if (nargin < 4)
    f = 8;
  else
    f = varargin{2};
  end
  u = randn(n,n);
  [x,y] = meshgrid(-n/2+1:n/2,-n/2+1:n/2);
  g = fftshift(exp(-0.1*(x.^2+y.^2)/a^2));
  u = rescale(real(ifft2(u .* g)),-1,1);
  u = rescale(sin(2 * pi * f * u ), 0, 255);
elseif strcmpi(type,'fibers')
  if (nargin < 3)
    m = 30;
  else
    m = varargin{1};
  end
  if (nargin < 4)
    l = 2 * n;
  else
    f = varargin{2};
  end
  if (nargin < 5)
    s1 = 50;
  else
    f = varargin{3};
  end
  if (nargin < 6)
    s2 = 1;
  else
    f = varargin{4};
  end
  % init filters
  h1 = fspecial('gaussian',[3*s1,1],s1);
  h2 = fspecial('gaussian',[3*s2,1],s2);
  % create fibers as smoothed random walks
  dx = imfilter(randn(l,m), h1);
  dy = imfilter(randn(l,m), h1);
  v = sqrt(dx.^2+dy.^2);
  x = repmat(n * rand(1,m),[l, 1]) + cumsum(dx./v,1);
  y = repmat(n * rand(1,m),[l, 1]) + cumsum(dy./v,1);
  idx = x>=1&x<n & y>=1&y<n;
  x = x(idx);
  y = y(idx);
  u = zeros(n,n);
  u(sub2ind([n,n],round(x),round(y))) = 1;
  % blur the fibers
  u = imfilter(u,h2);
  % add a background (~scattering)
  [x,y] = meshgrid(-n/2+1:n/2,-n/2+1:n/2);
  g = fftshift(exp(-0.5*(x.^2+y.^2)));
  b = rescale(real(ifft2(fft2(u) .* g)), 0, 1);
  u = rescale(b .* (0.5 + u), 0,255);
elseif strcmpi(type,'steps')
    if nargin < 3
        nsteps = 5;
    else
        nsteps = varargin{1};
    end
    u = round((n-1) * ceil((1:n)' * ones(1,n)/n*nsteps) / nsteps);
else
  error('underfined type (%s)', type);
end

function y = rescale(x,a,b)
  m = min(x(:));
  M = max(x(:));
  y = (x - m) / (M - m) *( b - a) + a;
