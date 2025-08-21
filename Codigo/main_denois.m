%% Se muestra img

clear all, close all, clc
im = imread('./images/noche1.jpeg'); 
im = im2double(im);

figure;
title('Imagen Original');
imagesc(im)
axis off

% Motivación: Las fotografías nocturnas realizadas con móviles de gama media están
% caracterizadas por un alto componente de ruido. 
%% Deterioramos la imagen

% Se busca deteriorar la imagen y a parte, ver si se puede mejorar. 

Noise_STD = 0.15;
noise=Noise_STD*randn(size(im)); % Ruido aleatorio distribucción normal
im_noisy = im + noise;

%% Datos de entrada
figure
subplot(131)
imagesc(im)
title('Original')
axis off
subplot(132)
imagesc(noise)
title('Noise')
axis off
subplot(133)
imagesc(im_noisy)
title('Noisy')
axis off

%% Selección de parámetros
close all
% Proporcionamos los parámetros para nuestro algoritmo
varin.lambda    = 0.5;      % hyperparámetro de fidelidad
varin.p         = 2;
varin.Nit       = 120;      % número de iteraciones del algoritmo
varin.dt        = 1e-2;     % tamaño del paso 
varin.f         = im_noisy;  % imagen ruidosa
varin.Verbose   = 2;        % Verbose, puede ser 0, 1, 2. 
varin.im_org    = im;       % Imagen original para el cómputo de la PSNR
% Los parámetros se agrupan en un struct por simplicidad

% Ejecutamos el algoritmo
[varout] = Denoising_Linear_Diffusion(varin);

% Mostramos el resultado
u = varout.u;

figure,
subplot(131), imshow(im),       title('Original')
subplot(132), imshow(varin.f),  title('Ruidosa')
subplot(133), imshow(u),        title('Restaurada')

% Se mejora la imagen con el ruido creado, ahora se quiere mejorar la
% imagen original sin tener en consideración una imagen ruidosa que se
% quiere restaurar respecto a la original, sino que se busca mejorar la
% propia calidad de la original. 

%% Denoising de original, p = 2, L > 0

% Selección de parámetros
close all

% Proporcionamos los parámetros para nuestro algoritmo
varin.lambda    = 0.1;      % hyperparámetro de fidelidad
varin.p         = 2;
varin.Nit       = 300;      % número de iteraciones del algoritmo
varin.dt        = 1e-2;     % tamaño del paso 
varin.f         = im;  % Imagen original
varin.Verbose   = 2;        % Verbose, puede ser 0, 1, 2. 

% Ejecutamos el algoritmo
[varout] = Denoising_Linear_Diffusion_Stop(varin);

% Mostramos el resultado
u = varout.u;

figure,
subplot(121), imshow(im),       title('Original')
subplot(122), imshow(u),        title('Restaurada')

%% Guardamos los resultados

% Normalizar rango [0, 1]
restored_image = (u - min(u(:))) / (max(u(:)) - min(u(:)));

% Guardar la imagen como archivo PNG
output_filename = './images/noche_denoise.png';
imwrite(restored_image, output_filename);

disp(['Imagen restaurada guardada como: ', output_filename]);

%% Se comparan los resultados
close all

% Cargar la imagen
im = imread('./images/noche1.jpeg'); 
im_new = imread('./images/noche_denoise.png');
im = im2double(im);    
im_new = im2double(im_new);

% Definir la región a recortar
x_start = 1010;   % Columna de inicio
y_start = 500;  % Fila de inicio
width = 500;    % Ancho del recorte
height = 500;   % Alto del recorte

cropped_image = im(y_start:y_start+height-1, x_start:x_start+width-1, :);
cropped_new = im_new(y_start:y_start+height-1, x_start:x_start+width-1, :);

figure,
subplot(121), imshow(cropped_image),       title('Original')
subplot(122), imshow(cropped_new),        title('Restaurada')


%% Denoising de original, p = 1, L > 0

% Selección de parámetros
close all

% Proporcionamos los parámetros para nuestro algoritmo
varin.lambda    = 0.3;      % hyperparámetro de fidelidad
varin.p         = 1;
varin.Nit       = 1000;      % número de iteraciones del algoritmo
varin.dt        = 1e-2;     % tamaño del paso 
varin.f         = im;  % Imagen original
varin.Verbose   = 2;        % Verbose, puede ser 0, 1, 2. 

