#!/bin/bash
cd /workspace/AvaOS_Realtime

echo "🚀 Starting AvaOS Realtime Auto Setup & Launch..."

# Step 1: Run setup_env.sh to prepare environment
bash setup_env.sh

# Step 2: Activate the virtual environment
echo "🔑 Activating virtual environment..."
source venv/bin/activate

# Step 3: Keep server alive forever (auto-restart on crash) with logging
echo "🌍 Launching AvaOS Realtime Server (auto-restart + logging enabled)..."

# Log directory
LOG_FILE="avaos_server.log"

# Start loop
while true; do
    echo "🔄 Starting server at $(date)" | tee -a $LOG_FILE
    python3 main.py >> $LOG_FILE 2>&1
    echo "⚠️  Server crashed or stopped at $(date). Restarting in 5 seconds..." | tee -a $LOG_FILE
    sleep 5
done
