function [DVTOT, DV_Dep ,DV_GA ,DV_Arr, KepLeg1, TOF1, KepLeg2, TOF2, vInfM, vInfP, rp, aHypM, eHypM, vpM, aHypP, eHypP, vpP, ratiodV] = interplanetaryTransfer(tDEP, tFB, tARR)
%
% Function which compute the total dV of an interplanetary transfer
%
% PROTOTYPE
% [DVTOT, DV_Dep ,DV_FB ,DV_Arr, KepLeg1, TOF1, KepLeg2, TOF2, rp, aHypM, eHypM, vpM, aHypP, eHypP, vpP, ratiodV] = interplanetaryTransfer(tDEP, tFB, tARR)
%
% INPUT
%  tD [1]  Deparure date        [days]
%  tFB[1]  Flyby date           [days]
%  tA [1]  Arrival date         [days]
%
% OUTPUT 
%  DVTOT     [1]    total dV of the interplanetary transfer              [km/s]
%  DV_Dep    [1]   dV for the departure                                  [km/s]
%  DV_FB     [1]    dV of the flyby                                      [km/s]
%  DV_Arr    [1]   dV for arrival                                        [km/s]
%  KepLeg1   [6x1] Keplerian elements for 1st interplanetary arc         [km; -; rad; rad; rad; rad]
%  TOF1      [1]      time of flight for 1st interplanetary arc          [s]
%  KepLeg2   [6x1] Keplerian elements for 2nd interplanetary arc         [km; -; rad; rad; rad; rad]
%  TOF2      [1]      time of flight for 2nd interplanetary arc          [s]
%  dVP       [1]           delta v cost of the powered gravity assist    [km/s]
%  rp        [1]           radius of perigee of the flyby trajectory     [km]
%  vpM       [1]         incoming velocity magnitude at perigee          [km/s]
%  vpP       [1]         outgoing velocity magnitude at perigee          [km/s]
%  aHypM     [1]      incoming hyperbola semi-major axis                 [km]
%  aHypP     [1]      outgoing hyperbola semi-major axis                 [km]
%  eHypM     [1]      incoming hyperbola eccentricity                    [-]
%  eHypP     [1]      outgoing hyperbola eccentricity                    [-]
%  turnAngle [1]      turn angle                                         [deg]
%  ratiodV   [1]      Ratio between the DV of the impulsive manoeuvre at the pericentre of the flyby and the total DV provided by the flyby [-]
%
% FUNCTIONS CALLED:
% astroConstants.m
% uplanet.m
% ephNEO.m
% kep2car.m
% car2kep.m
% lambertMR.m
% poweredGravityAssist.m
%
% CONTRIBUTORS
% Michele Puzzolante
%
% VERSION
% 2023/12/30 First version
%-------------------------------------------------------------------------%

DVTOT = NaN;
DV_Dep = NaN;
DV_GA = NaN; 
DV_Arr = NaN;
KepLeg1 = NaN;
TOF1 = NaN;
KepLeg2 = NaN;
TOF2 = NaN;
vInfM = NaN;
vInfP = NaN;
rp = NaN;
aHypM = NaN;
eHypM = NaN; 
aHypP = NaN;
eHypP = NaN;
vpM = NaN;
vpP = NaN;
ratiodV = NaN;
if (tFB - tDEP) >= 0 && (tARR - tFB) >= 0
    
    % Set id for the planets and the asteroid
    id_Departure_Planet = 5; % Jupiter
    id_Flyby_Planet = 4;     % Mars
    id_Arrival_Object = 40;    % Asteroid N 29
    
    % Gravitational Constant of the SUN
    muS = astroConstants(4);
    
    % Departure planet
    [KepDep, ~] = uplanet(tDEP, id_Departure_Planet);
    [rrD, vvD] = kep2car(KepDep, muS);
    
    % FlyBy Planet
    [KepFlyBy, ~] = uplanet(tFB, id_Flyby_Planet);
    [rrFB, vvFB] = kep2car(KepFlyBy, muS);
    
    % Arrival object
    [KepArr, ~] = ephNEO(tARR, id_Arrival_Object);
    [rrA, vvA] = kep2car(KepArr, muS);
    
    % compute TOFs
    TOF1 = (tFB - tDEP) * 3600 * 24;
    TOF2 = (tARR - tFB) * 3600 * 24;
    
    % 1st tranfer leg JUPITER to MARS
    [~, ~, ~, ERROR1, vvi_l1, vvf_l1, ~, ~] = lambertMR(rrD, rrFB, TOF1, muS, 0, 0, 0);
    vvi_l1 = vvi_l1';
    vvf_l1 = vvf_l1';
    KepLeg1 = car2kep(rrD, vvi_l1, muS);
    
    % 2nd transfer leg MARS to ASTEROID N29
    [~, ~, ~, ERROR2, vvi_l2, vvf_l2, ~, ~] = lambertMR(rrFB, rrA, TOF2, muS, 0, 0, 0);
    vvi_l2 = vvi_l2';
    vvf_l2 = vvf_l2';
    KepLeg2 = car2kep(rrFB, vvi_l2, muS);
    
    if ERROR1 == 0 && ERROR2 == 0
    vInfM = vvf_l1 - vvFB;
    vInfP = vvi_l2 - vvFB;
    [rp, DV_GA, aHypM, eHypM, vpM, aHypP, eHypP, vpP, turnAngle, ratiodV] = poweredGravityAssist(vInfM, vInfP);
        if not(isnan(rp))
            DV_Dep = norm(vvi_l1 - vvD);
            DV_Arr = norm(vvf_l2 - vvA);
            DVTOT = DV_Dep + DV_GA + DV_Arr;
        end
    end
end

end