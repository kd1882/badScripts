#!/bin/bash

# Check if directory name is provided as an argument
if [ -z "$1" ]
  then
    echo "Please provide a directory name"
else
  # Create the directory
  mkdir $1
  cd $1

  # Create empty files using 'touch' command
  touch index.html style.css script.js .gitignore
  mkdir assets resources
  # Output success message
  echo "Files created successfully"
fi
