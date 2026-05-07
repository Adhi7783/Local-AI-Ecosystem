#!/bin/bash
# Combined monitor for hardware and model status
watch -n 1 '
echo "=== NVIDIA GPU STATUS ==="
nvidia-smi --query-gpu=memory.used,memory.total,utilization.gpu --format=csv,noheader,nounits
echo -e "\n=== OLLAMA RUNTIME STATUS ==="
ollama ps
'