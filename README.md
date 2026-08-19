# Polish  —  v1.7 (Full)

Rephrase / polish text **anywhere** (Slack, Teams, Outlook, browser) with a
**local** AI model. Select text, press a hotkey, and the polished version
replaces it in place. No manual copy-pasting into ChatGPT/Claude — most
work is local, though some high-precision tasks use the cloud.

## Hotkeys

| Hotkey | What it does |
|--------|--------------|
| `Ctrl + Alt + P` | **Professional** — clear, client-ready |
| `Ctrl + Alt + C` | **Concise** — shorter, no filler |
| `Ctrl + Alt + F` | **Friendly** — warm but professional |
| `Ctrl + Alt + G` | **Grammar** — fix spelling/grammar only |
| `Ctrl + Alt + S` | **Summarize** — condense a long email/thread |
| `Ctrl + Alt + Q` | **Fix SQL** — explain SQL issues in pointers & show corrected query |
| `Ctrl + Alt + X` | Quit |

**Use it:** highlight some text → press a hotkey → wait ~2–5 sec → the text is replaced.

**Fixing SQL:** in SQL Developer / DBeaver, select a broken Oracle query and press
`Ctrl + Alt + Q`. It analyzes the query, explains the syntax/logic issues in clear
bullet points, and provides the corrected Oracle SQL query. This uses a high-precision cloud model
(`gemma4:cloud`) to ensure accuracy for complex queries.

**Summarize:** select a long email/thread and press `Ctrl + Alt + S` to replace it
with a concise bullet summary. (Best quality with the cloud model toggled on.)

**Models:** text tones + summarize use `qwen2.5:0.5b` locally (small & fast, streams
into a preview popup), or `gemma4:cloud` when the cloud toggle is on. SQL uses the
cloud model `gemma4:cloud` for maximum precision.

## Setup (one time)

1. **Double-click `setup.bat`.** It installs Ollama (a signed installer) and
   downloads the local model (`qwen2.5:0.5b` for text/summarize, ~400 MB). No admin rights needed.
2. **Double-click `Start-Polish.bat`** to run it. A tray icon appears near the
   clock and a "Ready" balloon pops up. (It flashes a console briefly, then runs
   hidden in the background.)
3. *(Optional)* **Double-click `Install-Autostart.bat`** so Polish starts
   automatically (hidden) every time you log in.

> If a `.bat` ever opens in Notepad instead of running, see the troubleshooting
> note at the bottom — it's a file-association issue on that PC, not a bad file.

That's the whole install: **one signed program (Ollama) + this folder.** The
hotkey app itself is a plain PowerShell script — nothing compiled.

## Optional: cloud model (better quality for text & summaries)

By default everything runs **locally** — private, offline, free. For higher
quality on the text tones and summaries, you can toggle a large **Ollama Cloud**
model (`gemma4:cloud`):

1. **Sign in once per machine:** open a terminal and run `ollama signin` (free
   Ollama account; heavy use may need a paid plan).
2. **Right-click the Polish tray icon → "Use cloud model for text".** Checkmark =
   cloud ON; uncheck to return to local.

> ⚠️ **Privacy & Cloud Mode:** With cloud ON (or when using Fix SQL), requests use the cloud model. **Polish automatically redacts all sensitive data** (SSNs, emails, DOBs, passwords, DB URIs, API keys, etc.) before transmission.

## 🛡️ Security & Privacy Architecture

Polish is built with a **privacy-first, low-attack-surface architecture**:

* 🔒 **Local-First & Offline by Default:** Text polishing runs 100% locally on `http://127.0.0.1:11434`. No data leaves your machine during local execution.
* 🛡️ **Automated Outbound Data Redaction (`polish.security.config.json`):** When cloud features are used (`gemma4:cloud`), Polish automatically scans and redacts confidential data into token placeholders (e.g. `[REDACTED_EMAIL_1]`, `[REDACTED_SSN_1]`, `[REDACTED_DBURI_1]`) **before** sending requests over the Internet.
  * **Supported Redaction Categories:** SSNs, Email Addresses, Dates of Birth (DOB), Passwords & DB URIs, API Keys & Tokens, Credit Cards, IP Addresses, Internal Corporate Domains, SUNET IDs, and Custom Regex Rules (e.g. Employee IDs).
