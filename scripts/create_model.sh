#!/bin/bash
# Builds the optimized Gemma 4 model using the Modelfile logic
echo "Building gemma-hackathon model..."
ollama create gemma-hackathon -f ../Modelfile

echo "Verifying model load..."
ollama list | grep "gemma-hackathon"
