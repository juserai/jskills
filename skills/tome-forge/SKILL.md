---
name: tome-forge
description: "Tome Forge — Personal knowledge base engine. LLM-compiled Markdown wiki, no RAG needed. init/ingest/query/lint/compile."
license: MIT
metadata:
  category: crucible
  permissions:
    network: false
    filesystem: read-write
    execution: none
    tools: [Read, Write, Glob, Grep]
argument-hint: "[init|ingest|query|lint|compile|capture] [args...]"
---

# Tome Forge — Personal Knowledge Base Engine

Based on Karpathy's LLM Wiki pattern: raw materials + LLM compilation = structured Markdown wiki. No RAG, no vector DB, no infra. Zero dependencies.

## KB Discovery

Before executing any sub-command, determine the KB root directory using this logic:

1. **Check current directory**: walk up from the current working directory looking for `.tome-forge.json`
2. **If found** → the directory containing `.tome-forge.json` is the KB root
3. **If not found** → use default location `~/.tome-forge/`
4. **If default doesn't exist and command is NOT `init`** → auto-initialize it at `~/.tome-forge/` first, then proceed

This means:
- Inside an initialized KB → operations target that KB
- Anywhere else → operations target `~/.tome-forge/` (auto-created if needed)
- `init` without arguments in a non-KB directory → initializes `~/.tome-forge/`
- `init .` → initializes the current directory (explicit override)

Report the resolved KB root at the start of every operation: `KB: /path/to/kb`

## Sub-commands

Parse the user's argument to determine which operation to run. Show help if no argument.

### `/tome-forge init`

Initialize a knowledge base. Target directory is determined by the argument:
- `/tome-forge init` → initialize at `~/.tome-forge/` (default)
- `/tome-forge init .` → initialize in current directory
- `/tome-forge init /path/to/dir` → initialize at specified path

**Steps:**

1. Create directory structure:
   ```
   raw/captures/
   raw/papers/
   raw/articles/
   raw/books/
   raw/conversations/
   wiki/
   wiki/_orphans/
   logs/
   ```

2. Write `CLAUDE.md` using the template in `references/schema-template.md` — read that file and write it as `./CLAUDE.md`

3. Write `index.md`:
   ```markdown
   # Knowledge Base Index
   > Last updated: {today}
   > Total pages: 0
   ```

4. Write `logs/{YYYY-MM}.md` (e.g. `logs/2026-04.md`):
   ```markdown
   # {YYYY-MM} Operation Log
   - [{today} {HH:MM}] **init**: Knowledge base initialized
   ```

5. Write `.tome-forge.json` (KB marker file):
   ```json
   {
     "version": 1,
     "created": "{today}"
   }
   ```

6. Write `.gitignore`:
   ```
   .last_compile
   __pycache__/
   *.pyc
   .env
   ```

7. Run `git init` if not already a git repo

8. Report: "KB: {path}\nKB initialized. Start capturing with `/tome-forge capture`"

---

### `/tome-forge capture [text]`

Quick-capture a thought, link, or clipboard content into today's raw captures.

**Steps:**

1. Determine today's capture dir: `raw/captures/{YYYY-MM-DD}/`
2. Create dir if needed
3. Detect input type and route:
   - **URL** (starts with `http`): append to `raw/captures/{date}/links.md` as `- [url](url) — captured {HH:MM}`
   - **`clip`** (literal keyword): run clipboard read command (`xclip -selection clipboard -o` on Linux, `pbpaste` on macOS, `powershell.exe -command "Get-Clipboard"` on WSL/Windows), save to `raw/captures/{date}/clipboard-{HHMM}.md`
   - **Text** (anything else): append to `raw/captures/{date}/notes.md` under a `## {HH:MM}` heading
   - **No argument**: create/open `raw/captures/{date}/notes.md` and tell user to write there
4. Append to `logs/{YYYY-MM}.md`: `- [{date} {HH:MM}] **capture**: {brief summary}`

---

### `/tome-forge ingest <path> [--dry-run]`

Ingest raw material into wiki pages. This is the core compilation operation.

**Options:**
- `--dry-run`: show routing plan (which raw files → which wiki pages) without writing anything
- Append `!` to path for important content (e.g. `ingest raw/papers/key-paper.md!`) — uses Opus model

**Steps — read `references/operations.md` for the full ingest algorithm, then execute:**

1. Read the raw file(s) at `<path>` (file or directory)
2. Read `index.md` to understand existing wiki structure
3. For each raw file, determine which wiki pages to update or create (routing)
4. **If `--dry-run`**: display the routing plan and stop. Do not write any files.
5. For each target wiki page:
   a. If **update**: read existing page, save a copy of `## My Understanding Delta` content BEFORE merge
   b. Merge new information following the rules in `references/operations.md`
   c. If **create**: generate new page using the template from `references/schema-template.md`
   d. Set `compiled_by` in frontmatter to the current model ID (e.g. `claude-opus-4-6`)
