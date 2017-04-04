function [coste] = calcularCoste(x,Ct,OEt)
coste=x(1)*Ct+x(2)*OEt;  %es una función cualquiera en la que sabemos cuál es el mínimo
                     

% Utotal=sum(ut)
% coste=-Utotal,