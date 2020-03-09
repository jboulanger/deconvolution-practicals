function imshow3(M, range, mode)
% imshow3(M, range, mode)
%
% Display a 3D array using slices in XY XZ YZ
%
% Inputs:
%  M : (3D) array to display
%  range : range (caxis). If empty use the min and max of M
%  mode : can be 'slice', 'average' or 'mip' for max intensity porjection
%
% Jerome Boulanger (2018-2020)

if nargin < 2
    range = [min(M(:)) max(M(:))];
end

if isempty(range)
    range = [min(M(:)) max(M(:))];
end

if nargin < 3
    mode = 'slice';
end

A = zeros(size(M,1)+size(M,3),size(M,2)+size(M,3));
if strcmp(mode, 'slice')    
    A(1:size(M,1),1:size(M,2)) = M(:,:,floor(size(M,3)/2+1));
    A(size(M,1)+1:end,1:size(M,2)) = squeeze(M(floor(size(M,1)/2+1),:,:))';
    A(1:size(M,1),size(M,2)+1:end) = squeeze(M(:,floor(size(M,2)/2+1),:));
elseif strcmp(mode, 'average')  
    A(1:size(M,1),1:size(M,2)) = mean(M,3);
    A(size(M,1)+1:end,1:size(M,2)) = squeeze(mean(M,1))';
    A(1:size(M,1),size(M,2)+1:end) = squeeze(mean(M,2)); 
else
    A(1:size(M,1),1:size(M,2)) = max(M,[],3);
    A(size(M,1)+1:end,1:size(M,2)) = squeeze(max(M,[],1))';
    A(1:size(M,1),size(M,2)+1:end) = squeeze(max(M,[],2));    
end
A(size(M,1)+1:end,size(M,2)+1:end) = mean(M(:));
imshow(A,range);