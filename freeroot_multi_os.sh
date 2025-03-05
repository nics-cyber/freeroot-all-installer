#!/bin/bash

# Embedded OS List (JSON format)
OS_LIST_JSON='{
  "operating_systems": [
    {
      "id": 1,
      "name": "Debian",
      "version": "11",
      "url": "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.0.0-amd64-netinst.iso",
      "checksum": "abc123..."
    },
    {
      "id": 2,
      "name": "Ubuntu",
      "version": "22.04",
      "url": "https://releases.ubuntu.com/22.04/ubuntu-22.04-live-server-amd64.iso",
      "checksum": "def456..."
    }
  ]
}'

# Check if jq is installed (for JSON parsing)
if ! command -v jq &> /dev/null; then
  echo "Error: 'jq' is required but not installed. Please install it and try again."
  exit 1
fi

# Function to display available OSes
list_os() {
  echo "Available Operating Systems:"
  echo "$OS_LIST_JSON" | jq -r '.operating_systems[] | "\(.id). \(.name) \(.version)"'
}

# Function to download OS image
download_os() {
  local os_id=$1
  local os_info=$(echo "$OS_LIST_JSON" | jq -r ".operating_systems[] | select(.id == $os_id)")
  local name=$(echo "$os_info" | jq -r '.name')
  local version=$(echo "$os_info" | jq -r '.version')
  local url=$(echo "$os_info" | jq -r '.url')
  local checksum=$(echo "$os_info" | jq -r '.checksum')
  local filename=$(basename "$url")

  echo "Downloading $name $version..."
  wget "$url" -O "$filename"

  echo "Verifying checksum..."
  # Remove the "sha256:" prefix from the checksum
  checksum=$(echo "$checksum" | sed 's/^sha256://')

  if echo "$checksum  $filename" | sha256sum --check; then
    echo "Checksum verified."
  else
    echo "Checksum verification failed!"
    exit 1
  fi
}

# Function to install OS
install_os() {
  local os_id=$1
  local os_info=$(echo "$OS_LIST_JSON" | jq -r ".operating_systems[] | select(.id == $os_id)")
  local name=$(echo "$os_info" | jq -r '.name')
  local version=$(echo "$os_info" | jq -r '.version')
  local filename=$(basename "$(echo "$os_info" | jq -r '.url')")

  echo "Starting installation of $name $version..."

  # Mount the ISO (example for Debian/Ubuntu)
  mkdir -p /mnt/iso
  mount -o loop "$filename" /mnt/iso

  # Run the installer (simplified example)
  echo "Running installer..."
  /mnt/iso/install

  # Cleanup
  umount /mnt/iso
  rmdir /mnt/iso

  echo "$name $version installation complete!"
}

# Main menu
echo "Welcome to FreeRoot Multi-OS Installer!"
list_os

# Prompt user to select an OS
read -p "Enter the ID of the OS you want to install: " os_choice
if ! echo "$OS_LIST_JSON" | jq -e ".operating_systems[] | select(.id == $os_choice)" &> /dev/null; then
  echo "Invalid selection!"
  exit 1
fi

# Download and install the selected OS
download_os "$os_choice"
install_os "$os_choice"
