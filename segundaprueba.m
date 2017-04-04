%========= Algorithmic Trading : Redes Bayesianas =========

% 1 -  SETUP
%       Se inicializa la red bayesiana con 5 nodos y las relaciones entre
%       ellos.
   clc
   clear all
   close all

    adj = [0 0 1 1 0; 0 0 1 1 0; 0 0 0 0 1; 0 0 0 0 1; 0 0 0 0 0];   % matriz de adyacencia [Ct OEt Rt Dt Ut]
    nodeNames = {'Ct', 'OEt', 'Rt','Dt','Ut'};                       % nodos
    Ct=1; OEt=2; Rt=3; Dt=4; Ut=5;                                   % identificadores de los nodos 
    n = numel(nodeNames);                                            % n�mero de nodos 
    t=1 ; f=0;                                                       % valores true y false
    
    %Visualizar la red bayesiana gr�ficamente usando 'biograph'
    nodeLabels = {'Cotizaci�n(t)', 'OscilEstocast(t)', 'Retorno(t)', 'Decision', 'Utilidad'};
    bg = biograph(adj, nodeLabels, 'arrowsize', 5);
    set(bg.Nodes, 'shape', 'ellipse');
   % bgInViewer = view(bg);
    
    

% 2 -  OBTENER COTIZACIONES
%       En un bucle de 35 iteraciones se obtiene para cada una de ellas el
%       valor de una acci�n en el instante actual mediante WebScrapping.

    ibex35 = {'abertis_a','acciona','acerinox','acs','aena','amadeus','arcelormitt.','b.popular','b.sabadell', ...
        'bankia','bankinter','bbva','caixabank','cellnex','dia','enagas','endesa','ferrovial','gamesa', ...
        'gas_natural','grifols','iag','iberdrola','inditex','indra_a','mapfre','mediaset','melia_hotels', ...
        'merlin_prop.','r.e.c.','repsol','santander','tecnicas_reu','telefonica','viscofan'};
   
    for i = 1:35 %cambiar por 35!
        url_string =['http://www.infobolsa.es/cotizacion/',ibex35{i}];
        lectura = urlread(url_string);
        Posicion = strfind(lectura,'"subdata1"');
        buscado = lectura(Posicion:Posicion+100);
        PosicionInicial = strfind(buscado,'"price equal center">')+length('"price equal center">')-1;
        PosicionFinal = strfind(buscado,'</div>');
        buscado(PosicionInicial:PosicionFinal);
        pattern='\d+(,\d+)?';                   
        text = buscado;
        Resultados=regexp(text, pattern, 'match');
        
        %Cambiar la coma del resultado devuelto por un punto, para que
        %Matlab no lo entienda como una matriz
        str = Resultados{2};
        expression = ',';
        replace = '.';
        cotizacion = regexprep(str,expression,replace);
        
        

  % 3 -  C�LCULO DE VARIABLES
  
        Ct = str2num(cotizacion);                                 % Ct = Valor acci�n momento t
        run valorcierre;                                          % Se recoge la cotizaci�n del momento t-1
        Cotizanterior = str2num(cotAnterior);                     % Cotizanterior = Valor acci�n momento t-1
        %valorMax = str2num(valorMax); 
        %valorMin = str2num(valorMin); 
        
        Rt = Ct - Cotizanterior;                                  % Rt = Retorno             
        OEt = 100*(Cotizanterior-valorMin)/(valorMax-valorMin);   % OEt = Oscilador Estoc�stico
        
        
        
  % 4 -  PSO

        [alpha1,alpha2] = PSOOptimizador(Ct,OEt);
        
  % 5 -  DECISI�N Y UTILIDAD
  
        Dt = sign(alpha1*Ct+alpha2*OEt);                         % Variable de decisi�n {-1,1}
        Ut = Dt*Rt;                                              % Variable de utilidad
       
        %Se tratar� de invertir cuando la utilidad sea m�xima. 
     
  % 6 -  (OPCIONAL) SALIDA DE DATOS POR PANTALLA    
        fprintf('%d |EMPRESA: %s| \n  \t Ct: %d \t OEt: %d \t Rt: %d   \n\t alpha1: %d \t alpha2: %d \n\t Dt: %d \t Ut: %d  \n\n\n', ...
            i, ibex35{i},Ct,OEt,Rt,alpha1,alpha2,Dt,Ut);
    end
     

 