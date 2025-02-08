#!/bin/bash

# There is only a linux distribution of MPS for amd64.
# This script replaces the bundled JBR with the arm version.

# Get the system architecture
OS_ARCH=$(uname -m)
if [ "$OS_ARCH" = "arm64" ]; then
    OS_ARCH="aarch64"
fi

# Only proceed if the architecture is aarch64
if [ "$OS_ARCH" != "aarch64" ]; then
    echo "Skipping download and extraction: Architecture is not aarch64."
    exit 0
fi

# Read the release file
RELEASE_FILE="/mps/jbr/release"
if [ ! -f "$RELEASE_FILE" ]; then
    echo "Error: release file not found!"
    exit 1
fi

# Extract required values from the release file
JAVA_VERSION=$(grep '^JAVA_VERSION=' "$RELEASE_FILE" | cut -d'=' -f2 | tr -d '"')
OS_NAME=$(grep '^OS_NAME=' "$RELEASE_FILE" | cut -d'=' -f2 | tr -d '"' | tr '[:upper:]' '[:lower:]')
JAVA_RUNTIME_VERSION=$(grep '^JAVA_RUNTIME_VERSION=' "$RELEASE_FILE" | cut -d'=' -f2 | tr -d '"')

# Extract the build number from JAVA_RUNTIME_VERSION
BUILD_NUMBER=$(echo "$JAVA_RUNTIME_VERSION" | awk -F'b' '{print $2}')

# Construct the download link
JBR_URL="https://cache-redirector.jetbrains.com/intellij-jbr/jbr_jcef-${JAVA_VERSION}-${OS_NAME}-${OS_ARCH}-b${BUILD_NUMBER}.tar.gz"

# Output the generated URL
echo "Downloading: $JBR_URL"

# Download the file to /jbr.tar.gz
JBR_ARCHIVE="/jbr.tar.gz"
wget -O "$JBR_ARCHIVE" "$JBR_URL"

# Remove existing /mps/jbr folder
rm -rf /mps/jbr
mkdir -p /mps/jbr

# Extract the file into /mps/jbr
tar -xzf "$JBR_ARCHIVE" -C /mps/jbr --strip-components=1
rm "$JBR_ARCHIVE"

echo "JBR extracted to /mps/jbr"
