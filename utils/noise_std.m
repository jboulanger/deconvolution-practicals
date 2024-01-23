function sigma = noise_std(img)
%  sigma = noise_std(img)
%
% Estimate noise standard deviation using MAD of pseudo-residuals
%
% Jerome Boulanger

noise = pseudoresiduals(img);
sigma = 1.4826 * median(abs(noise(:)-median(noise(:))));

function R = pseudoresiduals(img)
R = zeros(size(img));
for k = 1:size(img,3)
    for j = 2:size(img,2)-1
        for i = 2:size(img,1)-1
            R(i,j,k) = (4*img(i,j,k)-(img(i+1,j,k)+img(i-1,j,k)+img(i,j-1,k)+img(i,j+1,k))) / sqrt(20);
        end
    end
end
