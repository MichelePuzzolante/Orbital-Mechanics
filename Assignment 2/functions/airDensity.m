function rho = airDensity(r)
%
% airDensity is function that compute the density of the air at a given
% altitude
%
% PROTOTYPE
% rho = airDensity(r)
%
% INPUT
% r [1]      Position of the S/C                              [km]
%
% OUTPUT
% rho [1]    Density                                          [kg/km^3]
%
% FUNCTIONS CALLED:
% astroConstants.m
%
% CONTRIBUTORS
% Michele Puzzolante
%
% VERSION
% 2023/11/12 First version
%-------------------------------------------------------------------------%

% Radius of the Earth
Re = astroConstants(23);

% Computation of the altitude
h = r - Re;
if h > 0 && h < 25
    h0 = 0;
    rho0 = 1.225;
    H = 7.249;
end

if h > 25 && h < 30
    h0 = 25;
    rho0 = 3.899 * 10^-2;
    H = 6.349;
end

if h > 30 && h < 40
    h0 = 30;
    rho0 = 1.774 * 10^-2;
    H = 6.682;
end

if h > 40 && h < 50
    h0 = 40;
    rho0 = 3.972 * 10^-3;
    H = 7.554;
end

if h > 50 && h < 60
    h0 = 50;
    rho0 = 1.057 * 10^-3;
    H = 8.382;
end

if h > 60 && h < 70
    h0 = 60;
    rho0 = 3.206 * 10^-4;
    H = 7.714;
end

if h > 70 && h < 80
    h0 = 70;
    rho0 = 8.770 * 10^-5;
    H = 6.549;
end

if h > 80 && h < 90
    h0 = 80;
    rho0 = 1.905 * 10^-5;
    H = 5.799;
end

if h > 90 && h < 100
    h0 = 90;
    rho0 = 3.396 * 10^-6;
    H = 5.382;
end

if h > 100 && h < 110
    h0 = 100;
    rho0 = 5.297 * 10^-7;
    H = 5.877;
end

if h > 110 && h < 120
    h0 = 110;
    rho0 = 9.661 * 10^-8;
    H = 7.263;
end

if h > 120 && h < 130
    h0 = 120;
    rho0 = 2.438 * 10^-8;
    H = 9.473;
end

if h > 130 && h < 140
    h0 = 130;
    rho0 = 8.484 * 10^-9;
    H = 12.636;
end

if h > 140 && h < 150
    h0 = 140;
    rho0 = 3.845 * 10^-9;
    H = 16.149;
end

if h > 150 && h < 180
    h0 = 150;
    rho0 = 2.070 * 10^-9;
    H = 22.523;
end

if h > 180 && h < 200
    h0 = 180;
    rho0 = 5.464 * 10^-10;
    H = 29.740;
end

if h > 200 && h < 250
    h0 = 200;
    rho0 = 2.789 * 10^-10;
    H = 37.105;
end

if h > 250 && h < 300
    h0 = 250;
    rho0 = 7.248 * 10^-11;
    H = 45.546;
end

if h > 300 && h < 350
    h0 = 300;
    rho0 = 2.418 * 10^-11;
    H = 53.628;
end

if h > 350 && h < 400
    h0 = 350;
    rho0 = 9.158 * 10^-12;
    H = 53.298;
end

if h > 400 && h < 450
    h0 = 400;
    rho0 = 3.725 * 10^-12;
    H = 58.515;
end

if h > 450 && h < 500
    h0 = 450;
    rho0 = 1.585 * 10^-12;
    H = 60.828;
end

if h > 500 && h < 600
    h0 = 500;
    rho0 = 6.967 * 10^-13;
    H = 63.822;
end

if h > 600 && h < 700
    h0 = 600;
    rho0 = 1.454 * 10^-13;
    H = 71.835;
end

if h > 700 && h < 800
    h0 = 700;
    rho0 = 3.614 * 10^-14;
    H = 88.667;
end

if h > 800 && h < 900
    h0 = 800;
    rho0 = 1.170 * 10^-14;
    H = 124.64;
end

if h > 900 && h < 1000
    h0 = 900;
    rho0 = 5.245 * 10^-15;
    H = 181.05;
end

if h > 1000
    h0 = 1000;
    rho0 = 3.019 * 10^-15;
    H = 268;
end

% Computation of the density
rho = rho0 * exp(-(h - h0)/H);
% Conversion
rho = rho * 1e9;

end