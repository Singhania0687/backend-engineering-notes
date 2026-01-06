#!/bin/bash


# ===============================
# Backup Script with Rotation
# Usage:
# ./backup.sh <source_dir> <backup_dir> <max_backups>
# ===============================

SOURCE_DIR=$1
BACKUP_DIR=$2
MAX_BACKUPS=$3



# ---- Validation ----
if [ $# -ne 3 ]; then
  echo "Usage: $0 <source_dir> <backup_dir> <max_backups>"
  exit 1
fi


