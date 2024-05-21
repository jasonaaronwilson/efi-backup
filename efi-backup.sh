#!/bin/bash

## I have a partial implementation of this but I'm not quite happy with it...
## EFI_PARTITION=$(./find_efi_partition.sh)

EFI_PARTITION=/dev/nvme0n1p1

BACKUP_DIR="$HOME/efi-backups"
LOG_FILE="$BACKUP_DIR/log.txt"

mkdir -p "$BACKUP_DIR"
touch $LOG_FILE
echo "======================================================================" | tee -a $LOG_FILE
date -Is | tee -a $LOG_FILE

# Calculate SHA-256 checksum
CHECKSUM=$(sudo sha256sum "$EFI_PARTITION" | awk '{print $1}')
BACKUP_FILE="$BACKUP_DIR/efi-backup-$CHECKSUM.img"
echo $CHECKSUM | tee -a $LOG_FILE

# Check if backup already exists
if [ -f "$BACKUP_FILE" ]; then
    echo "EFI partition unchanged. Skipping backup." | tee -a $LOG_FILE
else
    echo "Starting raw backup of EFI partition ($EFI_PARTITION)..." | tee -a $LOG_FILE
    sudo dd if="$EFI_PARTITION" of="$BACKUP_FILE" status=progress

    if [ $? -eq 0 ]; then
        echo "Raw backup successful!" | tee -a $LOG_FILE
        # find "$BACKUP_DIR" -type f -mtime +7 -exec rm {} \;  # Keep only last 7 days of backups
    else
        echo "Raw backup failed!" >&2 | tee -a $LOG_FILE
    fi
fi
