# AvaOS_Realtime
# ⚡ AvaOS Realtime — Fully Automated Server Environment

AvaOS Realtime is a **self-healing, auto-installing, and auto-maintaining** voice server system.  
It automatically sets up dependencies, activates its virtual environment, launches the Flask server, and performs daily GitHub backups — all with **zero manual setup**.

---

## 🧱 System Architecture

| Script | Description |
|:--|:--|
| 🧩 **setup_env.sh** | Creates or activates the virtual environment and installs all dependencies from `requirements.txt` (Flask, aiohttp, Soundfile, etc.). |
| 🚀 **startup.sh** | Runs `setup_env.sh`, activates the venv, starts the AvaOS Flask server, and keeps it alive with an **auto-restart loop**. Logs are written to `avaos_server.log`. |
| 🛑 **stop_server.sh** | Safely stops the Flask server without killing the entire container. |
| 💾 **backup_logs.sh** | Backs up logs to GitHub daily and deletes backups older than 7 days automatically. |
| 🔁 **auto_backup_daemon.sh** | Runs in the background and executes daily backups every 24 hours. It also writes a **heartbeat log** every hour to confirm that it’s running. |

---

## ⚙️ Automation Flow

1. **On pod start**, RunPod executes:
   ```bash
   bash /workspace/AvaOS_Realtime/startup.sh
Creates and activates a virtual environment

Installs dependencies automatically

Launches the AvaOS Flask voice server

Starts the auto-backup daemon in the background

Every 24 hours, the daemon:

Executes backup_logs.sh

Pushes logs to GitHub with timestamps

Deletes any backup logs older than 7 days

Every hour, the daemon appends:

arduino
Copy code
[2025-10-16 15:30:00] Daemon still running...
to daemon_heartbeat.log, proving it’s active.

At any time, you can:

View logs → tail -f avaos_server.log

View heartbeat → tail -f daemon_heartbeat.log

Stop the server safely → bash stop_server.sh

🧩 Quick Start (for new servers)
When starting fresh on a new pod or machine:

bash
Copy code
git clone https://github.com/KarmaLodeyLekden/AvaOS_Realtime.git
cd AvaOS_Realtime
bash setup_env.sh && bash startup.sh & bash auto_backup_daemon.sh &
This single line will:

Reinstall all dependencies

Start the server

Enable continuous log backups

✅ Key Features
⚙️ Automatic dependency installation

🔁 Self-healing server with auto-restart

🧱 Persistent virtual environment

💾 Daily log backup + cleanup

🧠 Heartbeat tracking for uptime verification

🚀 Hands-free operation — just start and go!

📂 File Outputs
File	Purpose
avaos_server.log	Real-time Flask/TTS server logs
daemon_heartbeat.log	Hourly daemon heartbeat status
logs_backup/	Daily GitHub log backups
auto_backup.log	Daemon background output (if run with nohup)

🧠 Summary
AvaOS Realtime is designed for continuous operation, zero downtime, and hands-free maintenance.

Once deployed, it will take care of itself — install, run, log, restart, back up, and clean up — without a single manual command.

Simply start the pod and let AvaOS handle everything automatically.
