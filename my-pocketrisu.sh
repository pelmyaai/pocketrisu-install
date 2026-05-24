#!/usr/bin/env bash
set -e

echo "[PocketRisu] installer start"

cd ~

if ! command -v curl >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y curl
fi

curl -L -o PocketRisu.tar.gz https://github.com/PocketRisu/PocketRisu/releases/download/v1.6.0/PocketRisu-v1.6.0-linux-x64.tar.gz

rm -rf pocketrisu
mkdir -p pocketrisu

tar -xzf PocketRisu.tar.gz -C pocketrisu

cd pocketrisu/PocketRisu-v1.6.0-linux-x64

echo "[PocketRisu] server start"
bash start.sh
