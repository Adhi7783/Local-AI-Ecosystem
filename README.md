# Gemma4-Edge-Bridge

This repository demonstrates how to deploy a high-performance, 100% GPU-accelerated local AI environment using **Gemma 4:E2B** on a mid-range NVIDIA GTX 1050 Ti (4GB VRAM).

## 💡 Key Features
- **Zero-Cloud Privacy:** All inference happens locally on WSL2.
- **Full GPU Utilization:** Optimized layers to fit entirely in 4GB VRAM.
- **Seamless Integration:** Mirrored networking bridge between Windows Enterprise and Ubuntu.

## 🛠️ Installation
1. Copy `.wslconfig` to your Windows User folder so WSL2 picks up the memory and networking settings.
2. Run `sh setup_linux.sh` in WSL2 to configure the Ollama service.
3. Run `powershell ./setup_windows.ps1` to prepare the Python UI.
4. Launch the interface: `streamlit run app.py`.

## 🧠 Why a Custom Modelfile?
This project doesn't just run an off-the-shelf model. We created `gemma-hackathon` to:
* **Force GPU Residency:** By setting `num_gpu 999`, we encourage Ollama to keep every model layer resident in the 4GB VRAM of the 1050 Ti for maximum speed.
* **Logic-First Tuning:** We lower `temperature` to 0.3 so the model stays precise, technical, and suitable for engineering tasks.
* **Environment Persistence:** This wraps the Google Gemma 4 base model in a fixed configuration, so the Streamlit UI always talks to the same hardware-optimized version.

## ⚙️ Specs
- **Model:** Gemma 4:E2B (Quantized)
- **Host:** Windows Enterprise / WSL2 Ubuntu 24.04
- **Interface:** Streamlit / Python 3.13

## 💻 Running without a GPU (CPU-Only Mode)
This project is designed to be hardware-agnostic. If you do not have an NVIDIA GPU:
1. **Model Config:** In the `Modelfile`, remove the line `PARAMETER num_gpu 999`. 
2. **Performance:** The model will run using System RAM. While slower than GPU-accelerated inference, all logic and features remain fully functional.
3. **Resource Tuning:** Adjust `.wslconfig` memory settings to 50% of your total physical RAM for optimal stability.

## 📊 Monitoring & Utilities
To ensure the model is utilizing the GPU correctly, use the provided monitoring scripts:

* **Model Creation:** Run `sh scripts/create_model.sh` to initialize the optimized Gemma 4 environment.
* **GPU Verification:** Run `sh scripts/monitor_gpu.sh` to see real-time VRAM usage and layer offloading status.
* **Manual Checks:**
    * `ollama ps`: Shows which models are currently in memory and the GPU/CPU split.
    * `ollama list`: Displays all locally available model versions.

