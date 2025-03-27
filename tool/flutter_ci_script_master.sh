#!/bin/bash

set -e

DIR="${BASH_SOURCE%/*}"
source "$DIR/flutter_ci_script_shared.sh"

flutter doctor -v

declare -ar PROJECT_NAMES=(
    "green_thumb_cloud_next_25"
)

ci_projects "master" "${PROJECT_NAMES[@]}"

echo "-- Success --"
