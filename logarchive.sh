```bash
#!/bin/bash

# ==========================================================
# Log Archive Tool
# Archives /var/log into compressed .tar.gz files
# Designed for Amazon Linux / Ubuntu EC2
# ==========================================================

LOG_DIR="/var/log"
ARCHIVE_DIR="/var/log/archive"

# Create archive directory if it doesn't exist
mkdir -p "$ARCHIVE_DIR"

# Generate timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Archive file name
ARCHIVE_FILE="$ARCHIVE_DIR/logs_$TIMESTAMP.tar.gz"

echo "=============================================="
echo "          LOG ARCHIVE TOOL"
echo "=============================================="

echo "Log directory     : $LOG_DIR"
echo "Archive directory : $ARCHIVE_DIR"
echo "Archive file      : $ARCHIVE_FILE"
echo "=============================================="

# Check whether log directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "ERROR: Log directory $LOG_DIR does not exist."
    exit 1
fi

# Create compressed archive
echo "Creating log archive..."

tar -czf "$ARCHIVE_FILE" \
    --exclude="$ARCHIVE_DIR" \
    "$LOG_DIR"/* 2>/dev/null

# Check whether archive was created successfully
if [ $? -eq 0 ]; then
    echo
    echo "Log archive created successfully!"
    echo "Archive: $ARCHIVE_FILE"
else
    echo
    echo "ERROR: Failed to create log archive."
    exit 1
fi

# Display archive size
echo
echo "Archive size:"
du -h "$ARCHIVE_FILE"

echo
echo "=============================================="
echo "           ARCHIVING COMPLETED"
echo "=============================================="
```
