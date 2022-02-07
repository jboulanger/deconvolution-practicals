function [data,scale] = load_ij_hyperstack(filename)
% [data,scale] = load_ij_hyperstack(filename)
%
% Load imagej hyperstacks
%
%

% parse the metadata
metadata = imfinfo(filename);
md = strsplit(metadata(1).ImageDescription);
spacing = 1;
slices = 1;
frames = numel(metadata);
for f = md    
    kv = strsplit(f{1},'=');
    if strcmp(kv{1},'slices')
        slices = str2num(kv{2});
    elseif  strcmp(kv{1},'frames')
        frames = str2num(kv{2});
    elseif  strcmp(kv{1},'spacing')
        spacing = str2num(kv{2});
    end
end
width = metadata(1).Width;
height = metadata(1).Height;
if ~isempty(metadata(1).XResolution)
    scale = [1/metadata(1).XResolution, 1/metadata(1).YResolution, spacing];
else
    scale = [1, 1, spacing];
end

% read frames
for t = 1:frames    
    stack = zeros(height, width, slices);
    for z = 1:slices        
        stack(:,:,z) = imread(filename,z + slices * (t-1));
    end
    data{t,1} = stack;
end

