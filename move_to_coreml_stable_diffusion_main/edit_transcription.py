with open("version_num.txt", "r") as file:
    v_num = file.read()
v_num = v_num.split("\n")[0]

f_name = f"/Users/erik/Documents/ImageGenProject/Text/test{v_num}.txt"
with open(f_name, "r") as file:
    txt_prompt = file.read().lstrip()

open_brackets = ["(", "{", "["]

for idx, s in enumerate(txt_prompt):
    if s in open_brackets:
        txt_prompt = txt_prompt[:idx-1]
        break
txt_prompt = txt_prompt.split("\n")[0]

with open(f_name, "w") as file:
    file.write(txt_prompt)