#!/bin/bash
# .claude/hooks/inject-context.sh
# Injects git context (branch name, recent commits, status) into every prompt
# This hook runs on UserPromptSubmit event and adds contextual information

# Get git branch name
branch=$(git branch --show-current 2>/dev/null)

# Get 3 most recent commits with short format
commits=$(git log --oneline -3 2>/dev/null)

# Get git status summary (added, modified, deleted files)
status=$(git status --short 2>/dev/null | head -5)

# Build context message
context_parts=()

if [ -n "$branch" ]; then
  context_parts+=("Branch: $branch")
fi

if [ -n "$commits" ]; then
  context_parts+=("Recent commits:\n$commits")
fi

if [ -n "$status" ]; then
  context_parts+=("Changed files:\n$status")
fi

# If there's any context to inject, output it
if [ ${#context_parts[@]} -gt 0 ]; then
  echo "Injecting git context into prompt:"
  printf "%s\n" "${context_parts[@]}"
  echo ""
fi

exit 0