6. **Delta verification** (critical): after writing each updated page, re-read it and compare `## My Understanding Delta` with the saved copy. If they differ at all, RESTORE the original Delta and report a warning.
7. Write updated/new wiki pages
8. Update `index.md` with any new pages
9. Append to `logs/{YYYY-MM}.md`
10. Report what was ingested and which wiki pages were affected

---

### `/tome-forge query <question>`

Query the knowledge base.

**Steps:**

1. Read `index.md` to understand wiki structure
2. Based on the question, identify relevant wiki pages from the index
3. Read those wiki pages (read multiple in parallel if independent)
4. Synthesize an answer using ONLY information from the wiki
5. Cite wiki page paths for every claim: `[wiki/ai/transformers.md]`
6. If information is insufficient, explicitly state:
   - What's missing
   - What raw material should be ingested to fill the gap
7. If the query produced a valuable synthesis, offer to save it as a new wiki page

---

### `/tome-forge lint`

Health-check the wiki for structural and content issues.

**Steps — read `references/operations.md` for the full lint checklist, then execute:**

1. Glob all `wiki/**/*.md` files
2. For each page, check:
   - YAML frontmatter present with required fields (domain, maturity, last_compiled, source_refs, confidence)
   - All required sections present (Core Concept, My Understanding Delta, Open Questions, Connections)
   - `[[links]]` point to existing wiki pages
   - `source_refs` point to existing raw files
   - My Understanding Delta is not empty (warn if so)
   - No `<!-- REVIEW: -->` comments left unresolved
3. Check `index.md` lists all wiki pages
4. Identify orphan pages (in wiki/ but not reachable from any `[[link]]` or `index.md`) — offer to move them to `wiki/_orphans/`
5. Report summary:
   ```
   Lint: X pages checked
   Errors: N (must fix)
   Warnings: N (should fix)
   Info: N (human action needed)
   ```
5. List each issue with file path and description

---

### `/tome-forge compile`

Batch compile: ingest all raw files added since last compile.

**Steps:**

1. Read `.last_compile` timestamp (if missing, treat all raw files as new)
2. Glob `raw/**/*.md` and filter to files newer than last compile
3. If no new files: report "Nothing to compile"
4. Otherwise, run the ingest operation (same as `/tome-forge ingest`) for each new file
5. After all ingests complete, run lint (`/tome-forge lint`)
6. Write current timestamp to `.last_compile`
7. Run `git add wiki/ index.md logs/` and report staged changes
8. Do NOT auto-commit — show the diff summary and let the user decide

---

## Report archival protocol (for other forge skills)

Other forge skills (`insight-fuse`, `council-fuse`, `news-fetch`) may archive their outputs into the KB as a follow-on step. The archival contract — filename scheme, required frontmatter, routing rules — is defined in [references/report-archival-protocol.md](./references/report-archival-protocol.md). Those skills read that file at runtime to emit compatible reports; tome-forge itself does not need to load it during normal operation. Cross-skill integration thus stays **opt-in and read-only** from tome-forge's perspective.

## Key Principles

1. **Raw Sources are immutable** — never modify files in `raw/`
2. **My Understanding Delta is sacred** — never delete or overwrite human insights
3. **Wiki is LLM-owned** — you maintain structure, cross-references, and consistency
4. **Index is the entry point** — always keep `index.md` up to date
5. **Log with rotation** — append to `logs/{YYYY-MM}.md`，按月自动轮转，避免单文件膨胀
6. **Cite sources** — every wiki claim traces back to `raw/` via `source_refs`
7. **Reports are first-class raw material** — `raw/reports/` files from other skills follow the same ingest pipeline, frontmatter metadata enables smarter routing

## Help Text (no arguments)

```
Tome Forge — Personal Knowledge Base Engine

Commands:
  /tome-forge init              Initialize KB (default: ~/.tome-forge/)
  /tome-forge capture [text]    Quick-capture note, link, or clipboard (clip)
  /tome-forge ingest <path>     Compile raw material into wiki
  /tome-forge ingest <path> --dry-run  Preview routing without writing
  /tome-forge query <question>  Search and synthesize from wiki
  /tome-forge lint              Health-check wiki structure
  /tome-forge compile           Batch compile all new raw materials

Tip: Run compile weekly for best wiki coherence. Avoid real-time ingest.

Based on Karpathy's LLM Wiki pattern. Zero dependencies.
```
