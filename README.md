# Vid2Audio

**Video-to-MP3 downloader for Termux**

> **Developer By Mrcode Technologi. from Tanzania**
> **Mrcodex1 Tanzania**

Vid2Audio lets users choose a supported platform, enter one public video URL, convert the video to MP3, and save the audio directly to the phone.

Downloaded files are saved in:

```text
~/storage/downloads/Vid2Audio
```

## Supported Platforms

1. YouTube
2. Facebook Reels
3. Instagram videos and Reels
4. TikTok videos

## Installation on Termux

```bash
pkg update -y
pkg install -y git
cd ~
git clone https://github.com/King-pe/Vid2Audio.git
cd Vid2Audio
bash install.sh
```

The installer installs Python, FFmpeg, and yt-dlp. It also requests storage permission and creates the download folder.

If you have already cloned the repository, run:

```bash
cd /path/to/Vid2Audio
bash install.sh
```

## Running Vid2Audio

```bash
cd ~/Vid2Audio
bash vid2audio.sh
```

You can also run it directly after making it executable:

```bash
chmod +x vid2audio.sh
./vid2audio.sh
```

Use the menu to select a platform, paste one public video URL, and wait for the MP3 conversion to finish.

## Updating yt-dlp

Keep yt-dlp updated for the best platform compatibility:

```bash
python -m pip install --upgrade yt-dlp
```

## Important Notes

- Only download and convert content that you own or have permission to use, and follow the rules of the platform hosting the content.
- Use public URLs. Private videos or videos requiring login may not download.
- Vid2Audio processes one URL at a time and does not download entire playlists.
- FFmpeg is used to convert the video to high-quality MP3 audio.
- Platform changes can temporarily affect downloading. Updating yt-dlp may fix compatibility problems.

## Troubleshooting

### `yt-dlp: command not found`

```bash
python -m pip install --upgrade yt-dlp
```

### `ffmpeg: command not found`

```bash
pkg install ffmpeg
```

### Instagram, Facebook, or TikTok URL fails

Make sure the URL is complete and the video is public. Update yt-dlp and try again:

```bash
python -m pip install --upgrade yt-dlp
```

Some videos require login cookies or have download restrictions and may not work with a public URL.

## Project Files

- `vid2audio.sh` — Main interactive downloader and MP3 converter.
- `install.sh` — Termux dependency installer and storage setup script.
- `.gitignore` — Prevents downloaded audio files from being committed.

## License and Responsible Use

Use this tool responsibly. Respect copyright, privacy, terms of service, and the rights of content creators.
