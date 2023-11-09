# audio-to-image

Overview of project:
This repository provides an audio-to-image synthesis pipeline through a Bash script by utilizing multiple open-source libraries: FFmpeg, Whisper, and Stable Diffusion to create a Bash pipeline for audio-to-image synthesis. Users can select a time window within which they propose an image prompt, after which a 512x512 image will be output. This repository is currently compatible with MacOS but alternative technologies exist for Windows and Linux. The modular build allows for plu-and-play functionality with OS-specific technologies. Total memory of all provided technologies: XGB

At each stage are instructions on installing the technologies and a brief overview of their functional modularity. If you're not interested, feel free to skip to the shortcut section and read about how shortcut_install.sh can install all the technologies for you.

## FFmpeg

The first step for a functioning audio-to-image pipeline is the recording software. This repository expects the utilization of FFmpeg, but feel free to swap this for your own software. [Here's the installation guide I used](https://phoenixnap.com/kb/ffmpeg-mac). FFmpeg is free and open-source, offering multiple libraries for handling video and audio files. It's truly a Swiss Army knife for transcoding, editing, and standards compliance for a variety of multimedia files, with this pipeline we'll be using just one of the tools. Make sure to play around with some of the other FFmpeg capabilities when you get a chance!

As mentioned, this is the first step in building our audio-to-image pipeline. The FFmpeg command in our shell file utilizes the on-device microphone (-i ":0") to create a listening window at 16kHz (-ar 16000) for 10 seconds (-t 10) before saving the resultant .wav file to our specified directory. The listening frequency and file extension are particularly important, as this pipeline is built for Macs and the next module is dependent on these specifics for functionality.

## Whisper

Our next component is an Apple Silicon first-class citizen version of OpenAI's automatic speech recognition model: Whisper. Whisper offers state-of-the-art audio transcription performance and with a variety of model sizes, it is customizable to fit your device's memory capabilities. Fair warning: model performance is tied to model size, so although smaller models offer memory resource savings, they may also struggle with some transcription tasks, potentially leading to a downstream deprecation in generated image quality. All instructions on downloading the Whisper model and further details on its capabilities can be found [here](https://github.com/ggerganov/whisper.cpp).

OpenAI's Whisper model comes in a variety of sizes with varying layer, head, width, and parameter sizes (e.g. Medium: 6-layers, 1024-wide, 16-heads, consisting of 769M parameters in total). The models break audio into 25ms windows with a stride of 10ms. All audio within a window is converted into an 80-channel log-magnitude Mel spectrogram which is scaled between -1 and 1 with approximately zero mean before being fed through two convolution layers before arriving at the transformer encoder blocks. Here the cross-attention mechanism popularized via the Transformer architecture is utilized along with the learned positional .
For a deeper dive into the Whisper model, check out the Whisper.md file in the models_explained folder **link here**.

**with filter widths of 3 and the GELU activation function. Additionally, the second convolution layer has a stride of two. Exiting the convolution layers, the result is appended by sinusoidal positional embeddings before being fed to the encoder blocks. Here, the model utilizes the encoder-decoder architecture and cross-attention mechanism populated by Transformer architectures. The encoder blocks use pre-activation residual blocks, with a final layer normalization applied to the encoder output. The encoder and decoder have the same width and number of blocks, with the decoder using learned position embeddings and tied input-output token representations. A byte-level BPE text tokenizer is employed.**

Whisper is used for audio transcription from the .wav file produced in our audio recording stage and outputs a .txt file which is then employed as our text-to-image synthesis prompt. This may feel like using a sledgehammer to open a pickle jar, but Whisper's robustness, accuracy, and out-of-the-box readiness make it an easy plug-and-play tool for our audio-to-image pipeline. Feel free to try other ASR models that better fit your needs! Whisper's high attention-to-detail means that absences of audio before the end of the 10-second audio recording window will often be annotated by [BLANK AUDIO] or (background music). To prevent this from polluting our image synthesis prompt, we run remove_parentheses.py between our Whisper and Stable Diffusion stages.

## Stable Diffusion

Lastly, we arrive at the engine of our pipeline: Stable Diffusion. Responsible for the actual generation of our image from random noise, Stable Diffusion has been heavily popularized by allowing users to generate customized images with descriptive text prompts. Multiple Stable Diffusion model versions exist and this pipeline was developed with Stable Diffusion 2.1, but feel free to select whichever model version you prefer! Instructions on downloading an Apple Silicon-friendly version of Stable Diffusion can be found here: https://github.com/apple/ml-stable-diffusion. Blog posts on the performance and development of Apple Silicon-friendly Stable Diffusion models have been authored by multiple HuggingFace contributors, but Pedro Cuenca (@pcuenq)'s posts on the topics have been especially useful. After downloading the Core ML framework from Apple's repository, downloading a specific model is required. [This is a useful resource](https://huggingface.co/blog/diffusers-coreml) for downloading your chosen inference model, or feel free to check out download_model.py if you're comfortable running image synthesis with SD2.1. If you're concerned with the memory cost of some of these models, check out the [Quantization and Palettization](#quantization-and-palettization) section.

Stable Diffusion is pre-trained on a wide variety of image-caption pairs captured from the Internet. Those developed by Stability AI employ a Latent Diffusion Model with pre-trained text encoders employing the CLIP procedure to understand visual concepts. Latent diffusion models learn through deconstruction of their training images how to construct new image concepts from white noise. They . CLIP architecture differs from other image models by jointly training a text encoder and image encoder to learn the correct pairings for image-text training examples. It can then be further enhanced by training on datasets by embedding the names or descriptions of the target dataset classes. To learn more about Stable Diffusion, the U-Net architecture, or CLIP, feel free to check out their respective .md files in the models_explained directory.

We can't have an image generation pipeline without an image generator! Leveraging the CoreML framework for Stable Diffusion allows for rapid image synthesis with minimized latency. Total runtime for this pipeline on a 2021 14" Macbook Pro with the M1 Pro chip is under 50 seconds with the default number of inference steps (50). Later generations of Apple Silicon should offer faster performance. Unlike Stable Diffusion XL, SD2.1 and earlier versions' image qualities are tightly correlated with the descriptiveness of the prompt. Keep that in mind when speaking your chosen prompt. If using SDXL, be aware of the longer runtime especially with first generation Apple Silicon. I have plans to add a rudimentary classifier to augment prompts with descriptive language. For now, check out this link: **link here** for potential descriptors you can use depending on your prompt category. Hope you enjoy this repository and whatever your reason for wanting a hands-free image synthesizer, I hope this helps. Have fun!!!

#### Quantization and Palettization

Keeping an eye on the growing memory needs of machine learning applications, Apple designed [new tools for model compression](https://developer.apple.com/videos/play/wwdc2023/10047/) and optimized on-device throughput. The video covers it in fantastic detail, but I'll give a short overview. At every layer of these *giant* neural networks, each parameter holds a very specific weight. These weights are so specific, they are either stored in half-precision floating-point memory or fp16. Each fp16 weight is 16 bits or 2 bytes. Stable Diffusion has about 860 million parameters. Ballpark: 860m parameters at 2 bytes/parameter, we have a 1.6GB model, a fairly significant chunk of memory and the majority of the memory requirements of this repository. To compensate for these increasing memory costs, Apple introduced two new techniques. Quantization uses a multiplier and optional bias to shrink the number of bits required in storing numbers. 250 with a scale of 5.20 becomes **include some kind of image**

# Shortcut

Provide bash script to install all above technologies sequentially


#### Disclaimer

Please keep in mind general ethical and safety guidelines when utilizing any image generation technology. If you have any questions, OpenAI's [usage policies](https://openai.com/policies/usage-policies) are a good place to start. 


#### Sources
[1] https://en.wikipedia.org/wiki/FFmpeg
