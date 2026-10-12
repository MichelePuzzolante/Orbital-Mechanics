function [a, T] = semimajAxForRepGT(mu, wE, k, m)
% compute the semimajoraxis and the period for a repeating ground track for
% a given k and n
%
% PROTOTYPE
% [a, T] = semimajAxForRepGT(mu, wE, k, m)
%
% INPUT
% wE [1]   Angular velocity of the Earth                    [rad/s]
% k  [1]   Revolutions of the satellite                     [-]
% m  [1]   Rotations of the planet                          [-]
% mu [1]   Gravitational parameter of the Earth             [km^3/s^2]
%
% OUTPUT
% a  [1]    Semi-major axis                                  [km]
% T  [1]    Period                                           [s]
%
% FUNCTIONS CALLED:
% none
%
% CONTRIBUTORS
% Michele Puzzolante
% Mattia Bax
% Giorgia Privitera
% Carlo Vicenzetto
%
% VERSION
% 2023/11/12 First version
%-------------------------------------------------------------------------%

% Computation of the new period
T = 2 * pi * m / k /wE;
% Computation of the semi-major axis
a = ((T / (2 * pi))^2 * mu)^(1/3);
end