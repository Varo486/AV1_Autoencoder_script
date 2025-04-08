#!/bin/bash

# LISTA DE FUNCIONES
# header - Encabezado
# Batch - Lanzador del modo batch
# comprobar_ficheros_batch - Comprobación previa a encodeo batch
# Iniciar_batch - Iniciar encodeo en batch
# cancelar - Salir del script
# Retroceder - Volver al menú de selección de modos
# Iniciar_seleccion - Primera función del script
# AOMENC-AV1_batch - Proceso en batch experimental (AOMENC)
# SVT_AV1_PSY_batch - Proceso en batch experimental (SVT_AV1)

# Encabezado estático del programa (No contiene el parpadeo del modo)

header() {
clear
# Regresar puntero a posición 0 0
tput cup 0 0
printf  "=======================================\n     AV1 autoencoder v1 by Varo486 \n=======================================\n  Overcomplicating things since 1997!"
# desplazar change scroll region a línea 4
tput csr 4 $((`tput lines` - 4))
# desplazar cursor a línea 4
tput cup 4 0
}

Completado() {
#tput cup 5 8
echo "¡Proceso finalizado!"
echo ""
beep -f 932 -l 500 -D 700 -n -f 1244 -D 250 -n -f 932 -D 250 -n -f 1244 -n -f 1397 -n -f 1480
read -p " ¿Deseas hacer otra codificación? [S/n]" prompt
if [[ $prompt == "n" || $prompt == "N" || $prompt == "No" || $prompt == "no" ]]
then
# Rechazado, cerrar script
cancelar
else
# Aprobado, hacer otra codificación
Retroceder
fi

}

comprobar_ficheros_batch() {
# listar archivos que coincidan con la variable contenedor
count=`ls -1 *$contenedor 2>/dev/null | wc -l`
# Si la cuenta no es 0, lanzar función de inicio de batch.
if [ $count != 0 ]
then
Iniciar_batch
else
echo -e "\033[91mError 2, no existen ficheros con formato $contenedor en este directorio.\033[39m"
beep -f 640 -l 400 -r 3
Batch
fi
}

# Abortar
cancelar() { echo "Saliendo del script, ¡que tengas un buen día!."
  sleep 1
  beep -f 3000 -l 60 -r 4 -d 50
  clear
  exit 0
  }

# Retroceder a selección de modos
Retroceder() {
echo "Retrocediendo..."
    sleep 1
    beep -f 3000 -l 60 -r 4 -d 50
    clear
    header
    echo ""
    echo -e "\033[93mEste script está en desarrollo y puede tener bugs.\033[39m"
    echo ""
    Iniciar_seleccion
    }

# Encodeo en serie de un directorio entero

Batch() { read -p "Escribe el formato de contenedor a escanear: (mp4, mkv, avi, etc.): " contenedor
  if [[ $contenedor == "mp4" || $contenedor == "mkv" || $contenedor == "avi" ]]
  then
  read -p "Has seleccionado '$contenedor', ¿es esto correcto? [S/n]" prompt
   if [[ $prompt == "n" || $prompt == "N" || $prompt == "No" || $prompt == "no" ]]
   then
   # No, reiniciar función.
    Batch
    else
   # Sí, empezar comprobación.
    comprobar_ficheros_batch
    fi
   # Formato incorrecto especificado.
    else
    echo -e "\033[91mError 1, no se ha especificado un formato compatible.\033[39m"
    beep -f 640 -l 400
    Batch
    fi
    }

