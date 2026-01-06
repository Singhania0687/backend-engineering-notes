# ✅ TASK 1 — Backup Script (Production-style)



### Automates directory backups with compression and rotation.

### Features
- Timestamped backups
- Automatic cleanup of old backups
- Configurable retention count

### Usage
```bash
./backup.sh <source_dir> <backup_dir> <max_backups>



```
📂 Location:
scripts/backup/backup.sh

```

## Problem statement :- 
---
Write a bash script that:
- Takes a source directory
- Compresses it
- Stores it in a backup directory
- Appends timestamp to the filename
- Keeps only last N backups (older ones deleted)

---

## Expected concepts to practice

* tar
* date
* positional arguments $1 $2
* loops
* condition checking
* exit codes

---

## I wrote a shell script to automate backups with rotation logic.
