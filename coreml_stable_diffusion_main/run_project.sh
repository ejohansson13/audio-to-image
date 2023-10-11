i=$(cat /PATH/TO/version_num.txt)
seed=$(cat /PATH/TO/seed_num.txt)

ffmpeg -f avfoundation -i ":0" -ar 16000 -t 10 /PATH/TO/audio recording directory/test${i}.wav

/PATH/TO/whisper.cpp-master/main -m /PATH/TO/whisper.cpp-master/models/ggml-medium.bin -nt -otxt -of /PATH/TO/txt file directory/test${i}.txt -f /PATH/TO/audio recording directory/test${i}.wav

# multilingual option: specify language arg or let whisper detect it (delete language arg)
#/PATH/TO/whisper.cpp-master/main --language spanish -m /PATH/TO/whisper.cpp-master/models/ggml-large.bin -tr -nt -otxt -of /PATH/TO/txt file directory/test${i}.txt -f /PATH/TO/audio recording directory/test${i}.wav

# remove_parentheses file removes any associated ({[]}) written through whisper's transcription
python3 /PATH/TO/remove_parentheses.py

prompt=$(cat /PATH/TO/txt file directory/test${i}.txt)

# when using split attention, CPU_AND_NE performance may be optimized
python3 -m python_coreml_stable_diffusion.pipeline --prompt "${prompt}" --compute-unit CPU_AND_GPU -o /PATH/TO/image_output --seed ${seed} -i /PATH/TO/coreml_stable_diffusion_main/models/coreml-stable-diffusion-2-1-base_original_packages/original/packages --model-version stabilityai/stable-diffusion-2-1-base --scheduler EulerAncestralDiscrete
