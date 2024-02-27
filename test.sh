#!/bin/bash

# Compile the maze game program
echo "Compiling the maze game..."
gcc -o maze maze.c
if [ $? -ne 0 ]; then
    echo "Compilation failed."
    exit 1
fi
echo "Compilation successful."

    // This test is adapted from chatGPT’s response to the prompt ‘Give me an idea as to how I would tackle the structuring of my tests’

# Test valid mazes
echo -e "\n\n~~ Valid Maze Tests ~~"
valid_dir="./valid"
for maze_file in $valid_dir/*.txt; do
    
    if [[ $maze_file == *"_success.txt" ]] || [[ $maze_file == *"_wall_hit.txt" ]]; then
        continue
    fi
    base_name=$(basename "$maze_file" .txt)
    input_file_success="${valid_dir}/${base_name}_success.txt"
    input_file_wall_hit="${valid_dir}/${base_name}_wall_hit.txt"

    # Testing successful navigation
    echo -n "Testing successful navigation for $base_name - "
    ./maze < "$input_file_success" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "PASS"
    else
        echo "FAIL"
    fi

    # Testing wall hit scenario
    if [ -f "$input_file_wall_hit" ]; then
        echo -n "Testing wall hit for $base_name - "
        ./maze < "$input_file_wall_hit" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "PASS"
        else
            echo "FAIL"
        fi
    fi
done

// This test is adapted from chatGPT’s response to the prompt ‘Give me an idea as to how I would tackle testing my invalid files’

# Test invalid mazes
echo -e "\n\n~~ Invalid Maze Tests ~~"
invalid_dir="./invalid"
for maze_file in $invalid_dir/*.txt; do
    base_name=$(basename "$maze_file" .txt)
    echo -n "Testing $base_name for proper error handling - "
    ./maze < "$maze_file" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "PASS (Error detected)"
    else
        echo "FAIL (Error not detected)"
    fi
done
