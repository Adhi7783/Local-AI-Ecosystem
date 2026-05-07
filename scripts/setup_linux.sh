#!/bin/bash
# 1. Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# 2. Configure Environment for Mirrored Networking & Persistence
sudo mkdir -p /etc/systemd/system/ollama.service.d
echo '[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"
Environment="OLLAMA_KEEP_ALIVE=60m"' | sudo tee /etc/systemd/system/ollama.service.d/override.conf

# 3. Reload and Restart
sudo systemctl daemon-reload
sudo systemctl restart ollama

# 4. Build the Optimized Model
ollama create gemma-hackathon -f Modelfile