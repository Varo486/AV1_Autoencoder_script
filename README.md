# AV1_Autoencoder_script

This script allows the user to do batch encodes with AV1 + opus audio, inside the directory of the script, with a custom output directory.

![alt text](https://github.com/Varo486/AV1_Autoencoder_script/blob/main_english/.gitignore/screenshot_aom.png "Captura de aomenc en funcionamiento")

Features:

* Interactive AOMENC parameters for encoding
* Interactive SVT-AV1 parameters for encoding
* CRF Analysis with ab-av1 (it works, though I don't recommend this method as it's inefficient)

Dependencies:
* ffmpeg
* libaom-av1
* SvtAv1EncApp
* ab-av1
* beep (optional for pc-spkr output during batch encodes)

Recommendations for AOMENC:
You can run multiple instances of the script at the same time, they won't overwrite files by default.
