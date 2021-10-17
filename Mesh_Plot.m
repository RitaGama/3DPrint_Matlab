%% Descrição do ficheiro
% Neste ficheiro é realizado simplesmente o plot dos pontos da mesh
% assim como as suas normais

% Autor: Rita Gama
% Nome: Mesh_Plot

%% Limpeza/Fecho
clear all; close all; clc;

%% MAIN
% 
[F,V,N] = stlread('Mesh/Manequim_R.stl');

TR = triangulation(F,V);
trisurf(TR)
IC = incenter(TR);
FN = faceNormal(TR);

fh = figure(1);
fh.WindowState = 'maximized';
figure(1)
hold on
 
% plot3(IC(:,1),IC(:,2),IC(:,3), '*r')
% quiver3(IC(:,1),IC(:,2),IC(:,3), FN(:,1),FN(:,2),FN(:,3),2,'color','r');

% k = 1;
% for i = 1:size(IC,1)
%     
%     if (IC(i,2) < 0.006) && (IC(i,2) > -0.07) %defenir setor
%         
%         IC_new(k,:) = IC(i,:);
%         FN_new(k,:) = FN(i,:);
%         k = k+1; 
%     
%     end
% end
% plot3(IC_new(:,1),IC_new(:,2),IC_new(:,3), '*r')
% quiver3(IC_new(:,1),IC_new(:,2),IC_new(:,3), FN_new(:,1),FN_new(:,2),FN_new(:,3),2,'color','r');
  
lighting phong;
camproj('perspective');
axis square; 
axis equal; 

xlabel('X')
ylabel('Y')
zlabel('Z')