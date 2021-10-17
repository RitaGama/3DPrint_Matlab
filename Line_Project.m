%% Descrição do ficheiro
% Neste ficheiro é projetada uma linha por cima da nuvem de pontos. Essa linha pode
% ser dividida por N pontos que serão posteriormente projetados na nuvem em
% questão. A flag = 1 corresponde a uma linha vertical enquanto que a flag = 2
% corresponde a uma linhas horizontal
% O ficheiro guardado contém os pontos projetados na mesh com o seu vetor
%norma correspondente (px py pz nx ny nz)

% Autor: Rita Gama
% Nome: Line_Project

%% Limpeza/Fecho
clear all; close all; clc;

%% Main

[F,V,N] = stlread('Mesh/arm_0025.stl');

TR = triangulation(F,V);
trisurf(TR)
IC = incenter(TR);
FN = faceNormal(TR);

fh = figure(1);
fh.WindowState = 'maximized';
figure(1)
hold on

Ponto_i = load('Pontos/Point1.txt');
flag = 1;

%Decidir comprimento
Medida_reta = -0.1; %linha vertical = -0.1 / linha horizontal = -0.08

dis=Medida_reta - Ponto_i(:,2);
N_pontos = 6000;
s=dis/N_pontos;

if flag == 1
    
    Ponto_novo = Ponto_i;
    aux = Ponto_i(:,2);
    
    for i = 1:N_pontos-1
        Ponto_novo(i+1,:) = [Ponto_i(:,1) aux+s Ponto_i(:,3)];
        aux=aux+s;
    end
    
elseif flag == 2
    
    Ponto_novo = Ponto_i;
    aux = Ponto_i(:,1);
    
    for i = 1:N_pontos-1
        Ponto_novo(i+1,:) = [aux-s; Ponto_i(:,2); Ponto_i(:,3)];
        aux=aux-s;
    end
end

%plot3(Ponto_novo(:,1),Ponto_novo(:,2),Ponto_novo(:,3)+0.03, '*k');

P = sortrows(Ponto_novo,[2 1],'ascend');

%Encontrar pontos mais próximo

IC_x=IC(:,1)';
IC_y=IC(:,2)';
IC_z=IC(:,3)';
FN_x=FN(:,1)';
FN_y=FN(:,2)';
FN_z=FN(:,3)';

for i = 1:size(P,1)
    Pt = P(i,:);
    
    for k = 1:size(IC,1)
        arr = [IC_x(k) IC_y(k) IC_z(k); Pt];
        distArr(k) = pdist(arr,'euclidean');
    end
    [~,idx] = min(distArr);
   
    cloudPoints(i,:)=[Pt(1,1) Pt(1,2) IC_z(idx) FN_x(idx) FN_y(idx) FN_z(idx)];
end

plot3(cloudPoints(:,1),cloudPoints(:,2),cloudPoints(:,3), '*r');

lighting phong;
camproj('perspective');
axis square; 
axis equal; 
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');

%Cria ficheiro
fileID_ = fopen('Linha_T','w');
fprintf(fileID_,'%0s %1s %2s %3s %4s %5s\n','px','py','pz','nx','ny','nz');
fprintf(fileID_,'%0f %1f %2f %3f %4f %5f\n', cloudPoints');
fclose(fileID_);