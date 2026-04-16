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
---

# Tome Forge — Personal Knowledge Base Engine

Based on Karpathy's LLM Wiki pattern: raw materials + LLM compilation = structured Markdown wiki. No RAG, no vector DB, no infra. Zero dependencies.

## Auto-activation (hookless environments)

In platforms without a hook system, activate Tome Forge mode when:
1. User says "initialize knowledge base", "start a wiki", "set up KB"
2. User says "ingest this", "add to my KB", "compile my notes"
3. User says "search my KB", "what do I know about X"
4. User explicitly calls `/tome-forge`

## KB Discovery

Before executing any sub-command, determine the KB root directory:

1. Walk up from the current working directory looking for `.tome-forge.json`
2. If found → the directory containing it is the KB root
3. If not found → use `~/.tome-forge/` (auto-create if needed and command is not `init`)

Report resolved KB root at the start of every operation.

## Sub-commands

Parse the user's input to determine which operation to run.

### init

Initialize a knowledge base in the current directory.

1. Create directories: `raw/captures/`, `raw/papers/`, `raw/articles/`, `raw/books/`, `raw/conversations/`, `wiki/`, `wiki/_orphans/`
2. Write `CLAUDE.md` with the schema template (see `references/schema-template.md`)
3. Write empty `index.md`, create `logs/` directory and `logs/{YYYY-MM}.md`, write `.tome-forge.json`
4. Write `.gitignore`
5. Initialize git if needed

### capture [text]

Quick-capture into `raw/captures/{YYYY-MM-DD}/`.

- URL input: append to `links.md`
- `clip` keyword: read system clipboard, save to `clipboard-{HHMM}.md`
- Text input: append to `notes.md` under `## {HH:MM}` heading
- Always append to `logs/{YYYY-MM}.md` (monthly rotation)

### ingest <path> [--dry-run]

Core compilation operation. Read `references/operations.md` for the full algorithm.

- `--dry-run`: show routing plan without writing
- Append `!` to path for important content (uses stronger model)

1. Read raw file(s)
2. Read `index.md` for existing structure
3. Route: determine which wiki pages to update or create
4. If `--dry-run`: display plan and stop
5. For updates: save My Understanding Delta BEFORE merge
6. Compile: merge/create pages, set `compiled_by` in frontmatter
7. **Delta verification**: diff new Delta vs saved copy, auto-restore if changed
8. Update `index.md`
9. Append to `logs/{YYYY-MM}.md`

**CRITICAL RULES:**
- NEVER modify files in `raw/`
- NEVER delete or overwrite `## My Understanding Delta`
- NEVER convert Open Questions into answers without new evidence

### query <question>

1. Read `index.md` to locate relevant pages
2. Read those pages
3. Synthesize answer citing wiki paths
4. If insufficient: state what raw material is needed

### lint

Health-check all wiki pages. See `references/operations.md` for the full checklist.

Check: frontmatter fields, required sections, broken links, stale source_refs, empty My Understanding Delta, unresolved REVIEW comments.

Report: errors (must fix), warnings (should fix), info (human action needed).

### compile

Batch ingest all raw files since last compile.

1. Check `.last_compile` timestamp
2. Find new raw files
3. Ingest each one
4. Run lint
5. Update `.last_compile`
6. Stage changes in git (do NOT auto-commit)

## Help (no arguments)

```
Tome Forge — Personal Knowledge Base Engine

Commands:
  /tome-forge init              Initialize KB in current directory
  /tome-forge capture [text]    Quick-capture a note or link
  /tome-forge ingest <path>     Compile raw material into wiki
  /tome-forge query <question>  Search and synthesize from wiki
  /tome-forge lint              Health-check wiki structure
  /tome-forge compile           Batch compile all new raw materials
```
