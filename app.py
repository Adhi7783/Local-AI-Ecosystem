import streamlit as st
import requests
import json

st.set_page_config(page_title="Gemma 4 Edge Chat", page_icon="🤖")
st.title("🤖 Gemma 4: Edge Inference Chat")

if "messages" not in st.session_state:
    st.session_state.messages = []

for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

if prompt := st.chat_input("Ask your local model..."):
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    with st.chat_message("assistant"):
        response_placeholder = st.empty()
        full_response = ""
        
        try:
            # Connects to WSL2 via the mirrored network bridge
            response = requests.post(
                "http://localhost:11434/api/chat",
                json={
                    "model": "gemma-hackathon",
                    "messages": st.session_state.messages,
                    "stream": True
                },
                stream=True
            )
            for line in response.iter_lines():
                if line:
                    chunk = json.loads(line)
                    if "message" in chunk:
                        content = chunk["message"].get("content", "")
                        full_response += content
                        response_placeholder.markdown(full_response + "▌")
            
            response_placeholder.markdown(full_response)
            st.session_state.messages.append({"role": "assistant", "content": full_response})
            
        except Exception as e:
            st.error(f"Connection Error: {e}")