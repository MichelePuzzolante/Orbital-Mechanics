%-------------------------------------------------------------------------%
%                                                                         %
%                            ORBITAL MECHANICS                            %
%                              A.Y. 2023/2024                             %
%                                                                         %
%                        SPACEGHETTI - GROUP 2345                         %
%                                                                         %
%                               ASSIGNMENT 2                              %
%                                                                         %
%-------------------------------------------------------------------------%
% AUTHORS:
% Michele Puzzolante
% Mattia Bax
% Giorgia Privitera
% Carlo Vicenzetto
%
% The following code has been developed and tested on a PC which has OS
% Windows 10

%% INITIALIZZATION

clc;
clear; 
close all;

% Path adjustments:
addpath(strcat(pwd,'/functions'));
addpath(strcat(pwd,'/functions/texture'));
%% DATA

% Earth gravitational constant
muE = astroConstants(13);

a_DATA = 0.7192 * 10^4; % [km]
e_DATA = 0.0493; % [-]
i_DATA = deg2rad(82.395); % [rad]

OM = deg2rad(0); % [deg]
om = deg2rad(0); % [deg]
theta0 = deg2rad(0); % [deg]

k = 14; % [-]
m = 1; % [-]

omega_Earth = deg2rad(15.04 / 3600); % [rad/s]
T = 2 * pi * sqrt(a_DATA^3/muE); % [s]

kep_Nominal = [a_DATA; e_DATA; i_DATA; OM; om; theta0];
fprintf('\n---------------DATA--------------')
fprintf('\n a = %f [km]', a_DATA);
fprintf('\n e = %f [-]', e_DATA);
fprintf('\n i = %f [deg]', rad2deg(i_DATA));
fprintf('\n Omega = %f [deg]', rad2deg(OM));
fprintf('\n omega = %f [deg]', rad2deg(om));
fprintf('\n theta0 = %f [deg]', rad2deg(theta0));
fprintf('\n T = %.4f [h]', T/3600);

% Enable plots and saving of results
PLOTS = 0;     % 1 - on, 0 - off
SAVEPLOTS = 0; % 1 - on, 0 - off
TEXT = 0;      % 1 - on, 0 - off
%% TIME VECTORS NOMINAL
t0 = 0;
thetaG_t0 = 0; 

N = 10000;
tspan_1orbit = linspace(t0, T, N);
tspan_1day = linspace(t0, 24*60*60, N);
tspan_10day = linspace(t0, 10*24*60*60, N);

%% TIME VECTORS REPEATING 
[a_Repeating, T_Repeating] = semimajAxForRepGT(muE, omega_Earth, k, m);
tspan_1orbit_Repeating = linspace(t0, T_Repeating, N);
fprintf('\n ----------REPEATING-------------')
fprintf('\n a_REP = %.4f [km]', a_Repeating);
fprintf('\n T_REP = %.4f [h]', T_Repeating/3600);
fprintf('\n --------------------------------')
%% NOMINAL ORBIT UNPERTURBED
% In this section the ground track of the unperturbed orbit has been
% computed
[~, ~, lon_unp_1orbit, lat_unp_1orbit] = groundTrack(kep_Nominal, 'kep', thetaG_t0, omega_Earth, muE, t0, tspan_1orbit, 'unp');
[~, ~, lon_unp_1day, lat_unp_1day] = groundTrack(kep_Nominal, 'kep', thetaG_t0, omega_Earth, muE, t0, tspan_1day, 'unp');
[~, ~, lon_unp_10day, lat_unp_10day] = groundTrack(kep_Nominal, 'kep', thetaG_t0, omega_Earth, muE, t0, tspan_10day, 'unp');

