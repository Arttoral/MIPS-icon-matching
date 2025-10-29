#!/bin/bash

# Set the paths and filenames for the source code and compiled executable
source_code="P1-1.c"        # Replace with your actual source code file
executable="P1-1"           # Replace with your desired executable name

# Compiler and compiler flags (modify this if you're using a different language)
compiler="gcc"                         # Replace with your compiler (e.g., gcc, g++, javac, etc.)
compiler_flags="-Wall -g -o $executable"       # Replace with your desired compiler flags

test_output_0="The matching icon is 0"
test_output_3="The matching icon is 3"
test_output_4="The matching icon is 4"
test_output_5="The matching icon is 5"
test_output_7="The matching icon is 7"

# Test files folder
tests_folder="tests"               # Folder name containing the test files

# Function to compile the code
compile_code() {
    $compiler $compiler_flags $source_code
}

# Function to run the compiled executable with a test file
run_code() {
    ./$executable "$1" > program_output.txt
}

# Function to compare the program output with the test output
compare_output() {
    local expected_output="test_output_$test_label"
    local program_output=$(cat program_output.txt)

    echo "---- Test $test_label ----"
    echo "Expected Output:"
    echo "${!expected_output}"
    echo "Program Output:"
    echo "$program_output"

    if [ "$program_output" = "${!expected_output}" ]; then
        echo "Test $test_label passed! Output matches the expected test output."
    else
        echo "Test $test_label failed! Output does not match the expected test output."
    fi
}

# Main execution starts here
if [ $(grep -c "DEBUG" $source_code) -eq 0 -o $(grep -c "DEBUG 0" $source_code) -eq 1 ]
then
    rm -f log.out # this removes the previous log file
    compile_code
    if [ $? -eq 0 ]; then
	echo "Code compiled successfully!"
	for test_file in "$tests_folder"/test*.txt; do
            test_label=$(basename "$test_file" | sed 's/[^0-9]//g')
	    echo " "
            echo "Running Test $test_label ..." | tee -a log.out
            run_code "$test_file" | tee -a log.out # Run the executable
            compare_output "$test_label" | tee -a log.out # Check if it passed
	    echo " "
	    echo "These tests do not represent the complete set of tests that will be run to grade your code." | tee -a log.out
	done
    else
	echo "Compilation failed. Please check your source code."
    fi
else
    echo "Reset the DEBUG flag to 0!"
fi


# Cleanup temporary files
rm -f program_output.txt $executable
