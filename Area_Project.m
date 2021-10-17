%% Descriao do ficheiro
% Neste ficheiro Ž possivel projetar uma area retangular/quadrada na malha de superf’cie.
% A area Ž constituida por N linhas dividadas por x pontos.
% Posteriormente esses pontos sao projetados na malha formando assim a
% area. A flag = 1 corresponde a linha verticais enquanto que a flag = 2
% corresponde a linhas horizontais
%O ficheiro guardado contem os pontos projetados na mesh com o seu vetor
%normal correspondente (px py pz nx ny nz)

% Autor: Rita Gama
% Nome: Area_Project

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
flag = 2;

%Decidir comprimento
Medida_reta = -0.1; %linha vertical = -0.1 / linha horizontal = -0.08

dis=Medida_reta - Ponto_i(:,2);
N_pontos = 4000;
s=dis/N_pontos;
l_dis = -0.001;
N_Linhas = 10;

if flag == 1
    Ponto_novo = Ponto_i;
    aux = Ponto_i(:,2);
    
    for i = 1:N_pontos-1
        Ponto_novo(i+1,:) = [Ponto_i(:,1) aux+s Ponto_i(:,3)];
        aux=aux+s;
    end

    %plot3(Ponto_novo(:,1),Ponto_novo(:,2),Ponto_novo(:,3)+0.03, '*r');

    Area = sortrows(Ponto_novo,[2 1],'ascend');

    P_aux1 = Ponto_novo;
    Area = P;
    for l = 1:N_Linhas-1

        if mod(l,2) == 0

            P_aux2 = [P_aux1(:,1)-l_dis P_aux1(:,2) P_aux1(:,3)];
            P1 = sortrows(P_aux2,[2 1],'ascend');

        else

            P_aux2 = [P_aux1(:,1)-l_dis P_aux1(:,2) P_aux1(:,3)];
            P1 = sortrows(P_aux2,[2 1],'descend');

        end

        P_aux1 = P_aux2;
        Area((l*N_pontos)+1:((l*N_pontos)+1)+(N_pontos-1),:) = P1; 
    end
    
elseif flag == 2
    
    Ponto_novo = Ponto_i;
    aux = Ponto_i(:,1);
    for i = 1:N_pontos-1
        Ponto_novo(i+1,:) = [aux-s Ponto_i(:,2) Ponto_i(:,3)];
        aux=aux-s;
    end

    %plot3(Ponto_novo(:,1),Ponto_novo(:,2),Ponto_novo(:,3), '*r');

    P = sortrows(Ponto_novo,[1 2],'ascend');

    P_aux1 = Ponto_novo;
    Area = P;
    for l = 1:N_Linhas-1

        if mod(l,2) == 0

            P_aux2 = [P_aux1(:,1) P_aux1(:,2)+l_dis P_aux1(:,3)];
            P1 = sortrows(P_aux2,[1 2],'ascend');

        else

            P_aux2 = [P_aux1(:,1) P_aux1(:,2)+l_dis P_aux1(:,3)];
            P1 = sortrows(P_aux2,[1 2],'descend');

        end

        P_aux1 = P_aux2;
        Area((l*N_pontos)+1:((l*N_pontos)+1)+(N_pontos-1),:) = P1; 
    end
    
end

%plot3(Area(:,1),Area(:,2),Area(:,3), '*g');

%Encontrar ponto mais próximo
IC_x=IC(:,1)';
IC_y=IC(:,2)';
IC_z=IC(:,3)';
FN_x=FN(:,1)';
FN_y=FN(:,2)';
FN_z=FN(:,3)';

for i = 1:size(Area,1)
    Pt = Area(i,:);
    
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

%Criar ficheiro
fileID_ = fopen('Dados10NH_2','w');
fprintf(fileID_,'%0s %1s %2s %3s %4s %5s\n','px','py','pz','nx','ny','nz');
fprintf(fileID_,'%0f %1f %2f %3f %4f %5f\n', cloudPoints');
fclose(fileID_);
