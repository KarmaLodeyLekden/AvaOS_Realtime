#!/bin/bash
echo "🚀 Starting AvaOS Realtime Server..."
cd /workspace/AvaOS_Realtime

# Activate virtual environment if it exists
if [ -d "venv" ]; then
  source venv/bin/activate
fi

# Run the server with automatic port fallback
echo "🔍 Checking available ports (8888–8891)..."
python3 - <<'PYCODE'
import asyncio
from aiohttp import web
import socket

def create_app():
    async def handle(request):
        return web.Response(text="✅ AvaOS Realtime Server is running!")
    app = web.Application()
    app.router.ad
cat > startup.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting AvaOS Realtime Server..."
cd /workspace/AvaOS_Realtime

# Activate virtual environment if it exists
if [ -d "venv" ]; then
  source venv/bin/activate
fi

# Run the server with automatic port fallback
echo "🔍 Checking available ports (8888–8891)..."
python3 - <<'PYCODE'
import asyncio
from aiohttp import web
import socket

def create_app():
    async def handle(request):
        return web.Response(text="✅ AvaOS Realtime Server is running!")
    app = web.Application()
    app.router.add_get("/", handle)

    return app

for port in [8888, 8889, 8890, 8891]:
    try:
        app = create_app()
        print(f"✅ Running AvaOS Realtime on http://0.0.0.0:{port}")
        web.run_app(app, host="0.0.0.0", port=port)
        break
    except OSError as e:
        if e.errno == 98:
            print(f"⚠️  Port {port} is in use, trying next...")
        else:
            raise
PYCODE
