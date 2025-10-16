#!/bin/bash
echo "🛑 Stopping AvaOS Realtime Server..."

# Find and kill the running main.py process (inside the restart loop)
pkill -f "python3 main.py"

# Optional: deactivate virtual environment if active
if [ -n "$VIRTUAL_ENV" ]; then
    echo "🔻 Deactivating virtual environment..."
    deactivate
fi

echo "✅ AvaOS Realtime Server stopped successfully!"
