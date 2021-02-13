#!/usr/bin/env bash

set -e

# helper functions
_exit_if_empty() {
  local var_name=${1}
  local var_value=${2}
  if [ -z "$var_value" ]; then
    echo "Missing input $var_name" >&2
    exit 1
  fi
}

_get_full_image_name() {
  echo ${INPUT_REGISTRY:+$INPUT_REGISTRY/}${INPUT_IMAGE_NAME}
}

# action steps
check_required_input() {
  _exit_if_empty USERNAME "${INPUT_USERNAME}"
  _exit_if_empty PASSWORD "${INPUT_PASSWORD}"
  _exit_if_empty IMAGE_NAME "${INPUT_IMAGE_NAME}"
  _exit_if_empty IMAGE_TAG "${INPUT_IMAGE_TAG}"
}

login_to_registry() {
  decoded_password=$(echo "${INPUT_PASSWORD}" | base64 -d)
  echo "${decoded_password}" | docker login -u "${INPUT_USERNAME}" --password-stdin "${INPUT_REGISTRY}"
}

pull_cached_stages() {
  docker pull "$(_get_full_image_name)":cached 2> /dev/null || true
}

build_image() {
  # build image using cache
  set -x
  docker-compose \
    -f ${INPUT_CONTEXT}/${INPUT_DOCKERFILE} \
    build test
  docker tag deployment_test "$(_get_full_image_name)":${INPUT_IMAGE_TAG}
  set +x
}

push_stages() {
  # push the image itself as a stage (the last one)
  stage_image=$(_get_full_image_name):cached
  docker tag "$(_get_full_image_name)":${INPUT_IMAGE_TAG} $stage_image
  docker push $stage_image
}

logout_from_registry() {
  docker logout "${INPUT_REGISTRY}"
}

check_required_input
login_to_registry
pull_cached_stages
build_image
push_stages
logout_from_registry
