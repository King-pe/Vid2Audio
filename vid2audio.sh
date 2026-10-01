#!/data/data/com.termux/files/usr/bin/bash

# Vid2Audio — Video to MP3 downloader for Termux
# Developer By Mrcode Technologi. from Tanzania

set -u

APP_NAME="Vid2Audio"
VERSION="1.0.0"
DOWNLOAD_DIR="${HOME}/storage/downloads/Vid2Audio"

# Rangi za brand: kijani + blue
GREEN='\033[1;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
WHITE='\033[1;37m'
RESET='\033[0m'

print_banner() {
    clear 2>/dev/null || true
    printf "${GREEN} __     ___     _ ____     _             _ _       ${RESET}\n"
    printf "${GREEN} \\ \\   / (*) __| |__* \\   / \\  _   _  _*| (*) ___  ${RESET}\n"
    printf "${GREEN}  \\ \\ / /| |/ _\` | __) | / _ \\| | | |/ _\` | |/ _ \\ ${RESET}\n"
    printf "${BLUE}   \\ V / | | (*| | /_/ / ___ \\ || | (_| | | (*) |${RESET}\n"
    printf "${BLUE}    \\_/  |_|\\_,*|_____/     \\_\\_*,*|\\_,*|_|\\___/ ${RESET}\n"
    printf "\n"
    printf "${GREEN}✴.·´¯\`·.·★  ${WHITE}🎀𝓥𝓲𝓭2𝓐𝓾𝓭𝓲𝓸🎀  ${GREEN}★·.·\`¯´·.✴${RESET}\n"
    printf "${CYAN}              Video to MP3 — Termux Tool${RESET}\n"
    printf "${WHITE}      Developer By Mrcode Technologi. from Tanzania${RESET}\n\n"
}

say_error() { printf "${RED}✗ %s${RESET}\n" "$1"; }
say_ok() { printf "${GREEN}✓ %s${RESET}\n" "$1"; }

check_dependencies() {
    local missing=()
    command -v yt-dlp >/dev/null 2>&1 || missing+=("yt-dlp")
    command -v ffmpeg >/dev/null 2>&1 || missing+=("ffmpeg")

    if [ "${#missing[@]}" -gt 0 ]; then
        say_error "Programu hizi hazipo: ${missing[*]}"
        printf "${YELLOW}Endesha installer kwa kuandika:${RESET} bash install.sh\n"
        exit 1
    fi

    mkdir -p "$DOWNLOAD_DIR"
}

is_supported_url() {
    local platform="$1"
    local url="$2"
    case "$platform" in
        youtube)   [[ "$url" =~ ^https?://(www\.)?(youtube\.com|youtu\.be)/ ]] ;;
        facebook)  [[ "$url" =~ ^https?://(www\.)?(facebook\.com|fb\.watch)/ ]] ;;
        instagram) [[ "$url" =~ ^https?://(www\.)?instagram\.com/ ]] ;;
        tiktok)    [[ "$url" =~ ^https?://(www\.)?(www\.)?tiktok\.com/ ]] ;;
        *)         return 1 ;;
    esac
}

platform_name() {
    case "$1" in
        youtube) echo "YouTube" ;;
        facebook) echo "Facebook Reels" ;;
        instagram) echo "Instagram video/reels" ;;
        tiktok) echo "TikTok video" ;;
    esac
}

download_audio() {
    local platform="$1"
    local url="$2"
    local name
    name="$(platform_name "$platform")"

    printf "\n${CYAN}Inapakua kutoka ${WHITE}%s${CYAN}...${RESET}\n" "$name"
    printf "${YELLOW}Subiri kidogo; video ndefu inaweza kuchukua muda.${RESET}\n\n"

    # --no-playlist: URL moja hubadilishwa, si playlist nzima.
    # -x + mp3: yt-dlp hutumia ffmpeg kubadilisha video kuwa audio.
    if yt-dlp \
        --no-playlist \
        --restrict-filenames \
        --no-progress \
        --newline \
        --extract-audio \
        --audio-format mp3 \
        --audio-quality 0 \
        --embed-thumbnail \
        --add-metadata \
        -o "${DOWNLOAD_DIR}/%(title)s.%(ext)s" \
        "$url"; then
        printf "\n${GREEN}✓ Imekamilika!${RESET}\n"
        printf "${WHITE}Faili yako ipo hapa:${RESET}\n${CYAN}%s${RESET}\n" "$DOWNLOAD_DIR"
        printf "${YELLOW}Kufungua folder: termux-open \"%s\"${RESET}\n" "$DOWNLOAD_DIR"
    else
        printf "\n"
        say_error "Imeshindikana kubadilisha URL hii. Hakikisha URL ni sahihi na video iko public."
        printf "${YELLOW}Kwa Instagram/Facebook/TikTok, video yenye login/private inaweza kuhitaji cookies.${RESET}\n"
    fi
}

choose_platform() {
    local choice platform prompt url
    while true; do
        print_banner
        printf "${GREEN}Chagua aina ya link:${RESET}\n\n"
        printf "${BLUE}1${RESET}) YouTube\n"
        printf "${BLUE}2${RESET}) Facebook Reels\n"
        printf "${BLUE}3${RESET}) Instagram video / Reels\n"
        printf "${BLUE}4${RESET}) TikTok video\n"
        printf "${BLUE}5${RESET}) Toka\n\n"
        read -r -p "Chagua (1-5): " choice

        case "$choice" in
            1) platform="youtube"; prompt="Weka YouTube URL" ;;
            2) platform="facebook"; prompt="Weka Facebook Reels URL" ;;
            3) platform="instagram"; prompt="Weka Instagram video/Reels URL" ;;
            4) platform="tiktok"; prompt="Weka TikTok URL" ;;
            5)
                printf "${GREEN}Asante kwa kutumia ${WHITE}${APP_NAME}${GREEN}!${RESET}\n"
                exit 0
                ;;
            *)
                say_error "Chaguo si sahihi. Tumia 1, 2, 3, 4 au 5."
                sleep 1
                continue
                ;;
        esac

        printf "\n${CYAN}%s:${RESET} " "$prompt"
        read -r url
        url="$(printf '%s' "$url" | sed 's/^['\''"]//; s/['\''"]$//')"

        if [ -z "$url" ]; then
            say_error "URL haijawekwa."
            sleep 1
            continue
        fi

        if ! is_supported_url "$platform" "$url"; then
            say_error "Hii si URL ya $(platform_name "$platform")."
            printf "${YELLOW}Rudia kwa kuweka URL sahihi ya platform uliyochagua.${RESET}\n"
            sleep 2
            continue
        fi

        download_audio "$platform" "$url"
        printf "\n${CYAN}Bonyeza Enter kurudi kwenye menu...${RESET}"
        read -r
    done
}

check_dependencies
choose_platform
