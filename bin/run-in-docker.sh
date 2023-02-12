#!/usr/bin/env bash

TOP=$(dirname "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )")

TEMP_DIR=${TEMP_DIR:-/tmp/exercism}
DOCKER_TAG=${DOCKER_TAG:-latest}
DOCKER_IMAGE=${DOCKER_IMAGE:-exercism/ocaml-test-runner:${DOCKER_TAG}}

test  "${DOCKER_PULL:-false}" = true && docker pull "${DOCKER_IMAGE}"

run_test() {
  local slug=${1}
  local local_path="${TOP}/exercises/practice/${slug}"
  local out_path=$(mktemp -d "/tmp/exercism/${slug}.XXXXXXXXXX")

  rsync -a "${local_path}"/ "${out_path}"
  cp "${out_path}/.meta/example.ml" "${out_path}/${slug//-/_}.ml"

  docker run \
    --rm \
    --network none \
    --read-only \
    --mount type=bind,src="${out_path},dst=${out_path}" \
    --mount type=tmpfs,dst=/tmp \
    --workdir /opt/test-runner \
    "${DOCKER_IMAGE}" \
    "${slug}" "${out_path}" "${out_path}"

  test "$(jq -r .status "${out_path}/results.json")" = "pass"
  exit_code=$?

  test "${exit_code}" -ne 0 && cat "${out_path}/results.json"

  # The test runs as root, and creates files a normal user cannot delete
  # Since we don't know if we have sudo, use docker as a way to cleanup.
  docker run \
    --rm \
    --network none \
    --mount type=bind,src=/tmp/exercism,dst=/tmp/exercism \
    busybox:latest \
    rm -rf "${out_path:?Ensuring out_path is set before we attempt to delete anything}"

  return "${exit_code}"
}

help() {
echo
cat - << EOF
$(basename "$0") <exercise slug> - Run the excerise test suite as it would run in production

Exits 0 if tests succede and non-zero other wise.

Environment Variables:
TEMP_DIR - Directory to execute the test and write data to.
  default = "${TEMP_DIR}"

DOCKER_PULL - Should docker force pull the image from upstream even if exists locally?
  default = "${DOCKER_PULL}"

DOCKER_IMAGE - The full docker image name and tag to execute as.
  default = "${DOCKER_IMAGE}"

DOCKER_TAG - Just tag part of a docker image name. Ignored if DOCKER_IMAGE is set.
  default = "${DOCKER_TAG}"
EOF

[ "${1}" != "" ] && echo && echo "${1}"

exit 1
}

while getopts 'h' opt; do
  case "${opt}" in
    ?|h)
      help
      ;;
  esac
done


run_test "${1:?"$(help "ERROR: positional argument <slug> required")"}"
