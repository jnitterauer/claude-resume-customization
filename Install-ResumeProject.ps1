#Requires -Version 5.1
<#
.SYNOPSIS
    Resume Customization Project Installer
    Installs the Claude Resume Customization project to a folder of your choice.

.DESCRIPTION
    Creates the project folder structure, copies CLAUDE.md and the skill file,
    creates document staging folders, and displays connector recommendations.

.NOTES
    Run from the directory containing this script, CLAUDE.md, and the
    resume-customization\ skill folder.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ─── Banner ──────────────────────────────────────────────────────────────────

Clear-Host
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║   Resume Customization — Claude Project Installer   ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  This script will:" -ForegroundColor White
Write-Host "    1. Create the project folder structure" -ForegroundColor Gray
Write-Host "    2. Install CLAUDE.md and the resume-customization skill" -ForegroundColor Gray
Write-Host "    3. Create document staging folders" -ForegroundColor Gray
Write-Host "    4. Display recommended Claude connectors" -ForegroundColor Gray
Write-Host ""

# ─── Validate script source files ────────────────────────────────────────────

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$RequiredFiles = @(
    "$ScriptDir\CLAUDE.md",
    "$ScriptDir\resume-customization\SKILL.md"
)

foreach ($File in $RequiredFiles) {
    if (-not (Test-Path $File)) {
        Write-Host "  [ERROR] Required file not found: $File" -ForegroundColor Red
        Write-Host "  Make sure CLAUDE.md and resume-customization\SKILL.md are in" -ForegroundColor Red
        Write-Host "  the same directory as this installer script." -ForegroundColor Red
        Write-Host ""
        Read-Host "  Press Enter to exit"
        exit 1
    }
}

# ─── Prompt for install location ─────────────────────────────────────────────

Write-Host "  ── Step 1: Choose Install Location ─────────────────────" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Where would you like to install the project?" -ForegroundColor White
Write-Host "  Press Enter to accept the default, or type a custom path." -ForegroundColor Gray
Write-Host ""

$DefaultPath = Join-Path $env:USERPROFILE "Documents\Claude Projects\ResumeCustomization"
$UserInput = Read-Host "  Install path [$DefaultPath]"

if ([string]::IsNullOrWhiteSpace($UserInput)) {
    $InstallPath = $DefaultPath
} else {
    $InstallPath = $UserInput.Trim().Trim('"')
}

Write-Host ""
Write-Host "  Installing to: $InstallPath" -ForegroundColor Cyan
Write-Host ""

# ─── Confirm ─────────────────────────────────────────────────────────────────

