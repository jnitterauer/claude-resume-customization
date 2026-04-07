---
name: resume-customization
description: >
  Executive resume optimizer and ATS strategist for C-suite and senior leadership roles. Performs
  a full gap analysis and rewrites the resume section-by-section with achievement-oriented bullets
  and strategic keyword integration. When multiple job descriptions are provided, runs the full
  cycle independently for each one — producing one laser-focused resume per posting. Automatically
  generates three deliverables per job: resume .docx, report .docx, and report .md. USE THIS SKILL
  whenever the user provides a resume and a job description or URL, asks to "tailor my resume,"
  "optimize my resume," "apply to this job," or "do a gap analysis." Always trigger when both a
  resume and a target role are present.
---

# Resume Customization Skill

Full-cycle executive resume optimization: gap analysis → rewrite → three output files delivered automatically.

---

## Inputs

Collect these before starting. If any are missing, ask for them before proceeding.

1. **Current Resume** — Uploaded `.docx`, `.pdf`, `.txt`, or pasted text.
   - In Cowork: check `_documents\resume\` first.
   - In Claude.ai: accept as upload or paste.
2. **Target Job Title** — The exact role being pursued.
3. **Target Job Description(s)** — Full JD text, URL(s), or entries in the job queue file.
   - In Cowork: check `_documents\job-descriptions\` for uploaded JD files and check the **job queue file** (see below) before prompting the user.

#### Job Queue File — `_documents\job-descriptions\job-queue.md`

This file is the canonical list of jobs to process. The skill reads it on every run and maintains it automatically.

**Format:**
```
# Job Queue

| URL | Company | Title | Status | Cached File | Fetched |
|-----|---------|-------|--------|-------------|---------|
| https://linkedin.com/jobs/view/123 | Brightside Health | VP, Information Security | ✅ Downloaded | Brightside_VP-InfoSec_JD.md | 2026-04-07 16:30 UTC |
| https://linkedin.com/jobs/view/456 | Acme Corp | CISO | ⏳ Pending | — | — |
| https://linkedin.com/jobs/view/789 | Some Co | VP IT | ❌ Failed | — | 2026-04-07 17:00 UTC |
```

**Status values:** `⏳ Pending` · `✅ Downloaded` · `❌ Failed`

**Skill behavior:**
- If the file does not exist, create it with the header row when URLs are first provided.
- When the user provides URLs (in chat or via the job descriptions folder), append any new ones to the queue as `⏳ Pending` — skip duplicates.
- Before fetching any URL, check if its row is already `✅ Downloaded` and a cached file exists in `_documents\job-descriptions\data\`. If so, read from cache — do not re-fetch.
- After a successful fetch, save the full JD as `[CompanyShortName]_[TitleSlug]_JD.md` in `_documents\job-descriptions\data\` (include source URL and fetch timestamp as a header), then update the queue row: set status to `✅ Downloaded`, fill in the cached filename, and record the UTC timestamp.
- If a fetch fails, set status to `❌ Failed` and record the attempt timestamp. Retry on next run.
- Do not proceed on a partial read of any posting.
4. **Additional Context (optional)** — Archetype research, personal branding notes, LinkedIn About draft.

Once all inputs are confirmed, acknowledge and begin immediately.

> **Multiple JDs:** If more than one job description is provided, run the full optimization cycle independently for each JD — producing one complete, laser-focused resume per posting. Do not blend or average across jobs. In Cowork, use parallel subagents (one per JD). In Claude.ai Projects, run sequentially. Group all output files by job when presenting results.

---

## Execution Steps

### Step 1 — Deep Analysis & Keyword Extraction
Analyze the resume, JD(s), and any supporting context. Extract: hard skills, soft skills, action verbs, required qualifications, preferred qualifications, and primary ATS keywords.

### Step 2 — Gap Analysis
Compare JD requirements against the resume. Classify each gap as High / Medium / Low priority. Distinguish required vs. preferred qualifications. Output in **Part 1**.

### Step 3 — Resume Rewrite
Rewrite section by section per the rules below.

#### Formatting Rules (apply exactly)

| Element | Rule |
|---|---|
| Candidate Name | `##` H2 |
| Target Job Title (Headline) | `###` H3, directly under contact info |
| All section titles | `####` H4 |
| Under "Professional Experience" | `---` horizontal rule, no blank line after |
| Under "Education" | `---` horizontal rule, no blank line after |
| After last Education entry | `---` horizontal rule |
| Education / Certifications / Other section content | Indent with `>` blockquote |
| Dates | End of the same line as company/location, separated by ` | `. No parentheses. |

