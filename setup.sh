#!/bin/bash
echo "🚀 Setting up AvaOS Realtime Environment..."

# Update pip and tools
python3 -m ensurepip --upgrade
python3 -m pip install --upgrade pip setuptools wheel

# Install all dependencies
python3 -m pip install -r requirements.txt --no-cache-dir --force-reinstall

# Create missing site-packages folder if needed
mkdir -p /root/.local/lib/python3.11/site-packages

echo "✅ Setup complete. You can now run: python3 main.py"
