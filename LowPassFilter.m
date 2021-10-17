function [V] = LowPassFilter(Vn, a, b)
%vn = matriz com vetores normais
% a e b ganhos

V = [];
V(1,:) = Vn(1,:);

for i = 1:size(Vn,1)-1
    
    C = (a * V(i,:)) + (b * Vn(i+1,:));
    
    V(i+1,:) = C/norm(C);
    
end
end