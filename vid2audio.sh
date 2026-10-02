#!/data/data/com.termux/files/usr/bin/bash

# Vid2Audio — Video to MP3 downloader for Termux
# Developer By Mrcode Technologi. from Tanzania

set -u

APP_NAME="Vid2Audio"
VERSION="1.0.0"
DOWNLOAD_DIR="${HOME}/storage/downloads/Vid2Audio"
VIDEO_DOWNLOAD_DIR="${DOWNLOAD_DIR}/Videos"

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

has_working_ffmpeg() {
    command -v ffmpeg >/dev/null 2>&1 && ffmpeg -version >/dev/null 2>&1
}

check_dependencies() {
    local missing=()
    command -v yt-dlp >/dev/null 2>&1 || missing+=("yt-dlp")

    if [ "${#missing[@]}" -gt 0 ]; then
        say_error "Missing dependencies: ${missing[*]}"
        printf "${YELLOW}Run the installer with:${RESET} bash install.sh\n"
        exit 1
    fi

    if ! has_working_ffmpeg; then
        printf "${YELLOW}Warning: ffmpeg is missing or broken. Video downloads will use one MP4 format; audio conversion needs a working ffmpeg.${RESET}\n"
    fi

    mkdir -p "$DOWNLOAD_DIR" "$VIDEO_DOWNLOAD_DIR"
}

is_supported_url() {
    local platform="$1"
    local url="$2"
    case "$platform" in
        youtube)   [[ "$url" =~ ^https?://(www\.)?(youtube\.com|youtu\.be)/ ]] ;;
        facebook)  [[ "$url" =~ ^https?://(www\.)?(facebook\.com|fb\.watch)/ ]] ;;
        instagram) [[ "$url" =~ ^https?://(www\.)?instagram\.com/ ]] ;;
        tiktok)    [[ "$url" =~ ^https?://(www\.)?(www\.)?tiktok\.com/ ]] ;;
        other)     [[ "$url" =~ ^https?:// ]] ;;
        *)         return 1 ;;
    esac
}

platform_name() {
    case "$1" in
        youtube) echo "YouTube" ;;
        facebook) echo "Facebook Reels" ;;
        instagram) echo "Instagram video/reels" ;;
        tiktok) echo "TikTok video" ;;
        other) echo "Other website/browser link" ;;
    esac
}

download_audio() {
    local platform="$1"
    local url="$2"
    local name
    name="$(platform_name "$platform")"

    printf "\n${CYAN}Downloading audio from ${WHITE}%s${CYAN}...${RESET}\n" "$name"
    printf "${YELLOW}Please wait; longer videos may take more time.${RESET}\n\n"

    if ! has_working_ffmpeg; then
        say_error "A working ffmpeg is required for MP3 conversion."
        printf "${YELLOW}Repair it with: pkg upgrade -y && pkg install --reinstall ffmpeg${RESET}\n"
        return 1
    fi

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
        --trim-filenames 140 \
        -o "${DOWNLOAD_DIR}/%(title).120s-%(id)s.%(ext)s" \
        "$url"; then
        printf "\n${GREEN}✓ Audio conversion completed!${RESET}\n"
        printf "${WHITE}Saved to:${RESET}\n${CYAN}%s${RESET}\n" "$DOWNLOAD_DIR"
        printf "${YELLOW}Open folder: termux-open \"%s\"${RESET}\n" "$DOWNLOAD_DIR"
    else
        printf "\n"
        say_error "Audio conversion failed. Check that the URL is correct and public."
        printf "${YELLOW}Instagram, Facebook, and TikTok videos may require login cookies.${RESET}\n"
    fi
}

