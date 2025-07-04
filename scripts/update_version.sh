#!/bin/bash
set -e

# Determine the version to use.
if [ -n "$1" ]; then
  # If a version is passed as $1, use it.
  VERSION="$1"
  GIT_TAG="v$VERSION"
else
  # If no argument is passed, get the latest git tag.
  GIT_TAG=$(git describe --tags --abbrev=0)
  if [ -z "$GIT_TAG" ]; then
    echo "No tags found. Exiting."
    exit 1
  fi
  VERSION=$(echo "$GIT_TAG" | sed 's/^v//')
fi

echo "Using version: $VERSION"

# Update client pubspec.yaml with the new version.
PUBSPEC_FILE="fluttcloud_flutter/pubspec.yaml"
if grep -q "^version: $VERSION" "$PUBSPEC_FILE"; then
  echo "Version in $PUBSPEC_FILE is already up to date."
else
  sed -i '' "s/^version:.*/version: $VERSION/" "$PUBSPEC_FILE"
  echo "Updated version in $PUBSPEC_FILE to $VERSION"
fi

# Update server pubspec.yaml with the new version.
PUBSPEC_FILE="fluttcloud_server/pubspec.yaml"
if grep -q "^version: $VERSION" "$PUBSPEC_FILE"; then
  echo "Version in $PUBSPEC_FILE is already up to date."
else
  sed -i '' "s/^version:.*/version: $VERSION/" "$PUBSPEC_FILE"
  echo "Updated version in $PUBSPEC_FILE to $VERSION"
fi

# If a version was passed as an argument, commit the changes and create/push a new tag.
if [ -n "$1" ]; then
  echo "Creating commit and tag for version $VERSION"

  # Stage the changed files.
  git add "$PUBSPEC_FILE" "$PACKAGE_JSON_FILE" "$SCHEMA_JSON_FILE"

  # Commit the changes.
  git commit -m "Update version to $VERSION" || echo "No changes to commit."

  # Create a new tag.
  git tag "$GIT_TAG"

  # Push the commit and the new tag.
  git push origin HEAD
  git push origin "$GIT_TAG"
fi
