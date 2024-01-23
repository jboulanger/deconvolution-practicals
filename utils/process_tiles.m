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
%
% Example
%  
%  process_tiles(f,64,4,@(x) deconvolve_richardsonlucy_boundary(x,H,options))
% Jerome Boulanger 

% Split the image in tiles
k = 1;
for j=1:n:size(img,2)
    for i=1:n:size(img,1)
        r0 = max(1,i-p);
        r1 = min(size(img,1),i+n+p-1);
        c0 = max(1,j-p);
        c1 = min(size(img,2),j+n+p-1);
        tiles{k} = img(r0:r1,c0:c1,:);
        mask{k} = 0 * tiles{k}; 
        mask{k}(p:end-p,p:end-p) = 1;        
        k = k + 1;
    end
end

fprintf('Processing %d tiles\n', numel(tiles));
for k = 1:numel(tiles)   
    tiles{k} = fun(tiles{k});
    mask{k} = imfilter(mask{k},fspecial('gaussian',2*p+1,p));
end

% Initialize accumulators
su = 0 * img;
sw = 0 * img;

% Copy the tiles and mask to the accumulators
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

% nornalize the accumulators
k = sw > 0;
su(k) = su(k) ./ sw(k);

end