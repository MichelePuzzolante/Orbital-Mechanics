function [dydt] = ode_2BP(~, y, mu)
%
% ode_2BP Ode system for the two body problem (Keplerian Motion)
%
% PROTOTYPE
% dydt = ode_2BP(t, y, mu)
%
% INPUT
% t  [1]      Time (Can be omitted as the system is autonomus) [s]
% y  [6x1]    State of the body (rx; ry; rz; vx; vy; vz)       [km;km;km;km/s;km/s;km/s]
% mu [1]     Gravitational parameter of the primary            [km^3/s^2]
%
% OUTPUT
% dydt [6x1] Derivative of the state                          [km/s;km/s;km/s;km/s^2;km/s^2;km/s^2]
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

% Intializzation of the derivative of the state
dydt = zeros(6, 1);

% Assign the velocity to the first three term f the derivative
dydt(1:3) = y(4:6);

% Get the position
rr = y(1:3);
% Compute the norm of the position
r = norm(rr);

% Compute the last three term of the derivative of the state
dydt(4:6) = -mu/r^3 * rr;

end