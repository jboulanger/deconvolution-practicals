function data = imread3(filename)
% data = imread3(filename)
%
% Load a 3D image from a TIF stack
%
% Jerome Boulanger

metadata = imfinfo(filename);
data = zeros(metadata(1).Height,metadata(1).Width,numel(metadata));
for l = 1:numel(metadata)
    data(:,:,l) = imread(filename,l);
end
data = double(data);
