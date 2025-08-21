%%
% Motivación: cansado de las marcas de agua
clear all, close all, clc
im = imread('./images/marca_agua_2.jpg'); 
im = im2double(im);

figure;
title('Imagen Original');
imagesc(im)
axis off

%% Selección de región a reconstruir
% Umbralizar
% Crear la máscara para píxeles blancos (RGB)
mask_white = (im(:,:,1) >= 0.73) & (im(:,:,2) >= 0.73) & ...
(im(:,:,3) >= 0.73);

% Crear un elemento estructurante
se = strel('disk', 2); % Elemento estructurante circular de radio 5
mask_dila = imdilate(mask_white, se);

mask_in_black = 1.-mask_dila;

mask = im.*mask_in_black;

% Mostrar la máscara
figure;
subplot(1, 2, 1), imshow(im), title('Imagen Original');
subplot(1, 2, 2), imshow(mask), title('Máscara de Píxeles Negros');


%% Selección de parámetros p = 2
close all
% Configurar parámetros
varin.p         = 2;               % Orden del Laplaciano
varin.f         = im;              % Imagen deteriorada
varin.lambda    = 160*mask; % Peso de fidelidad basado en la máscara
varin.Nit       = 2500;            % Número de iteraciones
varin.dt        = 0.015;            % Tamaño del paso temporal
varin.Verbose   = 0;               % Mostrar progreso
varin.im_org    = im;              % Imagen original (opcional)

% Ejecutar el algoritmo de inpainting
[varout] = pLap_mask(varin);

% Obtener la imagen restaurada
u_restored = varout.u;

%%
% Mostrar resultados
figure;
subplot(1, 2, 1), imshow(im), title('Imagen Original');
subplot(1, 2, 2), imshow(u_restored), title('Imagen Restaurada');

%% Selección de parámetros p = 1
close all
% Configurar parámetros
varin.p         = 1;               % Orden del Laplaciano
varin.f         = im;              % Imagen deteriorada
varin.lambda    = 80*mask; % Peso de fidelidad basado en la máscara
varin.Nit       = 600;            % Número de iteraciones
varin.dt        = 0.005;            % Tamaño del paso temporal
varin.Verbose   = 0;               % Mostrar progreso
varin.im_org    = im;              % Imagen original (opcional)

% Ejecutar el algoritmo de inpainting
[varout] = pLap_mask(varin);

% Obtener la imagen restaurada
u_restored = varout.u;

%%

% Mostrar resultados
figure;
subplot(1, 2, 1), imshow(im), title('Imagen Original');
subplot(1, 2, 2), imshow(u_restored), title('Imagen Restaurada');