# Polish Change Log

All notable changes, architectural updates, and version history for **Polish** (Local AI Text & SQL Polisher for Windows) are documented in this file.

---

## [v1.6.1] - 2026-08-19

### Fixed
- **SQL Replacement Filter (`Get-ReplaceableText`)**:
  - Clicking **Replace** on a Fix SQL (`Ctrl + Alt + Q`) result now extracts and pastes *only* the corrected SQL query into the target editor, omitting the explanation and bulleted error analysis.
  - Full issue details remain visible inside the Preview window for review, while the clean query is copied/pasted into SQL Developer/DBeaver.

---

## [v1.6.0] - 2026-08-19

### Added
- **Multi-Tone Tabbed Switcher in Preview Window**:
  - Added tab buttons (`Professional`, `Concise`, `Friendly`, `Grammar`) to the top of `Show-ResultPopup` in text mode.
  - Lazy generation: text for a tab is generated only when the tab is clicked.
- **Per-Tone Response Caching**:
  - Built-in `$state.Cache` hash table per popup session. Switching back to an already-generated tone displays the cached output instantly without making another Ollama API request.
  - **Regenerate** button explicitly forces a fresh request and updates the cache.
- **Model & Execution Badge**:
  - Displays dynamic active model badge in the popup header (e.g., `Local - qwen2.5:0.5b` or `Cloud - gemma4:cloud`) and inside the non-activating "Polishing..." toast.
- **Robust Output Sanitizer (`Clean-Output`)**:
  - Added regex filters to strip inline HTML formatting tags (`<i>`, `<b>`, `<em>`, `<strong>`, `<p>`, `<br>`, `<code>`, etc.) emitted by small models.
  - Strips prompt structural tags (`<message>`, `</message>`), markdown fences (```), and conversational lead-ins ("*Sure, here is...*").

### Fixed & Improved
- **High-DPI Display Scaling Fix**:
  - Added P/Invoke `SetProcessDPIAware()` call before initializing forms/tray icons.
  - Calculated real device scaling (`Get-UiScale`) to dynamically scale pixel heights, padding, and form bounds on 125%, 150%, 175%, and 200% DPI monitors.
  - Updated `Center-Form` helper to position windows on the active display monitor under the user's cursor.
- **In-Place Direct Paste Focus Reliability**:
  - In direct paste mode (`PreviewBeforeReplace = $false`) and when clicking **Replace** in preview mode, `Set-AndPaste` now explicitly re-focuses the target window (`SetForegroundWindow($TargetHwnd)`) before sending `Ctrl+V`.
- **Clipboard Lock Retry Helper**:
  - Wrapped clipboard getters and setters in `Invoke-SafeClipboard` scriptblock retries (5 attempts with 10ms backoff) to handle OS clipboard locking conflicts gracefully.

---

## [v1.5.0] - 2026-08-10

### Added
- **Live Response Streaming**:
  - Replaced synchronous `Invoke-RestMethod` with live HTTP streaming (`System.Net.HttpWebRequest` and `StreamReader`) in `Invoke-Polish`.
  - Tokens append live into WinForms `RichTextBox` for real-time visual feedback.
- **Interactive Preview Before Replace**:
  - Added `$cfg.PreviewBeforeReplace` configuration setting (default: `true`).
  - Hotkeys open `Show-ResultPopup` featuring **Replace**, **Copy**, **Regenerate**, and **Close** actions.
- **Summary Popup Mode**:
  - `Ctrl + Alt + S` (Summarize) now streams bullet point summaries directly into `Show-ResultPopup` (view/copy only, direct paste disabled).
- **Persistent Configuration & History Viewer**:
  - Introduced `polish.config.json` for persistent user preferences.
  - Added `Show-History` viewer interface and `polish-history.json` storage (tracks last 25 polishes with timestamp, tone, original, and output).
  - Added **Start Polish at login** autostart shortcut installer (`Install-Autostart.bat` & tray toggle).
- **Startup Health Checks (`Invoke-HealthCheck`)**:
  - Pings `http://127.0.0.1:11434/api/tags` on application launch to verify Ollama status and required local model availability.

### Changed
- Switched default local text model from `gemma3:1b` to **`qwen2.5:0.5b`** (~400 MB) for faster generation speeds on standard PC hardware.
- Retired local SQL model `qwen2.5-coder:1.5b`; routed SQL fixing to the higher-precision cloud model `gemma4:cloud`.

---

## [v1.4.0] - 2026-07-25

### Added
- **Structured SQL Error Pointer Analysis (`Ctrl + Alt + Q`)**:
  - Formatted prompt guard to require SQL responses to present output in two distinct sections:
    1. **Issues Identified**: Bullet points detailing syntax, logic, or performance issues.
    2. **Corrected SQL**: The exact, executable Oracle SQL query without markdown code blocks.
- **Cloud Model Upgrade for SQL**:
  - Routed SQL fixing (`Ctrl + Alt + Q`) to high-precision cloud model (`gemma4:cloud`) for complex Oracle queries.

---

## [v1.3.0] - 2026-07-12

### Added
- **Summarize Hotkey (`Ctrl + Alt + S`)**:
  - Added text summarization prompt mode designed to condense lengthy email threads or documentation into key bullet points, decisions, and action items.
- **System Tray Cloud Model Toggle**:
  - Added **Use cloud model for text** toggle to the context menu to switch between local `qwen2.5:0.5b` and cloud `gemma4:cloud` on demand.

---

## [v1.2.0] - 2026-06-20

### Added
- **Fix SQL Hotkey (`Ctrl + Alt + Q`)**:
  - Added dedicated Oracle SQL query analyzer and fixer mode.
- **Hotkey Re-mapping**:
  - Moved **Quit** shortcut from `Ctrl + Alt + Q` to `Ctrl + Alt + X` to free up `Ctrl + Alt + Q` for SQL fixing.

---

## [v1.0.1] - 2026-06-02

### Fixed
- **Hotkey Selection Race Condition**:
  - Added `Wait-KeysUp` loop to wait until physical `Ctrl`, `Alt`, and hotkey letters are released before triggering selection capture.
  - Added selection copy retries to eliminate intermittent "No text selected" warnings.

---

## [v1.0.0] - 2026-05-15

### Added
- Initial stable release of **Polish**.
- Global system hotkeys registered via Win32 `RegisterHotKey` API:
  - `Ctrl + Alt + P` — Professional
  - `Ctrl + Alt + C` — Concise
  - `Ctrl + Alt + F` — Friendly
  - `Ctrl + Alt + G` — Grammar
- Direct in-place clipboard replacement (`Ctrl + C` -> Ollama API -> `Ctrl + V`).
- System tray icon with custom rendered GDI+ teal "P" bitmap icon.
- Local execution via Ollama API (`127.0.0.1:11434`) using `gemma3:1b`.
- CPU multi-threading support (`[Environment]::ProcessorCount`).
- Single instance enforcement using `System.Threading.Mutex` (`Local\PolishHotkeyApp`).
