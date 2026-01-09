#!/usr/bin/env bash

################################################################################
# Script Name: script-template.sh
# Description: Production-ready Bash script template with best practices
# Author: José María Cabeza Rodríguez
# Version: 1.0.0
# License: Apache 2.0
################################################################################

#
# This template demonstrates best practices from the "Bash In Depth" guide:
# - Strict error handling
# - Proper argument parsing
# - Function organization
# - Clean exit handling
# - Logging utilities
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Script directory and name
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

# Default configuration
VERBOSE=false
DRY_RUN=false

################################################################################
# Utility Functions
################################################################################

# Print error message to stderr and exit
error() {
    echo "[ERROR] $*" >&2
    exit 1
}

# Print warning message to stderr
warn() {
    echo "[WARN] $*" >&2
}

# Print info message
info() {
    echo "[INFO] $*"
}

# Print debug message (only if verbose)
debug() {
    if [[ "${VERBOSE}" == true ]]; then
        echo "[DEBUG] $*" >&2
    fi
}

# Print usage information
usage() {
    cat << EOF
Usage: ${SCRIPT_NAME} [OPTIONS] <argument>

Production-ready Bash script template demonstrating best practices.

OPTIONS:
    -h, --help          Show this help message
    -v, --verbose       Enable verbose output
    -d, --dry-run       Show what would be done without executing
    -o, --output FILE   Specify output file (default: output.txt)

ARGUMENTS:
    <argument>          Required positional argument

EXAMPLES:
    ${SCRIPT_NAME} myfile.txt
    ${SCRIPT_NAME} --verbose --output result.txt input.txt
    ${SCRIPT_NAME} --dry-run myfile.txt

ENVIRONMENT VARIABLES:
    DEBUG              Set to enable debug mode

For more information, see: https://github.com/chemacabeza/my-github-projects

EOF
    exit 0
}

################################################################################
# Main Logic Functions
################################################################################

# Validate prerequisites
validate_environment() {
    debug "Validating environment..."

    # Check required commands
    local required_commands=("sed" "awk" "grep")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "${cmd}" &> /dev/null; then
            error "Required command '${cmd}' not found"
        fi
    done

    debug "Environment validation passed"
}

# Process the main task
process_task() {
    local input_file="$1"
    local output_file="${2:-output.txt}"

    info "Processing: ${input_file}"
    debug "Output will be written to: ${output_file}"

    # Check if input file exists
    if [[ ! -f "${input_file}" ]]; then
        error "Input file not found: ${input_file}"
    fi

    if [[ "${DRY_RUN}" == true ]]; then
        info "[DRY RUN] Would process ${input_file} → ${output_file}"
        return 0
    fi

    # Example processing (modify this for your needs)
    {
        echo "# Processed: $(date)"
        echo "# Source: ${input_file}"
        echo "---"
        cat "${input_file}"
    } > "${output_file}"

    info "Successfully processed ${input_file}"
    info "Output saved to: ${output_file}"
}

# Cleanup function (called on exit)
cleanup() {
    local exit_code=$?
    debug "Cleaning up... (exit code: ${exit_code})"

    # Add cleanup tasks here (remove temp files, etc.)

    if [[ ${exit_code} -eq 0 ]]; then
        debug "Script completed successfully"
    else
        warn "Script exited with error code: ${exit_code}"
    fi
}

################################################################################
# Argument Parsing
################################################################################

parse_arguments() {
    local output_file="output.txt"
    local input_file=""

    # Parse options
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage
                ;;
            -v|--verbose)
                VERBOSE=true
                debug "Verbose mode enabled"
                shift
                ;;
            -d|--dry-run)
                DRY_RUN=true
                info "Dry run mode enabled"
                shift
                ;;
            -o|--output)
                if [[ -z "${2:-}" ]]; then
                    error "Option --output requires an argument"
                fi
                output_file="$2"
                shift 2
                ;;
            -*)
                error "Unknown option: $1"
                ;;
            *)
                # Positional argument
                if [[ -z "${input_file}" ]]; then
                    input_file="$1"
                else
                    error "Too many arguments. Expected one positional argument."
                fi
                shift
                ;;
        esac
    done

    # Validate required arguments
    if [[ -z "${input_file}" ]]; then
        error "Missing required argument: <argument>"
    fi

    # Process the task with parsed arguments
    process_task "${input_file}" "${output_file}"
}

################################################################################
# Main Entry Point
################################################################################

main() {
    # Set up cleanup trap
    trap cleanup EXIT

    # Enable debug mode if DEBUG env var is set
    if [[ -n "${DEBUG:-}" ]]; then
        VERBOSE=true
        set -x
    fi

    info "Starting ${SCRIPT_NAME}..."

    # Validate environment
    validate_environment

    # Parse and execute
    parse_arguments "$@"

    info "Completed successfully!"
}

# Run main function with all arguments
main "$@"
