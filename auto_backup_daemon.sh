#!/bin/bash
cd /workspace/AvaOS_Realtime

echo "💡 AvaOS Auto-Backup Daemon started..."
HEARTBEAT_FILE="daemon_heartbeat.log"

while true; do
    # 🧠 Log a heartbeat every hour
    date +"[%Y-%m-%d %H:%M:%S] Daemon still running..." >> $HEARTBEAT_FILE
    
    # 📦 Perform backup
    bash backup_logs.sh
    
    echo "Next backup in 24 hours..."
    sleep 86400  # 24 hours = 86400 seconds
done