#### Section Content Rules

**Professional Summary** — Omit the title. 3–4 sentences. Highlights years of experience, top 2–3 skills, most significant achievement. Tailored to top 3–4 JD requirements.

**Core Competencies** — Title: "Core Competencies". Pipe-separated list. Translate technical tools into strategic capabilities (e.g., "SIEM" → "Cybersecurity Strategy & Risk Management"). No tables.

**Professional Experience** — Achievement-oriented bullets. Strong action verbs. Quantify with metrics, percentages, dollars, timeframes wherever possible. Integrate High/Medium priority skills from gap analysis naturally.

**Education** — Each degree on its own line. Use blockquote indent.

**Certifications** — Single line, pipe-separated. Full title and acronym. Use blockquote indent.

**Volunteering / Publications / Awards** — Retain at end. Each volunteering role on its own line.

**Length** — Target two pages. No tables, images, or complex formatting.

### Step 4 — Final Review
Compare the Optimized Resume to the JD. Identify any skills that could not be integrated. Output in **Part 4**.

### Step 5 — Generate Resume .docx

After the five-part report, automatically generate a formatted Word document of the resume only. No user prompt needed.

**Runtime path:**
- Cowork: save to `_output\` subfolder of this project install directory.
- Claude.ai: save to `/mnt/user-data/outputs/` and present with `present_files`.

**Filename convention:** `[LastName]_[CompanyShortName]_Resume_Optimized.docx`
(e.g., `Smith_Acme_Resume_Optimized.docx`)

Use the hiring company's name (shortened if needed) rather than the job title — this makes files instantly distinguishable when multiple resumes are generated in one session.

**Document specs:**
- npm package: `docx` (`npm install docx` if needed)
- Page size: US Letter — `width: 12240, height: 15840` DXA (never A4)
- Margins: `top: 1080, bottom: 1080, left: 1080, right: 1080` (0.75 in)
- Content width: 10080 DXA
- Default font: Calibri, 11pt (`size: 22`)

**Styling:**
- Name: Bold, 20pt, centered
- Headline: 12pt, centered, color `#2E75B6`
- Contact line: 10pt, centered, pipe-separated; bottom border as visual rule (`BorderStyle.SINGLE, size: 6, color: "2E75B6"`)
- Section titles: Bold, 11pt, ALL CAPS, color `#2E75B6`, bottom border (`BorderStyle.SINGLE, size: 4, color: "AAAAAA"`)
- Summary: 11pt, justified
- Core Competencies: 10.5pt, centered, pipe-separated
- Bullets: `LevelFormat.BULLET` via numbering config — never unicode characters. Indent `left: 360, hanging: 180`
- Tab stop for right-aligned dates at content width edge (10080 DXA)
- Education/Certs: indented `left: 360`

**Rules:**
- Never use `\n` in a TextRun — use separate Paragraph elements
- Never use unicode bullet characters — use `LevelFormat.BULLET`
- Use `ShadingType.CLEAR` not SOLID
- Use `WidthType.DXA` for all widths — never PERCENTAGE
- Validate the file after generation. Fix any errors before delivering.

### Step 6 — Save Full Report as Markdown and Word

After the resume .docx is validated, automatically save the complete five-part report in two additional formats. No user prompt needed.

#### 6a — Markdown Report (.md)

Write the full five-part report to a `.md` file in the output folder.

**Filename convention:** `[LastName]_[CompanyShortName]_Report.md`
(e.g., `Smith_Acme_Report.md`)

**Content:** The complete five-part report exactly as delivered in the chat — all five parts in sequence, with all tables, bullets, and formatting intact. Prepend a metadata header:

```
# Resume Optimization Report
**Candidate:** [Full Name]
**Target Role:** [Target Job Title]
**Date:** [Today's date]
**Jobs Analyzed:** [List of company names and job titles]
---
```

Then append Parts 1 through 5 in full.

#### 6b — Word Report (.docx)

Generate a professionally formatted Word document of the full five-part report using the `docx` npm library.

**Filename convention:** `[LastName]_[CompanyShortName]_Report.docx`
(e.g., `Smith_Acme_Report.docx`)

