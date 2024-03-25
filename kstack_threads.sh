#!/bin/bash

OUTPUT_DIR="/tmp/kstacks"      # Output directory where kernel stacks will be saved
SPLUNK_HOME="/opt/splunk"      # Splunk installation directory
SAMPLE_PERIOD=1                 # Sampling period in seconds

mkdir -p "$OUTPUT_DIR"          # Create output directory if it doesn't exist

while true; do
    pid=$(head -1 "$SPLUNK_HOME/var/run/splunk/splunkd.pid")  # Read splunkd PID from file
    threads=$(cat "/proc/$pid/status" | grep Threads | awk '{print $2}')  # Get number of threads
    
    # Check if number of threads is greater than 1000
    if [ "$threads" -gt 1000 ]; then
        timestamp=$(date +%Y-%m-%d_%H-%M-%S)  # Get current timestamp
        output_file="${OUTPUT_DIR}/kstacktrace_all.out"  # Output filename

        echo "Kernel Stack collection at ${timestamp}:" >> "$output_file"
        echo "" >> "$output_file"  # Add a blank line for separation

        # Loop through all running processes
        for i in $(ps auxww | awk '{print $2,$8}' | grep -v PID | awk '{print $1}'); do
            # Check if process ID is not empty
            if [ -n "$i" ]; then
                # Append process information and kernel stack to output file
                echo "Process Info (PID ${i}):" >> "$output_file"
                ps -fp "${i}" >> "$output_file"
                echo "Kernel Stack:" >> "$output_file"
                cat "/proc/${i}/stack" >> "$output_file"
                echo "" >> "$output_file"  # Add a blank line between each stack trace
            fi
        done
    fi
    sleep "$SAMPLE_PERIOD"
done
