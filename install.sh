#!/usr/bin/env bash
# GemCode Universal 1-Click macOS & Linux Installer
# Author: Riad Developer (https://github.com/RiadDeveloper)
set -e

echo ""
echo "=========================================================="
echo "           🚀  GemCode AI Engine Setup                    "
echo "     Supercharged Free Claude Code for Everyone           "
echo "=========================================================="
echo ""

OS="$(uname -s)"
ARCH="$(uname -m)"
INSTALL_DIR="$HOME/.gemcode/bin"
BIN_PATH="$INSTALL_DIR/gemcode"
CLAUDE_DIR="$HOME/.claude"
SETTINGS_PATH="$CLAUDE_DIR/settings.json"

mkdir -p "$INSTALL_DIR"
mkdir -p "$CLAUDE_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"
VERSION="2.3.0"
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/VERSION" ]; then
    VERSION="$(cat "$SCRIPT_DIR/VERSION" | tr -d '[:space:]')"
else
    ONLINE_VER="$(curl -fsSL https://raw.githubusercontent.com/RiadDeveloper/GemCode-Setup/main/VERSION 2>/dev/null | tr -d '[:space:]' || true)"
    if [ -n "$ONLINE_VER" ]; then
        VERSION="$ONLINE_VER"
    fi
fi

# 1. Determine platform binary
BIN_NAME=""
if [ "$OS" = "Darwin" ]; then
    if [ "$ARCH" = "arm64" ]; then
        BIN_NAME="gemcode-darwin-arm64-v$VERSION"
    else
        BIN_NAME="gemcode-darwin-amd64-v$VERSION"
    fi
elif [ "$OS" = "Linux" ]; then
    BIN_NAME="gemcode-linux-amd64-v$VERSION"
else
    echo "[!] Unsupported OS: $OS"
    exit 1
fi

LOCAL_BIN="$SCRIPT_DIR/bin/$BIN_NAME"
DOWNLOAD_URL="https://raw.githubusercontent.com/RiadDeveloper/GemCode-Setup/main/bin/$BIN_NAME"

if [ -f "$LOCAL_BIN" ]; then
    cp "$LOCAL_BIN" "$BIN_PATH"
    echo "[√] Deployed local GemCode binary ($BIN_NAME)"
else
    echo "[*] Downloading $BIN_NAME..."
    curl -fsSL "$DOWNLOAD_URL" -o "$BIN_PATH"
    echo "[√] Downloaded GemCode binary"
fi
chmod +x "$BIN_PATH"

# 2. Configure ~/.claude/settings.json
cat <<EOF > "$SETTINGS_PATH"
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://localhost:8081",
    "ANTHROPIC_AUTH_TOKEN": "gemcode",
    "ANTHROPIC_MODEL": "claude-3-5-sonnet-20241022",
    "DISABLE_AUTOUPDATER": "1"
  },
  "theme": "dark"
}
EOF
echo "[√] Configured ~/.claude/settings.json (Auto-mapped to GemCode)"

# 3. Configure Auto-Start Service
if [ "$OS" = "Darwin" ]; then
    PLIST_PATH="$HOME/Library/LaunchAgents/com.gemcode.server.plist"
    cat <<EOF > "$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.gemcode.server</string>
    <key>ProgramArguments</key>
    <array>
        <string>$BIN_PATH</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
    launchctl load "$PLIST_PATH"
    echo "[√] Configured macOS LaunchAgent (Runs on boot in background)"
elif [ "$OS" = "Linux" ]; then
    SYSTEMD_DIR="$HOME/.config/systemd/user"
    mkdir -p "$SYSTEMD_DIR"
    SERVICE_PATH="$SYSTEMD_DIR/gemcode.service"
    cat <<EOF > "$SERVICE_PATH"
[Unit]
Description=GemCode Local AI Engine
After=network.target

[Service]
ExecStart=$BIN_PATH
Restart=always
RestartSec=3

[Install]
WantedBy=default.target
EOF
    systemctl --user daemon-reload
    systemctl --user enable --now gemcode
    echo "[√] Configured Linux systemd user service (Runs on boot in background)"
fi

# 4. Check if claude is installed
if ! command -v claude &> /dev/null; then
    echo "[*] Installing Claude Code CLI..."
    curl -fsSL https://claude.ai/install.sh | bash || true
fi

echo ""
echo "=========================================================="
echo "  🎉 SUCCESS! GemCode is ready to use!"
echo "  👉 Just open any terminal and type: claude"
echo "=========================================================="
echo ""
