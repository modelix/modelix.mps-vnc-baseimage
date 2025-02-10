#!/bin/bash
set -e

# There is only a linux distribution of MPS for amd64.
# This script replaces the bundled JBR with the arm version.

JBR_ARCHIVE="/jbr.tar.gz"

function tryDownloadJbr() {
  # Get the system architecture
  OS_ARCH=$(uname -m)
  if [ "$OS_ARCH" = "arm64" ]; then
      OS_ARCH="aarch64"
  fi

  # Only proceed if the architecture is aarch64
  if [ "$OS_ARCH" != "aarch64" ]; then
      echo "Skipping download and extraction: Architecture is not aarch64."
      return 1
  fi

  # Read the release file
  RELEASE_FILE="/mps/jbr/release"
  if [ ! -f "$RELEASE_FILE" ]; then
      echo "Error: release file not found!"
      return 1
  fi

  # Read version from "release" file
  IMPLEMENTOR_VERSION=$(grep '^IMPLEMENTOR_VERSION=' "$RELEASE_FILE" | cut -d'=' -f2 | tr -d '"')
  JAVA_VERSION=$(grep '^JAVA_VERSION=' "$RELEASE_FILE" | cut -d'=' -f2 | tr -d '"')
  JAVA_MAJOR_VERSION=$(echo "$JAVA_VERSION" | cut -d'.' -f1)
  OS_NAME=$(grep '^OS_NAME=' "$RELEASE_FILE" | cut -d'=' -f2 | tr -d '"' | tr '[:upper:]' '[:lower:]')

  # Use regex to capture BUILD_NUMBER
  if [[ $IMPLEMENTOR_VERSION =~ .*[0-9]+\.[0-9]+\.[0-9]+.*?-b?([0-9]+\.[0-9]+).* ]]; then
    BUILD_NUMBER="${BASH_REMATCH[1]}"

    # Construct the download link
    JBR_URL="https://cache-redirector.jetbrains.com/intellij-jbr/jbr_jcef-${JAVA_VERSION}-${OS_NAME}-${OS_ARCH}-b${BUILD_NUMBER}.tar.gz"

    # Download the file to /jbr.tar.gz
    if wget -O "$JBR_ARCHIVE" "$JBR_URL"; then
      echo "Download from $JBR_URL successful"
      return 0
    else
      echo "Download from $JBR_URL failed"
    fi
  fi

  if [ "$JAVA_MAJOR_VERSION" == "11" ]; then
    # There is no jcef version available for JBR 11
    wget -O "$JBR_ARCHIVE" "https://cache-redirector.jetbrains.com/intellij-jbr/jbr-11_0_16-linux-aarch64-b2043.64.tar.gz"
  else
    if [ "$JAVA_MAJOR_VERSION" == "17" ]; then
      wget -O "$JBR_ARCHIVE" "https://cache-redirector.jetbrains.com/intellij-jbr/jbr_jcef-17.0.14-linux-aarch64-b1367.22.tar.gz"
    else
      if [ "$JAVA_MAJOR_VERSION" == "21" ]; then
        wget -O "$JBR_ARCHIVE" "https://cache-redirector.jetbrains.com/intellij-jbr/jbr_jcef-21.0.6-linux-aarch64-b872.80.tar.gz"
      else
        return 1
      fi
    fi
  fi
}

if tryDownloadJbr; then
  echo "Download successful. Will extract it."
else
  echo "JBR download failed."
  exit 1
fi

# Remove existing /mps/jbr folder
rm -rf /mps/jbr
mkdir -p /mps/jbr

# Extract the file into /mps/jbr
tar -xzf "$JBR_ARCHIVE" -C /mps/jbr --strip-components=1
rm "$JBR_ARCHIVE"

echo "JBR extracted to /mps/jbr"