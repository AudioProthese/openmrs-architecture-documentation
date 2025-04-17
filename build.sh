#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined variables, and pipeline failures

# ======================
# CONFIGURATION
# ======================
INPUT_FILE="${1:-src/TAD_Template.md}"       # Allow input file override
OUTPUT_DIR="${2:-output}"                   # Allow output directory override
TEMPLATE_PATH="${3:-template/eisvogel.latex}" # Allow template override
FILTER_NAME="pandoc-latex-environment"
OUTPUT_FILE="${OUTPUT_DIR}/$(basename "${INPUT_FILE%.md}.pdf")"

# ======================
# DEPENDENCY CHECKS
# ======================
check_dependency() {
  if ! command -v "$1" &> /dev/null; then
    echo "❌ Error: Required command '$1' not found" >&2
    exit 1
  fi
}

check_dependency pandoc
check_dependency realpath

# ======================
# FILE VALIDATION
# ======================
[ -f "${INPUT_FILE}" ] || {
  echo "❌ Error: Input file '${INPUT_FILE}' not found" >&2
  exit 1
}

[ -f "${TEMPLATE_PATH}" ] || {
  echo "❌ Error: Template file '${TEMPLATE_PATH}' not found" >&2
  exit 1
}

# ======================
# MAIN PROCESSING
# ======================
echo "🔨 Building PDF from ${INPUT_FILE}..."
mkdir -p "${OUTPUT_DIR}"

pandoc "${INPUT_FILE}" \
  --from markdown \
  --template "${TEMPLATE_PATH}" \
  --filter "${FILTER_NAME}" \
  --listings \
  --verbose \
  -o "${OUTPUT_FILE}"

# ======================
# POST-VALIDATION
# ======================
if [ ! -f "${OUTPUT_FILE}" ]; then
  echo "❌ Error: Output file generation failed" >&2
  exit 1
fi

echo -e "\n✅ Success! PDF generated at:"
realpath "${OUTPUT_FILE}"
