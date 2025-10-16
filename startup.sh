#!/bin/bash
cd /workspace/AvaOS_Realtime

echo "🚀 Starting AvaOS Realtime Auto Setup & Launch..."

# Step 1: Run setup_env.sh to create and activate the environment
bash setup_env.sh

# Step 2: Activate the virtual environment
echo "🔑 Activating virtual environment..."
source venv/bin/activate

# Step 3: Start the Flask / AvaOS server
echo "🌍 Launching AvaOS Realtime Server..."
python3 main.py