$Confirm = Read-Host "  Proceed? (Y/N)"
if ($Confirm -notmatch '^[Yy]') {
    Write-Host ""
    Write-Host "  Installation cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

# ─── Create folder structure ──────────────────────────────────────────────────

$Folders = @(
    $InstallPath,
    "$InstallPath\_documents\resume",
    "$InstallPath\_documents\job-descriptions",
    "$InstallPath\_documents\context",
    "$InstallPath\_output",
    "$InstallPath\skills\resume-customization"
)

Write-Host "  ── Step 2: Creating Folder Structure ───────────────────" -ForegroundColor Yellow
Write-Host ""

foreach ($Folder in $Folders) {
    if (-not (Test-Path $Folder)) {
        New-Item -ItemType Directory -Path $Folder -Force | Out-Null
        Write-Host "  [+] Created: $Folder" -ForegroundColor Green
    } else {
        Write-Host "  [=] Exists:  $Folder" -ForegroundColor DarkGray
    }
}

Write-Host ""

# ─── Copy project files ───────────────────────────────────────────────────────

Write-Host "  ── Step 3: Installing Project Files ────────────────────" -ForegroundColor Yellow
Write-Host ""

# CLAUDE.md
Copy-Item "$ScriptDir\CLAUDE.md" "$InstallPath\CLAUDE.md" -Force
Write-Host "  [+] Installed: CLAUDE.md" -ForegroundColor Green

# SKILL.md
Copy-Item "$ScriptDir\resume-customization\SKILL.md" "$InstallPath\skills\resume-customization\SKILL.md" -Force
Write-Host "  [+] Installed: skills\resume-customization\SKILL.md" -ForegroundColor Green

Write-Host ""

# ─── Write document README ────────────────────────────────────────────────────

$DocumentsReadme = @"
# _documents — Staging Folder

Drop your input documents here before starting a session.

## resume\
Place your current resume here. Accepted formats:
- .docx (preferred)
- .pdf
- .txt (plain text export)

Only one file needed. Rename to something clear, e.g. `Jim_Nitterauer_Resume.docx`.

## job-descriptions\
Place target job description files here. Accepted formats:
- .txt (paste the full JD text and save as .txt)
- .pdf (if downloaded from a job board)
- .url (a shortcut file pointing to the live posting)

You can include multiple JDs — Claude will analyze all of them.

## context\
Optional. Drop any supporting material here:
- Archetype research exports
- Personal branding notes
- LinkedIn About section drafts
- Recruiter notes or feedback from previous applications
- Company research

Claude will incorporate this context into the gap analysis and summary framing.
"@

$DocumentsReadme | Out-File -FilePath "$InstallPath\_documents\README.md" -Encoding UTF8
Write-Host "  [+] Created:   _documents\README.md" -ForegroundColor Green

# ─── Write output README ──────────────────────────────────────────────────────

$OutputReadme = @"
# _output — Generated Files

Claude saves optimized resume .docx files here after each session.

Files are named automatically, e.g.:
  Jim_Nitterauer_CISO_Optimized_2026-04-03.docx

Review each file before using in a job application.
"@

$OutputReadme | Out-File -FilePath "$InstallPath\_output\README.md" -Encoding UTF8
Write-Host "  [+] Created:   _output\README.md" -ForegroundColor Green

Write-Host ""

# ─── Connector Recommendations ───────────────────────────────────────────────

Write-Host "  ── Step 4: Recommended Claude Connectors ───────────────" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Enable these connectors in Claude to enhance this project:" -ForegroundColor White
Write-Host ""

$Connectors = @(
    @{
        Name     = "Google Drive"
        Priority = "HIGH"
        Reason   = "Store and retrieve your resume and JDs from Drive instead of"
        Reason2  = "local files. Claude can read docs directly without uploading."
        Color    = "Green"
    },
    @{
        Name     = "Gmail"
        Priority = "HIGH"
        Reason   = "Draft and send application emails, follow-ups, and cover"
        Reason2  = "letters directly from the session without switching apps."
        Color    = "Green"
    },
    @{
        Name     = "Google Calendar"
        Priority = "MEDIUM"
        Reason   = "Schedule interview prep time, follow-up reminders, and"
        Reason2  = "application deadlines without leaving the workflow."
        Color    = "Yellow"
    },
    @{
        Name     = "LinkedIn (via browser)"
        Priority = "MEDIUM"
        Reason   = "Claude can fetch live job postings directly from LinkedIn"
        Reason2  = "URLs — no copy/paste required."
        Color    = "Yellow"
    },
    @{
        Name     = "Microsoft OneDrive / SharePoint"
        Priority = "LOW"
        Reason   = "Alternative to Google Drive if your resume lives in OneDrive."
        Reason2  = "Especially useful if you already use M365."
        Color    = "DarkGray"
    },
    @{
        Name     = "Attio CRM"
        Priority = "LOW"
        Reason   = "Track job applications, recruiter contacts, and follow-up"
        Reason2  = "tasks in a CRM connected to your Claude sessions."
        Color    = "DarkGray"
    }
)

foreach ($C in $Connectors) {
    Write-Host ("  [{0}] {1}" -f $C.Priority.PadRight(6), $C.Name) -ForegroundColor $C.Color
    Write-Host ("         {0}" -f $C.Reason) -ForegroundColor Gray
    Write-Host ("         {0}" -f $C.Reason2) -ForegroundColor Gray
    Write-Host ""
}

Write-Host "  Enable connectors at: claude.ai → Settings → Integrations" -ForegroundColor DarkCyan
Write-Host "  Or in Cowork:         Settings → Connected Apps" -ForegroundColor DarkCyan
Write-Host ""

# ─── Write connector guide to disk ───────────────────────────────────────────

$ConnectorGuide = @"
# Recommended Claude Connectors

Enable these in Claude to get the most out of the Resume Customization project.

## HIGH Priority

### Google Drive
Store your resume and job descriptions in Google Drive and Claude can read them directly
without requiring file uploads each session. Point Claude to the file path or share link.

### Gmail
Draft application emails, cover letter emails, and recruiter follow-ups directly from
your Claude session. Claude can compose and stage messages for your review before sending.

## MEDIUM Priority

### Google Calendar
Schedule interview prep sessions, application deadlines, and recruiter follow-up reminders
without leaving the workflow.

### LinkedIn (via browser / Claude in Chrome)
Claude can fetch live job posting content directly from LinkedIn URLs. No copy/paste
of JD text required — just paste the URL and Claude retrieves the full posting.

## LOW Priority

### Microsoft OneDrive
Alternative to Google Drive if your resume and documents are stored in OneDrive or
SharePoint. Useful if you are already in an M365 environment.

### Attio CRM
Track applications, contacts, and follow-up tasks in a connected CRM.
Useful if you are running a high-volume search with many parallel applications.

---

To enable: claude.ai → Settings → Integrations (web)
           Cowork → Settings → Connected Apps (desktop)
"@

$ConnectorGuide | Out-File -FilePath "$InstallPath\CONNECTORS.md" -Encoding UTF8
Write-Host "  [+] Created:   CONNECTORS.md (saved to project folder)" -ForegroundColor Green

Write-Host ""

# ─── Summary ─────────────────────────────────────────────────────────────────

Write-Host "  ── Installation Complete ───────────────────────────────" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Project installed to:" -ForegroundColor White
Write-Host "    $InstallPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor White
Write-Host "    1. Drop your resume into:       _documents\resume\" -ForegroundColor Gray
Write-Host "    2. Drop your target JD(s) into: _documents\job-descriptions\" -ForegroundColor Gray
Write-Host "    3. (Optional) Add context to:   _documents\context\" -ForegroundColor Gray
Write-Host "    4. In Claude Cowork or a Claude.ai Project:" -ForegroundColor Gray
Write-Host "         - Point to CLAUDE.md as your project instructions" -ForegroundColor Gray
Write-Host "         - Install the skill from:  skills\resume-customization\SKILL.md" -ForegroundColor Gray
Write-Host "    5. Enable recommended connectors (see CONNECTORS.md)" -ForegroundColor Gray
Write-Host "    6. Start a session and provide your resume + job posting" -ForegroundColor Gray
Write-Host ""

# Open the install folder in Explorer
$OpenFolder = Read-Host "  Open project folder in Explorer? (Y/N)"
if ($OpenFolder -match '^[Yy]') {
    Start-Process explorer.exe $InstallPath
}

Write-Host ""
Write-Host "  Done. Good luck with your search." -ForegroundColor Green
Write-Host ""
