function [alpha1,alpha2,vectorDt] = PSOOptimizador(Ct,OEt,OEempresa,vectorResultadosFormateados)

nP=50;
%inicializacion
nVar=2;
x=random('Uniform',-0.5,1.5,nVar,nP);  %-1,1 original
v=random('Uniform',-0.001,0.001,nVar,nP);    %velocidad
xOptimo=x;                                  
cOptimos=zeros(1,nP);                        %vector de costes �ptimos
c=zeros(1,nP);                               %vector de costes
cOptimoGlobal=inf;
phi1Max=0.1;
phi2Max=0.1;
inercia=0.01;
deltaT=0.1;

for k=1:nP                                      % k = la en�sima part�cula
    [cOptimos(k),vectorDt]= calcularCoste(x(:,k),Ct,OEt,OEempresa,vectorResultadosFormateados);
    if cOptimos(k)<cOptimoGlobal
        cOptimoGlobal=cOptimos(k);
        pOptima=x(:,k);
    end
end

nIter=5;
plot(x(1,:),x(2,:),'xr');
hold on
grid on
for i=1:nIter
    for k=1:nP
    [c(k), vectorDt] = calcularCoste(x(:,k),Ct,OEt,OEempresa,vectorResultadosFormateados);
        if c(k)<cOptimos(k)
            cOptimos(k)=c(k);
            xOptimo(:,k)=x(:,k);
            if c(k)<cOptimoGlobal
                cOptimoGlobal(k)=c(k);
                pOptima=x(:,k);                
            end
        end
    end
    for k=1:nP
        phi1=phi1Max*random('Uniform',0,1,1,1);
        phi2=phi2Max*random('Uniform',0,1,1,1);
        v(:,k)=inercia*v(:,k)+phi1*(xOptimo(:,k))-x(:,k)+phi2*(pOptima-x(:,k));
        x(:,k)=x(:,k)+deltaT*v(:,k);
    end
    plot(x(1,:),x(2,:),'xr');
end
plot(x(1,:),x(2,:),'og');


%el valor que queremos devolver es pOptima
pOptima;
alpha1= pOptima(1);
alpha2= pOptima(2); 
vectorDt;
nP;

clearvars nP x v xOptimo cOptimos c cOptimoGlobal phi1Max phi2Max inercia deltaT 
end