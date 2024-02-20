#!/bin/bash

# Check if the file "terraform.tfstate" exists
if [ -f "terraform.tfstate" ]; then
  # If it exists, delete it
  echo "Deleting terraform.tfstate..."
  rm "terraform.tfstate"
else 
    echo "No state file "
elif [ -f "terraform.tfstate.backup" ]; then
    echo "Deleting the terraform.tfstate.backup..."
    rm "terraform.tfstate.backup"
else 
    echo "No statebackup file "
elif [ -f ".terraform.lock.hcl" ]; then
    echo "Deleting the .terraform.lock.hcl..."
    rm ".terraform.lock.hcl"
else
    echo "No lock file"
fi



