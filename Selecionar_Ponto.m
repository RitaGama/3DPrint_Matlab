%% Descrição do ficheiro
% Neste ficheiro é possivel selecionar o ponto ao qual se pertende começar
% a realizar a trajetória. O ponto é guardado num ficheiro .txt

% Autor: Rita Gama
% Nome: Area_Project

%% Limpeza/Fecho
clear all; close all; clc;

%% Main

[F,V,N] = stlread('Mesh/Manequim_R.stl');

TR = triangulation(F,V);
IC = incenter(TR);
FN = faceNormal(TR);

handle.a = axes;
handle.x = IC_new(:,1)';
handle.y = IC_new(:,2)';
handle.z = IC_new(:,3)';

% 3D plot
handle.p = plot3(handle.x,handle.y,handle.z,'.');
lighting phong;
camproj('perspective');
axis square; 
axis equal; 
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');

%Criar ficheiro
fid = fopen( 'PontoManequim2.txt', 'wt' );
fclose(fid);


handle.p.ButtonDownFcn = {@click,handle};


% definition of click
function click(obj,eventData,handle)
    % co-ordinates of the current selected point
    Pt = handle.a.CurrentPoint(2,:);
    % find point closest to selected point on the plot
    for k = 1:2451
        arr = [handle.x(k) handle.y(k) handle.z(k);Pt];
        distArr(k) = pdist(arr,'euclidean');
    end
    [~,idx] = min(distArr);
    % display the selected point on plot
    disp([handle.x(idx) handle.y(idx) handle.z(idx)]);
    if isfile('PontoManequim2.txt')
        fid = fopen('PontoManequim2.txt', 'a');
        fprintf(fid, '%0f %1f %2f\n', [handle.x(idx) handle.y(idx) handle.z(idx)]);
        fclose(fid);
    else
        disp('Creat a file first!');
    end
end