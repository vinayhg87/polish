# Security Policy & Architecture

## Security & Privacy Philosophy

**Polish** is designed from the ground up to prioritize user data privacy, local execution, and low attack surface.

---

## Core Security Controls

### 1. Local-First Execution
By default, all text rephrasing, grammar checks, and summaries run **100% locally** via Ollama bound to local loopback (`http://127.0.0.1:11434`). Under local mode, zero data is transmitted over the Internet.

### 2. Pre-Transmission Outbound Data Masking
When utilizing cloud features (`gemma4:cloud`), Polish automatically runs an outbound security redaction engine configured via `polish.security.config.json`. Sensitive data patterns are intercepted and replaced with deterministic token tags (e.g. `[REDACTED_EMAIL_1]`) **before** HTTP payload serialization.

#### Automatically Redacted Categories:
- **SSNs & Government IDs** (`123-45-6789`)
- **Email Addresses** (`user@company.com`)
- **Dates of Birth (DOB)** (`6/7/1981`, `01/15/1990`)
- **Passwords & DB URIs** (`oracle://admin:secret@db.internal:5432/prod`)
- **API Keys & Tokens** (`sk-...`, `ghp_...`)
- **Credit Card Numbers** (`4111-2222-3333-4444`)
- **IP Addresses** (`192.168.1.45`)
- **Corporate Internal Domains** (`*.corp`, `*.internal`, `*.lan`)
- **SUNET IDs & Usernames** (`Usernames & Network IDs`)
- **Custom Regex Rules** (e.g. Employee ID `EMP-12345`)

### 3. Local Rehydration
Original sensitive values remain exclusively on your local machine. Upon response from the cloud model, tokens are rehydrated locally before display or paste execution (unless `"RehydrateInOutput": false` is configured to keep them permanently masked).

### 4. Interactive Security Audit Log
Users can right-click the system tray icon and select **`Security Audit Log...`** at any time to review side-by-side visual proof of exact masked payloads transmitted to Ollama Cloud versus local token mappings stored in `polish-security-audit.json`.

### 5. Input Validation & Zero RCE Vector
- No dynamic code execution (`Invoke-Expression`, `iex`, `eval`, or shell commands).
- User text is passed purely as data strings within `<message>` XML boundaries in JSON API payloads.
- Keystroke simulation uses static `SendWait('^v')` (Ctrl+V) rather than raw text typing, eliminating keystroke injection risks.

---

## Reporting a Vulnerability

If you discover a potential security issue in Polish, please open an issue or contact the maintainers with details. All reports will be investigated promptly.
