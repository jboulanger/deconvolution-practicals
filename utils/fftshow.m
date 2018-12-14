function fftshow(data,otf)
% display the log magnitude of the fourier transform
%
% Jerome Boulanger 2018
%
imshow(fftshift(log(1+abs(fftn(data)))),[])
if nargin > 1
  hold on;
  r0 = find(otf(1,:)<eps,1);
  t = linspace(0,2*pi);
  plot(size(data,2)/2+r0*cos(t),size(data,1)/2+r0*sin(t));
  hold off
end
