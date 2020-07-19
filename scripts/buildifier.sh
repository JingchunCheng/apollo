#!/usr/bin/env bash

###############################################################################
# Copyright 2019 The Apollo Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################
TOP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd -P)"
source ${TOP_DIR}/scripts/apollo.bashrc
# Ubuntu 16.04+ is required.
# Usage:
#   buildifier.sh <path/to/BUILD>
# Or
#  buildifier.sh <dir>

# Note(storypku): buildifier was pre-installed in our docker image.
BUILDIFIER_CMD="$(which buildifier)"
if [ -z "${BUILDIFIER_CMD}" ]; then
  error "Command 'buildifier' not found in your PATH."
  error "If installed, check your PATH settings."
  error "If not, please refer to https://github.com/bazelbuild/buildtools" \
        "on how to install it manually."
  exit 1
fi
# echo "Installing buildifier..."
# go get github.com/bazelbuild/buildtools/buildifier

FIRST_TARGET="$1"
# Format.
if [ -f "${FIRST_TARGET}" ]; then
  ${BUILDIFIER_CMD} -lint=fix $@
elif [ -d "${FIRST_TARGET}" ]; then
  #${BUILDIFIER_CMD} -r -lint=fix $@
  set -x
  find $@ -type f \
      \( -name "BUILD" -or -name "*.BUILD" -or -name "*.bzl" -or -name "*.bazel" \) \
      -exec ${BUILDIFIER_CMD} -lint=fix {} +
  set +x

else
  error "Bazel files or directories expected, got '${FIRST_TARGET}'"
  exit 1
fi

info "Done buildifier on $@."

