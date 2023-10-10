i=$(cat /Users/erik/Documents/ImageGenProject/coreml_stable_diffusion_main/version_num.txt)
seed=$(cat /Users/erik/Documents/ImageGenProject/coreml_stable_diffusion_main/seed_num.txt)

#ffmpeg -f avfoundation -i ":0" -t 10 /Users/erik/Documents/ImageGenProject/Recordings/test${i}.mkv
#ffmpeg -i /Users/erik/Documents/ImageGenProject/Recordings/test${i}.mkv -ar 16000 -ac 1 -c:a pcm_s16le /Users/erik/Documents/ImageGenProject/Recordings/test${i}.wav

ffmpeg -f avfoundation -i ":0" -ar 16000 -t 10 /Users/erik/Documents/ImageGenProject/Recordings/test${i}.wav

/Users/erik/Documents/ImageGenProject/whisper.cpp-master/main -m /Users/erik/Documents/ImageGenProject/whisper.cpp-master/models/ggml-medium.bin -nt -otxt -of /Users/erik/Documents/ImageGenProject/Text/test${i} -f /Users/erik/Documents/ImageGenProject/Recordings/test${i}.wav

#/Users/erik/Documents/ImageGenProject/whisper.cpp-master/main --language spanish -m /Users/erik/Documents/ImageGenProject/whisper.cpp-master/models/ggml-large.bin -tr -nt -otxt -of /Users/erik/Documents/ImageGenProject/Text/test${i} -f /Users/erik/Documents/ImageGenProject/Recordings/test${i}.wav

python3 /Users/erik/Documents/ImageGenProject/coreml_stable_diffusion_main/remove_parentheses.py

prompt=$(cat /Users/erik/Documents/ImageGenProject/Text/test${i}.txt)

python3 -m python_coreml_stable_diffusion.pipeline --prompt "${prompt}" --compute-unit CPU_AND_GPU -o /Users/erik/Documents/ImageGenProject/SD_Images --seed ${seed} -i /Users/erik/Documents/ImageGenProject/coreml_stable_diffusion_main/models/coreml-stable-diffusion-2-1-base_original_packages/original/packages --model-version stabilityai/stable-diffusion-2-1-base --scheduler EulerAncestralDiscrete
