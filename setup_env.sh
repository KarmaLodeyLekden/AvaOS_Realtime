#!/bin/bash

echo "🧱 Setting up AvaOS Realtime environment..."

# Create a virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
else
    echo "✅ Virtual environment already exists."
fi

# Activate the virtual environment
echo "🔑 Activating virtual environment..."
source venv/bin/activate

# Upgrade pip to latest version
echo "⬆️  Upgrading pip..."
pip install --upgrade pip

# Install all dependencies from requirements.txt
echo "📂 Installing dependencies..."
pip install -r requirements.txt

echo "✅ AvaOS environment setup complete!"
