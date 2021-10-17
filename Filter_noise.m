%% Descrição do ficheiro
% Neste ficheiro realiza-se a filtragem dos pontos retirados da nuvem de
% pontos. Este ficheiro funciona para qualquer especie de ruido. A funcao 
% FilterNoise recebe dois variaveis. A funcao onde se quer realizar a 
% filtragem e uma flag 1/2. A 1 corresponde a passar um filtro butter com 
% ajuste na fase com filtfilt. A 2 corresponde a passar o sinal pelo 
% smoothdata.

% Autor: Rita Gama
% Nome: Filter_noise

%% Limpeza
clear all; clc; close all;

%%
S = importdata('//Users/ritagama/Desktop/Dissertação/Fases de Projecto/3ºFase/2ºFase de Resultados/Ficheiros Areas/Manequim/Ponto1/DadosManequim25_306');

px = S.data(:,1);
py = S.data(:,2);
pz = S.data(:,3);
Nx = S.data(:,4);
Ny = S.data(:,5);
Nz = S.data(:,6);

pz_new = FilterNoise(pz, 1);
Nx_new = FilterNoise(Nx, 1);
Ny_new = FilterNoise(Ny, 1);
Nz_new = FilterNoise(Nz, 1);

figure(1)
plot(px, '-k');
hold on
hold off
grid on
ylabel('p_x (m)', 'FontSize', 20);
xlabel('t (s)', 'FontSize', 20)
%legend('Original');

figure(2)
plot(py, '-k');
hold on
hold off
grid on
ylabel('p_y (m)', 'FontSize', 20);
xlabel('t (s)', 'FontSize', 20)
%legend('Original');

figure(3)
plot(pz, '-k');
hold on
%plot(pz_new, '-r', 'LineWidth',2)
hold off
grid on
ylabel('p_z (m)', 'FontSize', 20);
xlabel('t (s)', 'FontSize', 20)
%legend('Original','filtfilt');

figure(4)
plot(Nx, '-k');
hold on
%plot(Nx_new, '-r', 'LineWidth',2)
hold off
grid on
ylabel('N_x', 'FontSize', 20);
xlabel('t (s)', 'FontSize', 20)
%legend('Original','filtfilt');

figure(5)
plot(Ny, '-k');
hold on
%plot(Ny_new, '-r', 'LineWidth',2)
hold off
grid on
ylabel('N_y', 'FontSize', 20);
xlabel('t (s)', 'FontSize', 20)
%legend('Original','filtfilt');

figure(6)
plot(Nz, '-k');
hold on
%plot(Nz_new, '-r', 'LineWidth',2)
hold off
grid on
ylabel('N_z', 'FontSize', 20);
xlabel('t (s)', 'FontSize', 20)
%legend('Original','filtfilt');


%% Passar para quaterniões
V = [Nx_new Ny_new Nz_new];
n=size(V);
for i=1:1:n
    R=normal2Rotation(V(i,:));
    quat(i,:)=rotm2quat(R);
end

P = [px py pz_new];
Quat = [quat(:,1) quat(:,2) quat(:,3) quat(:,4)];

Path = [P Quat];

%Cria ficheiro
fileID_ = fopen('AreaManequim60VFiltro300_3','w');
fprintf(fileID_,'%0s %1s %2s %3s %4s %5s %6s\n','px','py','pz','qx','qy','qz', 'qw');
fprintf(fileID_,'%0f %1f %2f %3f %4f %5f %6f\n', Path');
fclose(fileID_);
