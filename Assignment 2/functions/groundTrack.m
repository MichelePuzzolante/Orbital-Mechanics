function [alpha, delta, lon_new, lat_new] = groundTrack(state, stateType, thetaG_t0, wE, mu, t0, tspan, model)
%
% groundTrack is a function which computes the ground track of an orbit 
%
% PROTOTYPE:
% [alpha, delta, lon_new, lat_new, thetaG] = groundTrack(state, stateType, thetaG_t0, wE, mu, t0, tspan, model)
%
% INPUT :
% state     [6x1]    (Can be keplerian elements or state fo the S/C)      [km,-,rad,rad,rad,rad] or [km,km,km,km/s,km/s,km/s]
% stateType [1]      String which contains type of the state can be 'kep' or any other type                   [-]
% thetaG_t0 [1]      Right ascension of Greenwich meridian at t0          [rad]
% wE        [1]      Angular velocity of the Earth                        [rad/s]
% mu        [1]      Gravitational parameter of the primary               [km^3/s^2]
% t0        [1]      Initial time                                         [s]
% tspan     [Nx1]    Time vector                                          [s]
% model     [1]      String which contains type of the 2BP 'unp' or 'per' [-] 
%
% OUTPUT:
% alpha   [Nx1]        Right ascension in Earth Centred Equatorial Inertialframe [deg]
% delta   [Nx1]        Declination in Earth Centred Equatorial Inertial frame    [deg]
% lon_new [Nx1]      Longitude with respect to rotating Earth                    [deg]
% lat_new [Nx1]      Latitude with respect to rotating Earth                     [deg]
%
% FUNCTIONS CALLED:
% astroConstants.m
% kep2car.m
% car2kep.m
% ode_2BP.m
% ode_2BPPerturbed.m
%
% AUTHOR:
%
% PREVIOUS VERSION:
%   
% CHANGELOG:
%   20/09/2022 ode function for two-body problem   
%   21/09/2022 ode function for perturbed two-body problem
% -------------------------------------------------------------------------

% Check if the state vector is given in cartesian coordinates or keplerian
if strcmp(stateType, 'kep')
    a = state(1);
    e = state(2);
    i = state(3);
    RAAN = state(4);
    argOfPer = state(5);
    theta0 = state(6);
    [r, v] = kep2car(state);
else
    r = state(1:3);
    v = state(4:6);
    [a, e, i, RAAN, argOfPer, theta0] = car2kep(r, v, mu);
end
T = (2 * pi * sqrt(a^3 / mu));
y0 = [r; v];
% Set options for the ODE solver
options = odeset( 'RelTol', 1e-13, 'AbsTol', 1e-14 );
% Perform the integration
if strcmp(model, 'unp')
    [time, rv] = ode78( @(t,y) ode_2BP(t,y,mu), tspan, y0, options );
else
    [time, rv] = ode78( @(t,y) ode_2BPPerturbed(t,y,mu), tspan, y0, options );
end
% Define the vectors used for the output
delta = zeros(1, length(tspan));
alpha = zeros(1, length(tspan));
lon = zeros(1, length(tspan));
lat = zeros(1, length(tspan));

% Calculate alpha, delta, latutitude and longitude

for index = 1:length(tspan)
    % Conversion to the cartesian coordinates
    % Delta
    r = rv(index, 1:3);
    v = rv(index, 4:6);
    delta(index) = asin(r(3) / norm(r));
    % Alpha
    if r(2)/norm(r) > 0
        alpha(index) = acos(r(1) / (norm(r) * cos(delta(index))));
    else
        alpha(index) = 2 * pi - acos(r(1) / (norm(r) * cos(delta(index))));
    end
    
    % Longitude and Latitude
    
    thetaG(index) = thetaG_t0 + wE * (tspan(index) - t0);
    lon(index) = alpha(index) - thetaG(index);
    lat(index) = delta(index);
    
end
lon = wrapTo180(rad2deg(lon));

lon_new = [];
lat_new = [];
for i = 1 : length(lon) - 1
    if abs(lon(i+1) - lon(i)) > 180
        lon_new = [lon_new, lon(i), NaN];
        lat_new = [lat_new, lat(i), NaN];
    else
        lon_new = [lon_new, lon(i)];
        lat_new = [lat_new, lat(i)];
    end
end
lon_new = [lon_new, lon(end)];
lat_new = [lat_new, lat(end)];

delta = rad2deg(delta);
alpha = rad2deg(alpha);
lon_new = lon_new;
lat_new = rad2deg(lat_new);
thetaG = rad2deg(thetaG);
end