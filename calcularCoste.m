function [coste] = calcularCoste(x,Ct,OEt)
coste=x(1)*Ct+x(2)*OEt;  %es una funci�n cualquiera en la que sabemos cu�l es el m�nimo
                     

% Utotal=sum(ut)
% coste=-Utotal,