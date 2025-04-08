# AV1_Autoencoder_script

Este script permite hacer una codificación en AV1 con audio opus de un directorio completo, con salida en otro directorio.

![alt text](https://github.com/Varo486/AV1_Autoencoder_script/blob/main/.gitignore/screenshot_aom.png "Captura de aomenc en funcionamiento")

Características:

Autoencode con AOMENC interactivo
Autoencode con SVT-AV1 interactivo
Análisis de CRF con ab-av1 para buscar unos ajustes de calidad y compresión con AV1 (en desarrollo, incompleto)

Dependencias:
* ffmpeg
* libaom-av1
* SvtAv1EncApp
* ab-av1
* beep (opcional, para sonidos del script a través del speaker del PC)
