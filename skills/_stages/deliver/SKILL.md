---
name: deliver
description: "Package artifacts for delivery: build packages, release notes, handoff guides, demo scripts, presentations, posters. Use when shipping, publishing, presenting, or handing off work. Triggers: 'deliver', 'ship', 'publish', 'slides', 'presentation', 'poster', 'demo', 'handoff', 'release notes'."
---

# deliver

Package artifacts for delivery: build packages, release notes, handoff guides, demo scripts, presentations, posters. Use when shipping, publishing, presenting, or handing off work.

## Trigger Words
`deliver`, `ship`, `publish`, `release`, `package`, `handoff`, `demo`, `slides`, `presentation`, `poster`

## Gate Requirement
**Requires:** Evidence Bundle + Quality Gate PASS (`artifacts/evidence.md` with overall PASS verdict).
If no evidence bundle exists or gate is FAIL, redirect to `verify/` first.

## Sub-skills

| Sub-skill | File | Input | Output |
|---|---|---|---|
| Package | `sub/package.md` | Built artifact | Publishable package |
| Release Notes | `sub/release-notes.md` | Diff/changelog | Release notes |
| Handoff Guide | `sub/handoff-guide.md` | Package | Handoff guide |
| Demo Script | `sub/demo-script.md` | Package | Demo script + data |

## Domain Tool Routing (Delivery Formats)

| Trigger | Domain Tool | Path |
|---|---|---|
| "slides", "presentation", "talk" | Scientific Slides | `_tools/present/sub/scientific-slides.md` |
| "poster" (LaTeX) | LaTeX Posters | `_tools/present/sub/latex-posters.md` |
| "poster" (PPTX) | PPTX Posters | `_tools/present/sub/pptx-posters.md` |
| "video", "slide-to-video" | Video | `_tools/present/sub/slide-to-video.md` |
| "website", "publish web" | Paper→Web | `_tools/web/paper-2-web.md` |
| "research website" | Research→Web | `_tools/web/research-2-web.md` |
| "PDF" | invoke `/pdf` skill | (plugin) |
| "Word", "docx" | invoke `/docx` skill | (plugin) |
| "PowerPoint", "pptx" | invoke `/pptx` skill | (plugin) |
| "Excel", "xlsx" | invoke `/xlsx` skill | (plugin) |

## Default Behavior

When invoked without a format trigger:
1. Check evidence bundle exists + PASS
2. Run Package → create versioned deliverable
3. Run Handoff Guide → recipient can operate independently
4. Optionally: Release Notes, Demo Script

## Gate: Delivery Gate
**Output artifact:** `artifacts/package.md` with version + instructions
**Required before:** Operate stage
