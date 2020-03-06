function u = generate_test_image(type,dims,varargin)
% u = generate_test_image(type,dims,varargin)
%
% Generate a random test image
%
% Input
%  type : 'wavy'  or 'fibers'
%  dims    : size of the image
%
% for the wavy pattern, the next parameters are the
%    bandwidth/smoothness (default 1)
%    frequency            (default 8)
% for the fibers pattern, the next parameters are
%    number of fibers     (default 30)
%    length of the fibers (default 2 max(dims))
%    smoothness/curvature (default 2)
%    smoothness/bluriness (default 1)
%
% Jerome Boulanger (2018)

if isscalar(dims)
    dims = [dims,dims,1];
end

if numel(dims) == 2
    dims = [dims(:); 1]';
end

if strcmpi(type,'wavy')
    if (nargin < 3)
        a = 100;
    else
        a = varargin{1};
    end
    if (nargin < 4)
        f = 8;
    else
        f = varargin{2};
    end    
    u = randn(dims);
    [kx,ky,kz] = freqgrid(dims);
    if dims(3) == 1
        g = exp(-0.1*a.^2*(kx.^2+ky.^2));
    else
        g = exp(-0.1*a.^2*(kx.^2+ky.^2+kz.^2));
    end
    u = normalize(real(ifftn(u .* g)),-1,1);
    u = normalize(sin(2 * pi * f * u ), 0, 255);
elseif strcmpi(type,'fibers')
    if (nargin < 3)
        m = 30; % number of fibers
    else
        m = varargin{1};
    end
    if (nargin < 4)
        l = 2 * max(dims);
    else
        l = varargin{2};
    end
    if (nargin < 5)
        s1 = 10;
    else
        s1 = varargin{3};
    end
    if (nargin < 6)
        bg = 0.2;
    else
        bg = varargin{4};
    end
    % init filters
    h1 = fspecial('gaussian',[3*s1,1],s1);
    % create fibers as smoothed random walks
    dx = imfilter(randn(l,m), h1) * dims(2);
    dy = imfilter(randn(l,m), h1) * dims(1);
    dz = imfilter(randn(l,m), h1) * dims(3);
    v = sqrt(dx.^2+dy.^2+dz.^2);
    x = repmat(dims(2) * (0.5+0.25*rand(1,m)),[l, 1]) + cumsum(dx./v,1);
    y = repmat(dims(1) * (0.5+0.25*rand(1,m)),[l, 1]) + cumsum(dy./v,1);
    z = repmat(dims(3) * (0.5+0.25*rand(1,m)),[l, 1]) + cumsum(dz./v,1);
    idx = find(x>=1 & x<=dims(2) & y>=1 & y<=dims(1) & z >=0 & z <= dims(3));
    u = zeros(dims);
    for k = 1:numel(idx)
        xi = max(1,floor(x(k)-3)):min(dims(2),ceil(x(k)+3));
        yi = max(1,floor(y(k)-3)):min(dims(1),ceil(y(k)+3));
        zi = max(1,floor(z(k)-3)):min(dims(3),ceil(z(k)+3));
        [xs,ys,zs] = meshgrid(xi,yi,zi);
        u(sub2ind(dims,xs,ys,zs)) = u(sub2ind(dims,xs,ys,zs)) + exp(-2*((xs-x(k)).^2+(ys-y(k)).^2+(zs-z(k)).^2));
    end
            
    % add a background (~scattering)
    if bg > 0
        [kx,ky,kz] = freqgrid(dims);
        if dims(3) == 1
        g = exp(-1000*(kx.^2+ky.^2));
    else
        g = exp(-1000*(kx.^2+ky.^2+kz.^2));
    end
        b = normalize(real(ifftn(fftn(u) .* g)),0,1);
        u = normalize(b .* (bg + u), 0,255);    
    end        
elseif strcmpi(type,'steps')
    if nargin < 3
        nsteps = 5;
    else
        nsteps = varargin{1};
    end
    [x,~,~] = meshgrid(1:dims(2),1:dims(1),1:dims(3));
    u = round(x/nsteps);
else
    error('underfined type (%s)', type);
end

function y = normalize(x,a,b)
m = min(x(:));
M = max(x(:));
y = (x - m) / (M - m) *( b - a) + a;

function [kx,ky,kz] = freqgrid(dims)
fx = [0:floor(dims(2)/2)-1, floor(-dims(2)/2):-1] / (dims(2));
fy = [0:floor(dims(1)/2)-1, floor(-dims(1)/2):-1] / (dims(1));
fz = [0:floor(dims(3)/2)-1, floor(-dims(3)/2):-1] / (dims(3));
[kx,ky,kz] = meshgrid(fx,fy,fz);
