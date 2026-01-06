#!/bin/sh
# Fix file permissions for media services
# This ensures SABnzbd downloads are accessible by Radarr/Sonarr

# Detect the shared group (users or media)
SHARED_GROUP="users"
if getent group media > /dev/null 2>&1; then
  SHARED_GROUP="media"
fi

echo "Using shared group: $SHARED_GROUP"
echo ""

# 1. Add all media service users to the shared group
echo "Adding service users to $SHARED_GROUP group..."
for user in sabnzbd radarr sonarr lidarr prowlarr; do
  if id "$user" > /dev/null 2>&1; then
    usermod -a -G "$SHARED_GROUP" "$user" 2>/dev/null && echo "  ✓ Added $user to $SHARED_GROUP" || echo "  ✗ Failed to add $user"
  fi
done
echo ""

# 2. Find download directories (common locations)
echo "Looking for download directories..."
DOWNLOAD_DIRS=""
for dir in "/mnt/Media/Downloads" "/mnt/Media/downloads" "/var/lib/sabnzbd/Downloads" "/home/sabnzbd/Downloads"; do
  if [ -d "$dir" ]; then
    DOWNLOAD_DIRS="$DOWNLOAD_DIRS $dir"
    echo "  Found: $dir"
  fi
done

if [ -z "$DOWNLOAD_DIRS" ]; then
  echo "  ⚠ No download directories found automatically"
  echo "  Please run this script with the download path:"
  echo "    $0 /path/to/downloads"
  exit 1
fi

# 3. Set group ownership and permissions on download directories
echo ""
echo "Setting group ownership and permissions..."
for dir in $DOWNLOAD_DIRS; do
  echo "  Processing: $dir"
  chgrp -R "$SHARED_GROUP" "$dir" 2>/dev/null && echo "    ✓ Set group ownership" || echo "    ✗ Failed to set group"
  
  # Set setgid bit on directories so new files inherit the group
  find "$dir" -type d -exec chmod g+s {} \; 2>/dev/null && echo "    ✓ Set setgid bit on directories" || echo "    ✗ Failed to set setgid"
  
  # Ensure directories are group-writable
  find "$dir" -type d -exec chmod g+w {} \; 2>/dev/null && echo "    ✓ Set group write on directories" || echo "    ✗ Failed to set group write"
  
  # Fix existing files to be group-readable/writable
  find "$dir" -type f -exec chmod g+rw {} \; 2>/dev/null && echo "    ✓ Set group read/write on files" || echo "    ✗ Failed to set file permissions"
done

echo ""
echo "Done! Restart SABnzbd:"
echo "  sudo systemctl restart sabnzbd"
echo ""
echo "Verify umask is set correctly:"
echo "  sudo systemctl show sabnzbd | grep UMask"

