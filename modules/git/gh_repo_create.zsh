#!/bin/bash

vis="$1"
name=$(basename "$PWD")

if [[ "$vis" != "--public" && "$vis" != "--private" ]]; then
  echo "Usage: ghrc [--public|--private]"
  exit 1
fi

gh repo create "$name" "$vis" --source=. --push
