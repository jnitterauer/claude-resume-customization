# Claude Resume Customization Project

An AI-powered executive resume optimizer built for **Claude Cowork** (desktop) and **Claude.ai Projects** (web). Performs a full gap analysis against a target job description, rewrites your resume section-by-section with ATS-optimized, achievement-oriented content, and delivers a professionally formatted `.docx` file — automatically.

---

## What It Does

1. **Gap Analysis** — Compares your resume against the job description. Classifies missing skills as High / Medium / Low priority with actionable suggestions.
2. **Resume Rewrite** — Rewrites every section with strong action verbs, quantified achievements, and strategic keyword integration tailored to C-suite hiring expectations.
3. **Strategic Rationale** — Explains every change made and why.
4. **Opportunities for Improvement** — A final gap table showing what couldn't be integrated and what to do about it.
5. **Elevator Pitch Offer** — Offers to generate a personalized pitch using The Breakthrough Formula.
6. **Auto `.docx` Delivery** — Generates a professionally formatted Word document after every session. No extra prompt needed.

---

## Repo Structure

```
claude-resume-customization/
├── README.md                          ← You are here
├── CLAUDE.md                          ← Project instructions for Claude
├── CONNECTORS.md                      ← Recommended Claude connector guide
├── Install-ResumeProject.ps1          ← Windows installer (PowerShell)
├── install-resume-project.sh          ← macOS/Linux installer (bash)
└── skills/
    └── resume-customization/
        └── SKILL.md                   ← Claude skill definition
```

---

## Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/YOUR_USERNAME/claude-resume-customization.git
cd claude-resume-customization
```

### 2. Run the installer

**macOS / Linux:**
```bash
chmod +x install-resume-project.sh
./install-resume-project.sh
```

**Windows (PowerShell):**
```powershell
.\Install-ResumeProject.ps1
```

The installer will:
- Prompt for an install location (defaults to `~/Documents/Claude Projects/ResumeCustomization`)
- Create the full project folder structure
- Copy `CLAUDE.md` and the skill file into place
- Create document staging folders with READMEs
- Display recommended Claude connectors
- Check for Node.js / npm (macOS only)

### 3. Add your documents

```
_documents/
├── resume/            ← Drop your current resume here (.docx, .pdf, or .txt)
├── job-descriptions/  ← Drop JD files here, or paste URLs in session
└── context/           ← Optional: archetype research, branding notes, etc.
```

### 4. Configure Claude

**Claude Cowork:**
- Open Cowork → New Project
- Set project instructions to the contents of `CLAUDE.md`
- Install the skill from `skills/resume-customization/SKILL.md`

**Claude.ai Projects:**
- Go to claude.ai → Projects → New Project
- Paste the contents of `CLAUDE.md` into Project Instructions
- Start a conversation and upload your resume + job posting

### 5. Run a session

Provide your resume and a job description (text or URL). Claude will run the full five-part analysis and deliver an optimized `.docx` to your `_output/` folder automatically.

---

## Recommended Connectors

Enable these in Claude for the best experience. See [`CONNECTORS.md`](./CONNECTORS.md) for details.

| Priority | Connector | Benefit |
|---|---|---|
| HIGH | Google Drive | Claude reads your resume and JDs directly — no uploads needed |
| HIGH | Gmail | Draft and send application emails from within Claude |
| MEDIUM | Google Calendar | Schedule prep and follow-up reminders |
| MEDIUM | LinkedIn (Claude in Chrome) | Fetch live job postings from URLs directly |
| LOW | Microsoft OneDrive | Alternative to Google Drive for M365 users |
| LOW | Attio CRM | Track applications and recruiter contacts |

---

## Requirements

- **Claude Cowork** or a **Claude.ai Pro / Team / Enterprise** account
- **Node.js + npm** — required for `.docx` file generation ([nodejs.org](https://nodejs.org))
- **Python 3** — used by the docx validation script (usually pre-installed on macOS/Linux)

---

## Disclaimer

Always review and validate the accuracy of any AI-generated resume content before submitting a job application. Do not fabricate or misrepresent experience or qualifications.

---

## License

MIT — use freely, modify as needed, contributions welcome.
