#!/bin/bash
# Get current year and month
CURRENT_YEAR=$(date +"%Y")
CURRENT_MONTH=$(date +"%m")

# Calculate previous month and year
if [ "$CURRENT_MONTH" -eq 1 ]; then
    PREVIOUS_MONTH=12
    PREVIOUS_YEAR=$((CURRENT_YEAR - 1))
else
    PREVIOUS_MONTH=$((CURRENT_MONTH - 1))
    PREVIOUS_YEAR=$CURRENT_YEAR
fi

YEAR=$PREVIOUS_YEAR
MONTH=$PREVIOUS_MONTH

# Directory where logs are stored (change this to your log directory)
LOG_DIR="/home/jigx/Desktop/log/$YEAR/$MONTH"


# Check if log directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Log directory $LOG_DIR not found."
    exit 1
fi

# Backup directory (change this to your backup directory)
BACKUP_DIR="/home/jigx/Desktop/backup/$YEAR/$MONTH"


echo backup log from $LOG_DIR to $BACKUP_DIR

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Check if backup directory creation was successful
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: Failed to create backup directory $BACKUP_DIR."
    exit 1
fi

# Go to the log directory
cd "$LOG_DIR"

# List the files in the log directory (or modify to copy them)
ls -l

original_file_count=0
backup_file_count=0

# Encrypt and compress each file in the directory, then move to backup folder
for file in *; do
    if [ -f "$file" ]; then

        ((original_file_count++))

        # Encrypt the file (Replace 'encryption_command' with your encryption tool and options)
        # Example: openssl enc -aes-256-cbc -salt -in "$file" -out "${file}.enc" -pass pass:YourPassword
        #encryption_command "$file" "${file}.enc"

        # Compress the encrypted file
        gzip "${file}"

        # Move to backup directory
        mv "${file}.gz" "$BACKUP_DIR/"
        ((backup_file_count++))

        # Delete the original file
        rm -rf "$file"
    fi
done

echo "Backup process completed."
echo "Number of original files processed: $original_file_count"
echo "Number of backup files created: $backup_file_count"

# If you want to copy the files to the backup directory, uncomment the following line:
# cp *.log "$BACKUP_DIR/"

