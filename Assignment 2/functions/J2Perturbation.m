function aJ2 = J2Perturbation(mu, rr)
% function for computation of the J2 perturbations
%
% PROTOTYPE
% aJ2 = J2Perturbation(mu, rr)
%
% INPUT
% rr [3x1]   Position of the S/C                              [km; km; km]
% mu [1]     Gravitational parameter of the primary           [km^3/s^2]
%
% OUTPUT
% aJ2 [3x1]  J2                                               [km/s^2; km/s^2; km/s^2]
%
% FUNCTIONS CALLED:
% astroConstants.m
%
% CONTRIBUTORS
% Michele Puzzolante
%
% VERSION
% 2023/11/12 First version
%-------------------------------------------------------------------------%
r = norm(rr);
%-------Computation of J2 perturbation---------
% get radius of the Earth from astroconstants
Re = astroConstants(23);
% J2 from https://nssdc.gsfc.nasa.gov/planetary/factsheet/earthfact.html
J2 = 0.00108263;
% Compute the value of the perturbation
aJ2 = 3/2 * J2 * mu * Re^2/(r^4) * [...
    rr(1)/r * (5 * (rr(3)/r)^2 - 1);
    rr(2)/r * (5 * (rr(3)/r)^2 - 1);
    rr(3)/r * (5 * (rr(3)/r)^2 - 3)];

end