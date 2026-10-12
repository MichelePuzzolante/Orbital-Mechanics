function aDrag = dragPerturbation(rr, vv)
% function for computation of the drag perturbations
%
% PROTOTYPE
% aDrag = dragPerturbation(rr, vv)
%
% INPUT
% rr [3x1]   Position of the S/C                              [km; km; km]
% vv [3x1]   Velocity of the S/C                              [km/s; km/s; km/s]
%
% OUTPUT
% aDrag [3x1]  Drag                                               [km/s^2; km/s^2; km/s^2]
%
% FUNCTIONS CALLED:
% none
%
% CONTRIBUTORS
% Michele Puzzolante
%
% VERSION
% 2023/11/12 First version
%-------------------------------------------------------------------------%
r = norm(rr);
%-------Computation of Drag perturbation---------
% get radius of the Earth from astroconstants
% Get air density from atmoscoesa

rho = airDensity(r);
% J2 from https://nssdc.gsfc.nasa.gov/planetary/factsheet/earthfact.html
CD = 2.1; % [-]
A_M = 0.0136 * 1e-6; % [m2/kg]
% Compute the relative velocity
omega_Earth = [0; 0; deg2rad(15.04)/3600];
v_rel = vv - cross(omega_Earth, rr);
% Compute the value of the perturbation
aDrag = -0.5 * A_M * CD * rho * dot(v_rel, v_rel) * (v_rel/norm(v_rel));

end