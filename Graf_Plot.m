%% 
%% DescSição do ficheiro
% Este ficheiro expõe os resultados obtidos num gráfico em função do tempo.
%Gráficos de posição (x,y,z) Gráficos de orientação (Yaw Pitch Roll ) 

% Autor: Rita Gama
% Nome: Graf_Plot

%% Limpeza/Fecho
clear all; close all; clc;

%% Main
%t p_x p_xd p_y p_yd p_z p_zd Ox Oxd Oy Oyd Oz Ozd Ow Owd e_px e_py e_pz e_ox e_oy e_oz
S = importdata('//Users/ritagama/Desktop/Dissertação/Fases de Projecto/3ºFase/2ºFase de Resultados/Resultados02/FicheirosTrajetoriasManequim/Filtro/PandaArea25_3F');
%% 

t_robot = S.data(:,1);
px_robot = S.data(:,2);
pxd_robot = S.data(:,3);
py_robot = S.data(:,4);
pyd_robot = S.data(:,5);
pz_robot = S.data(:,6);
pzd_robot = S.data(:,7);


Qox_robot = S.data(:,8);
Qoxd_robot = S.data(:,9);
Qoy_robot = S.data(:,10);
Qoyd_robot = S.data(:,11);
Qoz_robot = S.data(:,12);
Qozd_robot = S.data(:,13);
Qow_robot = S.data(:,14);
Qowd_robot = S.data(:,15);

%Quaternion to euler

quat = [Qox_robot Qoy_robot Qoz_robot Qow_robot];
quatd = [Qoxd_robot Qoyd_robot Qozd_robot Qowd_robot];

euler_ang = quat2eul(quat);
euler_ang_d = quat2eul(quatd);

ox_robot = euler_ang(:,1);
oxd_robot = euler_ang_d(:,1);
oy_robot = euler_ang(:,2);
oyd_robot = euler_ang_d(:,2);
oz_robot = euler_ang(:,3);
ozd_robot = euler_ang_d(:,3);

%error position

ex = S.data(1:end-1,16);
ey = S.data(1:end-1,17);
ez = S.data(1:end-1,18);

ex2 = ex.^2;
RMSE_x = sqrt(mean(ex2))

ey2 = ey.^2;
RMSE_y = sqrt(mean(ey2))

ez2 = ez.^2;
RMSE_z = sqrt(mean(ez2))


% %error oriention
ox = S.data(1:end-1,19);
oy = S.data(1:end-1,20);
oz = S.data(1:end-1,21);

eox2 = ox.^2;
RMSE_ox = sqrt(mean(eox2))

eoy2 = oy.^2;
RMSE_oy = sqrt(mean(eoy2))

eoz2 = oz.^2;
RMSE_oz = sqrt(mean(eoz2))

%% Simulation

%position

figure(1)
plot(t_robot, px_robot, '--k', 'linewidth', 2)
hold on
plot(t_robot, pxd_robot, 'r', 'linewidth', 1)
grid on
xlabel('t (s)', 'FontSize', 20)
ylabel('p_x (m)', 'FontSize', 20)
legend('robô', 'pretendida', 'FontSize', 20)
xlim([t_robot(1) t_robot(end)])
%ylim([0.4 0.8])
%title('End-Effector Position (x) in Base frame (Robot)')
% savefig(gcf, 'S_px.png')

figure(2)
plot(t_robot, py_robot, '--k', 'linewidth', 2)
hold on
plot(t_robot, pyd_robot, 'r', 'linewidth', 1)
grid on
xlabel('t (s)', 'FontSize', 20)
ylabel('p_y (m)', 'FontSize', 20)
legend('robô', 'pretendida', 'FontSize', 20)
xlim([t_robot(1) t_robot(end)+1])
%ylim([-0.6 0.6])
%title('End-Effector Position (y) in Base frame (Robot)')
% savefig(gcf, 'S_py.png')

figure(3)
plot(t_robot, pz_robot, '--k', 'linewidth', 2)
hold on
plot(t_robot, pzd_robot, 'r', 'linewidth', 1)
grid on
xlabel('t (s)', 'FontSize', 20)
ylabel('p_z (m)', 'FontSize', 20)
legend('robô', 'pretendida', 'FontSize', 20)
xlim([t_robot(1) t_robot(end)+1])
%ylim([-0.4 0.4])
%title('End-Effector Position (z) in Base frame (Robot)')
% savefig(gcf, 'S_pz.png')

%-------------------------------------------------------------------

%% orientation

figure(4)
plot(t_robot, ox_robot, '--k', 'linewidth', 2)
hold on
plot(t_robot, oxd_robot, 'r', 'linewidth', 1)
grid on
xlabel('t (s)', 'FontSize', 20)
ylabel('Roll (rad)', 'FontSize', 20)
legend('robot', 'desired', 'FontSize', 20)
%ylim([-0.2 0.2])
xlim([t_robot(1) t_robot(end)])
% title('End-Effector Orientation in Base frame (Robot)')

figure(5)
plot(t_robot, oy_robot, '--k', 'linewidth', 2)
hold on
plot(t_robot, oyd_robot, 'r', 'linewidth', 1)
grid on
xlabel('t (s)', 'FontSize', 20)
ylabel('Pitch (rad)', 'FontSize', 20)
legend('robot', 'desired', 'FontSize', 20)
%ylim([-0.4 0.4])
xlim([t_robot(1) t_robot(end)])
% title('End-Effector Orientation in Base frame (Robot)')

figure(6)
plot(t_robot, oz_robot, '--k', 'linewidth', 2)
hold on
plot(t_robot, ozd_robot, 'r', 'linewidth', 1)
grid on
xlabel('t (s)', 'FontSize', 20)
ylabel('Yaw (rad)', 'FontSize', 20)
legend('robot', 'desired', 'FontSize', 20)
ylim([-0.2 0.1])
xlim([t_robot(1) t_robot(end)])
% title('End-Effector Orientation in Base frame (Robot)')
