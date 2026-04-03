#!/usr/bin/env bash
# Resume Customization — Claude Project Installer (macOS)
# Run from the directory containing this script, CLAUDE.md, and resume-customization/
#
# Usage:
#   chmod +x install-resume-project.sh
#   ./install-resume-project.sh

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
GRAY='\033[0;37m'
DARK='\033[0;90m'
RED='\033[0;31m'
RESET='\033[0m'
BOLD='\033[1m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Banner ─────────────────────────────────────────────────────────────────────
clear
echo ""
echo -e "${CYAN}  ╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}  ║   Resume Customization — Claude Project Installer   ║${RESET}"
echo -e "${CYAN}  ╚══════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "${BOLD}  This script will:${RESET}"
echo -e "${GRAY}    1. Create the project folder structure${RESET}"
echo -e "${GRAY}    2. Install CLAUDE.md and the resume-customization skill${RESET}"
echo -e "${GRAY}    3. Create document staging folders${RESET}"
echo -e "${GRAY}    4. Display recommended Claude connectors${RESET}"
echo ""

# ── Validate source files ──────────────────────────────────────────────────────
REQUIRED_FILES=(
    "$SCRIPT_DIR/CLAUDE.md"
    "$SCRIPT_DIR/resume-customization/SKILL.md"
)

for f in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "$f" ]]; then
        echo -e "${RED}  [ERROR] Required file not found: $f${RESET}"
        echo -e "${RED}  Make sure CLAUDE.md and resume-customization/SKILL.md${RESET}"
        echo -e "${RED}  are in the same directory as this installer script.${RESET}"
        echo ""
        exit 1
    fi
done

# ── Prompt for install location ────────────────────────────────────────────────
echo -e "${YELLOW}  ── Step 1: Choose Install Location ─────────────────────${RESET}"
echo ""
echo -e "${BOLD}  Where would you like to install the project?${RESET}"
echo -e "${GRAY}  Press Enter to accept the default, or type a custom path.${RESET}"
echo ""

DEFAULT_PATH="$HOME/Documents/Claude Projects/ResumeCustomization"
read -rp "  Install path [$DEFAULT_PATH]: " USER_INPUT

if [[ -z "$USER_INPUT" ]]; then
    INSTALL_PATH="$DEFAULT_PATH"
else
    # Strip surrounding quotes if user typed them
    INSTALL_PATH="${USER_INPUT//\"/}"
fi

echo ""
echo -e "${CYAN}  Installing to: $INSTALL_PATH${RESET}"
echo ""

read -rp "  Proceed? (y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}  Installation cancelled.${RESET}"
    exit 0
fi

echo ""

# ── Create folder structure ────────────────────────────────────────────────────
echo -e "${YELLOW}  ── Step 2: Creating Folder Structure ───────────────────${RESET}"
echo ""

FOLDERS=(
    "$INSTALL_PATH"
    "$INSTALL_PATH/_documents/resume"
    "$INSTALL_PATH/_documents/job-descriptions"
    "$INSTALL_PATH/_documents/context"
    "$INSTALL_PATH/_output"
    "$INSTALL_PATH/skills/resume-customization"
)

for folder in "${FOLDERS[@]}"; do
    if [[ ! -d "$folder" ]]; then
        mkdir -p "$folder"
        echo -e "${GREEN}  [+] Created: $folder${RESET}"
    else
        echo -e "${DARK}  [=] Exists:  $folder${RESET}"
    fi
done

echo ""

# ── Copy project files ─────────────────────────────────────────────────────────
echo -e "${YELLOW}  ── Step 3: Installing Project Files ────────────────────${RESET}"
echo ""

cp "$SCRIPT_DIR/CLAUDE.md" "$INSTALL_PATH/CLAUDE.md"
echo -e "${GREEN}  [+] Installed: CLAUDE.md${RESET}"

cp "$SCRIPT_DIR/resume-customization/SKILL.md" \
   "$INSTALL_PATH/skills/resume-customization/SKILL.md"
echo -e "${GREEN}  [+] Installed: skills/resume-customization/SKILL.md${RESET}"

echo ""

# ── Write _documents README ────────────────────────────────────────────────────
cat > "$INSTALL_PATH/_documents/README.md" << 'DOCS_README'
# _documents — Staging Folder

Drop your input documents here before starting a session.

## resume/
Place your current resume here. Accepted formats:
- .docx (preferred)
- .pdf
- .txt (plain text export)

Only one file needed. Rename to something clear, e.g. `Jim_Nitterauer_Resume.docx`.

## job-descriptions/
Place target job description files here. Accepted formats:
- .txt (paste the full JD text and save as .txt)
- .pdf (if downloaded from a job board)

You can include multiple JDs — Claude will analyze all of them.

## context/
Optional. Drop any supporting material here:
- Archetype research exports
- Personal branding notes
- LinkedIn About section drafts
- Recruiter notes or feedback from previous applications
- Company research

Claude will incorporate this context into the gap analysis and summary framing.
DOCS_README

echo -e "${GREEN}  [+] Created:   _documents/README.md${RESET}"

# ── Write _output README ───────────────────────────────────────────────────────
cat > "$INSTALL_PATH/_output/README.md" << 'OUTPUT_README'
# _output — Generated Files

Claude saves optimized resume .docx files here after each session.

Files are named automatically, e.g.:
  Jim_Nitterauer_CISO_Optimized_2026-04-03.docx

Review each file before using in a job application.
OUTPUT_README

echo -e "${GREEN}  [+] Created:   _output/README.md${RESET}"

echo ""

