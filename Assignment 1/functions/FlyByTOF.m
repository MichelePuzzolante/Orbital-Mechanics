function TOF = FlyByTOF(aHypM,eHypM,aHypP,eHypP,rrM_flyby)
% 
% Function to compute the duration of the flyby around Earth considering
% a finite sphere of influence
% 
% PROTOTYPE:
% TOF = FlyByTOF(aHypM,eHypM,aHypP,eHypP,rrM_flyby)
%
% INPUT:
% aHypM [1]          semi-major axis of incoming hyperbola           [km]
% eHypM [1]          eccentricity of incoming hyperbola              [-]
% aHypP [1]          semi-major axis of outgoing hyperbola           [km]
% eHypP [1]          eccentricity of outgoing hyperbola              [-]
% rrM_flyby [3x1]    Mars position vector at flyby                   [km]
% 
% OUTPUT:
% TOF [1]        duration of the flyby                            [s]
% 
% FUNCTIONS CALLED:
% none
%
% CONTRIBUTORS:
% Michele Puzzolante
% 
% VERSIONS:
%  2023/12/30
%-------------------------------------------------------------------------%
% Constants:
muS = astroConstants(4);                   % Sun gravitational constant
muM = astroConstants(14);                  % Earth gravitational constant

% Radius of Earth's SOI
r_SOI = norm(rrM_flyby)*(muM/muS)^(2/5); 

% Apply hyperbola time law:
% Incoming hyperbola:
thM = acos((aHypM*(1-eHypM^2)-r_SOI)/eHypM/r_SOI);
EM = 2*atanh(tan(thM/2)/sqrt((1+eHypM)/(eHypM-1)));
dtM = sqrt((abs(aHypM))^3/muM) * (eHypM*sinh(EM)-EM);

% Outgoing hyperbola:
thP = acos((aHypP*(1-eHypP^2)-r_SOI)/eHypP/r_SOI);
EP = 2*atanh(tan(thP/2)/sqrt((1+eHypP)/(eHypP-1)));
dtP = sqrt((abs(aHypP))^3/muM) * (eHypP*sinh(EP)-EP);

TOF = dtM + dtP;
end
