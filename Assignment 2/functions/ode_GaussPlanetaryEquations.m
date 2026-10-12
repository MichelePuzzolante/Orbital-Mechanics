function [dkepdt] = ode_GaussPlanetaryEquations(~, y, mu)
%
% ode for Gauss plaentary equations
%
% PROTOTYPE
% [dkepdt] = ode_GaussPlanetaryEquations(~, y, mu)
%
% INPUT
% t  [1]      Time (Can be omitted as the system is autonomus) [s]
% y  [6x1]    State of the body (a; e; i; OM; om; theta)       [km; -; rad; rad; rad; rad]
% mu [1]     Gravitational parameter of the primary            [km^3/s^2]
%
% OUTPUT
% dkepdt [6x1] Derivative of the state                        [km/s; 1/s; rad/s; rad/s; rad/s; rad/s]
%
% FUNCTIONS CALLED:
% kep2car.m
% J2Perturbation.m
% dragPerturbation.m
%
% CONTRIBUTORS
% Michele Puzzolante
%
% VERSION
% 2023/11/12 First version
%-------------------------------------------------------------------------%

% Get variable from the state
a = y(1); % Semi-major axis
e = y(2); % Eccentricity
i = y(3); % Inclination
OM = y(4); % RAAN
om = y(5); % Argumet of pericenter
theta = y(6); % True anomaly

% Conversion from keplerian to cartesian
[rr, vv] = kep2car(y, mu);

% Computation of parameters usefull for equations
b = a * sqrt(1 - e^2);
p = (b^2) / a;
n = sqrt(mu / a^3);
h = n * a * b;
r = p / (1 + e * cos(theta));
v = sqrt(2 * mu / r - mu / a);
theta_hat = theta + om;

% Get disturbances
% J2
aJ2 = J2Perturbation(mu, rr);
% Drag
aDrag = dragPerturbation(rr, vv);
aP_car = aJ2 + aDrag;

% Versors for rotate the perturbances
tt_dir = vv/norm(vv);
h_dir = cross(rr, vv);
hh_dir = h_dir/norm(h_dir);
nn_dir = cross(hh_dir, tt_dir);

aP_tnh = [tt_dir nn_dir hh_dir]' * aP_car;
at = aP_tnh(1);
an = aP_tnh(2);
ah = aP_tnh(3);

% Definitions of the derivatives of the keplerian elements
dadt =  2 * a^2 * v / mu * at;

dedt = 1/v * (2 * (e + cos(theta)) * at - r / a * sin(theta) *an);

didt = r * cos(theta_hat) / h * ah;

dOMdt = r * sin(theta_hat) / h /sin(i) * ah;

domdt = 1/(e*v) * ( 2*sin(theta)*at + (2*e + (r/a)*cos(theta)) * an) - r*sin(theta_hat)*cos(i)/h/sin(i) * ah;

dthetadt = h/r^2 - 1/(e*v) * ( 2*sin(theta)*at + (2*e + (r/a)*cos(theta)) * an) ;

dkepdt = [dadt; dedt; didt; dOMdt; domdt; dthetadt];

end