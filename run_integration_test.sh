#!/bin/bash

# Initialize counters
success_count=0
fail_count=0

# Create a directory to store failure logs
mkdir -p failure_logs

# Define the log file
log_file="test_results.log"

# Run tests in an infinite loop until the terminal is terminated
while true; do
  echo "Running tests..."
  output=$(flutter test integration_test 2>&1)
  if [[ $output == *"All tests passed"* ]]; then
    echo "Test: Success"
    ((success_count++))
  else
    echo "Test: Fail"
    ((fail_count++))
    # Save the failure reason to a file
    echo "$output" > "failure_logs/failure_$fail_count.log"
  fi

  # Save results to the log file
  echo "Total Success: $success_count" > "$log_file"
  echo "Total Fail: $fail_count" >> "$log_file"

  # Print the results to the console
  cat "$log_file"
done
