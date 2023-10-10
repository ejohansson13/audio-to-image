from huggingface_hub import snapshot_download
from pathlib import Path

repo_id = "apple/coreml-stable-diffusion-2-1-base"
variant = "original/packages"

model_path = Path("./models") / (repo_id.split("/")[-1] + "_" + variant.replace("/", "_"))
snapshot_download(repo_id, allow_patterns=f"{variant}/*", local_dir=model_path, local_dir_use_symlinks=False)
print(f"Model downloaded at {model_path}")
