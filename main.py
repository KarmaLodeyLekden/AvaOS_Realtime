import asyncio
import json
import base64
import torch
import soundfile as sf
import io
from aiohttp import web
from flask import Flask, jsonify
from faster_whisper import WhisperModel
from openai import OpenAI
from uuid import uuid4

# -------------------------------
# AvaOS Realtime Voice Server (v2)
# Flask + aiohttp hybrid
# -------------------------------

# Flask app (for REST)
flask_app = Flask(__name__)

@flask_app.route('/')
def home():
    return jsonify({"message": "✅ AvaOS Realtime Voice Server running!", "port": 8888})

# -------------------------------
# Core models
# -------------------------------

print("🔄 Loading models...")

# Load faster-whisper (Speech-to-Text)
stt_model = WhisperModel("base", device="cuda" if torch.cuda.is_available() else "cpu", compute_type="float16")

# Load Glow-TTS + HiFi-GAN (Text-to-Speech)
from TTS.api import TTS
tts = TTS(model_name="tts_models/en/ljspeech/glow-tts", progress_bar=False, gpu=torch.cuda.is_available())

# OpenAI client (GPT reasoning)
client = OpenAI()

print("✅ All models loaded and ready!")

# -------------------------------
# aiohttp WebSocket app
# -------------------------------

async def handle_ws(request):
    ws = web.WebSocketResponse()
    await ws.prepare(request)
    client_id = str(uuid4())
    print(f"🔗 New client connected: {client_id}")

    try:
        async for msg in ws:
            if msg.type == web.WSMsgType.BINARY:
                # Binary audio chunk received
                audio_bytes = msg.data
                audio_file = io.BytesIO(audio_bytes)

                # Transcribe speech
                segments, _ = stt_model.transcribe(audio_file, beam_size=1)
                text = " ".join([segment.text for segment in segments]).strip()

                if text:
                    print(f"[{client_id}] User: {text}")

                    # Generate GPT response
                    completion = client.chat.completions.create(
                        model="gpt-4o-mini",
                        messages=[
                            {"role": "system", "content": "You are Ava, a helpful and friendly AI receptionist."},
                            {"role": "user", "content": text}
                        ]
                    )
                    reply_text = completion.choices[0].message.content.strip()
                    print(f"[{client_id}] Ava: {reply_text}")

                    # Convert GPT reply to speech
                    wav_bytes = io.BytesIO()
                    tts.tts_to_file(text=reply_text, file_path="temp.wav")
                    data, samplerate = sf.read("temp.wav")
                    sf.write(wav_bytes, data, samplerate, format="WAV")
                    wav_bytes.seek(0)

                    # Encode as base64 to send via WebSocket
                    audio_b64 = base64.b64encode(wav_bytes.read()).decode("utf-8")

                    await ws.send_json({"type": "reply", "text": reply_text, "audio": audio_b64})
            elif msg.type == web.WSMsgType.ERROR:
                print(f"⚠️ Connection closed with exception: {ws.exception()}")

    except Exception as e:
        print(f"❌ Error with client {client_id}: {e}")

    finally:
        print(f"❎ Client disconnected: {client_id}")

    return ws


# -------------------------------
# Combine Flask + aiohttp
# -------------------------------

def run():
    loop = asyncio.get_event_loop()
    app = web.Application()
    app.router.add_get('/ws', handle_ws)

    # Run both servers concurrently
    from threading import Thread
    def start_flask():
        flask_app.run(host='0.0.0.0', port=8888, use_reloader=False)

    flask_thread = Thread(target=start_flask)
    flask_thread.start()

    web.run_app(app, port=8888)  # aiohttp WS on separate port

if __name__ == '__main__':
    run()