* 🔄 **Inbound Rehydration:** Original sensitive values are restored back to your output on your local machine so you don't lose data when pasting into your app (controllable via `"RehydrateInOutput"`).
* 👁️ **Visual Security Audit Log:** Right-click the tray icon -> **`Security Audit Log...`** to inspect side-by-side visual proof of exact masked payloads sent to Ollama Cloud vs your local token map.
* ⚡ **Zero Remote Code Execution (RCE) / Injection Vectors:** No `Invoke-Expression`, shell commands, or dynamic code evaluation. Text is handled strictly as string data.

## Requirements

- Windows 10/11
- ~1 GB free RAM while polishing (fine on an 8 GB machine)
- ~400 MB disk for the local model (qwen2.5:0.5b)

## First-run prompts you may see

- **Windows Firewall**: Ollama runs a local-only server; click *Allow* (private
  network is enough).
- Nothing here contacts the internet after setup — it all runs on `localhost`.

## Test without hotkeys

```powershell
powershell -ExecutionPolicy Bypass -File Polish.ps1 -Test "hey can u send me teh report asap" -Tone professional
```

Valid `-Tone` values: `professional`, `concise`, `friendly`, `grammar`, `summarize`, `sql`.

## Tips & troubleshooting

- **"Can't reach the model"** balloon → Ollama isn't running. Open the Start
  menu, launch **Ollama**, then try again. (Setup normally starts it for you.)
- **Nothing happens on the hotkey** → another app may already use `Ctrl+Alt+P`.
  Tell whoever set this up and the hotkey can be changed in `Polish.ps1`.
- **Doesn't work in an app running as Administrator** → Windows blocks a normal
  program from typing into an elevated window (UIPI). Fix: run Polish as admin
  too (right-click the launcher -> Run as administrator), OR just use it in
  normal apps (Slack/Teams/Outlook/browser all run non-elevated and work as-is).
- **Closing a window killed Polish** → it was launched *attached* to that console.
  Start it by double-clicking `Start-Polish.bat` (it detaches and runs hidden), or
  use `Install-Autostart.bat` (hidden at login). Do NOT run `Polish.ps1` by hand in
  a cmd/PowerShell window you then keep open - closing that window kills it.
- **A .bat file opens in Notepad instead of running** → the `.bat` association on
  that PC is broken, or the file is secretly named `...bat.txt`.
  1. Turn on File Explorer -> View -> Show -> "File name extensions" and check the
     real name; if it ends in `.txt`, rename it to end in `.bat`.
  2. If it truly is `.bat`, run it from a Command Prompt: open `cmd`, drag the
     `.bat` file into the window, press Enter (works despite the bad association).
  3. Permanent fix (admin cmd): `assoc .bat=batfile`  then  `ftype batfile="%1" %*`
- **Want a stronger model?** Edit `polish.config.json` and change `"Model"` from
  `qwen2.5:0.5b` to `qwen2.5:1.5b` (slower, noticeably better wording; still fits
  8 GB), then run `ollama pull qwen2.5:1.5b`. Or just toggle the cloud model in the
  tray for the best quality.

## How it works

`Polish.ps1` registers global hotkeys, copies your selection, sends it to the
local Ollama server (`http://127.0.0.1:11434`) with a tone-specific instruction,
and pastes the result back over your selection. Everything is local.

## Changelog

### v1.7
- **Security Redaction & Data Masking Engine (`polish.security.config.json`)**:
  - Automatically redacts sensitive data (SSNs, Emails, DOBs, Passwords, DB URIs, API Keys, Credit Cards, IP Addresses, Corporate Domains, SUNET IDs, and Custom Employee ID regex rules) into token placeholders before sending to cloud models.
  - **Inbound Rehydration**: Automatically restores original sensitive values on local return so you don't lose data.
