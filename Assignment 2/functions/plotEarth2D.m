function plotEarth2D()
% 
% Function to plot the 2D representation of Earth's surface for Ground Track plotting.
%
% PROTOTYPE
% plot_Earth_2D()
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

% Loads the Earth map
I = (imread('Earth.jpg'));  
% Puts the axes limits as the latitude and longitude limits (in deg)
image([-180 180],[90 -90], I);     
axis xy

end