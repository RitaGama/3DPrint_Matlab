%% Descri��o do ficheiro
% � neste ficheiro que se faz a filtragem das normais quando estas contem
% muito ruido. Basicamente, cada normal � passada por um filtro de banda
% Passa-Baixo. Posteriormente � guardado os dados num ficheiro texto. Os
% dados s�o referente �s posi��es dos pontos com os seus quaterni�es. Este
% ficheiro recebe o ficheiro gerado no c�digo Area_Project/Line_Project

% Autor: Rita Gama
% Nome: Filter_normal

%% Limpeza
clear all; close all; clc

%% Main

[F,V,N] = stlread('Mesh/Manequim_R.stl');

% TR = triangulation(F,V);
% trisurf(TR)
% 
% fh = figure(1);
% fh.WindowState = 'maximized';
% figure(1)
% hold on

% lighting phong;
% camproj('perspective');
% axis square; 
% axis equal; 

%Importar dados
S = importdata('//Users/ritagama/Desktop/Disserta��o/Fases de Projecto/3�Fase/2�Fase de Resultados/Ficheiros Areas/Manequim/Ponto1/DadosManequim25_306');
IC = S.data(:,1:3);
FN = S.data(:,4:6);

%Filtro Passa-Baixo
a = 5000;
b = 1;
V = LowPassFilter(FN, a, b);

%Plot da normal obtida
%quiver3(IC(:,1),IC(:,2),IC(:,3), V(:,1),V(:,2),V(:,3), 2, 'color','k');

figure(1)
plot(FN(:,1));
hold on
plot(V(:,1), '-r', 'LineWidth',2)
hold off
grid on
ylabel('N_x', 'FontSize', 20);
legend('Original','Filtro');

figure(2)
plot(FN(:,2));
hold on
plot(V(:,2), '-r', 'LineWidth',2)
hold off
grid on
ylabel('N_y', 'FontSize', 20);
legend('Original','Filtro');

figure(3)
plot(FN(:,3));
hold on
plot(V(:,3), '-r', 'LineWidth',2)
hold off
grid on
ylabel('N_z', 'FontSize', 20);
legend('Original','Filtro');

% Passar para quaterni�es
n=size(V);
for i=1:1:n
    R=normal2Rotation(V(i,:));
    quat(i,:)=rotm2quat(R);
end


Path = [IC quat];

%Cria ficheiro
fileID_ = fopen('Teste2','w');
fprintf(fileID_,'%0s %1s %2s %3s %4s %5s %6s\n','px','py','pz','qx','qy','qz', 'qw');
fprintf(fileID_,'%0f %1f %2f %3f %4f %5f %6f\n', Path');
fclose(fileID_);