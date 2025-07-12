#!/usr/bin/env bash
set -euo pipefail

# claude-codeを最新バージョンに更新
echo "Updating claude-code..."
VERSION=$(npm view @anthropic-ai/claude-code version)

cd "$(dirname "${BASH_SOURCE[0]}")/../.."
echo "Updating to version $VERSION..."
nix-update claude-code-override --flake --version "$VERSION"

echo "claude-code has been updated to version $VERSION"