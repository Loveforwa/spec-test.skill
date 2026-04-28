#!/usr/bin/env bash
# Build .skill bundles for both editions.
#
# Usage:
#   ./scripts/build-skills.sh            # build both editions
#   ./scripts/build-skills.sh zh         # build only the Chinese edition
#   ./scripts/build-skills.sh en         # build only the English edition
#
# Output: dist/spec-driven-test-zh.skill
#         dist/spec-driven-test-en.skill
#
# A .skill file is just a zip archive whose top-level entry is a folder
# named `spec-driven-test/`. Cowork / Claude Code's skill installer
# accepts these directly.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST_DIR="${REPO_ROOT}/dist"
mkdir -p "${DIST_DIR}"

build_edition() {
  local edition="$1"          # "zh" or "en"
  local src_dir="${REPO_ROOT}/${edition}"
  local out_file="${DIST_DIR}/spec-driven-test-${edition}.skill"

  if [[ ! -d "${src_dir}" ]]; then
    echo "  ✗ source directory not found: ${src_dir}" >&2
    exit 1
  fi

  # Stage the contents inside a folder named `spec-driven-test/` so the
  # archive extracts as `spec-driven-test/SKILL.md` etc. — matching the
  # convention every Claude skill bundle uses.
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "${tmp_dir}"' RETURN
  cp -R "${src_dir}" "${tmp_dir}/spec-driven-test"

  rm -f "${out_file}"
  ( cd "${tmp_dir}" && zip -rq "${out_file}" "spec-driven-test" )

  local count
  count=$(unzip -Z1 "${out_file}" | wc -l | tr -d ' ')
  local size
  size=$(du -h "${out_file}" | cut -f1)
  echo "  ✓ built ${out_file} (${count} entries, ${size})"
}

case "${1:-all}" in
  zh)  build_edition zh ;;
  en)  build_edition en ;;
  all) build_edition zh; build_edition en ;;
  *)
    echo "Usage: $0 [zh|en|all]" >&2
    exit 1
    ;;
esac

echo
echo "Done. Upload the .skill files in ${DIST_DIR}/ as assets to a GitHub Release."
