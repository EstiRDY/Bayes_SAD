
    %Script para coger los datos del valor de cierre de la �ltima sesi�n
    
        empresa = ibex35{i};
       %fecha de ayer 
        Busday = busdate(date, -1);
        ayer = datestr(Busday);
        formatOut = 'dd/mm/yyyy';
        ayer = datestr(ayer,formatOut);

        url_string = ['http://www.infobolsa.es/cotizacion/historico-', empresa];
        %fprintf(url_string)
        lectura = urlread(url_string);
        Posicion = strfind(lectura,ayer);
        AzpiEmaitza=lectura(Posicion:Posicion+400);
        PosicionInicial=strfind(AzpiEmaitza,'"price">')+length('"price">')-1;
        PosicionFinal=strfind(AzpiEmaitza,'</td>');
        AzpiEmaitza(PosicionInicial:PosicionFinal);

        pattern='\d+(,\d+)?';
        text = AzpiEmaitza;
        Resultados=regexp(text, pattern, 'match');
        
        %cambiar la coma por un punto, si no luego lo convierte en una
        %matriz
        cotAnterior = Resultados{4};
        valorMax = Resultados{6};
        valorMin = Resultados{7};
        
        expression = ',';
        replace = '.';
        cotAnterior = regexprep(cotAnterior,expression,replace);
        valorMax = regexprep(valorMax,expression,replace);
        valorMin = regexprep(valorMin,expression,replace);
        
        %fprintf(Resultados{4})
        
