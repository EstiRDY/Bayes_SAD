clc
clear all
close all

nP=10;
%inicializacion
nVar=2;
x=random('Uniform',-1,1,nVar,nP);
v=random('Uniform',-0.001,0.001,nVar,nP);
xOptimo=x;
cOptimos=zeros(1,nP);
c=zeros(1,nP);
cOptimoGlobal=inf;
phi1Max=0.1;
phi2Max=0.1;
inercia=0.01;
deltaT=0.1;

for k=1:nP
    cOptimos(k)= calcularCoste(x(:,k));
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
    c(k)= calcularCoste(x(:,k));
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