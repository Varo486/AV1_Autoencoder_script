# AV1_Autoencoder_script

This script allows the user to do batch encodes with AV1 + opus audio, inside the directory of the script, with a custom output directory.

![alt text](https://github.com/Varo486/AV1_Autoencoder_script/blob/main_english/.gitignore/screenshot_aom.png "Captura de aomenc en funcionamiento")

Features:

* Interactive AOMENC parameters for encoding (option for parallel encoding available but manually, by opening more than one instance, which will ask to replace files before continuing)
* Interactive SVT-AV1 parameters for encoding
* CRF Analysis with ab-av1 (it works, though I don't recommend this method as it's inefficient)

Dependencies:
* ffmpeg
* libaom-av1
* SvtAv1EncApp
* ab-av1
* beep (optional for pc-spkr output during batch encodes)
* tput (for batch progress with AOMENC when encoding files in parallel)

Pending bugs:
* Parallel encoding is not available at the moment with the current script (separate script in testing needs to be implemented to the original)
* 5.1 opus audio encoding does not work currently, it will prompt a failure during an encode
* Further testing needed to check if all audio/subtitles are being processed

Todo:
* Fix 5.1 audio encoding with opus
* Add mp4 fdk-aac output
* Add stereo downmix option
* Implement parallel encoding with a progress list
* Add progress information to the progress list
