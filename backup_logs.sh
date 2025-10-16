#!/bin/bash
cd /workspace/AvaOS_Realtime

# 🗂️ File to back up
LOG_FILE="avaos_server.log"
BACKUP_DIR="logs_backup"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# 🧰 Create a backup folder if it doesn't exist
mkdir -p $BACKUP_DIR

# 📦 Copy the log file with timestamp
if [ -f "$LOG_FILE" ]; then
    cp "$LOG_FILE" "$BACKUP_DIR/avaos_server_$TIMESTAMP.log"
else
    echo "⚠️ No avaos_server.log found to back up."
fi

# 🧹 Delete old backups (older than 7 days)
find $BACKUP_DIR -type f -name "*.log" -mtime +7 -exec rm {} \;
echo "🧹 Old logs older than 7 days deleted."

# 🚀 Commit and push backup to GitHub
git add $BACKUP_DIR
git commit -m "Auto backup logs on $TIMESTAMP"
git push origin main

echo "✅ Logs backed up to GitHub at $TIMESTAMP!"
