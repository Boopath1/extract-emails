#!/bin/bash

# Color variables
green='\033[0;32m'
blue='\033[0;34m'
nc='\033[0m'  # No Color

echo -e "${green}Made by Bobby (0xBobby)${nc}"

running_message() {
    echo -e "${blue}Running...¯\_(ツ)_/¯${nc}"
}

if [[ $1 == "-h" || $1 == "--help" ]]; then
    echo "Usage: ./mail.sh [filename] [outputfile]"
    echo "Extracts email addresses from a list of URLs."
    echo ""
    echo "Positional arguments:"
    echo "  filename     Name of the file containing URLs"
    echo "  outputfile   Name of the output file"
    exit 0
fi

if [[ $# -lt 2 ]]; then
    echo "Error: Invalid number of arguments."
    echo "Usage: ./mail.sh [filename] [outputfile]"
    exit 1
fi

filename=$1
outputfile=$2

# Temporary file to store unique emails
tempfile=$(mktemp)

# Read URLs from file and count total URLs
total_urls=$(wc -l < "$filename")

# Function to display progress bar
function show_progress() {
    local completed=$1
    local total=$2
    local width=50

    # Calculate percentage
    local percentage=$((completed * 100 / total))
    percentage=$((percentage > 100 ? 100 : percentage))  # Ensure percentage is not above 100

    # Calculate number of filled and empty slots
    local filled_slots=$((width * percentage / 100))
    local empty_slots=$((width - filled_slots))

    # Create progress bar string
    local progress_bar="["
    for ((i = 0; i < filled_slots; i++)); do
        progress_bar+="="
    done
    for ((i = 0; i < empty_slots; i++)); do
        progress_bar+=" "
    done
    progress_bar+="]"

    # Display progress
    echo -ne "Processing URL $completed of $total $progress_bar ($percentage%)\r"
}

# Function to handle errors
function handle_error() {
    echo -e "${red}An error occurred: $1${nc}"
    echo -e "${red}Exiting.${nc}"
    rm "$tempfile"  # Clean up temporary file
    exit 1
}

trap 'handle_error "Script interrupted."' INT

# Initialize progress variables
completed_urls=0

running_message  # Call the running_message function

while IFS= read -r url; do
    for path in / /contact /about /team /services /blog /index.html /home.html /contact.html /pricing /faq /careers /newsletter /subscribe; do
        ((completed_urls++))
        show_progress "$completed_urls" "$total_urls"

        # Make the request and extract emails
        email=$(curl -s "$url$path" | grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}')

        # Check if any email found
        if [ -n "$email" ]; then
            echo "$email" >> "$tempfile"
        fi
    done
done < "$filename"

# Remove duplicate emails and write to the output file
sort -u "$tempfile" > "$outputfile"

# Clean up temporary file
rm "$tempfile"

# Clear progress bar and display completion message
echo -ne "Processing URL $completed_urls of $total_urls"
echo -e "\n${green}Scan is completed - Happy Fuzzing${nc}"
