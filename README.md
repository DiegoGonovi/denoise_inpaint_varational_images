# 📌 Procesamiento de Imágenes con Métodos Variacionales

Implementación en MATLAB de métodos variacionales para eliminación de ruido y reconstrucción de imágenes usando procesos de difusión lineales y no lineales.

## 📂 Estructura del Repositorio

```
/
├── Codigo/
|   ├─ images/                            # Imágenes utilizadas                               
|   ├─ Denoising_Linear_Diffusion.m       # Función principal de denoising con iteraciones fijas
|   ├─ Denoising_Linear_Diffusion_Stop.m  # Denoising con criterio de parada por energía    
|   ├─ gradx.m, grady.m, div.m            # Operadores de gradiente y divergencia
|   ├─ pLap_mask.m                        # Inpainting con p-Laplaciano para eliminar marcas de agua
|   ├─ pEnergy.m, PSNR.m                  # Cálculos de energía y métricas de calidad
|   ├─ main_denois.m                      # Script para aplicaciones de denoising
|   ├─ main_inpating.m                    # Script demostrativo para aplicaciones de inpainting           
├── Diego_Gonzalez_Oviaño_memoria.pdf     # Documentación del proyecto
└── README.md                             # Presentación del repositorio.            

```

## 📊 Resultados
Se adjunta en Diego_Gonzalez_Oviaño_memoria.pdf los fundamentos matemáticos, el análisis detallado de los métodos utilizados y los resultados obtenidos.
Además, se presenta un vídeo ilustrativo donde se visualiza el proceso de eliminación de marcas de agua en una fotografía modelizado mediante la ecuación de difusión del calor. 

https://github.com/user-attachments/assets/5cbaf46e-c339-4188-acb6-fe89d20b120b

## 📄 Licencia
Proyecto académico de la Universidad Rey Juan Carlos.

