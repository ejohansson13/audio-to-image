# audio-to-image

Overview of project:
This repository provides an audio-to-image synthesis pipeline through a Bash script by utilizing multiple open-source libraries: FFmpeg, Whisper, and Stable Diffusion to create a Bash pipeline for audio-to-image synthesis. Users can select a time window within which they propose an image prompt, after which a 512x512 image will be output. This repository is currently compatible with MacOS but alternative technologies exist for Windows and Linux. Total memory of all provided technologies: XGB

At each stage are instructions on installing the technologies and a brief overview of their functional modularity. If you're not interested, feel free to skip to the shortcut section and read about how shortcut_install.sh can install all the technologies for you.

## FFmpeg

First, make sure you have FFmpeg installed (here is a website to help you through the process). Maybe include brief overview on FFmpeg

## Whisper

Install Whisper. If not, here's site to help you with it. Attach repos for Windows/Linux in addition to MacOS port

## Stable Diffusion

Install Stable Diffusion. Include link to apple/ml-stable-diffusion and HF blog resources to help with that process. Mention SDXL, current performance limitations with M1 chip, palettization, and difference in prompts for SD2.1 vs SDXL.

## Shortcut

Provide bash script to install all above technologies sequentially


#### Disclaimer

Something about responsibility while using image generation technology. Safety, ensuring consent, etc.