% PLOTS
if PLOTS == 1
    colorUNP = [68, 216, 227]/255;
    figure()
    hold on
    plotEarth2D();
    GT1 = plot(lon_unp_1orbit(1), lat_unp_1orbit(1), 'Marker','o','LineWidth',4, 'Color', [0 0 1], 'MarkerSize',8);
    GT2 = plot(lon_unp_1orbit(end), lat_unp_1orbit(end), 'Marker','square', 'LineWidth',4, 'Color', [1 0 0], 'MarkerSize',8);
    plot(lon_unp_1orbit, lat_unp_1orbit, 'LineWidth',1.5, 'Color', colorUNP);
    hold off
    legend('Start', 'End','Interpreter','latex');
    uistack(GT1, 'top');
    uistack(GT2, 'top');
    xlim([-180 180]);ylim([-90 90]);
    xlabel('Longitude [deg]','Interpreter','latex','FontSize', 9);
    ylabel('Latitude [deg]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'GroundTrackUNP_NOMINAL_1.png','Resolution',600);
    end
    
    figure()
    hold on
    plotEarth2D();
    GT3 = plot(lon_unp_1day(1), lat_unp_1day(1), 'Marker','o','LineWidth',4, 'Color', [0 0 1], 'MarkerSize',8);
    GT4 = plot(lon_unp_1day(end), lat_unp_1day(end), 'Marker','square','LineWidth',4, 'Color', [1 0 0], 'MarkerSize',8);
    plot(lon_unp_1day, lat_unp_1day,'LineWidth',1,'Color', colorUNP);
    hold off
    legend('Start', 'End','Interpreter','latex');
    uistack(GT3, 'top');
    uistack(GT4, 'top');
    xlim([-180 180]);ylim([-90 90]);
    xlabel('Longitude [deg]','Interpreter','latex','FontSize', 9);
    ylabel('Latitude [deg]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'GroundTrackUNP_NOMINAL_2.png','Resolution',600);
    end

    figure()
    hold on
    plotEarth2D();
    GT5 = plot(lon_unp_10day(1), lat_unp_10day(1), 'Marker','o','LineWidth',4, 'Color', [0 0 1], 'MarkerSize',8);
    GT6 = plot(lon_unp_10day(end), lat_unp_10day(end), 'Marker','square','LineWidth',4, 'Color', [1 0 0], 'MarkerSize',8);
    plot(lon_unp_10day, lat_unp_10day,'Color', colorUNP);
    hold off
    legend('Start', 'End','Interpreter','latex');
    uistack(GT5, 'top');
    uistack(GT6, 'top');
    xlim([-180 180]);ylim([-90 90]);
    xlabel('Longitude [deg]','Interpreter','latex','FontSize', 9);
    ylabel('Latitude [deg]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'GroundTrackUNP_NOMINAL_3.png','Resolution',600);
    end
end
%% NOMINAL ORBIT PERTURBED
% In this section the ground track of the perturbed orbit has been
% computed
[~, ~, lon_per_1orbit, lat_per_1orbit] = groundTrack(kep_Nominal, 'kep', thetaG_t0, omega_Earth, muE, t0, tspan_1orbit, 'per');
[~, ~, lon_per_1day, lat_per_1day] = groundTrack(kep_Nominal, 'kep', thetaG_t0, omega_Earth, muE, t0, tspan_1day, 'per');
[~, ~, lon_per_10day, lat_per_10day] = groundTrack(kep_Nominal, 'kep', thetaG_t0, omega_Earth, muE, t0, tspan_10day, 'per');

% PLOTS
if PLOTS == 1
    figure()
    hold on
    plotEarth2D();
    GT7 = plot(lon_per_1orbit(1), lat_per_1orbit(1), 'Marker','o','LineWidth',4, 'Color', [0 0 1], 'MarkerSize',8);
    GT8 = plot(lon_per_1orbit(end), lat_per_1orbit(end), 'Marker','square', 'LineWidth',4, 'Color', [1 0 0], 'MarkerSize',8);
    plot(lon_per_1orbit, lat_per_1orbit, 'LineWidth',1.5);
    hold off
    legend('Start', 'End','Interpreter','latex');
    uistack(GT7, 'top');
    uistack(GT8, 'top');
    xlim([-180 180]);ylim([-90 90]);
    xlabel('Longitude [deg]','Interpreter','latex','FontSize', 9);
    ylabel('Latitude [deg]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'GroundTrackPER_NOMINAL_1.png','Resolution',600);
    end

    figure()
    hold on
    plotEarth2D();
    GT9 = plot(lon_per_1day(1), lat_per_1day(1), 'Marker','o','LineWidth',4, 'Color', [0 0 1], 'MarkerSize',8);
    GT10 = plot(lon_per_1day(end), lat_per_1day(end), 'Marker','square','LineWidth',4, 'Color', [1 0 0], 'MarkerSize',8);
    plot(lon_per_1day, lat_per_1day,'LineWidth',1);
    hold off
    legend('Start', 'End','Interpreter','latex');
    uistack(GT9, 'top');
    uistack(GT10, 'top');
    xlim([-180 180]);ylim([-90 90]);
    xlabel('Longitude [deg]','Interpreter','latex','FontSize', 9);
    ylabel('Latitude [deg]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'GroundTrackPER_NOMINAL_2.png','Resolution',600);
    end

    figure()
    hold on
    plotEarth2D();
    GT11 = plot(lon_per_10day(1), lat_per_10day(1), 'Marker','o','LineWidth',4, 'Color', [0 0 1], 'MarkerSize',8);
    GT12 = plot(lon_per_10day(end), lat_per_10day(end), 'Marker','square','LineWidth',4, 'Color', [1 0 0], 'MarkerSize',8);
    plot(lon_per_10day, lat_per_10day);
    hold off
    legend('Start', 'End','Interpreter','latex');
    uistack(GT11, 'top');
    uistack(GT12, 'top');
    xlim([-180 180]);ylim([-90 90]);
    xlabel('Longitude [deg]','Interpreter','latex','FontSize', 9);
    ylabel('Latitude [deg]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'GroundTrackPER_NOMINAL_3.png','Resolution',600);
    end
end
%% NOMINAL ORBIT UNPERTURBED REPEATING
% In this section the repeating ground track of the unperturbed orbit with has been
% computed
kep_Repeating = [a_Repeating; e_DATA; i_DATA; OM; om; theta0];
[~, ~, lon_unp_1orbit_rep, lat_unp_1orbit_rep] = groundTrack(kep_Repeating, 'kep', thetaG_t0, omega_Earth, muE, t0, tspan_1orbit_Repeating, 'unp');
[~, ~, lon_unp_1day_rep, lat_unp_1day_rep] = groundTrack(kep_Repeating, 'kep', thetaG_t0, omega_Earth, muE, t0, tspan_1day, 'unp');
[~, ~, lon_unp_10day_rep, lat_unp_10day_rep] = groundTrack(kep_Repeating, 'kep', thetaG_t0, omega_Earth, muE, t0, tspan_10day, 'unp');

% PLOTS
if PLOTS == 1
    figure()
    hold on
    plotEarth2D();
    GT13 = plot(lon_unp_1orbit_rep(1), lat_unp_1orbit_rep(1), 'Marker','o','LineWidth',4, 'Color', [0 0 1], 'MarkerSize',8);
    GT14 = plot(lon_unp_1orbit_rep(end), lat_unp_1orbit_rep(end), 'Marker','square', 'LineWidth',4, 'Color', [1 0 0], 'MarkerSize',8);
    plot(lon_unp_1orbit_rep, lat_unp_1orbit_rep, 'LineWidth',1.5,'Color', colorUNP);
    hold off
    legend('Start', 'End','Interpreter','latex');
    uistack(GT13, 'top');
    uistack(GT14, 'top');
    xlim([-180 180]);ylim([-90 90]);
    xlabel('Longitude [deg]','Interpreter','latex','FontSize', 9);
    ylabel('Latitude [deg]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'GroundTrackUNP_REPEATING_1.png','Resolution',600);
    end

    figure()
    hold on
    plotEarth2D();
    GT15 = plot(lon_unp_1day_rep(1), lat_unp_1day_rep(1), 'Marker','o','LineWidth',4, 'Color', [0 0 1], 'MarkerSize',8);
    GT16 = plot(lon_unp_1day_rep(end), lat_unp_1day_rep(end), 'Marker','square','LineWidth',4, 'Color', [1 0 0], 'MarkerSize',8);
    plot(lon_unp_1day_rep, lat_unp_1day_rep,'LineWidth',1,'Color', colorUNP);
    hold off
    legend('Start', 'End','Interpreter','latex');
    uistack(GT15, 'top');
    uistack(GT16, 'top');
    xlim([-180 180]);ylim([-90 90]);
    xlabel('Longitude [deg]','Interpreter','latex','FontSize', 9);
    ylabel('Latitude [deg]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'GroundTrackUNP_REPEATING_2.png','Resolution',600);
    end
    
    figure()
    hold on
    plotEarth2D();
    GT17 = plot(lon_unp_10day_rep(1), lat_unp_10day_rep(1), 'Marker','o','LineWidth',4, 'Color', [0 0 1], 'MarkerSize',8);
    GT18 = plot(lon_unp_10day_rep(end), lat_unp_10day_rep(end), 'Marker','square','LineWidth',4, 'Color', [1 0 0], 'MarkerSize',8);
    plot(lon_unp_10day_rep, lat_unp_10day_rep,'Color', colorUNP);
    hold off
    legend('Start', 'End','Interpreter','latex');
    uistack(GT17, 'top');
    uistack(GT18, 'top');
    xlim([-180 180]);ylim([-90 90]);
    xlabel('Longitude [deg]','Interpreter','latex','FontSize', 9);
    ylabel('Latitude [deg]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'GroundTrackUNP_REPEATING_3.png','Resolution',600);
    end
end
%% NOMINAL ORBIT PERTURBED REPEATING
% In this section the repeating ground track of the perturbed orbit with has been
% computed
[~, ~, lon_per_1orbit_rep, lat_per_1orbit_rep] = groundTrack(kep_Repeating, 'kep', thetaG_t0, omega_Earth, muE, t0, tspan_1orbit_Repeating, 'per');
[~, ~, lon_per_1day_rep, lat_per_1day_rep] = groundTrack(kep_Repeating, 'kep', thetaG_t0, omega_Earth, muE, t0, tspan_1day, 'per');
[~, ~, lon_per_10day_rep, lat_per_10day_rep] = groundTrack(kep_Repeating, 'kep', thetaG_t0, omega_Earth, muE, t0, tspan_10day, 'per');

% PLOTS
if PLOTS == 1
    figure()
    hold on
    plotEarth2D();
    GT19 = plot(lon_per_1orbit_rep(1), lat_per_1orbit_rep(1), 'Marker','o','LineWidth',4, 'Color', [0 0 1], 'MarkerSize',8);
    GT20 = plot(lon_per_1orbit_rep(end), lat_per_1orbit_rep(end), 'Marker','square', 'LineWidth',4, 'Color', [1 0 0], 'MarkerSize',8);
    plot(lon_per_1orbit_rep, lat_per_1orbit_rep, 'LineWidth',1.5);
    hold off
    legend('Start', 'End','Interpreter','latex');
    uistack(GT19, 'top');
    uistack(GT20, 'top');
    xlim([-180 180]);ylim([-90 90]);
    xlabel('Longitude [deg]','Interpreter','latex','FontSize', 9);
    ylabel('Latitude [deg]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'GroundTrackPER_REPEATING_1.png','Resolution',600);
    end

    figure()
    hold on
    plotEarth2D();
    GT21 = plot(lon_per_1day_rep(1), lat_per_1day_rep(1), 'Marker','o','LineWidth',4, 'Color', [0 0 1], 'MarkerSize',8);
    GT22 = plot(lon_per_1day_rep(end), lat_per_1day_rep(end), 'Marker','square','LineWidth',4, 'Color', [1 0 0], 'MarkerSize',8);
    plot(lon_per_1day_rep, lat_per_1day_rep,'LineWidth',1);
    hold off
    legend('Start', 'End','Interpreter','latex');
    uistack(GT21, 'top');
    uistack(GT22, 'top');
    xlim([-180 180]);ylim([-90 90]);
    xlabel('Longitude [deg]','Interpreter','latex','FontSize', 9);
    ylabel('Latitude [deg]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'GroundTrackPER_REPEATING_2.png','Resolution',600);
    end
    
    figure()
    hold on
    plotEarth2D();
    GT23 = plot(lon_per_10day_rep(1), lat_per_10day_rep(1), 'Marker','o','LineWidth',4, 'Color', [0 0 1], 'MarkerSize',8);
    GT24 = plot(lon_per_10day_rep(end), lat_per_10day_rep(end), 'Marker','square','LineWidth',4, 'Color', [1 0 0], 'MarkerSize',8);
    plot(lon_per_10day_rep, lat_per_10day_rep);
    hold off
    legend('Start', 'End','Interpreter','latex');
    uistack(GT23, 'top');
    uistack(GT24, 'top');
    xlim([-180 180]);ylim([-90 90]);
    xlabel('Longitude [deg]','Interpreter','latex','FontSize', 9);
    ylabel('Latitude [deg]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'GroundTrackPER_REPEATING_3.png','Resolution',600);
    end
end
%% ORBIT PROPAGATION WITH PERTURBATIONS
% in this section the has been computed the error between the keplerian
% elements propagate with the perturbed 2BP and the kepl. ele. propagated
% with gauss equations
kep_0 = [a_DATA; e_DATA; i_DATA; OM; om; theta0];
[rr_0, vv_0] = kep2car(kep_0, muE);

initial_date = date2mjd2000([2023 12 25 13 0 0]);
t0 = initial_date * 86400;

N_orbit = 50;
N_points = 10000;
tspan_propagation = linspace(t0, t0 + N_orbit * T, N_points);

options = odeset( 'RelTol', 1e-13, 'AbsTol', 1e-14 );

% Cartesian
[time_cartesian, rv_cartesian] = ode78(@(t,y) ode_2BPPerturbed(t, y, muE), tspan_propagation, [rr_0; vv_0], options);
kep_cartesian = zeros(N_points, 6);
kep_cartesian(1, :) = kep_0;
for i = 2 : N_points
    kep_cartesian(i, :) = car2kep(rv_cartesian(i, 1:3), rv_cartesian(i, 4:6), muE);
end
kep_cartesian(:,4:6) = unwrap(kep_cartesian(:,4:6));

% Gauss's planetary equations
[time_Gauss, kep_Gauss] = ode78(@(t,y) ode_GaussPlanetaryEquations(t, y, muE), tspan_propagation, kep_0, options);
kep_Gauss(:,6) = unwrap(kep_Gauss(:,6));
% Errors
err_a = abs(kep_cartesian(:, 1) - kep_Gauss(:, 1))/kep_0(1);
err_e = abs(kep_cartesian(:, 2) - kep_Gauss(:, 2));
err_i = abs(kep_cartesian(:, 3) - kep_Gauss(:, 3))/(2*pi);
err_OM = abs(kep_cartesian(:, 4) - kep_Gauss(:, 4))/(2*pi);
err_om = abs(kep_cartesian(:, 5) - kep_Gauss(:, 5))/(2*pi);
%err_theta = abs(kep_cartesian(:, 6) - kep_Gauss(:, 6))./abs(kep_Gauss(:,6));
err_theta = abs(kep_cartesian(:, 6) - kep_Gauss(:, 6))./(2*pi);

% PLOTS
if PLOTS == 1
    % Semi-Major axis
    figure()
    subplot(3, 1, 1)
    hold on
    plot((tspan_propagation-t0)/T, kep_cartesian(:, 1),'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Evolution of $a$ cartesian method','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('a [km]','Interpreter','latex','FontSize', 9);
    
    subplot(3, 1, 2)
    hold on
    plot((tspan_propagation-t0)/T, kep_Gauss(:, 1),'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Evolution of $a$ Gauss method','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('a [km]','Interpreter','latex','FontSize', 9);
    
    subplot(3, 1, 3)
    hold on
    plot((tspan_propagation-t0)/T, err_a,'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Relative error of $a$','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$|a_c - a_G|$/$|a_0|$ [-]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'aCAR_GAUSS.png','Resolution',600);
    end
    
    % Eccentricity
    figure()
    subplot(3, 1, 1)
    hold on
    plot((tspan_propagation-t0)/T, kep_cartesian(:, 2),'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Evolution of $e$ cartesian method','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('e [-]','Interpreter','latex','FontSize', 9);
    
    subplot(3, 1, 2)
    hold on
    plot((tspan_propagation-t0)/T, kep_Gauss(:, 2),'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Evolution of $e$ Gauss method','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('e [-]','Interpreter','latex','FontSize', 9);
    
    subplot(3, 1, 3)
    hold on
    plot((tspan_propagation-t0)/T, err_e,'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Relative error of $e$','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$|e_c - e_G|$ [-]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'eCAR_GAUSS.png','Resolution',600);
    end
    
    % Inclination
    figure()
    subplot(3, 1, 1)
    hold on
    plot((tspan_propagation-t0)/T, rad2deg(kep_cartesian(:, 3)),'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Evolution of $i$ cartesian method','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('i [deg]','Interpreter','latex','FontSize', 9);
    
    subplot(3, 1, 2)
    hold on
    plot((tspan_propagation-t0)/T, rad2deg(kep_Gauss(:, 3)),'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Evolution of $i$ Gauss method','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('i [deg]','Interpreter','latex','FontSize', 9);
    
    subplot(3, 1, 3)
    hold on
    plot((tspan_propagation-t0)/T, err_i,'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Relative error of $i$','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$|i_c - i_G|$/$360^o$ [-]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'iCAR_GAUSS.png','Resolution',600);
    end

    % OM
    figure()
    subplot(3, 1, 1)
    hold on
    plot((tspan_propagation-t0)/T, rad2deg(kep_cartesian(:, 4)),'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Evolution of $\Omega$ cartesian method','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$\Omega$ [deg]','Interpreter','latex','FontSize', 9);
    
    subplot(3, 1, 2)
    hold on
    plot((tspan_propagation-t0)/T, rad2deg(kep_Gauss(:, 4)),'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Evolution of $\Omega$ Gauss method','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$\Omega$ [deg]','Interpreter','latex','FontSize', 9);
    
    subplot(3, 1, 3)
    hold on
    plot((tspan_propagation-t0)/T, err_OM,'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Relative error of $\Omega$','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$|\Omega_c - \Omega_G|$/$360^o$ [-]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'OMCAR_GAUSS.png','Resolution',600);
    end

    % omega
    figure()
    subplot(3, 1, 1)
    hold on
    plot((tspan_propagation-t0)/T, rad2deg(kep_cartesian(:, 5)),'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Evolution of $\omega$ cartesian method','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$\omega$ [deg]','Interpreter','latex','FontSize', 9);
    
    subplot(3, 1, 2)
    hold on
    plot((tspan_propagation-t0)/T, rad2deg(kep_Gauss(:, 5)),'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Evolution of $\omega$ Gauss method','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$\omega$ [deg]','Interpreter','latex','FontSize', 9);
    
    subplot(3, 1, 3)
    hold on
    plot((tspan_propagation-t0)/T, err_om,'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Relative error of $\omega$','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$|\omega_c - \omega_G|$/$360^o$ [-]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'omCAR_GAUSS1.png','Resolution',600);
    end

    % Theta
    figure()
    subplot(3, 1, 1)
    hold on
    plot((tspan_propagation-t0)/T, rad2deg(kep_cartesian(:, 6)),'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Evolution of $\theta$ cartesian method','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$\theta$ [deg]','Interpreter','latex','FontSize', 9);
    
    subplot(3, 1, 2)
    hold on
    plot((tspan_propagation-t0)/T, rad2deg(kep_Gauss(:, 6)),'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Evolution of $\theta$ Gauss method','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$\theta$ [deg]','Interpreter','latex','FontSize', 9);
    
    subplot(3, 1, 3)
    hold on
    plot((tspan_propagation-t0)/T, err_theta,'LineWidth',1, 'Color', [0 0 1]);
    hold off
    grid on
    xlim([0 N_orbit])
    title('Relative error of $\theta$','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$|\theta_c - \theta_G|$/$360^o$ [-]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'thetaCAR_GAUSS.png','Resolution',600);
    end
end
% MAX ERRORS
MAX_err_a = max(err_a);
MAX_err_e = max(err_e);
MAX_err_i = max(err_i);
MAX_err_OM = max(err_OM);
MAX_err_om = max(err_om);
MAX_err_theta = max(err_theta);

fprintf('\n------------------ERRORS------------------')
fprintf('\n Max error on a = %.4e', MAX_err_a);
fprintf('\n Max error on e = %.4e', MAX_err_e);
fprintf('\n Max error on i = %.4e', MAX_err_i);
fprintf('\n Max error on OM = %.4e', MAX_err_OM);
fprintf('\n Max error on om = %.4e', MAX_err_om);
fprintf('\n Max error on theta = %.4e', MAX_err_theta);
fprintf('\n------------------------------------------')
%% ORBIT PROPAGATED
% In this section the perturbated orbit has been propagted for 1000 orbits
% in order to see what happen
N_orbit_propagated = 1000;
N_points_orbit_propagated = 50000;

tspan_plot_orbit = linspace(t0, t0 + N_orbit_propagated*T, N_points_orbit_propagated);

[time_Gauss_propagated, kep_Gauss_propagated] = ode78(@(t,y) ode_GaussPlanetaryEquations(t, y, muE), tspan_plot_orbit, kep_0, options);

rr_Gauss_propagated = zeros(3, N_points_orbit_propagated);
for i = 1 : N_points_orbit_propagated
    [rr_Gauss_propagated(:, i), ~] = kep2car(kep_Gauss_propagated(i, :), muE);
end

% COLOR ALGORITHM
i = 1;
FirstOrbit = 0;
while (time_Gauss_propagated(i) - t0)/T <= 1
    FirstOrbit = FirstOrbit + 1;
    i = i + 1;
end
i = 0;
LastOrbit = 0;
while (time_Gauss_propagated(end - i) - t0)/T >= N_orbit_propagated-1
    LastOrbit = LastOrbit + 1;
    i = i + 1;
end

%% PLOT
if PLOTS == 1
    figure()
    hold on
    plot3(rr_Gauss_propagated(1, 1:FirstOrbit), rr_Gauss_propagated(2, 1:FirstOrbit), rr_Gauss_propagated(3, 1:FirstOrbit), 'LineWidth',3, 'LineStyle','-', 'Color',[0.1 0.9 0]);
    plot3(rr_Gauss_propagated(1, end-LastOrbit:end), rr_Gauss_propagated(2, end-LastOrbit:end), rr_Gauss_propagated(3, end-LastOrbit:end), 'LineWidth',3, 'LineStyle','-', 'Color',[0.9 0.1 0]);
    plot3(rr_Gauss_propagated(1, 1), rr_Gauss_propagated(2, 1), rr_Gauss_propagated(3, 1), 'Linewidth', 4,'Marker','o', 'MarkerSize', 8, 'Color', [0 0.5 0.5])
    plot3(rr_Gauss_propagated(1, end), rr_Gauss_propagated(2, end), rr_Gauss_propagated(3, end), 'Linewidth', 4,'Marker','square', 'MarkerSize', 8, 'Color',[0.3 0 0.7])
    plotPlanet(3, 1);
    colorValue = ceil((time_Gauss_propagated(FirstOrbit+1 : length(time_Gauss_propagated)-LastOrbit-1) - t0)/T)/N_orbit_propagated;
    map = [0.3 0.7 0] -([0.3 0.7 0] - [0.7 0.1 0.2]).*colorValue;
    i_initial = 1;
    for Nx = 2 : N_orbit_propagated-1
        indexM = 0;
        for i = i_initial : length(colorValue)
            if colorValue(i) * N_orbit_propagated == Nx
                indexM = indexM + 1;
                colorN = map(i, :);
            end
        end
        plot3(rr_Gauss_propagated(1, FirstOrbit+i_initial:FirstOrbit+i_initial+indexM),...
              rr_Gauss_propagated(2, FirstOrbit+i_initial:FirstOrbit+i_initial+indexM),...
              rr_Gauss_propagated(3, FirstOrbit+i_initial:FirstOrbit+i_initial+indexM),...
              'LineWidth',0.1, 'LineStyle', '--', 'Color', colorN);
        i_initial = i_initial + indexM;
    end
    hold off
    colormap(map)
    c = colorbar;
    c.Label.String = 'N of orbits';
    c.Label.Interpreter = 'latex';
    c.TickLabelInterpreter = 'latex';
    c.FontSize = 15;
    clim([1 N_orbit_propagated])
    grid on
    axis equal
    view(103.3254,42.5284)
    legend('Initial Orbit', 'Final Orbit', 'Start', 'End', 'Interpreter', 'latex', 'Location', 'northeast');
    %view(0, 90) 
    %legend('Initial Orbit', 'Final Orbit', 'Start', 'End', 'Interpreter', 'latex', 'Location', 'southwest');
    xlabel('x [km]','Interpreter','latex','FontSize', 9);
    ylabel('y [km]','Interpreter','latex','FontSize', 9);
    zlabel('z [km]','Interpreter','latex','FontSize', 9);
    if SAVEPLOTS == 1
        exportgraphics(gcf,'OrbitEVOLUTION.png','Resolution',600);
    end
end
fprintf('\n----------ORBIT EVOLUTION------------')
fprintf('\n a_i = %.4f [km] \t a_f = %.4f [km]', kep_Gauss_propagated(1,1), kep_Gauss_propagated(end,1))
fprintf('\n e_i = %.4f [-] \t e_f = %.4f [-]', kep_Gauss_propagated(1,2), kep_Gauss_propagated(end,2))
fprintf('\n i_i = %.4f [deg] \t i_f = %.4f [deg]', rad2deg(kep_Gauss_propagated(1,3)), rad2deg(kep_Gauss_propagated(end,3)))
fprintf('\n OM_i = %.4f [deg] \t OM_f = %.4f [deg]', rad2deg(kep_Gauss_propagated(1,4)), rad2deg(kep_Gauss_propagated(end,4)))
fprintf('\n om_i = %.4f [deg] \t om_f = %.4f [deg]', rad2deg(kep_Gauss_propagated(1,5)), rad2deg(kep_Gauss_propagated(end,5)))
fprintf('\n theta_i = %.4f [deg] \t theta_f = %.4f [deg]', rad2deg(kep_Gauss_propagated(1,6)), wrapTo360(rad2deg(kep_Gauss_propagated(end,6))) )
fprintf('\n-------------------------------------')
%% FILTERING
T_long = T;                                                      % period of long-periodic oscillations [s]
nwindow_long = nearest(T_long/(sum(diff(time_Gauss)/(numel(time_Gauss)-1))));         % number of points of the time window of the length of 1 T_long [s]
kep_filtered_secular = movmean(kep_Gauss,nwindow_long,1); % filtering of short-periodic oscillations (only secular and long periodic components remaining)

% PLOTS
if PLOTS == 1
% Semi-Major axis
figure()
hold on
plot((tspan_propagation-t0)/T, kep_Gauss(:, 1),'LineWidth',1, 'Color', [0 0 1]);
plot((tspan_propagation-t0)/T, kep_filtered_secular(:, 1),'LineWidth',1, 'Color', [1 0 0]);
hold off
grid on
xlim([0 N_orbit])
title('Semimajor axis','Interpreter','latex','FontSize', 9);
xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
ylabel('a [km]','Interpreter','latex','FontSize', 9);
legend('Propagated', 'Secular', 'Location', 'southeast','Interpreter','latex')
if SAVEPLOTS == 1
    exportgraphics(gcf,'aFiltering.png','Resolution',600);
end

% Eccentricity
figure()
hold on
plot((tspan_propagation-t0)/T, kep_Gauss(:, 2),'LineWidth',1, 'Color', [0 0 1]);
plot((tspan_propagation-t0)/T, kep_filtered_secular(:, 2),'LineWidth',1, 'Color', [1 0 0]);
hold off
grid on
xlim([0 N_orbit])
title('Eccentricity','Interpreter','latex','FontSize', 9);
xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
ylabel('e [-]','Interpreter','latex','FontSize', 9);
legend('Propagated', 'Secular', 'Location', 'southeast','Interpreter','latex')
if SAVEPLOTS == 1
    exportgraphics(gcf,'eFiltering.png','Resolution',600);
end

% Inclination
figure()
hold on
plot((tspan_propagation-t0)/T, rad2deg(kep_Gauss(:, 3)),'LineWidth',1, 'Color', [0 0 1]);
plot((tspan_propagation-t0)/T, rad2deg(kep_filtered_secular(:, 3)),'LineWidth',1, 'Color', [1 0 0]);
hold off
grid on
xlim([0 N_orbit])
title('Inclination','Interpreter','latex','FontSize', 9);
xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
ylabel('i [deg]','Interpreter','latex','FontSize', 9);
legend('Propagated', 'Secular', 'Location', 'southeast','Interpreter','latex')
if SAVEPLOTS == 1
    exportgraphics(gcf,'iFiltering.png','Resolution',600);
end

% OM
figure()
hold on
plot((tspan_propagation-t0)/T, rad2deg(kep_Gauss(:, 4)),'LineWidth',1, 'Color', [0 0 1]);
plot((tspan_propagation-t0)/T, rad2deg(kep_filtered_secular(:, 4)),'LineWidth',1, 'Color', [1 0 0]);
hold off
grid on
xlim([0 N_orbit])
title('Right ascension of ascending node','Interpreter','latex','FontSize', 9);
xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
ylabel('$\Omega$ [deg]','Interpreter','latex','FontSize', 9);
legend('Propagated', 'Secular', 'Location', 'southeast','Interpreter','latex')
if SAVEPLOTS == 1
    exportgraphics(gcf,'OMFiltering.png','Resolution',600);
end

% omega
figure()
hold on
plot((tspan_propagation-t0)/T, rad2deg(kep_Gauss(:, 5)),'LineWidth',1, 'Color', [0 0 1]);
plot((tspan_propagation-t0)/T, rad2deg(kep_filtered_secular(:, 5)),'LineWidth',1, 'Color', [1 0 0]);
hold off
grid on
xlim([0 N_orbit])
title('Evolution of $\omega$ cartesian method','Interpreter','latex','FontSize', 9);
xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
ylabel('$\omega$ [deg]','Interpreter','latex','FontSize', 9);
legend('Propagated', 'Secular', 'Location', 'southeast','Interpreter','latex')
if SAVEPLOTS == 1
    exportgraphics(gcf,'omFiltering1.png','Resolution',600);
end

% Theta
figure()
hold on
plot((tspan_propagation-t0)/T, rad2deg(kep_Gauss(:, 6)),'LineWidth',1, 'Color', [0 0 1]);
plot((tspan_propagation-t0)/T, rad2deg(kep_filtered_secular(:, 6)),'LineWidth',1, 'Color', [1 0 0]);
hold off
grid on
xlim([0 N_orbit])
title('True anomaly','Interpreter','latex','FontSize', 9);
xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
ylabel('$\theta$ [deg]','Interpreter','latex','FontSize', 9);
legend('Propagated', 'Secular', 'Location', 'southeast','Interpreter','latex')
if SAVEPLOTS == 1
    exportgraphics(gcf,'thetaFiltering.png','Resolution',600);
end
end
%% REAL ORBIT
%loadRealData();
load('POPACS2_Full_orbital_elements.mat','kep_POPACS2');
initial_date = date2mjd2000([2023 12 12 0 0 0]) * 86400;
final_date = date2mjd2000([2023 12 16 0 0 0]) * 86400;
time_step = 1 * 60;
tspan_real_orbit = initial_date : time_step : final_date;

kep0_real = kep_POPACS2(1, :);
kep0_real(3:6) = deg2rad(kep0_real(3:6));
[rr0_real, vv0_real] = kep2car(kep0_real, muE);
T_real = 2 * pi * sqrt(kep0_real(1)^3 / muE);
[time_Kep_Real, rv_2BPP_Real] = ode78(@(t,y) ode_2BPPerturbed(t, y, muE), tspan_real_orbit, [rr0_real, vv0_real], options);

kep_kep_Real = zeros(length(tspan_real_orbit), 6);
for i = 1 : length(tspan_real_orbit)
    kep_kep_Real(i, :) = car2kep(rv_2BPP_Real(i, 1:3), rv_2BPP_Real(i, 4:6), muE);
end

kep_POPACS2(:, 6) = deg2rad(kep_POPACS2(:, 6));
kep_POPACS2(:, 6) = unwrap(kep_POPACS2(:, 6));
kep_POPACS2(:, 6) = rad2deg(kep_POPACS2(:, 6));
kep_kep_Real(:, 6) = unwrap(kep_kep_Real(:, 6));
kep_kep_Real(:, 3:6) = rad2deg(kep_kep_Real(:, 3:6));

% PLOTS
if PLOTS == 1
    % Semi-Major axis
    figure()
    hold on
    plot((tspan_real_orbit-initial_date)/T_real, kep_kep_Real(:, 1),'LineWidth',1, 'Color', [0 0 1]);
    plot((tspan_real_orbit-initial_date)/T_real, kep_POPACS2(:, 1),'LineWidth',1, 'Color', [1 0 0]);
    hold off
    grid on
    xlim([0 max((tspan_real_orbit-initial_date)/T_real)])
    title('Semimajor axis','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('a [km]','Interpreter','latex','FontSize', 9);
    legend('Cartesian', 'NASA Horizon', 'Location', 'southwest','Interpreter','latex')
    if SAVEPLOTS == 1
        exportgraphics(gcf,'aREALvsPROPAGATED.png','Resolution',600);
    end

    % Eccentricity
    figure()
    hold on
    plot((tspan_real_orbit-initial_date)/T_real, kep_kep_Real(:, 2),'LineWidth',1, 'Color', [0 0 1]);
    plot((tspan_real_orbit-initial_date)/T_real, kep_POPACS2(:, 2),'LineWidth',1, 'Color', [1 0 0]);
    hold off
    grid on
    xlim([0 max((tspan_real_orbit-initial_date)/T_real)])
    title('Eccentricity','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('e [-]','Interpreter','latex','FontSize', 9);
    legend('Cartesian', 'NASA Horizon', 'Location', 'southwest','Interpreter','latex')
    if SAVEPLOTS == 1
        exportgraphics(gcf,'eREALvsPROPAGATED.png','Resolution',600);
    end

    % Inclination
    figure()
    hold on
    plot((tspan_real_orbit-initial_date)/T_real, kep_kep_Real(:, 3),'LineWidth',1, 'Color', [0 0 1]);
    plot((tspan_real_orbit-initial_date)/T_real, kep_POPACS2(:, 3),'LineWidth',1, 'Color', [1 0 0]);
    hold off
    grid on
    xlim([0 max((tspan_real_orbit-initial_date)/T_real)])
    title('Inclination','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('i [deg]','Interpreter','latex','FontSize', 9);
    legend('Cartesian', 'NASA Horizon', 'Location', 'southwest','Interpreter','latex')
    if SAVEPLOTS == 1
        exportgraphics(gcf,'iREALvsPROPAGATED.png','Resolution',600);
    end

    % OM
    figure()
    hold on
    plot((tspan_real_orbit-initial_date)/T_real, kep_kep_Real(:, 4),'LineWidth',1, 'Color', [0 0 1]);
    plot((tspan_real_orbit-initial_date)/T_real, kep_POPACS2(:, 4),'LineWidth',1, 'Color', [1 0 0]);
    hold off
    grid on
    xlim([0 max((tspan_real_orbit-initial_date)/T_real)])
    title('Right ascension of ascending node','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$\Omega$ [deg]','Interpreter','latex','FontSize', 9);
    legend('Cartesian', 'NASA Horizon', 'Location', 'southwest','Interpreter','latex')
    if SAVEPLOTS == 1
        exportgraphics(gcf,'OMREALvsPROPAGATED.png','Resolution',600);
    end

    % omega
    figure()
    hold on
    plot((tspan_real_orbit-initial_date)/T_real, kep_kep_Real(:, 5),'LineWidth',1, 'Color', [0 0 1]);
    plot((tspan_real_orbit-initial_date)/T_real, kep_POPACS2(:, 5),'LineWidth',1, 'Color', [1 0 0]);
    hold off
    grid on
    xlim([0 max((tspan_real_orbit-initial_date)/T_real)])
    title('Argument of pericenter','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$\omega$ [deg]','Interpreter','latex','FontSize', 9);
    legend('Cartesian', 'NASA Horizon', 'Location', 'southwest','Interpreter','latex')
    if SAVEPLOTS == 1
        exportgraphics(gcf,'om1REALvsPROPAGATED.png','Resolution',600);
    end

    % Theta
    figure()
    hold on
    plot((tspan_real_orbit-initial_date)/T_real, kep_kep_Real(:, 6),'LineWidth',1, 'Color', [0 0 1]);
    plot((tspan_real_orbit-initial_date)/T_real, kep_POPACS2(:, 6),'LineWidth',1, 'Color', [1 0 0]);
    hold off
    grid on
    xlim([0 max((tspan_real_orbit-initial_date)/T_real)])
    title('True anomaly','Interpreter','latex','FontSize', 9);
    xlabel('N of orbits [-]','Interpreter','latex','FontSize', 9);
    ylabel('$\theta$ [deg]','Interpreter','latex','FontSize', 9);
    legend('Cartesian', 'NASA Horizon', 'Location', 'southeast','Interpreter','latex')
    if SAVEPLOTS == 1
        exportgraphics(gcf,'thetaREALvsPROPAGATED.png','Resolution',600);
    end
end

fprintf('\n-------------------REAL DATA------------------')
fprintf('\n a = %.4f [km]', kep_POPACS2(1,1));
fprintf('\n e = %.4f [-]', kep_POPACS2(1,2));
fprintf('\n i = %.4f [deg]', kep_POPACS2(1,3));
fprintf('\n Omega = %.4f [deg]', kep_POPACS2(1,4));
fprintf('\n omega = %.4f [deg]', kep_POPACS2(1,5));
fprintf('\n theta0 = %.4f [deg]', kep_POPACS2(1,6));
fprintf('\n T = %.4f [h]', T/3600);
fprintf('\n----------------------------------------------')
% ERROS BETWEEN REAL AND PROPAGATED
err_a_POP = abs(kep_kep_Real(:, 1) - kep_POPACS2(:, 1))/kep_0(1);
err_e_POP = abs(kep_kep_Real(:, 2) - kep_POPACS2(:, 2));
err_i_POP = abs(kep_kep_Real(:, 3) - kep_POPACS2(:, 3))/(2*pi);
err_OM_POP = abs(kep_kep_Real(:, 4) - kep_POPACS2(:, 4))/(2*pi);
err_om_POP = abs(kep_kep_Real(:, 5) - kep_POPACS2(:, 5))/(2*pi);
err_theta_POP = abs(kep_kep_Real(:, 6) - kep_POPACS2(:, 6))./abs(kep_POPACS2(:,6));
% MAX ERRORS
MAX_err_a_POP = max(err_a_POP);
MAX_err_e_POP = max(err_e_POP);
MAX_err_i_POP = max(err_i_POP);
MAX_err_OM_POP = max(err_OM_POP);
MAX_err_om_POP = max(err_om_POP);
MAX_err_theta_POP = max(err_theta_POP);
fprintf('\n------------ERRORS REAL DATA------------------')
fprintf('\n Max error on a = %.4e', MAX_err_a_POP);
fprintf('\n Max error on e = %.4e', MAX_err_e_POP);
fprintf('\n Max error on i = %.4e', MAX_err_i_POP);
fprintf('\n Max error on OM = %.4e', MAX_err_OM_POP);
fprintf('\n Max error on om = %.4e', MAX_err_om_POP);
fprintf('\n Max error on theta = %.4e', MAX_err_theta_POP);
fprintf('\n----------------------------------------------')

%% SAVE RESULTS
if TEXT == 1
    FILE = fopen('Results_PlanetaryMission_group_2345.txt', 'W');
    fprintf(FILE,'\n-------------------RESULTS-------------------');
    fprintf(FILE,'\n a_Rep = %.3f [km]', a_Repeating);
    fprintf(FILE,'\n---------------------------------------------');
    fclose(FILE);
end