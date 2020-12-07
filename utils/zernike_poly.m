function P = zernike_poly(rho, theta, coefficient)
% P = zernike_poly(rho, theta, coefficient)
%
% Zernike Polynomial
% coefficient 1 and 2 are tilt
% coeffifiant 3 is focus
% coefficients 4,5 are astigmatism and defocus
% coefficient 6,7 are coma and tilt
% coefficient 8 is spherical aberation
% 
% from http://wyant.optics.arizona.edu/zernikes/Zernikes.pdf
if numel(coefficient) < 15
    coefficient = padarray(coefficient(:), 15-numel(coefficient),0,'post');
end
idx = rho < 1;
P = zeros(size(rho));
P(idx) = P(idx) + coefficient(1) .* rho(idx) .* cos(theta(idx));
P(idx) = P(idx) + coefficient(2) .* rho(idx) .* sin(theta(idx));
P(idx) = P(idx) + coefficient(3) .* (2 * rho(idx).^2 - 1);
P(idx) = P(idx) + coefficient(4) .* rho(idx).^2 .* cos(2*theta(idx));
P(idx) = P(idx) + coefficient(5) .* rho(idx).^2 .* sin(2*theta(idx));
P(idx) = P(idx) + coefficient(6) .* (3 * rho(idx).^2 - 2) .* rho(idx) .* cos(theta(idx));
P(idx) = P(idx) + coefficient(7) .* (3 * rho(idx).^2 - 2) .* rho(idx) .* sin(theta(idx));
P(idx) = P(idx) + coefficient(8) .* (6 * rho(idx).^4 - 6  * rho(idx).^2 + 1);
P(idx) = P(idx) + coefficient(9) .* rho(idx).^3 .* cos(3*theta(idx));
P(idx) = P(idx) + coefficient(10) .* rho(idx).^4 .* sin(3*theta(idx));
P(idx) = P(idx) + coefficient(11) .* (4.*rho(idx).^2-3).*rho(idx).^2 .* cos(2*theta(idx));
P(idx) = P(idx) + coefficient(12) .* (4.*rho(idx).^2-3).*rho(idx).^2 .* sin(2*theta(idx));
P(idx) = P(idx) + coefficient(13) .* (10 .* rho(idx).^4 - 12 .* rho(idx).^2 + 3).*rho(idx) .* cos(theta(idx));
P(idx) = P(idx) + coefficient(14) .* (10 .* rho(idx).^4 - 12 .* rho(idx).^2 + 3).*rho(idx) .* sin(theta(idx));
P(idx) = P(idx) + coefficient(15) .* (20 .* rho(idx).^6 - 30 .* rho(idx).^4 + 12 .* rho(idx).^2 - 1);


end