#!/bin/bash

# Copyright 2024 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Run gofmt, govet, and golint on all go files in the repo.

set -o errexit
set -o nounset
set -o pipefail

PROJ_ROOT=$(git rev-parse --show-toplevel)
# Ensure that gopath is in the path
PATH=$PATH:$GOPATH/bin

if ! command -v golint &> /dev/null; then
  go install golang.org/x/lint/golint@latest
fi

cd "${PROJ_ROOT}"

# Run gofmt against all go files
echo "Running gofmt..."
gofmt -l -s $(find . -type f -name '*.go')
if [[ -n $(gofmt -l -s $(find . -type f -name '*.go')) ]]; then 
    echo "gofmt check failed on the above files."
    exit 1
fi

# Run go vet against all go files
echo "Running go vet..."
go vet ./...

# Run golint against all go files
echo "Running golint..."
golint -set_exit_status ./...