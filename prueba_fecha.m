vectorDias = [];
formatOut = 'dd/mm/yyyy';

empresa = ibex35{t};
%empresa = 'bbva';
url_string = ['http://www.infobolsa.es/cotizacion/historico-', empresa];

fechahoy = date;

for k=1:3 %eran 10
    
    hoy = fechahoy;
    Busday = busdate(hoy,-1);
    ayer = datestr(Busday);
    vectorDias{k} = ayer;
    
   % ayer = datestr(ayer,formatOut);   % sin esta linea funciona
    fechahoy = ayer;
end

% Una vez lleno el vector, cambiar de formato todos los días

diasFormateados = [];
vectorResultados = [];
vectorResultadosFormateados = [];
OEempresa = [];

for i=1:3 %eran 10
    
    diaFormato = vectorDias{i};
    diaFormato = datestr(diaFormato,formatOut);
    diasFormateados{i} = diaFormato;
    
    %dentro de este bucle, para cada dia, se ejecuta la recogida de datos
    %de cotizaciones.
    
    lecturaF = urlread(url_string);
    PosicionF = strfind(lecturaF,diaFormato);
            %hasta aquí funciona
     busquedaF=lecturaF(PosicionF:PosicionF+100);
     PosicionInicialF=strfind(busquedaF,'"price">')+length('"price">')-1;
     PosicionFinalF=strfind(busquedaF,'</td>');
     PosicionFinalF=PosicionFinalF(2);
     busquedaF(PosicionInicialF:PosicionFinalF);
     
     pattern='\d+(,\d+)?';
     text = busquedaF;
     ResultadosF=regexp(text, pattern, 'match');
     ResultadosF{4};   %es el resultado que buscamos
     resulBuscado = ResultadosF{4};
     vectorResultados{i} = resulBuscado;
    
     % cálculo del oscilador estocástico para cada empresa, para cada día.
     % OEt = 100*(Cotizanterior-valorMin)/(valorMax-valorMin); 
     
        expression = ',';
        replace = '.';
        cosa = regexprep(resulBuscado,expression,replace);
        
        cosa = str2double(cosa);
        
    OEempresa{i} = 100*(cosa-valorMin)/(valorMax-valorMin) ;
    
   for i=1:length(vectorResultados)
       var = regexprep(vectorResultados(i),expression,replace);
       var = str2double(var);
       vectorResultadosFormateados{i} = var;
   end
  
end
% diasFormateados 
 % OEempresa
 clearvars PosicionFinalF PosicionInicialF PosicionF busquedaF diasFormateados vectorDias diaFormato hoy ayer
