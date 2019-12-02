function ubest = optimize_parameter(f,H,u,method,parameter,range)
% optimize_parameter Optimize the parameter for method

uest = zeros(size(u,1),size(u,2),numel(range));
q = zeros(1,numel(range));

for k = 1:numel(range)
    opts.(parameter) = range(k);        
    uest(:,:,k) = deconvolve(f, H, method, opts);
    e = uest(:,:,k) - u; 
    q(k) = mean(e(:).^2);    
end
[~,k] = min(q); 
ubest = uest(:,:,k);

