#!/bin/bash

# Define the maze executable and source file
maze_executable="./maze"
source_file="maze.c"

# Compile the maze game program
echo "Compiling the maze game..."
gcc -o $maze_executable $source_file
compile_status=$?
if [ $compile_status -ne 0 ]; then
    echo "Compilation failed."
    exit $compile_status
fi
echo "Compilation successful."

# Define directories
valid_dir="./valid"
invalid_dir="./invalid"

# Test valid mazes
echo -e "\n\n~~ Valid Maze Tests ~~"
for maze_file in "$valid_dir"/*.txt; do
    # Skip non-maze files and wall_hit files
    if [[ $maze_file == *"_success.txt" ]] || [[ $maze_file == *"_wall_hit.txt" ]] || [[ $maze_file == *"_bad_input.txt" ]]; then
        continue
    fi
    base_name=$(basename "$maze_file" .txt)

    # Testing successful navigation
    echo -n "Testing successful navigation for $base_name - "
    if [ -f "$valid_dir/${base_name}_success.txt" ]; then
        $maze_executable < "$valid_dir/${base_name}_success.txt" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "PASS"
        else
            echo "FAIL"
        fi
    else
        echo "No success input file found for $base_name"
    fi

    # Testing wall hit scenario
    echo -n "Testing wall hit for $base_name - "
    if [ -f "$valid_dir/${base_name}_wall_hit.txt" ]; then
        $maze_executable < "$valid_dir/${base_name}_wall_hit.txt" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "PASS"
        else
            echo "FAIL"
        fi
    else
        echo "No wall hit input file found for $base_name"
    fi
done

# Test invalid mazes
echo -e "\n\n~~ Invalid Maze Tests ~~"
for maze_file in "$invalid_dir"/*.txt; do
    echo -n "Testing $(basename "$maze_file") for proper error handling - "
    $maze_executable < "$maze_file" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "PASS"
    else
        echo "FAIL"
    fi
done

# Test bad user input
echo -e "\n\n~~ Bad User Input Test ~~"
# Now correctly referencing the bad input file
echo -n "Testing bad user input for 5_5.txt - "
if [ -f "$valid_dir/5_5_bad_input.txt" ]; then
    $maze_executable < "$valid_dir/5_5_bad_input.txt" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "PASS"
    else
        echo "FAIL"
    fi
else
    echo "No bad input file found for 5_5"
fi
