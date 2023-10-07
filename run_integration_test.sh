#!/bin/bash

# Initialize counters
success_count=0
fail_count=0
running_number=100
# Create a directory to store failure logs
mkdir -p failure_logs

# Define the log file
log_file="test_results.log"

# Loop 100 times
for ((i=1; i<=running_number; i++)); do
  echo "Running test $i..."
  output=$(flutter test integration_test 2>&1)
  if [[ $output == *"All tests passed"* ]]; then
    echo "Test $i: Success"
    ((success_count++))
  else
    echo "Test $i: Fail"
    ((fail_count++))
    # Save the failure reason to a file
    echo "$output" > "failure_logs/failure_$i.log"
  fi
done

# Save results to the log file
echo "Total Success: $success_count" >> "$log_file"
echo "Total Fail: $fail_count" >> "$log_file"

# Print the results to the console
cat "$log_file"
