#!/usr/bin/env bash
# Cloud Agent Build hook. Fetches project skills into .cursor/skills (gitignored).
# Discover ids via the public GitHub contents API, then GET each SKILL.md from
# raw.githubusercontent.com. Never clones. Never writes ~/.cursor/skills.
# Fetch failures warn on stderr and continue; always exit 0 so the Build succeeds.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SKILLS_DIR="${ROOT}/.cursor/skills"

PLUGIN_OWNER="bowerbird-app"
PLUGIN_REPO="RecordingStudio_cursor_plugin"
PLUGIN_REF="main"
PLUGIN_CONTENTS_API="https://api.github.com/repos/${PLUGIN_OWNER}/${PLUGIN_REPO}/contents/skills?ref=${PLUGIN_REF}&per_page=100"
PLUGIN_RAW="https://raw.githubusercontent.com/${PLUGIN_OWNER}/${PLUGIN_REPO}/${PLUGIN_REF}/skills"
PSTACK_RAW="https://raw.githubusercontent.com/cursor/plugins/main/pstack/skills"
USER_AGENT="RecordingStudio-gem-template-fetch-skills"
SKIP_ID="add-skill-or-agent"

warn() {
  printf 'fetch-skills: %s\n' "$*" >&2
}

mkdir -p "${SKILLS_DIR}"

fetch_raw() {
  local dest_id="$1"
  local url="$2"
  local dest_dir="${SKILLS_DIR}/${dest_id}"
  local tmp

  mkdir -p "${dest_dir}"
  tmp="$(mktemp "${dest_dir}/.SKILL.md.XXXXXX")" || {
    warn "could not create temp file for ${dest_id}"
    return 0
  }

  if curl -fsSL --retry 2 --retry-delay 1 -A "${USER_AGENT}" -o "${tmp}" "${url}" && [[ -s "${tmp}" ]]; then
    mv -f "${tmp}" "${dest_dir}/SKILL.md"
  else
    warn "failed to fetch ${dest_id} from ${url}"
    rm -f "${tmp}"
  fi
}

list_plugin_skill_ids() {
  local json
  json="$(curl -fsSL --retry 2 --retry-delay 1 -A "${USER_AGENT}" \
    -H "Accept: application/vnd.github+json" \
    "${PLUGIN_CONTENTS_API}")" || {
    warn "failed to list skills from GitHub contents API"
    return 0
  }

  if ! command -v python3 >/dev/null 2>&1; then
    warn "python3 not found; cannot parse skill list"
    return 0
  fi

  printf '%s' "${json}" | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)
if not isinstance(data, list):
    sys.exit(0)
for item in data:
    if not isinstance(item, dict):
        continue
    if item.get("type") != "dir":
        continue
    name = item.get("name") or ""
    if name.startswith("recording-studio-"):
        print(name)
'
}

while IFS= read -r skill_id; do
  [[ -z "${skill_id}" ]] && continue
  [[ "${skill_id}" == "${SKIP_ID}" ]] && continue
  fetch_raw "${skill_id}" "${PLUGIN_RAW}/${skill_id}/SKILL.md"
done < <(list_plugin_skill_ids)

fetch_raw "poteto-mode" "${PSTACK_RAW}/poteto-mode/SKILL.md"

exit 0
