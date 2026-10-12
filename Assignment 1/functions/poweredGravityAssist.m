function [rp, dVP, aHypM, eHypM, vpM, aHypP, eHypP, vpP, turnAngle, ratiodV] = poweredGravityAssist(vInfM, vInfP)
%
% Function to compute the powered gravity assist manoeuvre around Mars
%
% PROTOTYPE
% [rp, dVP, aHypM, eHypM, vpM, aHypP, eHypP, vpP, turnAngle, ratiodV] = poweredGravityAssist(vInfM, vInfP)
%
% INPUT
%  vInfM [3x1]    incoming excess velocity vector                    [km/s]
%  vInfP [3x1]    outgoing excess velocity vector                    [km/s]
%
% OUTPUT
%  dVP       [1]      delta v cost of the powered gravity assist         [km/s]
%  rp        [1]      radius of perigee of the flyby trajectory          [km]
%  vpM       [1]      incoming velocity magnitude at perigee             [km/s]
%  vpP       [1]      outgoing velocity magnitude at perigee             [km/s]
%  aHypM     [1]      incoming hyperbola semi-major axis                 [km]
%  aHypP     [1]      outgoing hyperbola semi-major axis                 [km]
%  eHypM     [1]      incoming hyperbola eccentricity                    [-]
%  eHypP     [1]      outgoing hyperbola eccentricity                    [-]
%  turnAngle [1]      turn angle                                         [deg]
%  ratiodV   [1]      Ratio between the DV of the impulsive manoeuvre at the pericentre of the flyby and the total DV provided by the flyby [-]
%
% FUNCTIONS CALLED:
% astroConstants.m
%
% CONTRIBUTORS
% Michele Puzzolante
%
% VERSION
% 2023/12/30 First version
%-------------------------------------------------------------------------%
idFlyBy = 14;
mu = astroConstants(idFlyBy); % Mars

vInfP_n = norm(vInfP);
vInfM_n = norm(vInfM);

rp0 = astroConstants(idFlyBy + 10); % Minimum rp
turnAngle = acos(dot(vInfP, vInfM) / (vInfP_n * vInfM_n));
% Set options for fzer0
options = optimset('Display', 'off');
% fzero
rp = fzero(@(rp) -turnAngle + ( 2 * asin(1 / (1 + rp * vInfM_n^2 / mu) ) )/2 + ( 2 * asin(1 / (1 + rp * vInfP_n^2 / mu) ) )/2, rp0, options);

% Set limit for rp
rpLimit = astroConstants(idFlyBy + 10) + 250;

% Check if rp is admissible
if rp > rpLimit
    % Minus Hyperbola
    aHypM = -mu / vInfM_n^2;
    eHypM = 1 + rp * vInfM_n^2 / mu;
    vpM = sqrt(2 * mu * (1./rp + 1/2/abs(aHypM)));
    % Plus Hyperbola
    aHypP = -mu / vInfP_n^2;
    eHypP = 1 + rp * vInfP_n^2 / mu;
    vpP = sqrt(2 * mu * (1./rp + 1/2/abs(aHypP)));    
    % Delta V
    dVP = abs(vpP - vpM);
else
    % Minus Hyperbola
    aHypM = NaN;
    eHypM = NaN;
    vpM = NaN;
    % Plus Hyperbola
    aHypP = NaN;
    eHypP = NaN;
    vpP = NaN;    
    % Delta V
    dVP = NaN;
    rp = NaN;
end
ratiodV = dVP/abs(norm(vInfP - vInfM));
turnAngle = rad2deg(turnAngle);

end