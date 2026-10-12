function [TOF, aT] = HonmannTransfer(mu, rp, ra)
%
% function that computes the TOF of an Homann transfer
%
% PROTOTYPE
% [TOF, aT] = HonmannTransfer(mu, rp, ra)
%
% INPUT
% rp [1]     radius of the departure orbit                    [km]
% ra [1]     radius of the arrival orbit                      [km]
% mu [1]     Gravitational parameter of the primary           [km^3/s^2]
%
% OUTPUT
% TOF [1] Time of flight                                      [s]
% aT  [1] Semimajor axis of the transfer orbit                [km]
%
% FUNCTIONS CALLED:
% none
%
% CONTRIBUTORS
% Michele Puzzolante
%
% VERSION
% 2023/11/12 First version
%-------------------------------------------------------------------------%
aT = (rp + ra) / 2;
TOF = pi * sqrt(aT^3 / mu);

end