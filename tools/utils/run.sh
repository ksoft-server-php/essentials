#!/usr/bin/env bash

source "$(dirname "$0")/../utils/path.sh"
source "$(dirname "$0")/../config/config.sh"

if [[ ${SOURCED_RUN_UTIL:-} -ne 1 ]]; then
    readonly SOURCED_RUN_UTIL=1

    # Run tool script
    function run_tool() {
        local script_path=$(path_join "$DIR_TOOL_BIN" "${1}")
        shift
        local script_arguments=${@}

        "$script_path" $script_arguments
    }

    # Run vendor script
    function run_bin() {
        local script_path=$(path_join "$DIR_BIN" "${1}")
        shift
        local script_arguments=${@}

        "$script_path" $script_arguments
    }
fi
