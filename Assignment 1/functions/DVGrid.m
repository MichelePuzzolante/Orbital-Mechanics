function [DVtot, DV1, DV2] = DVGrid(mu_CB, DepObjType, indexDepObj, ArrObjType, indexArrObj, DepWindow, ArrWindow)
%
% Function which compute the total dV and dV1 and dV2 for a Lambert
% transfer
%
% PROTOTYPE
% [DVtot, DV1, DV2] = DVGrid(mu_CB, DepObjType, indexDepObj, ArrObjType, indexArrObj, DepWindow, ArrWindow)
%
% INPUT
% mu_CB       [1]  Gravitational parameter of the primary            [km^3/s^2]
% DepObjType  [1]  Type for the departure object 'p'(planet)         [-]
% indexDepObj [1]  index for the departure object                    [-]
% ArrObjType  [1]  Type for the arrival object 'p'(planet)           [-]
% indexArrObj [1]  index for the departure object                    [-]
% DepWindow   [Nx1]  array which contains dates for the departure    [days]
% ArrWindow   [Nx1]  array which contains dates for the departure    [days]
%
% OUTPUT 
% DVtot  [1]   total dV                     [km/s]
% DV1    [1]   dV for the first manoeuvre   [km/s]
% DV1    [1]   dV for the second manoeuvre  [km/s]
%  
% FUNCTIONS CALLED:
% uplanet.m
% ephNEO.m
% kep2car.m
% lambertMR.m
%
% CONTRIBUTORS
% Michele Puzzolante
%
% VERSION
% 2023/12/30 First version
%-------------------------------------------------------------------------%
for i = 1 :length(DepWindow)
    for j = 1 : length(ArrWindow)
        % Departure Object
        if strcmp(DepObjType, 'P')
            kepD = uplanet(DepWindow(i), indexDepObj);
        else
            KepD = ephNEO(DepWindow(i), indexDepObj);
        end
        [rD, vD] = kep2car(kepD, mu_CB);
        % Arrival Object
        if strcmp(ArrObjType, 'P')
            kepA = uplanet(ArrWindow(j), indexArrObj);
        else
            kepA = ephNEO(ArrWindow(j), indexArrObj);
        end
        [rA, vA] = kep2car(kepA, mu_CB);
        % TOF
        TOF = - (DepWindow(i) - ArrWindow(j)) * 24 * 60 * 60;
        % Lambert Transfer
        [~, ~, ~, ERROR, VI, VF, ~, ~] = lambertMR(rD, rA, TOF, mu_CB, 0, 0, 0);
        % Delta V tot Computation
        if ERROR == 0
            DV1(i, j) = norm(VI' - vD);
            DV2(i, j) = norm(VF' - vA);
            DVtot(i, j) = DV1(i, j) + DV2(i, j);
        else
            DV1(i, j) = NaN;
            DV2(i, j) = NaN;
            DVtot(i, j) = NaN;
        end
    end
end
[a, b] = min(DVtot);
[DVmin, ArrIndex] = min(a);
DepIndex = b(ArrIndex);
end