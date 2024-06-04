# EFI Backup (for Linux)

Something messed up my EFI partition on Debian Bookworm. I was able to
recover my user data luckily using a Live Linux CD but I want to have
a backup ready in case this happens again - also, I'll have a better
idea of when the change actually happened.

The strategy is to compute the SHA-256 hash of the EFI parition and if
there isn't already a file of that name then use dd to copy the entire
partition to a backup directory. The thinking is that the EFI
partition shouldn't be changing that much and we can manually manage the
backups if space becomes an issue. We also keep a small text log to
help keep track of the latest version in the rare case that it changes
and then changes back to a previous value.
