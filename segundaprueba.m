%========= Algorithmic Trading : Redes Bayesianas =========

% 1 -  SETUP
   clc
   clear all
   close all
    
    % Get current date
    %[this_year, this_month, this_day, dummy, dummy] = datevec(date);


    adj = [0 0 1 1 0; 0 0 1 1 0; 0 0 0 0 1; 0 0 0 0 1; 0 0 0 0 0];   % matriz de adyacencia [Ct OEt Rt Dt Ut]
    nodeNames = {'Ct', 'OEt', 'Rt','Dt','Ut'};                       % nodos
    Ct=1; OEt=2; Rt=3; Dt=4; Ut=5;                                   % identificadores de los nodos 
    n = numel(nodeNames);                                            % número de nodos 
    t=1 ; f=0;                                                       % valores true y false
    
    % FUNCIÓN CARGAR_DATOS
    ibex35={'abertis_a','acciona','acerinox','acs','aena','amadeus','arcelormitt.','b.popular','b.sabadell','bankia','bankinter','bbva','caixabank','cellnex','dia','enagas','endesa','ferrovial','gamesa','gas_natural','grifols','iag','iberdrola','inditex','indra_a','mapfre','mediaset','melia_hotels','merlin_prop.','r.e.c.','repsol','santander','tecnicas_reu','telefonica','viscofan'};
   
    for i = 1:1
        url_string =['http://www.infobolsa.es/cotizacion/',ibex35{i}];
        lectura = urlread(url_string);
        Posicion=findstr(lectura,'"subdata1"');
        AzpiEmaitza=lectura(Posicion:Posicion+100);
        PosicionInicial=findstr(AzpiEmaitza,'"price equal center">')+length('"price equal center">')-1;
        PosicionFinal=findstr(AzpiEmaitza,'</div>');
        AzpiEmaitza(PosicionInicial:PosicionFinal);
        pattern='\d+(,\d+)?';
        text = AzpiEmaitza;
        Resultados=regexp(text, pattern, 'match');
        
        %cambiar la coma por un punto, si no luego lo convierte en una
        %matriz
        str = Resultados{2};
        expression = ',';
        replace = '.';
        cotizacion = regexprep(str,expression,replace);

  
        %se asigna a Ct el valor de la cotización en el momento actual
        % OJO lo estamos haciendo mal, estamos cogiendo el volumen, no la
        % cotización!!!!!
        Ct = str2num(cotizacion); 
        run valorcierre;
        Cotizanterior = str2num(cotAnterior);
        valorMax = str2num(valorMax); valorMin = str2num(valorMin); 
        Rt = Ct - Cotizanterior;
        OEt = 100*(Cotizanterior-valorMin)/(valorMax-valorMin);
        
        %Ajustar los alpha mediante sharpe
        alpha1 = []; alpha2 = [];
        %Dt = sign(alpha1*Ct+alpha2*OEt)
        
      fprintf('-%d-|||| Empresa: %s, Cotizacion = %d, Cotizaciont-1 = %d, Retorno = %d |||| \n',i, ibex35{i}, Ct, Cotizanterior, Rt)
    end
  

   % Tabla de probabilidad condicional
   T{Dt}(:,t) = [25 5];    %T{Dt}(:,f) = 1- T{Dt}(:,t);
     
  %Visualizar la red bayesiana gráficamente usando biograph
  nodeLabels = {'Cotización(t)', 'OscilEstocast(t)', 'Retorno(t)', 'Decision', 'Utilidad'};
  bg = biograph(adj, nodeLabels, 'arrowsize', 5);
  set(bg.Nodes, 'shape', 'ellipse');
 % bgInViewer = view(bg);
 