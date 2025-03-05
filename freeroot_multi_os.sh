#!/bin/bash

# Embedded OS List (JSON format)
OS_LIST_JSON='{
  "operating_systems": [
    {
      "id": 1,
      "name": "Debian",
      "version": "11",
      "url": "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.0.0-amd64-netinst.iso",
      "checksum": "sha256:abc123..."
    },
    {
      "id": 2,
      "name": "Ubuntu",
      "version": "22.04",
      "url": "https://releases.ubuntu.com/22.04/ubuntu-22.04-live-server-amd64.iso",
      "checksum": "sha256:def456..."
    },
    {
      "id": 3,
      "name": "Arch Linux",
      "version": "latest",
      "url": "https://mirror.rackspace.com/archlinux/iso/latest/archlinux-2023.10.14-x86_64.iso",
      "checksum": "sha256:ghi789..."
    },
    {
      "id": 4,
      "name": "Fedora",
      "version": "38",
      "url": "https://download.fedoraproject.org/pub/fedora/linux/releases/38/Server/x86_64/iso/Fedora-Server-dvd-x86_64-38-1.6.iso",
      "checksum": "sha256:fedora_checksum_here"
    },
    {
      "id": 5,
      "name": "CentOS",
      "version": "9",
      "url": "https://isoredirect.centos.org/centos/9/isos/x86_64/CentOS-9-latest-x86_64-dvd1.iso",
      "checksum": "sha256:centos_checksum_here"
    },
    {
      "id": 6,
      "name": "openSUSE",
      "version": "Leap 15.4",
      "url": "https://download.opensuse.org/distribution/leap/15.4/iso/openSUSE-Leap-15.4-DVD-x86_64.iso",
      "checksum": "sha256:opensuse_checksum_here"
    },
    {
      "id": 7,
      "name": "Kali Linux",
      "version": "2023.3",
      "url": "https://cdimage.kali.org/kali-2023.3/kali-linux-2023.3-installer-amd64.iso",
      "checksum": "sha256:kali_checksum_here"
    },
    {
      "id": 8,
      "name": "Alpine Linux",
      "version": "3.18",
      "url": "https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/x86_64/alpine-standard-3.18.0-x86_64.iso",
      "checksum": "sha256:alpine_checksum_here"
    },
    {
      "id": 9,
      "name": "Gentoo",
      "version": "latest",
      "url": "https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/latest-install-amd64-minimal.iso",
      "checksum": "sha256:gentoo_checksum_here"
    },
    {
      "id": 10,
      "name": "FreeBSD",
      "version": "13.2",
      "url": "https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/13.2/FreeBSD-13.2-RELEASE-amd64-disc1.iso",
      "checksum": "sha256:freebsd_checksum_here"
    },
    {
      "id": 11,
      "name": "OpenBSD",
      "version": "7.3",
      "url": "https://cdn.openbsd.org/pub/OpenBSD/7.3/amd64/install73.iso",
      "checksum": "sha256:openbsd_checksum_here"
    },
    {
      "id": 12,
      "name": "NetBSD",
      "version": "9.3",
      "url": "https://cdn.netbsd.org/pub/NetBSD/NetBSD-9.3/images/NetBSD-9.3-amd64.iso",
      "checksum": "sha256:netbsd_checksum_here"
    },
    {
      "id": 13,
      "name": "Manjaro",
      "version": "22.1.0",
      "url": "https://download.manjaro.org/kde/22.1.0/manjaro-kde-22.1.0-230529-linux61.iso",
      "checksum": "sha256:manjaro_checksum_here"
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
  if echo "$checksum $filename" | sha256sum --check; then
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
