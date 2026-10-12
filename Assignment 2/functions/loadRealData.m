function [] = loadRealData()
%
% functions for loading data of a real satellite
%
% PROTOTYPE
% [] = loadRealData()
%
% INPUT
%
% OUTPUT
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

% open file
FILE = fopen('horizons_results_POPACS2_Full_OE.txt');
% Read first line
tlineDATE = fgetl(FILE);
i = 1; 

% while for read all the file
while ischar(tlineDATE) 
    tlineLINE1 = fgetl(FILE);
    LINE1 = split(tlineLINE1," ");
    kep_POPACS2(i, 2) = str2num(LINE1{3}); % Eccentricity
    kep_POPACS2(i, 3) = str2num(LINE1{7}); % inclination
    tlineLINE2 = fgetl(FILE);
    LINE2 = split(tlineLINE2," ");
    kep_POPACS2(i, 4) = str2num(LINE2{3}); % OM
    kep_POPACS2(i, 5) = str2num(LINE2{6}); % om
    tlineLINE3 = fgetl(FILE);
    LINE3 = split(tlineLINE3," ");
    kep_POPACS2(i, 6) = str2num(LINE3{8}); % theta
    tlineLINE4 = fgetl(FILE);
    LINE4 = split(tlineLINE4," ");
    kep_POPACS2(i, 1) = str2num(LINE4{4}); % a
    tlineDATE = fgetl(FILE);
    i = i + 1;
end
% save variable in .mat file
save('POPACS2_Full_orbital_elements.mat', 'kep_POPACS2');
% Close the file
fclose(FILE);

end