# Inicio de proceso batch, selección de modo
Iniciar_batch() { read -p "¿Quieres codificar vídeo con AOMENC-AV1 (MUY LENTO)? [s/N]" prompt
     if [[ $prompt == "s" || $prompt == "S" || $prompt == "Sí" || $prompt == "sí" ]]
     then
     AOMENC_AV1_batch
     else
     read -p "¿Quieres codificar vídeo con SVT-AV1-PSY (MÁS RÁPIDO QUE AOMENC)? [S/n]" prompt
     if [[ $prompt == "n" || $prompt == "N" || $prompt == "No" || $prompt == "no" ]]
     then
       read -p "¿Quieres entonces usar ab-av1 para calcular un CRF aproximado en ese caso? [S/n]" prompt
       if [[ $prompt == "n" || $prompt == "N" || $prompt == "No" || $prompt == "no" ]]
        then
        Retroceder
        else
      # ab-av1 - CRF Search
        clear
        header
      # Mostrar modo seleccionado en línea 4, columna 6
        tput cup 4 7
        printf "\033[1;34m\e[5mModo: ab-av1 - CRF Search\033[0m"
        tput csr 5 $((`tput lines` - 5))
        tput cup 6 0
      # LOOP PARA ESCOGER NÚMERO DEL 0 AL 13
        while true; do
                      read -p "Escoge el preset de AV1 para calcular el CRF [0-13] (Recomendado: 4) " preset
      # COMPROBAR QUE EL NÚMERO ESTÉ DENTRO DE LOS LÍMITES
                      if [[ $preset =~ ^[0-9]+$ ]] && [ "$preset" -ge 0 ] && [ "$preset" -le 13 ]; then
                      echo "Preset escogido: $preset"
                      break
                      else
                      echo -e "\033[0;33mPreset no válido. Introduce un número del 0 al 13.\033[0m"
                      beep -f 640 -l 400
                      fi
                    done
     sleep 2
    # INICIO DEL TESTEO DE CRF
     for file in *.$contenedor
      do
       echo -e "Calculando CRF en el archivo \033[0;32m"$file"\033[0m con preset \033[0;32m$preset\033[0m..."
       ab-av1 crf-search -i "$file" --preset $preset
       beep -f 800 -l 200 -n -f 640
      done
      #header
      echo ""
      Completado
       fi
     # AOMENC
       else
       SVT_AV1_PSY_batch
       fi
       fi
       }

# Menú de selección de modos

Iniciar_seleccion () { PS3="Iniciar o salir: "
select modo in "Iniciar" "Salir"
do
case $modo in
Iniciar)
beep -f 3000 -l 60 -r 4 -d 50
echo -e "\033[0;31m¡IMPORTANTE! ¡Para usar este modo, debes haber depositado el script en el directorio de los ficheros!\033[0m"
echo -e "El directorio de trabajo es '\033[0;33m$PWD\033[0m'."
echo -e "\033[0;31m¡Este script es MUY lento y podría tardar horas, días o semanas dependiendo de lo que elijas!\033[0m"
read -p "¿Estás seguro de que quieres continuar? [S/n]" prompt
if [[ $prompt == "n" || $prompt == "N" || $prompt == "No" || $prompt == "no" ]]
then
# Rechazado, volver al menú de selección
Retroceder
else
Batch
fi
;;
Salir)
cancelar
;;
esac
done
}

AOMENC_AV1_batch() {
clear
header
# Mostrar modo seleccionado en línea 4, columna 6
  tput cup 4 7
  printf "\033[1;34m\e[5mModo: AOMENC - Autoencode\033[0m"
  tput cup 5 0
  printf "======================================="
  # desplazar change scroll region a línea 6
  tput csr 6 $((`tput lines` - 6))
  # Colocar cursor en línea 6, columna 0
  tput cup 6 0
  echo "    === AOMENC-AV1 Batch Encoder ==="
  echo -e "ESCRIBE LOS PARÁMETROS A MANO, DE LO CONTRARIO NO SERÁN VÁLIDOS"
  read -p "CRF deseado (0-63)(Recomendado 19-21): " CRF
  read -p "Nivel de denoising (0-3) (Recomendado: 0): " DENOISE_LEVEL
  read -p "Nivel de grano artificial (0–50) (Recomendado: 10): " FILM_GRAIN
  read -p "Preset cpu_used (0-8 - menos es mejor calidad, pero más lento) (Recomendado 4-6): " CPUPRESET
  read -p "Bitrate de audio opus en kbps (Recomendado 128k): " AUDIO_BITRATE
  read -p "¿Cuántas columnas de Tiles quieres poner? (2-4) (2 es equilibrado, 4 usa idealmente 16 núcleos): " TILE_COLUMNS
  read -p "¿Cuántas filas de Tiles quieres poner? (2-4) (2 es equilibrado, 4 usa idealmente 16 núcleos): " TILE_ROWS

  read -p "Escoge el nombre del directorio (si no existe será creado): " DIR_OUTPUT
  echo "usando directorio "$PWD/"$DIR_OUTPUT"
  sleep 1
  mkdir -p "$DIR_OUTPUT"
  echo "Iniciando codificación de todo el directorio..."
  sleep 2
  for input in *.$contenedor; do
    [ -e "$input" ] || continue

    filename="$(basename "$input")"
    filename="${filename%.*}"

    echo "Procesando: \"$input"\"
    sleep 2

    ffmpeg -i "$input" -threads 0 -c:v libaom-av1 -cpu-used $CPUPRESET -crf $CRF -pix_fmt yuv420p10le -aom-params "tile-columns=$TILE_COLUMNS:tile-rows=$TILE_ROWS:denoise-noise-level=$FILM_GRAIN:enable-dnl-denoising=$DENOISE_LEVEL" -c:a libopus -b:a $AUDIO_BITRATE -c:s copy "$DIR_OUTPUT/$filename[AV1].$contenedor"
    beep -f 800 -l 200 -n -f 640
    sleep 2
    clear
    header
    # Mostrar modo seleccionado en línea 4, columna 6
  tput cup 4 7
  printf "\033[1;34m\e[5mModo: AOMENC - Autoencode\033[0m"
  tput cup 5 0
  printf "======================================="
  # desplazar change scroll region a línea 6
  tput csr 6 $((`tput lines` - 6))
  # Colocar cursor en línea 6, columna 0
  tput cup 6 0
  echo -e "Codificación terminada, continuando con el siguiente archivo..."
  sleep 2
    done
    Completado
    }

