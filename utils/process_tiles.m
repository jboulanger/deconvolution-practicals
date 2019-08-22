function [su,sw] = process_tiles(img,n,p,fun)
% [su,sw] = process_tiles(img,n,p,fun)
%
% Process the image in n x n tiles with overlap p using function y=fun(x)
%
% Input:
%   img : the image to process
%   n : size of the block (without overlap)
%   p : overlap in pixel
%   func % function to apply to each tiles
%
% Output
%  su : image processed in tiles
%  sw : accumulator with sum of the weights
% Jerome Boulanger 2019

if isa(img,'gpuArray')
    tiles = gpuArray(tiles);
end
k = 1;
for j=1:n:size(img,2)
    for i=1:n:size(img,1)
        r0 = max(1,i-p);
        r1 = min(size(img,1),i+n+p-1);
        c0 = max(1,j-p);
        c1 = min(size(img,2),j+n+p-1);
        tiles{k} = img(r0:r1,c0:c1,:);
        mask{k} = zeros(size(tiles{k}));
        mask{k}(p:end-p,p:end-p) = 1;        
        k = k + 1;
    end
end
fprintf('Processing %d tiles\n', numel(tiles));
parfor k = 1:numel(tiles)   
    tiles{k} = fun(tiles{k});
    mask{k} = imfilter(mask{k},fspecial('gaussian',2*p+1,p));
end
su = zeros(size(img));
sw = zeros(size(img));
k = 1;
for j=1:n:size(img,2)
    for i=1:n:size(img,1)  
        r0 = max(1,i-p);
        r1 = min(size(img,1),i+n+p-1);
        c0 = max(1,j-p);
        c1 = min(size(img,2),j+n+p-1);          
        su(r0:r1,c0:c1,:) = su(r0:r1,c0:c1,:) + mask{k}.*tiles{k};
        sw(r0:r1,c0:c1,:) = sw(r0:r1,c0:c1,:) + mask{k};
        k = k + 1;
    end
end

k = sw > 0;
su(k) = su(k) ./ sw(k);

end