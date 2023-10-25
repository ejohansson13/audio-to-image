# audio-to-image

Overview of project:
This repository provides an audio-to-image synthesis pipeline through a Bash script by utilizing multiple open-source libraries: FFmpeg, Whisper, and Stable Diffusion to create a Bash pipeline for audio-to-image synthesis. Users can select a time window within which they propose an image prompt, after which a 512x512 image will be output. This repository is currently compatible with MacOS but alternative technologies exist for Windows and Linux. Total memory of all provided technologies: XGB

At each stage are instructions on installing the technologies and a brief overview of their functional modularity. If you're not interested, feel free to skip to the shortcut section and read about how shortcut_install.sh can install all the technologies for you.

## FFmpeg

Where and how to install technology:

The first step for a functioning audio-to-image pipeline is the recording software. This repository expects the utilization of FFmpeg, but feel free to swap this for your own software. Here's the installation guide I used: https://phoenixnap.com/kb/ffmpeg-mac. FFmpeg is free and open-source, offering multiple libraries for handling video and audio files. It's truly a Swiss Army knife for transcoding, editing, and standards compliance for a variety of multimedia files, with this pipeline we'll be using just one of the tools. Make sure to play around with some of the other FFmpeg capabilities when you get a chance!

Overview of technology and how it fits into our pipeline:

As mentioned, this is the first step in building our audio-to-image pipeline. The FFmpeg command in our shell file utilizes the on-device microphone (-i ":0") to create a listening window at 16kHz (-ar 16000) for 10 seconds (-t 10) before saving the resultant .wav file to our specified directory. The listening frequency and file extension are particularly important, as this pipeline is built for Macs and the next module is dependent on these specifics for functionality.

## Whisper

Where and how to install technology:

Our next component is an Apple Silicon first-class citizen version of OpenAI's automatic speech recognition model: Whisper. Whisper offers state-of-the-art audio transcription performance and with a variety of model sizes, it is customizable to fit your device's memory capabilities. Fair warning: model performance is closely tied to model size, so although smaller models may offer memory resource savings, they may also struggle with some transcription tasks, leading to a downstream deprecation in generated image quality. All instructions on downloading the Whisper model and further details on its capabilities can be found here: https://github.com/ggerganov/whisper.cpp.

Overview of technology:

OpenAI's Whisper model comes in a variety of sizes with varying layer, head, width, and parameter sizes (e.g. Medium: 6-layers, 1024-wide, 16-heads, consisting of 769M parameters in total). The models break audio into 25ms windows with a stride of 10ms. All audio within a window is converted into an 80-channel log-magnitude Mel spectrogram. The total input is scaled between -1 and 1 with approximately zero mean before being fed to two convolution layers with filter widths of 3 and the GELU activation function (https://pytorch.org/docs/stable/generated/torch.nn.functional.gelu.html). Additionally, the second convolution layer has a stride of two. Exiting the convolution layers, the result is appended by sinusoidal positional embeddings before being fed to the encoder blocks. Here, the model utilizes the encoder-decoder architecture and cross-attention mechanism populated by Transformer architectures. The encoder blocks use pre-activation residual blocks, with a final layer normalization applied to the encoder output. The encoder and decoder have the same width and number of blocks, with the decoder using learned position embeddings and tied input-output token representations. A byte-level BPE text tokenizer is employed.

How technology fits into our pipeline:

Whisper is used for audio transcription from the .wav file produced in our audio recording stage and outputs a .txt file which is then employed as our text-to-image synthesis prompt. This may feel like using a sledgehammer to open a pickle jar, but Whisper's robustness, accuracy, and out-of-the-box readiness make it an easy plug-and-play tool for our audio-to-image pipeline. Feel free to try other ASR models that better fit your needs! Whisper's high attention-to-detail means that absences of audio before the end of the 10-second audio recording window will often be annotated by [BLANK AUDIO] or (background music). To prevent this from polluting our image synthesis prompt, we run remove_parentheses.py between our Whisper and Stable Diffusion stages.

## Stable Diffusion

Where and how to install technology:

Lastly, we arrive at the engine of our pipeline: Stable Diffusion. Responsible for the actual generation of our image from random noise, Stable Diffusion has been heavily popularized by allowing users to create their wildest image ideas with a descriptive text prompt. Multiple Stable Diffusion model versions exist, but this pipeline was developed with Stable Diffusion 2.1 in mind. Instructions on downloading an Apple Silicon-friendly version of Stable Diffusion can be found here: https://github.com/apple/ml-stable-diffusion. Blog posts on the performance and development of Apple Silicon-friendly Stable Diffusion models have been authored by multiple HuggingFace contributors, but Pedro Cuenca (@pcuenq)'s posts on the topics have been especially useful. After downloading the Core ML framework from Apple's repository, downloading a specific model is required. https://huggingface.co/blog/diffusers-coreml can advise you on downloading your chosen inference model, or feel free to check out download_model.py if you're comfortable running image synthesis with SD2.1. If you're concerned with the memory cost of some of these models, check out the #quantization-and-palettization section.

Overview of technology:

How technology fits into our pipeline:

### Quantization and Palettization

### Shortcut

Provide bash script to install all above technologies sequentially


#### Disclaimer

Something about responsibility while using image generation technology. Safety, ensuring consent, etc.


#### Sources
[1] https://en.wikipedia.org/wiki/FFmpeg
