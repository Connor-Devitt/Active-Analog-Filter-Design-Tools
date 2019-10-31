%   Recursively define the Reverse Bessel Polynomial (Theta)
%   Theta(n=0) = 1
%   Theta(n=1) = x + 1
%   Theta(n) = (2*n - 1)*Theta(n-1) + x^2 * Theta(n-2)
function [polynomial] = getReverseBesselPolynomial(n)
    if n == 0
        polynomial = [1];
        return;
    elseif n == 1
        polynomial = [1 1];
        return;
    else
        polynomial = [0 (2*n - 1)* getReverseBesselPolynomial(n-1)] + [getReverseBesselPolynomial(n-2) 0 0];  
    end
end