% Ejecutamos el algoritmo
[varout] = Denoising_Linear_Diffusion_Stop(varin);

% Mostramos el resultado
u = varout.u;
%%

figure,
subplot(121), imshow(im),       title('Original')
subplot(122), imshow(u),        title('Restaurada')

% Si aumento lamnda suavizo menos, el algoritmo intenta ajustar más 
% la solución a los datos originales

%% Guardamos los resultados

% Normalizar rango [0, 1]
restored_image = (u - min(u(:))) / (max(u(:)) - min(u(:)));

% Guardar la imagen como archivo PNG
output_filename = './images/noche_denoise_p1.png';
imwrite(restored_image, output_filename);

disp(['Imagen restaurada guardada como: ', output_filename]);

%% Se comparan los resultados
close all

% Cargar la imagen
im = imread('./images/noche1.jpeg'); 
im_new = imread('./images/noche_denoise_p1.png');
im = im2double(im);    
im_new = im2double(im_new);

% Definir la región a recortar
x_start = 1010;   % Columna de inicio
y_start = 500;  % Fila de inicio
width = 500;    % Ancho del recorte
height = 500;   % Alto del recorte

cropped_image = im(y_start:y_start+height-1, x_start:x_start+width-1, :);
cropped_p1 = im_new(y_start:y_start+height-1, x_start:x_start+width-1, :);

figure,
subplot(121), imshow(cropped_image),       title('Original')
subplot(122), imshow(cropped_p1),        title('Restaurada')

%%

figure,
subplot(121), imshow(cropped_new),       title('P2')
subplot(122), imshow(cropped_p1),        title('P1')

%%

clear all, close all, clc
im = imread('./images/noche1.jpeg'); 
im = im2double(im);

figure;
title('Imagen Original');
imagesc(im)
axis off

% Motivación: Las fotografías nocturnas realizadas con móviles de gama media están
% caracterizadas por un alto componente de ruido.

%% Filtrado de original, p = 2, L = 0

% Selección de parámetros
close all

% Proporcionamos los parámetros para nuestro algoritmo
varin.lambda    = 0;      % hyperparámetro de fidelidad
varin.p         = 2;
varin.Nit       = 400;      % número de iteraciones del algoritmo
varin.dt        = 1e-2;     % tamaño del paso 
varin.f         = im;  % Imagen original
varin.Verbose   = 0;        % Verbose, puede ser 0, 1, 2. 

% Ejecutamos el algoritmo
[varout] = Denoising_Linear_Diffusion_Stop(varin);

% Mostramos el resultado
u = varout.u;

%%

figure,
subplot(121), imshow(im),       title('Original')
subplot(122), imshow(u),        title('Filtrada')

% Si aumento lamnda suavizo menos, el algoritmo intenta ajustar más 
% la solución a los datos originales

%%

clear all, close all, clc
im = imread('./images/noche1.jpeg'); 
im = im2double(im);

figure;
title('Imagen Original');
imagesc(im)
axis off

% Motivación: Las fotografías nocturnas realizadas con móviles de gama media están
% caracterizadas por un alto componente de ruido.

%% Filtrado de original, p = 1 L = 0

% Selección de parámetros
close all

% Proporcionamos los parámetros para nuestro algoritmo
varin.lambda    = 0;      % hyperparámetro de fidelidad
varin.p         = 1;
varin.Nit       = 400;      % número de iteraciones del algoritmo
varin.dt        = 1e-2;     % tamaño del paso 
varin.f         = im;  % Imagen original
varin.Verbose   = 0;        % Verbose, puede ser 0, 1, 2. 

% Ejecutamos el algoritmo
[varout] = Denoising_Linear_Diffusion_Stop(varin);

% Mostramos el resultado
u = varout.u;

%%

figure,
subplot(121), imshow(im),       title('Original')
subplot(122), imshow(u),        title('Filtrada P = 1')

% Si aumento lamnda suavizo menos, el algoritmo intenta ajustar más 
% la solución a los datos originales
