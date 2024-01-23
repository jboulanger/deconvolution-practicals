function imsave3(img,filename)
% imsave3(img,filename)
%
% Save a 3D matrix as a multipage tiff image 
%
% Jerome Boulanger

imwrite(img(:,:,1),filename);
for i = 2:size(img,3)
    imwrite(img(:,:,i),filename,'WriteMode','append');
end