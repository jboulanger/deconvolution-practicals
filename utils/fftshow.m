function fftshow(data,otf)
% display the log magnitude of the fourier transform
%
% Jerome Boulanger
%
if numel(size(data)) == 2
imshow(fftshift(log(1+abs(fftn(data)))),[])
if nargin > 1
  hold on;
  r0 = find(otf(1,:)<eps,1);
  t = linspace(0,2*pi);
  plot(size(data,2)/2+1+r0*cos(t),size(data,1)/2+1+r0*sin(t), 'linewidth',2);
  hold off
end
else
    imshow3(fftshift(log(1+abs(fftn(data)))),[])
end