download_video() {
    local platform="$1"
    local url="$2"
    local resolution="$3"
    local name
    local format
    name="$(platform_name "$platform")"

    printf "\n${CYAN}Downloading video from ${WHITE}%s${CYAN}...${RESET}\n" "$name"
    printf "${YELLOW}Using fast multi-fragment download where supported.${RESET}\n\n"

    # Prefer a real video+audio result. When ffmpeg is available, combine the
    # best video and audio streams. Without ffmpeg, only select a format that
    # already contains both video and audio; never silently choose audio-only.
    if has_working_ffmpeg; then
        if [ "$resolution" = "best" ]; then
            format="bestvideo*+bestaudio/best"
        else
            format="bestvideo*[height<=${resolution}]+bestaudio/best[height<=${resolution}]"
        fi
    else
        if [ "$resolution" = "best" ]; then
            format="best[vcodec!=none][acodec!=none]/best[acodec!=none][vcodec!=none]"
        else
            format="best[height<=${resolution}][vcodec!=none][acodec!=none]/best[height<=${resolution}][acodec!=none][vcodec!=none]"
        fi
    fi

    # --concurrent-fragments can improve speed on supported servers.
    if yt-dlp \
        --no-playlist \
        --restrict-filenames \
        --newline \
        --concurrent-fragments 4 \
        --format "$format" \
        --merge-output-format mp4 \
        --trim-filenames 140 \
        -o "${VIDEO_DOWNLOAD_DIR}/%(title).120s-%(id)s.%(ext)s" \
        "$url"; then
        printf "\n${GREEN}✓ Video download completed!${RESET}\n"
        printf "${WHITE}Saved to:${RESET}\n${CYAN}%s${RESET}\n" "$VIDEO_DOWNLOAD_DIR"
        printf "${YELLOW}Open folder: termux-open \"%s\"${RESET}\n" "$VIDEO_DOWNLOAD_DIR"
    else
        printf "\n"
        say_error "Video download failed. Check that the URL is correct and public."
        if [ "$platform" = "facebook" ]; then
            printf "${YELLOW}Facebook changed its page format. Update yt-dlp with:${RESET}\n"
            printf "${CYAN}python -m pip install --upgrade --pre \"yt-dlp[default]\"${RESET}\n"
            printf "${YELLOW}If it still fails, this Reel may require login cookies or be restricted.${RESET}\n"
        else
            printf "${YELLOW}Some sites require login cookies or may block downloads.${RESET}\n"
        fi
    fi
}

select_resolution() {
    local choice
    while true; do
        printf "\n${GREEN}Choose video quality:${RESET}\n\n"
        printf "${BLUE}1${RESET}) Auto / Best available\n"
        printf "${BLUE}2${RESET}) 2160p (4K)\n"
        printf "${BLUE}3${RESET}) 1440p (2K)\n"
        printf "${BLUE}4${RESET}) 1080p (Full HD)\n"
        printf "${BLUE}5${RESET}) 720p (HD)\n"
        printf "${BLUE}6${RESET}) 480p\n"
        printf "${BLUE}7${RESET}) 360p\n\n"
        read -r -p "Choose quality (1-7): " choice

        case "$choice" in
            1) SELECTED_RESOLUTION="best"; return ;;
            2) SELECTED_RESOLUTION="2160"; return ;;
            3) SELECTED_RESOLUTION="1440"; return ;;
            4) SELECTED_RESOLUTION="1080"; return ;;
            5) SELECTED_RESOLUTION="720"; return ;;
            6) SELECTED_RESOLUTION="480"; return ;;
            7) SELECTED_RESOLUTION="360"; return ;;
            *)
                say_error "Invalid quality choice. Use a number from 1 to 7."
                sleep 1
                ;;
        esac
    done
}

