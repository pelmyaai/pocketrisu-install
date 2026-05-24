#!/usr/bin/env bash
set -e

echo "[PocketRisu] installer start"

cd ~

if ! command -v curl >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y curl
fi

if ! command -v npm >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y nodejs npm
fi

if ! command -v pm2 >/dev/null 2>&1; then
  sudo npm install -g pm2
fi

if ! command -v cloudflared >/dev/null 2>&1; then
  curl -L -o cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
  chmod +x cloudflared
  sudo mv cloudflared /usr/local/bin/cloudflared
fi

curl -L -o PocketRisu.tar.gz https://github.com/PocketRisu/PocketRisu/releases/download/v1.6.0/PocketRisu-v1.6.0-linux-x64.tar.gz

rm -rf pocketrisu
mkdir -p pocketrisu

tar -xzf PocketRisu.tar.gz -C pocketrisu

cd pocketrisu/PocketRisu-v1.6.0-linux-x64

echo "[PocketRisu] server start"
pm2 delete risuai >/dev/null 2>&1 || true
pm2 start "bash start.sh" --name risuai
pm2 save

echo "[PocketRisu] Cloudflare tunnel start"
pm2 delete tunnel >/dev/null 2>&1 || true
pm2 start "cloudflared tunnel --url http://localhost:6001" --name tunnel
sleep 5

echo ""
echo "설치 완료!"
echo "터널 주소 확인:"
echo "pm2 logs tunnel --lines 50 --nostream"
echo ""
echo "자주 쓰는 명령어:"
echo "상태 확인 -> pm2 list"
echo "서버 재시작 -> pm2 restart risuai"
echo "터널 로그 -> pm2 logs tunnel --lines 50 --nostream"
echo "실시간 로그 -> pm2 logs risuai"
