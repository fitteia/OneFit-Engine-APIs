#!/usr/bin/env bash

# Function to upload a file with optional parameters
fit() {
    local file function download logx="no" autox="yes" autoy="yes" logy="no"

    # Parse named parameters
    while getopts ":i:f:d:l:L:a:b:" opt; do
        case $opt in
            i) file="$OPTARG" ;;       # -i: Input data file path
            f) function="$OPTARG" ;;   # -f: Function
            d) download="$OPTARG" ;;   # -d: Download file name
            l) logx="$OPTARG" ;;       # -l: logx value (default: "no")
            L) logy="$OPTARG" ;;       # -L: logy value (default: "no")
            a) autox="$OPTARG" ;;      # -a: autox value (default: "yes")
            b) autoy="$OPTARG" ;;      # -b: autoy value (default: "yes")
            *) echo "Invalid option: -$OPTARG" >&2; return 1 ;;
        esac
    done

    # Check if required parameters are provided
    if [[ -z "$file" || -z "$function" ]]; then
        echo "Usage: fit -i <file> -f <function> [-d <download>]  [-l <logx>]  [-L <logy>] [-a <autox>] [-b <autoy>]"
        return 1
    fi

    # Build the curl command
    local curl_command="curl -F 'file=@$file' -F 'function=$function' -F 'logx=$logx' -F 'logy=$logy' -F 'autox=$autox' -F 'autoy=$autoy'"
    if [[ -n "$download" ]]; then
        curl_command+=" -F 'download=$download'"
    fi
    curl_command+=" http://192.92.147.107:8142/fit"

    # Execute the curl command
    eval "$curl_command"
}

# Function to upload a file with logx=yes
fit-logx() {
    # Call the fit function with logx="yes"
    fit -l "yes" "$@"
}

# Function to upload a file with a fixed function (a: one exponential) and logx=yes
fit-exp-logx() {
    # Call the fit function with function="a: one exponential" and logx="yes"
    fit -f "a: one exponential" -l "yes" "$@"
}
