#!/bin/bash
# Detect NVIDIA GPU and update Modelfile (Modelfile or Modelfile.txt)
set -e
repo_root="$(dirname "$(dirname "$0")")"
modelfile=""
if [ -f "$repo_root/Modelfile" ]; then
  modelfile="$repo_root/Modelfile"
elif [ -f "$repo_root/Modelfile.txt" ]; then
  modelfile="$repo_root/Modelfile.txt"
else
  echo "Modelfile not found in repo root" >&2
  exit 0
fi
echo "Using Modelfile: $modelfile"

if command -v nvidia-smi >/dev/null 2>&1; then
  echo "NVIDIA GPU detected — enabling GPU offload"
  # Uncomment any commented PARAMETER num_gpu lines, and set to 999
  sed -E -i 's/^[[:space:]]*#?[[:space:]]*(PARAMETER[[:space:]]+num_gpu[[:space:]]+)[0-9]+/\1 999/' "$modelfile"
else
  echo "No NVIDIA GPU detected — commenting out num_gpu parameter"
  sed -E -i 's/^[[:space:]]*(PARAMETER[[:space:]]+num_gpu[[:space:]]+)[0-9]+/# \1 999/' "$modelfile" || true
fi
echo "Modelfile updated."