**Runtime path:** Same as resume — `_output\` in Cowork, `/mnt/user-data/outputs/` in Claude.ai.

**Document specs:**
- Page size: US Letter (`width: 12240, height: 15840` DXA)
- Margins: `top: 1080, bottom: 1080, left: 1440, right: 1440` (0.75 in top/bottom, 1 in left/right)
- Default font: Calibri, 11pt

**Styling rules:**

| Element | Style |
|---|---|
| Document title ("Resume Optimization Report") | Bold, 20pt, centered, color `#2E75B6` |
| Metadata block (Candidate, Role, Date, Jobs) | 10pt, left-aligned, color `#555555` |
| Horizontal rule after metadata | `BorderStyle.SINGLE, size: 6, color: "2E75B6"` as paragraph bottom border |
| Part headings ("Part 1: Gap Analysis Report", etc.) | Bold, 14pt, color `#2E75B6`, bottom border (`BorderStyle.SINGLE, size: 4, color: "AAAAAA"`), spacing before: 240 |
| Sub-headings within parts (e.g., "High Priority") | Bold, 11pt, color `#2E75B6` |
| Body text / prose paragraphs | 11pt, justified, spacing after: 120 |
| Bullet points | `LevelFormat.BULLET`, indent `left: 360, hanging: 180`, spacing after: 60 |
| Tables (Hard Skill Table, Opportunities Table) | Full-width (`WidthType.DXA, 10080`), header row bold with light blue fill (`color: "DEEAF1"`), `ShadingType.CLEAR` |
| Part 3 resume text | Rendered as formatted body text — job titles bold, company/date lines normal weight, bullets indented — not as raw markdown |

**Table column widths (Hard Skill Table):**
- Priority: 1200 DXA
- Skill/Competency: 5400 DXA
- Relevant Jobs: 3480 DXA

**Table column widths (Opportunities for Improvement):**
- Priority: 1200 DXA
- Missing Skill/Competency: 3000 DXA
- Recommendation: 5880 DXA

**General rules (same as resume .docx):**
- Never use `\n` in a TextRun — use separate Paragraph elements
- Never use unicode bullet characters — use `LevelFormat.BULLET`
- Use `WidthType.DXA` for all widths
- Validate the file after generation. Fix any errors before delivering.

---

## Output File Summary

After completing all six steps, confirm delivery of three files **per job**:

| File | Contents | Format |
|---|---|---|
| `[LastName]_[Company]_Resume_Optimized.docx` | Optimized resume — tailored to this specific JD | Word (.docx) |
| `[LastName]_[Company]_Report.md` | Full five-part report for this JD | Markdown (.md) |
| `[LastName]_[Company]_Report.docx` | Full five-part report for this JD | Word (.docx) |

When multiple JDs are processed, each job produces its own set of three files. In Cowork, all files are saved to `_output\`. Provide a direct link to each file, grouped by job.

Additionally, any job descriptions fetched from URLs are cached to `_documents\job-descriptions\data\` and will be reused automatically on future runs — no re-fetching needed.

---

## Final Output — Five Parts (deliver in chat in this exact order)

### Part 1: Gap Analysis Report
- **High Priority (Essential):** Missing required skills — why it matters + integration suggestion
- **Medium Priority (Strongly Preferred):** Missing preferred skills — importance + suggestion
- **Low Priority (Good to Have):** Brief suggestion for each
- **Hard Skill Table:** Markdown table of all gaps by priority
- **Resume Match Analysis:** Estimated % match for the *original* resume + one-sentence rationale

### Part 2: Strategic Rationale Summary
Bulleted summary of key changes and the reasoning behind each one.

### Part 3: The Optimized Resume
Full clean Markdown text of the rewritten resume. All formatting rules applied exactly. No "References" section.

### Part 4: Opportunities for Improvement
Markdown table: **Priority | Missing Skill/Competency | Recommendation**

### Part 5: The Breakthrough Elevator Pitch Offer
Offer to generate a customized Elevator Pitch using The Breakthrough Formula:
> *"I help [target audience] achieve [desired benefit] without [negative consequence]."*

Ask the user if they want one or two tailored versions to complement the new resume.

---

## Iteration

After the user reviews the output, accept targeted revision requests without restarting the full process. When the user specifies which job they want to revise (e.g., "strengthen the Acme resume bullets"), apply changes only to that job's resume and regenerate that job's three output files automatically (resume .docx, report .md, and report .docx).
