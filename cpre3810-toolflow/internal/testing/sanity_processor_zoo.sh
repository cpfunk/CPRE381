#!/usr/bin/env bash
set -euo pipefail

export TOOLFLOW_SKIP_TF_UPDATE=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ZOO_REPO="https://git.ece.iastate.edu/cpre3810-course/cpre3810-processor-zoo-riscv.git"

TMP_DIR="$(mktemp -d)"
ORIG_PROJ_BACKUP="${TMP_DIR}/orig_proj_backup"
ZOO_DIR="${TMP_DIR}/processor-zoo"
FAILURES=0

cleanup() {
  set +e
  rm -rf "${REPO_ROOT}/proj"
  if [[ -d "${ORIG_PROJ_BACKUP}" ]]; then
    mv "${ORIG_PROJ_BACKUP}" "${REPO_ROOT}/proj"
  fi
  rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

echo "Cloning processor zoo..."
AUTH_USER="oauth2"
AUTH_TOKEN="${PROCESSOR_ZOO_TOKEN:-}"
if [[ -z "${AUTH_TOKEN}" ]]; then
  echo "ERROR: No usable token found for processor zoo clone."
  echo "Set PROCESSOR_ZOO_TOKEN as an unprotected or protected CI variable, and verify it can read the processor-zoo project."
  echo "Check whether the token is exposed in this pipeline and whether the token's project/group membership includes cpre3810-processor-zoo-riscv."
  exit 2
fi

AUTH_B64="$(printf '%s:%s' "${AUTH_USER}" "${AUTH_TOKEN}" | base64 | tr -d '\n')"
if ! GIT_TERMINAL_PROMPT=0 git \
  -c http.extraHeader="Authorization: Basic ${AUTH_B64}" \
  clone "${ZOO_REPO}" "${ZOO_DIR}"; then
  echo "ERROR: Failed to clone processor zoo."
  echo "Check PROCESSOR_ZOO_TOKEN scope (read_repository) and project/group membership for cpre3810-processor-zoo-riscv."
  exit 128
fi

echo "Processor zoo commit: $(git -C "${ZOO_DIR}" rev-parse HEAD)"

if [[ -d "${REPO_ROOT}/proj" ]]; then
  mv "${REPO_ROOT}/proj" "${ORIG_PROJ_BACKUP}"
fi

run_case() {
  local proc_dir="$1"
  local expected="$2"   # pass|fail
  local name
  name="$(basename "${proc_dir}")"

  echo "==> Testing ${name} (expect: ${expected})"

  rm -rf "${REPO_ROOT}/proj"
  mkdir -p "${REPO_ROOT}/proj"
  cp -a "${proc_dir}/." "${REPO_ROOT}/proj/"

  local output clean_output
  output="$(
    cd "${REPO_ROOT}"
    printf 'n\n' | ./3810_tf.sh test proj/riscv/grendel.s 2>&1
  )" || true

  # Normalize output for reliable matching
  clean_output="$(sed -E 's/\x1B\[[0-9;]*[[:alpha:]]//g' <<< "${output}")"
  clean_output="${clean_output//$'\r'/}"

  if grep -Fq "Test Result: ${expected}" <<< "${clean_output}"; then
    echo "PASS: ${name}"
  else
    echo "FAIL: ${name} (missing 'Test Result: ${expected}')"
    echo "---- output ----"
    echo "${clean_output}" | tail -n 60
    echo "-----------------"
    FAILURES=$((FAILURES + 1))
  fi
}

while IFS= read -r -d '' d; do
  run_case "${d}" "pass"
done < <(find "${ZOO_DIR}/functional" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

while IFS= read -r -d '' d; do
  run_case "${d}" "fail"
done < <(find "${ZOO_DIR}/buggy" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

if [[ "${FAILURES}" -ne 0 ]]; then
  echo "Sanity suite failed: ${FAILURES} case(s)."
  exit 1
fi

echo "Sanity suite passed."