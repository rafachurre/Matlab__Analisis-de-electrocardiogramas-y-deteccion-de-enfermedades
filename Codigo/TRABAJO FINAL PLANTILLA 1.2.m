% Laboratorio de tratamiento digital de señales
% Trabajo final - Análisis de electrocardiogramas

% Puesto de trabajo   XTA-D5
% Alumnos:
%   Rafael López Martínez
%   Miguel Lumeras Gutiérrez

%% Analisis maximos y minimos de la señal

%load x;
%muestras=input('indique las muestras por segundo del electrocardiograma: ');
muestras = 100; % muestras por segundo del ecg, si es distinto, cambiar el comentado
x=(1/muestras):(1/muestras):(length(ecg)/muestras);
plot(x,ecg);
title('ECG')
xlabel('t(s)')
ylabel('V(mV)')
pause
% Buscamos los maximos y minimos de la señal ecg
[picos_max, posiciones_max] = findpeaks(ecg,'minpeakheight',0.1); %buscamos los maximos de la señal
[picos_min, posiciones_min] = findpeaks(-ecg,'minpeakheight',0.1); %buscamos los minimos de la señal
picos_min = -(picos_min);
posiciones = [posiciones_max posiciones_min]; %posiciones de maximos y minimos en un solo vector
posiciones = sort(posiciones);
picos = 1: length(posiciones);
y=1;z=1; %indices para ordenar las amplitudes de maximos y minimos
for n = 1:length(posiciones)
    if(posiciones(n) == posiciones_max(y))
        picos(n) = picos_max(y); 
        if(y<length(posiciones_max))
            y = y+1;
        else y = y;
        end
    else picos(n) = picos_min(z); z = z+1;
    end
end
clear z y posiciones_min posiciones_max picos_min picos_max n
posiciones = posiciones./muestras; 
%Dibujamos el ECG y  los picos que hemos detectado
hold on %superpone las graficas
plot(x, ecg, 'b');
stem(posiciones, picos,'g');
title('ECG con los picos detectados')
xlabel('t(s)')
ylabel('V(mV)')
hold off %ya no superpone mas las graficas
pause
%Limpiar onda por encima de 0
r1=1;
for r0=1:length(picos)
    if(picos(r0)>0)
        if((r1==1)|((posiciones(r0)-posiciones(r1))>(8/muestras)))
            r1=r0;
        else if(picos(r0)<picos(r1))
                picos(r0)=0; else picos(r1)=0; r1=r0;
            end         
        end
    end
end
%Limpiar onda por debajo de 0
r1=1;
for r0=1:length(picos)
    if(picos(r0)<0)
        if((r1==1)|((posiciones(r0)-posiciones(r1))>(8/muestras)))
            r1=r0;
        else if(picos(r0)<picos(r1))
                picos(r1)=0; r1=r0; else picos(r0)=0;
            end         
        end
    end
end
clear r0 r1
%Eliminar los 0 de las matrices posiciones y picos
w=0;
for r=1:length(picos) %Cuenta los ceros de la matriz picos, que hay que eliminar
    if(picos(r)~=0)
        w=w+1;
    end
end
picos2=1:w; posiciones2=1:w;
z=1;
for r=1:length(picos)
    if(picos(r)~=0)
        picos2(z)=picos(r); posiciones2(z)=posiciones(r);
        z=z+1;
    end
end

posiciones = posiciones2; picos = picos2;
clear r z w picos2 posiciones2

%Dibujamos el ECG y  los picos que hemos detectado
hold on %superpone las graficas
plot(x, ecg, 'b');
stem(posiciones, picos,'r');
title('ECG con los picos de ruido eliminados')
xlabel('t(s)')
ylabel('V(mV)')
hold off %ya no superpone mas las graficas
pause
%calcular bit rate
y=1; %indices para buscar las ondas R
    for i=1:length(picos)
        if (picos(i) > 1.2) %si la onda R es menor que 1,2 hay un problema (no se detecta latido)
            p(y)=posiciones(i);
            y=y+1;
        end
    end
%p() tiene las posiciones de las ondas R
bit_rate = 60/(p(2)-p(1));
bit_rate = round(bit_rate);

clear y

[estadoOndas_amplitud, distancias, numeroDeOndas]=estudiaOndas(p, picos, posiciones);

%decidimos las enfermedades segun estadoOndas_amplitud y distancias

enfermedad = 0;
for i=1:length(numeroDeOndas)
    if numeroDeOndas(i)<4
        enfermedad = 1;
    end
end
if enfermedad ==1
    disp('Las ondas S y T se han mezclado por una T negativa: posible infarto de miocardio')
else %si tenemos las cuatro ondas en cada latido
    
    %comprobamos infarto de miocardio
    if estadoOndas_amplitud(3) == 1
        enfermedad = 1;
        disp('Onda T negativa: posible infarto de miocardio')
    end
    %comprobamos hiperpotasemia
    if estadoOndas_amplitud(3) == 2
        enfermedad = 1;
        disp('Onda T demasiado grande: posible hiperpotasemia')
    end
    if distancias(1) > 20/muestras
        enfermedad = 1;
        disp('Segmento PR demasiado largo: posible hiperpotasemia')
    end
    %comprobamos hipocalcemia
    if distancias(3) > 20/muestras
        enfermedad = 1;
        disp('Segmento ST demasiado largo: posible hipocalcemia')
    end
end

fprintf('La pulsación es de %2.0f pulsaciones/min\n',bit_rate)
if bit_rate < 60
    disp('Pulso demasiado bajo')
elseif bit_rate > 99
    disp('Pulso demasiado alto')
else 
    disp('pulso normal')
end

if enfermedad == 0
    disp('ECG normal')
end

clear bit_rate numeroDeOndas distancias enfermedad estadoOndas_amplitud i p x muestras picos posiciones
