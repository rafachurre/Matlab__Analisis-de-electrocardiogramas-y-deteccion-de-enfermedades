function [estadoOndas_amplitud, distancias, numeroDeOndas]=estudiaOndas(p, picos, posiciones)                       
estadoOndas_amplitud = zeros(1,4);  %primera posicion: onda R (0=OK ; 1= SIGNO CONTRARIO; 2=ONDA DEMASIADO GRANDE)
                                    %segunda posicion: onda S (0=OK ; 1= SIGNO CONTRARIO; 2=ONDA DEMASIADO GRANDE)
                                    %tercera posicion: onda T (0=OK ; 1= SIGNO CONTRARIO; 2=ONDA DEMASIADO GRANDE)
                                    %cuarta posicion: onda P (0=OK ; 1= SIGNO CONTRARIO; 2=ONDA DEMASIADO GRANDE)
                                    
distancias = zeros(1,3);    %primera posicion: distanciaPR 
                            %segunda posicion: distanciaRS 
                            %tercera posicion: distanciaST 
                             
                            
%contamos el numero de ondas entre cada latido
i1=1;
for i=1:length(p)-1
    while p(i)~= posiciones(i1)
        i1= i1+1;
    end
    i=i+1;
    i2=i1+1;
    if i2<=length(posiciones) %para que no se desborde
        while p(i)~= posiciones(i2)
            i2= i2+1;
        end
    end
    numeroDeOndas(i-1)=i2-i1;
end
                
i=1; %usamos este indice avanzar de pico a pico
while p(1)~= posiciones(i)
        i= i+1; %lo situamos inicialmente en la primera onda R
end
while i<=length(posiciones)  
    %Estudio onda R
    if i<=length(posiciones) %comprobamos que no queramos acceder a un dato inexistente
        if picos(i)<0
            estadoOndas_amplitud(1) = 1; %si es negativa esta mal
        elseif picos(i)>1.7 %umbral amplitud onda R
            estadoOndas_amplitud(1) = 2;
        else
            estadoOndas_amplitud(1) = 0; %si es positiva esta OK
        end        
        distancias(1) = posiciones(i)-posiciones(i-1);
    end
    

    i=i+1; %siguiente pico sera la onda S
    %Estudio onda S
    if i<=length(posiciones)%comprobamos que no queramos acceder a un dato inexistente
        if picos(i)>0
            estadoOndas_amplitud(2) = 1; %si es positiva esta mal
        elseif picos(i)<-0.3 %umbral amplitud onda S
            estadoOndas_amplitud(2) = 2;
        else
            estadoOndas_amplitud(2) = 0; %si es negativa esta OK
        end
        distancias(2) = posiciones(i)-posiciones(i-1);
    end


    i=i+1; %siguiente pico sera la onda T
    %Estudio onda T
    if i<=length(posiciones)%comprobamos que no queramos acceder a un dato inexistente
        if picos(i)<0
            estadoOndas_amplitud(3) = 1; %si es negativa esta mal
        elseif picos(i)>0.45 %umbral amplitud onda T
            estadoOndas_amplitud(3) = 2;
        else
            estadoOndas_amplitud(3) = 0; %si es negativa esta OK
        end
        distancias(3) = posiciones(i)-posiciones(i-1);
    end


    i=i+1; %siguiente pico sera la onda P
    %Estudio onda P
    if i<=length(posiciones)%comprobamos que no queramos acceder a un dato inexistente
        if picos(i)<0
            estadoOndas_amplitud(4) = 1; %si es negativa esta mal
        elseif picos(i)>0.35 %umbral amplitud onda P
            estadoOndas_amplitud(4) = 2;
        else
            estadoOndas_amplitud(4) = 0; %si es negativa esta OK
        end
    end
    i=i+1; %siguiente pico sera la siguiente onda R, y empezaremos un nuevo ciclo
end
return