- **Interactive Security Audit Log Viewer (`Show-SecurityAuditLog`)**:
  - Right-click tray menu -> **`Security Audit Log...`** to view side-by-side proof of exact masked payloads sent to Ollama Cloud vs local token map.
  - One-click **`Open Log File`** button to view `polish-security-audit.json` in Notepad.
- **Notification Encoding Fix**: Plain text toast formatting fix (`Security Protection:`) preventing Windows balloon tip character corruption (`ðY›¡ï`).

### v1.6.1
- **Fix SQL Replacement Filter**: Clicking **Replace** on a Fix SQL (`Ctrl+Alt+Q`) result now extracts and pastes *only* the corrected SQL query into the target editor, omitting error explanations.

### v1.6
- **Tone switcher in the Preview popup**: tabs for Professional / Concise / Friendly /
  Grammar. Open with any tone hotkey, then click another tab to see that tone -
  generated lazily, only when you pick it.
- **Per-tone caching**: switching back to a tone you already viewed shows it
  instantly with no new local/cloud request. Regenerate forces a fresh take.
- **Model badge**: the popup header and the "Polishing..." toast now show which
  model is running and whether it's Local or Cloud.
- **DPI fix**: popups scale correctly on 125/150/175% displays (no more clipped
  header) and open centered on the active monitor.
- **Reliable in-place paste**: direct paste (preview off) now re-focuses the
  source window before pasting, fixing intermittent misses on Ctrl+Alt+C / F.
- **Cleaner output**: strips stray HTML tags (`<i>`, `<b>`, ...) the small model
  sometimes emits.

### v1.5
- Switched the local text model to **`qwen2.5:0.5b`** (down from `gemma3:1b`) —
  ~400 MB and much faster on low-powered machines. Retired the local
  `qwen2.5-coder:1.5b` (SQL now uses the cloud model).
- **Streaming**: local output now streams live into the popup as it's generated.
- **Preview before replace + Regenerate**: text hotkeys open a popup so you can
  review (and re-roll) the result before it replaces your selection.
- **Summarize** (`Ctrl+Alt+S`) now shows the summary in a popup instead of pasting.
- Added a **config file** (`polish.config.json`), **first-run health check**,
  **autostart toggle**, and a **History viewer** in the tray menu.
- Improved rephrase prompts + lower temperature for cleaner, more faithful output.

### v1.4
- Updated **Fix SQL** to use a high-precision cloud model (`gemma4:31b-cloud`) instead of a local one for significantly better accuracy with complex Oracle queries.

### v1.3 (Full)
- Added **Summarize** on `Ctrl+Alt+S` — condenses a long email/thread into a
  concise plain-text bullet summary in place.
- Added an optional **cloud model** toggle (Ollama Cloud `gemma4:cloud`) in the
  tray menu, for higher-quality text tones & summaries. Local `gemma3:1b` stays
  the default; SQL always stays on the local coder model. Sends `think: false`.

### v1.2
- Added **Fix SQL** on `Ctrl+Alt+Q` — corrects an existing Oracle SQL query in
  place (syntax/logic only; never writes a new query). Uses a dedicated code
  model `qwen2.5-coder:1.5b`; runs at low temperature and strips markdown fences.
- Moved **Quit** to `Ctrl+Alt+X` (freed up `Ctrl+Alt+Q` for SQL).

### v1.0.1
- Fixed intermittent "No text selected" error (notably on Ctrl+Alt+G): now waits
  for the hotkey's own key to release, adds a short settle delay, and retries the
  copy once so selections are captured reliably.

### v1.0
- First stable release.
- Four in-place tone hotkeys: Professional, Concise, Friendly, Grammar.
- Local model **gemma3:1b** via Ollama — fully offline and private.
- Professional tone tuned for polished, formal business wording.
- Faithful rephrasing: prompt guards against inventing facts/dates and against
  "answering" your message instead of rewriting it.
- Uses all CPU cores for speed; model warmed at startup; kept in RAM for 30 min.
- Teal "P" tray icon; startup conflict warning if a hotkey is already in use.
- Runs hidden in the background; optional auto-start at login.
