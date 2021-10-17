%% Descrição do ficheiro

% Autor: Rita Gama
% Nome: Manequim_Project

%% Limpeza/Fecho
clear all; close all; clc;

%% Main

[F,V,N] = stlread('Mesh/Manequim_R.stl');

TR = triangulation(F,V);
trisurf(TR)
IC = incenter(TR);
FN = faceNormal(TR);

fh = figure(1);
fh.WindowState = 'maximized';
figure(1)
hold on

Ponto_i = load('PontoManequim1.txt');
Al = 2;
flag = 2;

%Decidir comprimento
Medida_reta = -0.025; %linha vertical = -0.1 && -0.060 %linha horizontal = -0.025

dis=Medida_reta - Ponto_i(:,2);
N_pontos = 2500; %6000
s=dis/N_pontos;
l_dis = -0.001;
N_Linhas = 60; %25

if Al == 1
    
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

Area = sortrows(Ponto_novo,[2 1],'ascend');

elseif Al == 2
    
    if flag == 1
        
        Ponto_novo = Ponto_i;
        aux = Ponto_i(:,2);
    
        for i = 1:N_pontos-1
            Ponto_novo(i+1,:) = [Ponto_i(:,1) aux+s Ponto_i(:,3)];
            aux=aux+s;
        end

        %plot3(Ponto_novo(:,1),Ponto_novo(:,2),Ponto_novo(:,3)+0.03, '*r');

        P = sortrows(Ponto_novo,[2 1],'ascend');

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

end

%Encontrar pontos mais próximo

k = 1;
for i = 1:size(IC,1)
    
    if (IC(i,2) < 0.006) && (IC(i,2) > -0.07) %defenir setor -0.09 para 0.060
        
        IC_new(k,:) = IC(i,:);
        FN_new(k,:) = FN(i,:);
        k = k+1; 
    
    end
end

IC_x=IC_new(:,1)';
IC_y=IC_new(:,2)';
IC_z=IC_new(:,3)';
FN_x=FN_new(:,1)';
FN_y=FN_new(:,2)';
FN_z=FN_new(:,3)';

for i = 1:size(Area,1)
    Pt = Area(i,:);
    
    for k = 1:size(IC_new,1)
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
fileID_ = fopen('DadosManequim60V_6','w');
fprintf(fileID_,'%0s %1s %2s %3s %4s %5s\n','px','py','pz','nx','ny','nz');
fprintf(fileID_,'%0f %1f %2f %3f %4f %5f\n', cloudPoints');
fclose(fileID_);
