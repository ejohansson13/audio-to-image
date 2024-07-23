# read in version_num
with open("version_num.txt", "r") as file:
    v_num = file.read()
v_num = v_num.split("\n")[0]

# check it's an int
v_num = f"{int(v_num) + 1}"

# write to version_num.txt
with open("version_num.txt", "w") as file:
    file.write(v_num)