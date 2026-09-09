# GitHub Pages Deployment Plan — MAiD Policy Packet

## Context

The MAiD policy packet site is a static HTML/CSS/JS site with downloadable PDFs, hosted at `https://github.com/CambrianMinds/MAiD`. It is currently on branch `maid-no-ip` with uncommitted working-tree changes that remove the "Companion Essay" content. The goal is to clean the repository, commit the changes, and deploy to GitHub Pages from the `maid-no-ip` branch.

## Files Currently in the Working Tree

| File | Status |
|---|---|
| `essay.html`, `autonomy_exit_essay.pdf`, `autonomy_exit_essay.tex`, `pincer.html` | Deleted (uncommitted) |
| 8 HTML files | Modified (essay references removed) |
| 8 PDFs at root | Untracked? Need to verify — they are tracked per `git ls-files` |

Per `git ls-files`, all 8 PDFs are tracked at the repository root: `00_cover_sheet.pdf`, `00_master_policy.pdf`, `01_legal_foundations.pdf`, `01_legislative_brief.pdf`, `02_advocacy_brief.pdf`, `03_academic_paper.pdf`, `04_clinical_brief.pdf`, `05_model_reporting_form.pdf`.

## Critical Issue: PDF Path Mismatch

Every HTML file references PDFs at `pdfs/*.pdf` (e.g., `href="pdfs/00_master_policy.pdf"`), but the PDFs are tracked at the repository root. The site is therefore currently broken — no PDF downloads would resolve. The user has chosen to fix this by **moving PDFs into a `pdfs/` subdirectory**.

## Task List

### 1. Create `pdfs/` directory and move PDFs

- `mkdir -p pdfs`
- Move all 8 tracked PDFs from root into `pdfs/`:
  - `00_cover_sheet.pdf`
  - `00_master_policy.pdf`
  - `01_legal_foundations.pdf`
  - `01_legislative_brief.pdf`
  - `02_advocacy_brief.pdf`
  - `03_academic_paper.pdf`
  - `04_clinical_brief.pdf`
  - `05_model_reporting_form.pdf`
- Use `git mv` for each so history is preserved and the move is staged.

### 2. Remove unnecessary files

These files are not needed for a GitHub Pages static site and should be removed from the repository:

| File | Reason |
|---|---|
| `00_master_policy.tex` | LaTeX source — PDF is the deliverable |
| `01_legislative_brief.tex` | LaTeX source |
| `02_advocacy_brief.tex` | LaTeX source |
| `03_academic_paper.tex` | LaTeX source |
| `04_clinical_brief.tex` | LaTeX source |
| `compile_tex.sh` | Build script — not needed at runtime |
| `campaign.sty` | LaTeX style file — not needed |
| `netlify.toml` | Netlify config — irrelevant for GitHub Pages |

Use `git rm` for each so removal is staged.

### 3. Commit all changes on `maid-no-ip`

Stage and commit in one commit:
- The 4 deleted files (`essay.html`, `autonomy_exit_essay.pdf`, `autonomy_exit_essay.tex`, `pincer.html`)
- The 8 modified HTML files
- The 8 PDFs moved into `pdfs/`
- The 9 removed unnecessary files

Commit message (matching repo style — short, descriptive):
```
Remove companion essay and LaTeX sources; move PDFs to pdfs/
```

Verify with `git status` that the working tree is clean and `git log --oneline -3` shows the new commit.

### 4. Configure GitHub Pages

Pages must be sourced from the `maid-no-ip` branch. Two options:

**Option A — GUI (recommended for first setup):**
- In GitHub repo settings → Pages → Source → Branch: `maid-no-ip` → `/` (root) → Save

**Option B — via branch-level configuration:**
- Ensure `maid-no-ip` is the branch GitHub sees as the Pages source.

No `.nojekyll` file is needed (no Jekyll-sensitive content — no `_config.yml`, no `_posts`, no `_layouts`).

### 5. Verify the deployment

After enabling Pages (may take a few minutes to propagate):
- Visit `https://cambrianminds.github.io/MAiD/` (exact URL depends on repo name casing — GitHub lowercases)
- Confirm `index.html` loads with correct styling
- Confirm PDF downloads resolve (e.g., `pdfs/00_master_policy.pdf`)
- Confirm 404s are gone for any previously broken PDF links
- Verify all 6 nav links + footer links work

## Risks / Notes

- **No build step:** This is a pure static site. No `package.json`, no build config. GitHub Pages serves files as-is.
- **The `form.html` form** posts to `action="#"` — it is a placeholder and will not function as a real contact form on GitHub Pages. This is pre-existing behavior and out of scope.
- **Branch name casing:** GitHub Pages URLs are case-insensitive for the path but the repo owner/repo slug is lowercase. The expected URL is `https://cambrianminds.github.io/MAiD/`.
- **If `maid-no-ip` is not the default branch:** GitHub Pages defaults to `main`/`master`. The user must explicitly select `maid-no-ip` in the Pages source settings, otherwise it will not deploy from this branch.

## Out of Scope

- Adding a `CNAME` custom domain (user has not requested one)
- Adding analytics, SEO metadata beyond what exists, or a build pipeline
- Fixing content or copyediting the HTML