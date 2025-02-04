#!/bin/sh
# localの拡張一覧をdotfilesに書き込む

CURRENT=$(cd $(dirname $0) && pwd)

code --list-extensions > "$CURRENT/extensions"