SVT_AV1_PSY_batch() {
clear
header
# Mostrar modo seleccionado en línea 4, columna 6
  tput cup 4 7
  printf "\033[1;34m\e[5mModo: SVT-AV1 - Autoencode\033[0m"
  tput cup 5 0
  printf "======================================="
  # desplazar change scroll region a línea 6
  tput csr 6 $((`tput lines` - 6))
  # Colocar cursor en línea 6, columna 0
  tput cup 6 0
  echo "  === SVT-AV1-PSY Batch Encoder ==="
  echo -e "ESCRIBE LOS PARÁMETROS A MANO, DE LO CONTRARIO NO SERÁN VÁLIDOS"
  read -p "CRF deseado (0-63)(Recomendado 19-21):" CRF
  read -p "Preset (0=mejor calidad, 13=más rápido) (Recomendado 4-6):" PRESET
  read -p "Bitrate de audio opus en kbps (Recomendado 128k):" AUDIO_BITRATE
  read -p "Escoge el nombre del directorio (si no existe será creado):" DIR_OUTPUT
  echo "usando directorio $PWD/"$DIR_OUTPUT""
  sleep 1
  mkdir -p "$DIR_OUTPUT"
  echo "Iniciando codificación de todo el directorio..."
  sleep 2
  for input in *.$contenedor; do
    [ -e "$input" ] || continue

    filename="$(basename "$input")"
    filename="${filename%.*}"

    echo "Procesando: \""$input"\""
    sleep 2

    ffmpeg -i "$input" -threads 0 -c:v libsvtav1 -preset $PRESET -crf $CRF -psy 1 -c:a libopus -b:a $AUDIO_BITRATE -c:s copy "$DIR_OUTPUT"/"$filename[AV1].$contenedor"
    beep -f 800 -l 200 -n -f 640
    sleep 2
    # Colocar cursor en línea 6, columna 0
    tput cup 6 0
    sleep 2
    clear
    header
    # Mostrar modo seleccionado en línea 4, columna 6
  tput cup 4 7
  printf "\033[1;34m\e[5mModo: SVT-AV1 - Autoencode\033[0m"
  tput cup 5 0
  printf "======================================="
  # desplazar change scroll region a línea 6
  tput csr 6 $((`tput lines` - 6))
  # Colocar cursor en línea 6, columna 0
  tput cup 6 0
  echo -e "Codificación terminada, continuando con el siguiente archivo..."
  sleep 2
    done
    Completado
    }
#  Inicio del script
# ===================

header
#beep -f 932 -l 500 -D 700 -n -f 1244 -D 250 -n -f 932 -D 250 -n -f 1244 -n -f 1397 -n -f 1480
echo ""
echo -e "\033[93mEste script está en desarrollo y puede tener errores.\033[39m"
echo ""
tput csr 5 $((`tput lines` - 5))
tput cup 7 0
Iniciar_seleccion
