function [r, v] = kep2car(kep, mu)
%
% Function that converts Cartesian coordinates into perifocal coordinates. 
% The standard gravitational parameter is an optional input, if none is given the fuction will use Earth's parameter.
%
% INPUT
% a    [1]    semimajor axis                          [Km]       
% e    [1]    eccentricity                            [-]        
% i    [1]    inclination                             [rad]     
% OM   [1]    right ascension of the ascending node   [rad]      
% om   [1]    argument of periapsis                   [rad]      
% theta[1] true anomaly                               [rad]      
% mu   [1]    standard gravitational parameter        [km^3/s^2] 
% 
% OUTPUT
% r    [3x1] position vector                          [km]       
% v    [3x1] velocity vector                          [km/s]     
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
% Retrive keplerian elements from the vector
a = kep(1);
e = kep(2);
i = kep(3);
OM = kep(4);
om = kep(5);
theta = kep(6);

% Checking if the gravitational parameter is given
if nargin == 1
    mu = 398600;
end

% 1: Calculating P
P = a*(1-e^2);

% 2: Calculating the module of r
module_r = P/(1+e*cos(theta));

% 3: Assigning the vectors r and v
r_PF = module_r*[cos(theta); sin(theta); 0];

v_PF = sqrt(mu/P)*[-sin(theta); e + cos(theta); 0];

% The following comment contains the procedure to obtain R (and R'). In
% order to reduce computational costs, only the final matrix Rt is assigned.
%
% % Assigning the first rotation matrix: OM rotates around k.
% % Starting coordinates: x,j,k; final coordinates: x',j',k'.
R_OM = [ cos(OM) sin(OM) 0;...
        -sin(OM) cos(OM) 0;...
         0 0 1];

% Assigning the second rotation matrix: i rotates around i'.
% Starting coordinates: x',j',k'; final coordinates: x'',j'',k''.
R_i = [ 1 0 0;...
        0 cos(i) sin(i);...
        0 -sin(i) cos(i)];

% Assigning the second rotation matrix: om rotates around k''.
% Starting coordinates: x'',j'',k''; final coordinates: x''',j''',k'''.
R_om = [ cos(om) sin(om) 0;...
        -sin(om) cos(om) 0;...
         0 0 1];
R = R_om*R_i*R_OM;
Rt = R';

r = Rt*r_PF;
v = Rt*v_PF;