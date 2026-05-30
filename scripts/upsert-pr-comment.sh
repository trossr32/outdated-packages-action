#!/usr/bin/env bash
#
# Create or update a pull request comment, identified by a hidden marker so
# re-runs update the existing comment instead of adding a new one (mirrors the
# behaviour of thollander/actions-comment-pull-request's comment-tag).
#
# Usage: upsert-pr-comment.sh <comment-tag> <body-file>
#
# Required environment:
#   GH_TOKEN          token with pull-requests: write (e.g. ${{ github.token }})
#   GITHUB_REPOSITORY owner/repo (provided automatically by GitHub Actions)
#   PR_NUMBER         the pull request number to comment on
#
set -eu

TAG="$1"
BODY_FILE="$2"
MARKER="<!-- outdated-packages-action:${TAG} -->"

if [ -z "${PR_NUMBER:-}" ]; then
  echo "PR_NUMBER is not set; this action only supports pull request events." >&2
  exit 1
fi

# Compose the comment body: hidden marker followed by the rendered markdown.
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
{ printf '%s\n\n' "$MARKER"; cat "$BODY_FILE"; } > "$tmp"

# Find an existing comment carrying our marker. Pipe gh's JSON to jq with the
# marker passed via --arg, so tags containing slashes/spaces/etc are matched
# literally without any quoting or injection concerns.
existing_id="$(gh api --paginate \
  "repos/${GITHUB_REPOSITORY}/issues/${PR_NUMBER}/comments?per_page=100" \
  | jq -r --arg marker "$MARKER" '.[] | select(.body | contains($marker)) | .id' | head -n1)"

if [ -n "$existing_id" ]; then
  gh api --method PATCH \
    "repos/${GITHUB_REPOSITORY}/issues/comments/${existing_id}" \
    -F body=@"$tmp" >/dev/null
  echo "Updated existing comment ${existing_id} (tag: ${TAG})."
else
  gh api --method POST \
    "repos/${GITHUB_REPOSITORY}/issues/${PR_NUMBER}/comments" \
    -F body=@"$tmp" >/dev/null
  echo "Created new comment (tag: ${TAG})."
fi
