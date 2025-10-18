#!/bin/sh

# Your GitHub repo (public)
REPO_USER="undoLogic"
REPO_NAME="linuxPersonalDevServer"
BRANCH="main"  # or "master", depending on the repo

# Download as ZIP
echo "📥 Downloading $REPO_USER/$REPO_NAME..."
wget -O "$REPO_NAME.zip" "https://github.com/$REPO_USER/$REPO_NAME/archive/refs/heads/$BRANCH.zip"

# Unzip
unzip "$REPO_NAME.zip"
rm "$REPO_NAME.zip"

# Rename folder for convenience
mv "$REPO_NAME-$BRANCH" "$REPO_NAME"

echo "✅ Done. Folder available at: ./$REPO_NAME"