# ── Connector Recommendations ──────────────────────────────────────────────────
echo -e "${YELLOW}  ── Step 4: Recommended Claude Connectors ───────────────${RESET}"
echo ""
echo -e "${BOLD}  Enable these connectors in Claude to enhance this project:${RESET}"
echo ""

echo -e "${GREEN}  [HIGH  ] Google Drive${RESET}"
echo -e "${GRAY}           Store your resume and JDs in Drive — Claude reads them${RESET}"
echo -e "${GRAY}           directly without requiring uploads each session.${RESET}"
echo ""

echo -e "${GREEN}  [HIGH  ] Gmail${RESET}"
echo -e "${GRAY}           Draft and send application emails, cover letters, and${RESET}"
echo -e "${GRAY}           recruiter follow-ups directly from your Claude session.${RESET}"
echo ""

echo -e "${YELLOW}  [MEDIUM] Google Calendar${RESET}"
echo -e "${GRAY}           Schedule interview prep, deadlines, and follow-up${RESET}"
echo -e "${GRAY}           reminders without leaving the workflow.${RESET}"
echo ""

echo -e "${YELLOW}  [MEDIUM] LinkedIn (via Claude in Chrome)${RESET}"
echo -e "${GRAY}           Claude fetches live job posting content directly from${RESET}"
echo -e "${GRAY}           LinkedIn URLs — no copy/paste required.${RESET}"
echo ""

echo -e "${DARK}  [LOW   ] Microsoft OneDrive${RESET}"
echo -e "${DARK}           Alternative to Google Drive if your files live in OneDrive.${RESET}"
echo ""

echo -e "${DARK}  [LOW   ] Attio CRM${RESET}"
echo -e "${DARK}           Track applications, recruiter contacts, and follow-up tasks.${RESET}"
echo ""

echo -e "${CYAN}  Enable connectors at: claude.ai → Settings → Integrations${RESET}"
echo -e "${CYAN}  Or in Cowork:         Settings → Connected Apps${RESET}"
echo ""

# ── Write CONNECTORS.md ────────────────────────────────────────────────────────
cat > "$INSTALL_PATH/CONNECTORS.md" << 'CONNECTORS'
# Recommended Claude Connectors

Enable these in Claude to get the most out of the Resume Customization project.

## HIGH Priority

### Google Drive
Store your resume and job descriptions in Google Drive and Claude can read them directly
without requiring file uploads each session.

### Gmail
Draft application emails, cover letter emails, and recruiter follow-ups directly from
your Claude session. Claude stages messages for your review before sending.

## MEDIUM Priority

### Google Calendar
Schedule interview prep sessions, application deadlines, and recruiter follow-up reminders
without leaving the workflow.

### LinkedIn (via Claude in Chrome)
Claude can fetch live job posting content directly from LinkedIn URLs. No copy/paste
of JD text required — just paste the URL and Claude retrieves the full posting.

## LOW Priority

### Microsoft OneDrive
Alternative to Google Drive if your resume and documents are stored in OneDrive.

### Attio CRM
Track applications, contacts, and follow-up tasks in a connected CRM.
Useful for high-volume searches with many parallel applications.

---

To enable: claude.ai → Settings → Integrations (web)
           Cowork → Settings → Connected Apps (desktop)
CONNECTORS

echo -e "${GREEN}  [+] Created:   CONNECTORS.md${RESET}"
echo ""

# ── Check for Node.js / npm ────────────────────────────────────────────────────
echo -e "${YELLOW}  ── Step 5: Checking Dependencies ───────────────────────${RESET}"
echo ""

if command -v node &>/dev/null; then
    NODE_VER=$(node --version)
    echo -e "${GREEN}  [✓] Node.js found: $NODE_VER${RESET}"
else
    echo -e "${YELLOW}  [!] Node.js not found.${RESET}"
    echo -e "${GRAY}      Claude uses Node.js to generate .docx resume files.${RESET}"
    echo -e "${GRAY}      Install it from: https://nodejs.org${RESET}"
    echo -e "${GRAY}      Or via Homebrew: brew install node${RESET}"
fi

if command -v npm &>/dev/null; then
    NPM_VER=$(npm --version)
    echo -e "${GREEN}  [✓] npm found: $NPM_VER${RESET}"
fi

echo ""

# ── Summary ────────────────────────────────────────────────────────────────────
echo -e "${CYAN}  ── Installation Complete ───────────────────────────────${RESET}"
echo ""
echo -e "${BOLD}  Project installed to:${RESET}"
echo -e "${CYAN}    $INSTALL_PATH${RESET}"
echo ""
echo -e "${BOLD}  Next steps:${RESET}"
echo -e "${GRAY}    1. Drop your resume into:       _documents/resume/${RESET}"
echo -e "${GRAY}    2. Drop your target JD(s) into: _documents/job-descriptions/${RESET}"
echo -e "${GRAY}    3. (Optional) Add context to:   _documents/context/${RESET}"
echo -e "${GRAY}    4. In Claude Cowork or a Claude.ai Project:${RESET}"
echo -e "${GRAY}         - Point to CLAUDE.md as your project instructions${RESET}"
echo -e "${GRAY}         - Install the skill from:  skills/resume-customization/SKILL.md${RESET}"
echo -e "${GRAY}    5. Enable recommended connectors (see CONNECTORS.md)${RESET}"
echo -e "${GRAY}    6. Start a session and provide your resume + job posting${RESET}"
echo ""

read -rp "  Open project folder in Finder? (y/N): " OPEN_FINDER
if [[ "$OPEN_FINDER" =~ ^[Yy]$ ]]; then
    open "$INSTALL_PATH"
fi

echo ""
echo -e "${GREEN}  Done. Good luck with your search.${RESET}"
echo ""
