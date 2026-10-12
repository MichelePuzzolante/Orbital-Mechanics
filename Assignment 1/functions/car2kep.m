function [Kep] = car2kep(r, v, mu)
%
% Function that converts perifocal coordinate into Cartesian coordinates . 
% The standard gravitational parameter is an optional input, if none is given the fuction will use Earth's parameter.
%
% INPUT
% r    [3x1] position vector                          [km]       
% v    [3x1] velocity vector                          [km/s]
% mu   [1]    standard gravitational parameter        [km^3/s^2]
% 
% OUTPUT
% Kep [6x1]  Kepliarian parameters(a,e,i,OM,om,theta) [km;-;rad;rad;rad;rad;rad]
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
% Checking if the gravitational parameter is given
if nargin == 2
    mu = 398600;
end

% 1: Calculating the module of r and v
module_r = norm(r);
module_v = norm(v);

% 2: Calculating the semimajor axis (a) via the Energy formula
a = ((2/module_r) - ((module_v^2)/mu))^(-1);

% 3: Calculating the angular momentum vector and its module (h)
vector_h = cross(r,v);
h = norm(vector_h);

% 4: Calculating the eccentricity vector and its module (e)
vector_e = cross(v,vector_h)/mu - r/module_r;
e = norm(vector_e);

% 5: Calculating the inclination (i)
if (vector_h(1) == 0 && vector_h(2) == 0)
    i = 0;
else
    i = acos(vector_h(3)/h);
end

% 6: Calculating the line of nodes (N)
if i == 0
    N = [1, 0, 0];
else
    N = cross([0;0;1],vector_h)/(norm(cross([0;0;1],vector_h)));
end

% 7: Calculating the right ascension of the ascending node (OM)
if N(2) == 0 & N(3) == 0
    OM = 0;
else
    if N(2) >= 0
       OM = acos(N(1)); 
    else
       OM = 2*pi - acos(N(1));
    end
end

% 8: Calculating the argument of periapsis (om)
if e == 0
    om = 0;
else
    if vector_e(3) >= 0
       om = acos(dot(N,vector_e)/e); 
    else
       om = 2*pi - acos(dot(N,vector_e)/e); 
    end
end

% 9: Calculating the true anomaly (theta)
if dot(v,r)/module_r > 0
   theta = acos(dot(r,vector_e)/(module_r*e)); 
else
   theta = 2*pi - acos(dot(r,vector_e)/(module_r*e)); 
end
Kep = [a e i OM om theta];
end