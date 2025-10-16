import asyncio
import json
import soundfile as sf
from aiohttp import web
from uuid import uuid4
import io

class ConnectionManager:
    def __init__(self):
        self.active_clients = {}

    async def connect(self, ws):
        client_id = str(uuid4())
        self.active_clients[client_id] = ws
        print(f"[Connected] Client {client_id}")
        return client_id

    async def disconnect(self, client_id):
        ws = self.active_clients.get(client_id)
        if ws:
            await ws.close()
            del self.active_clients[client_id]
            print(f"[Disconnected] Client {client_id}")

async def process_audio(data, client_id):
    await asyncio.sleep(0.01)
    print(f"[Audio Received] Client {client_id} - {len(data)} bytes")

manager = ConnectionManager()

async def voice_handler(request):
    ws = web.WebSocketResponse()
    await ws.prepare(request)

    client_id = await manager.connect(ws)

    try:
        async for msg in ws:
            if msg.type == web.WSMsgType.BINARY:
                await process_audio(msg.data, client_id)
            elif msg.type == web.WSMsgType.TEXT:
                data = msg.data.strip()
                print(f"[Text] {client_id}: {data}")
                await ws.send_str(json.dumps({"ack": data}))
            elif msg.type == web.WSMsgType.ERROR:
                print(f"[Error] {client_id}: {ws.exception()}")
    except Exception as e:
        print(f"[Exception] Client {client_id}: {e}")
    finally:
        await manager.disconnect(client_id)

    return ws

async def cleanup_inactive_clients(app):
    while True:
        for cid, ws in list(manager.active_clients.items()):
            if ws.closed:
                await manager.disconnect(cid)
        await asyncio.sleep(10)

def create_app():
    app = web.Application()
    app.router.add_get("/voice", voice_handler)
    app.on_startup.append(start_background_tasks)
    return app

async def start_background_tasks(app):
    app["cleanup_task"] = asyncio.create_task(cleanup_inactive_clients(app))

if __name__ == "__main__":
    import socket
    for port in [8888, 8889, 8890, 8891]:
        try:
            app = create_app()
            web.run_app(app, host="0.0.0.0", port=port)
            break
        except OSError as e:
            if e.errno == 98:
                print(f"[Warning] Port {port} in use, trying next...")
            else:
                raise
