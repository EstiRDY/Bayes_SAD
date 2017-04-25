function [costedos] = calcularCoste(x,Ct,OEt,OEempresa,vectorResultadosFormateados)

OEempresa;                              % Vector que recoge los Oscil. Estocásticos de los días anteriores de 1 empresa. 
vectorResultadosFormateados;            % Vector que recoge las cotizaciones de los días anteriores de 1 empresa
%coste=x(1)*Ct+x(2)*OEt;                 % Fórmula "temporal" para calcular el coste. No es la buena. 
vectorDt = [];                          % Vector que recoge todas las variables de decisión que se van calculando.
Ganar = [];

longCotiz = length(vectorResultadosFormateados);
longOEs = length(OEempresa);
% La longitud de estos vectores es siempre evidentemente, igual al número de días evaluados

%========NI TOCAR - ESTA ES LA CHULETA DE EKAITZ================================
%Dt=sign(x(1)*Ct+x(2)*OEt);  %es una función cualquiera en la que sabemos cuál es el mínimo
%Ganar=diff(Ct).*Dt(1:end-1); 
%coste=-sum(Ganar);
%======================================% 


% 1- Para cada valor del Oscilador Estocástico, calculamos la variable de decisión correspondiente. 
for i=1:longOEs
    actual = OEempresa{i};
    vectorDt{i} = sign(x(1)*Ct+x(2)*actual);
end

% 2 - Ganar = diff(Ct).*Dt(1:end-1); 
%     La operación diff no puede aplicarse directamente a vectores, de ahí el bucle que los recorre.
for n=1:longCotiz 
    n;                   
    v = vectorResultadosFormateados{n};
    f = vectorDt{n};
    Ganar{n} = v^f;
end 
    
% 1) HACER LA FUNCIÓN DIFF CON EL VECTOR GANAR
   A = cell2mat(Ganar);
   diferencia = diff(A);
   
%       2) COSTE = -(SUMAR TODOS LOS VALORES DEL VECTOR GANAR)
   costedos=-sum(diferencia);
    
%       3) CALCULAR LA VARIABLE DE UTILIDAD??????

        % Utotal=sum(ut)
        % coste=-Utotal,
    
end

