#!/bin/bash
cd /workspace/AvaOS_Realtime

echo "🚀 Starting AvaOS Realtime Auto Setup & Launch..."

# Step 1: Run setup_env.sh to prepare environment
bash setup_env.sh

# Step 2: Activate the virtual environment
echo "🔑 Activating virtual environment..."
source venv/bin/activate

# Step 3: Keep server alive forever (auto-restart on crash)
echo "🌍 Launching AvaOS Realtime Server (auto-restart enabled)..."

while true; do
    echo "🔄 Starting server..."
    python3 main.py
    echo "⚠️  Server crashed or stopped. Restarting in 5 seconds..."
    sleep 5
done
