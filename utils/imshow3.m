function imshow3(M,range)
% imshow3(M,range)
%
% Display a 3D array using slices in XY XZ YZ
%
% Jerome Boulanger (2018)

A = zeros(size(M,1)+size(M,3),size(M,2)+size(M,3));
A(1:size(M,1),1:size(M,2)) = M(:,:,round(size(M,3)/2));
A(size(M,1)+1:end,1:size(M,2)) = squeeze(M(round(size(M,1)/2)-1,:,:))';
A(1:size(M,1),size(M,2)+1:end) = squeeze(M(:,round(size(M,2)/2)-1,:));
A(size(M,1)+1:end,size(M,2)+1:end) = mean(M(:));
imshow(A,range);