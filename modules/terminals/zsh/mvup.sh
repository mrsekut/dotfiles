mvup() {
  local src="$1"
  local dest="$2"
  if [ -z "$src" ] || [ -z "$dest" ]; then
    echo "Usage: mvup <source_dir> <dest_dir>"
    return 1
  fi
  if [ ! -d "$src" ]; then
    echo "Error: source directory '$src' does not exist"
    return 1
  fi
  if [ ! -d "$dest" ]; then
    echo "Error: destination directory '$dest' does not exist"
    return 1
  fi

  mv "$src"/* "$src"/.* "$dest"/ 2>/dev/null
  rmdir "$src"
}

mvup "$1" "$2"