choose_audio_platform() {
    local choice platform prompt url
    while true; do
        print_banner
        printf "${GREEN}Convert video to MP3:${RESET}\n\n"
        printf "${BLUE}1${RESET}) YouTube\n"
        printf "${BLUE}2${RESET}) Facebook Reels\n"
        printf "${BLUE}3${RESET}) Instagram video / Reels\n"
        printf "${BLUE}4${RESET}) TikTok video\n"
        printf "${BLUE}5${RESET}) Back\n\n"
        read -r -p "Choose (1-5): " choice

        case "$choice" in
            1) platform="youtube"; prompt="Enter YouTube URL" ;;
            2) platform="facebook"; prompt="Enter Facebook Reels URL" ;;
            3) platform="instagram"; prompt="Enter Instagram video/Reels URL" ;;
            4) platform="tiktok"; prompt="Enter TikTok URL" ;;
            5) return ;;
            *)
                say_error "Invalid choice. Use 1, 2, 3, 4, or 5."
                sleep 1
                continue
                ;;
        esac

        printf "\n${CYAN}%s:${RESET} " "$prompt"
        read -r url
        url="$(printf '%s' "$url" | sed 's/^['\''"]//; s/['\''"]$//')"

        if [ -z "$url" ]; then
            say_error "No URL was entered."
            sleep 1
            continue
        fi

        if ! is_supported_url "$platform" "$url"; then
            say_error "This is not a valid $(platform_name "$platform") URL."
            printf "${YELLOW}Enter a valid URL for the platform you selected.${RESET}\n"
            sleep 2
            continue
        fi

        download_audio "$platform" "$url"
        printf "\n${CYAN}Press Enter to return to the audio menu...${RESET}"
        read -r
    done
}

choose_video_platform() {
    local choice platform prompt url
    while true; do
        print_banner
        printf "${GREEN}Download video:${RESET}\n\n"
        printf "${BLUE}1${RESET}) YouTube\n"
        printf "${BLUE}2${RESET}) Facebook / Facebook Reels\n"
        printf "${BLUE}3${RESET}) Instagram video / Reels\n"
        printf "${BLUE}4${RESET}) TikTok video\n"
        printf "${BLUE}5${RESET}) Other website / browser URL\n"
        printf "${BLUE}6${RESET}) Back\n\n"
        read -r -p "Choose (1-6): " choice

        case "$choice" in
            1) platform="youtube"; prompt="Enter YouTube URL" ;;
            2) platform="facebook"; prompt="Enter Facebook URL" ;;
            3) platform="instagram"; prompt="Enter Instagram URL" ;;
            4) platform="tiktok"; prompt="Enter TikTok URL" ;;
            5) platform="other"; prompt="Enter video URL" ;;
            6) return ;;
            *)
                say_error "Invalid choice. Use 1, 2, 3, 4, 5, or 6."
                sleep 1
                continue
                ;;
        esac

        printf "\n${CYAN}%s:${RESET} " "$prompt"
        read -r url
        url="$(printf '%s' "$url" | sed 's/^['\''"]//; s/['\''"]$//')"

        if [ -z "$url" ]; then
            say_error "No URL was entered."
            sleep 1
            continue
        fi

        if ! is_supported_url "$platform" "$url"; then
            say_error "Please enter a valid HTTP/HTTPS URL."
            sleep 2
            continue
        fi

        select_resolution
        download_video "$platform" "$url" "$SELECTED_RESOLUTION"
        printf "\n${CYAN}Press Enter to return to the video menu...${RESET}"
        read -r
    done
}

main_menu() {
    local choice
    while true; do
        print_banner
        printf "${GREEN}Choose an action:${RESET}\n\n"
        printf "${BLUE}1${RESET}) Convert video to MP3 audio\n"
        printf "${BLUE}2${RESET}) Download video\n"
        printf "${BLUE}3${RESET}) Exit\n\n"
        read -r -p "Choose (1-3): " choice

        case "$choice" in
            1) choose_audio_platform ;;
            2) choose_video_platform ;;
            3)
                printf "${GREEN}Thank you for using ${WHITE}${APP_NAME}${GREEN}!${RESET}\n"
                exit 0
                ;;
            *)
                say_error "Invalid choice. Use 1, 2, or 3."
                sleep 1
                ;;
        esac
    done
}

check_dependencies
main_menu
