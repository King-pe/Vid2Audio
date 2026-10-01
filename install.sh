#!/data/data/com.termux/files/usr/bin/bash

# Vid2Audio installer for Termux
set -e

GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RESET='\033[0m'

printf "${GREEN}Vid2Audio installer${RESET}\n"
printf "${BLUE}Developer By Mrcode Technologi. from Tanzania${RESET}\n\n"

pkg update -y
pkg install -y python ffmpeg
python -m pip install --upgrade yt-dlp

# Ruhusu kuhifadhi faili kwenye Downloads ya simu.
if command -v termux-setup-storage >/dev/null 2>&1; then
    termux-setup-storage || true
fi

chmod +x "$(dirname "$0")/vid2audio.sh"
mkdir -p "$HOME/storage/downloads/Vid2Audio"

printf "\n${GREEN}✓ Installation imekamilika.${RESET}\n"
printf "Endesha tool kwa:\n${YELLOW}bash $(dirname "$0")/vid2audio.sh${RESET}\n"
