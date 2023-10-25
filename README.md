# audio-to-image

Overview of project:
This repository provides an audio-to-image synthesis pipeline through a Bash script by utilizing multiple open-source libraries: FFmpeg, Whisper, and Stable Diffusion to create a Bash pipeline for audio-to-image synthesis. Users can select a time window within which they propose an image prompt, after which a 512x512 image will be output. This repository is currently compatible with MacOS but alternative technologies exist for Windows and Linux. Total memory of all provided technologies: XGB

At each stage are instructions on installing the technologies and a brief overview of their functional modularity. If you're not interested, feel free to skip to the shortcut section and read about how shortcut_install.sh can install all the technologies for you.

## FFmpeg

//where and how to install technology
The first step for a functioning audio-to-image pipeline is the recording software. This repository expects the utilization of FFmpeg, but feel free to swap this for your own software. Here's the installation guide I used: https://phoenixnap.com/kb/ffmpeg-mac. FFmpeg is free and open-source, offering multiple libraries for handling video and audio files. It's truly a Swiss Army knife for transcoding, editing, and standards compliance for a variety of multimedia files, with this pipeline we'll be using just one of the tools. Make sure to play around with some of the other FFmpeg capabilities when you get a chance!

//overview of technology and how it fits into our pipeline
As mentioned, this is the first step in building our audio-to-image pipeline. The FFmpeg command in our shell file utilizes the on-device microphone (-i ":0") to create a listening window at 16kHz (-ar 16000) for 10 seconds (-t 10) before saving the resultant .wav file to our specified directory. The listening frequency and file extension are particularly important, as this pipeline is built for Macs and the next module is dependent on these specifics for functionality.

## Whisper

//where and how to install technology
Our next component is an Apple Silicon first-class citizen version of OpenAI's automatic speech recognition model: Whisper. Whisper offers state-of-the-art audio transcription performance and with a variety of model sizes, it is customizable to fit your device's memory capabilities. Fair warning: model performance is closely tied to model size, so although smaller models may offer memory resource savings, they may also struggle with some transcription tasks, leading to a downstream deprecation in generated image quality. All instructions 

//overview of technology

//how technology fits into our pipeline

## Stable Diffusion

// intro paragraph
Install Stable Diffusion. Include link to apple/ml-stable-diffusion and HF blog resources to help with that process. Mention SDXL, current performance limitations with M1 chip, palettization, and difference in prompts for SD2.1 vs SDXL.

//overview of technology

//how technology fits into our pipeline

## Shortcut

Provide bash script to install all above technologies sequentially


#### Disclaimer

Something about responsibility while using image generation technology. Safety, ensuring consent, etc.


#### Sources
[1] https://en.wikipedia.org/wiki/FFmpeg
