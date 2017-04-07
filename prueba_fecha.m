clc
clear all
close all

vectorDias = [];
formatOut = 'dd/mm/yyyy';

for k=1:10
    hoy = date;
    Busday = busdate(hoy,-1);
    ayer = datestr(Busday);
    vectorDias{k} = ayer
   % ayer = datestr(ayer,formatOut);   % sin esta linea funciona
    date = ayer;
end
% Una vez lleno el vector, cambiar de formato todos los días

diasFormateados = []
for k=1:10
    dia = vectorDias{k};
    dia = datestr(dia,formatOut);
    diasFormateados{k} = dia
    
end



