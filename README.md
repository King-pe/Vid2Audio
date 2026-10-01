    
# ✴.·´¯`·.·★  🎀𝓥𝓲𝓭2𝓐𝓾𝓭𝓲𝓸🎀  ★·.·`¯´·.✴                                                           

**Video-to-MP3 downloader for Termux**

> **Developer By Mrcode Technologi. from Tanzania**
> **Mrcodex1 Tanzania**

Vid2Audio lets users choose between converting a video to MP3 or downloading the original video file. Users can enter one public URL from a supported platform or another website.

Downloaded files are saved in:

```text
~/storage/downloads/Vid2Audio
```

Downloaded videos are saved in:

```text
~/storage/downloads/Vid2Audio/Videos
```

## Supported Platforms

1. YouTube
2. Facebook Reels
3. Instagram videos and Reels
4. TikTok videos

The video downloader also supports **Other website / browser URL** when yt-dlp supports the website.

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

Use the main menu to choose one of these actions:

1. **Convert video to MP3 audio** — saves MP3 files in `~/storage/downloads/Vid2Audio`.
2. **Download video** — saves MP4/video files in `~/storage/downloads/Vid2Audio/Videos`.

The video downloader uses MP4 when available and enables concurrent fragments for faster downloads on servers that support it. Paste one public video URL and wait for the download to finish.

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
- Video downloads use yt-dlp and are saved separately from MP3 files in the `Videos` folder.
- The **Other website / browser URL** option works only for websites supported by yt-dlp.
- Filenames are automatically shortened to prevent Android's `File name too long` error.
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

FFmpeg is required for MP3 conversion and for combining separate video and audio streams. If FFmpeg is not installed, the video downloader automatically requests a single combined MP4 format when the website provides one.

### `File name too long`

The downloader automatically limits output filenames and adds the video ID. Update the tool before trying again:

```bash
cd ~/Vid2Audio
git pull
bash vid2audio.sh
```

### Instagram, Facebook, or TikTok URL fails

Make sure the URL is complete and the video is public. Update yt-dlp and try again:

```bash
python -m pip install --upgrade yt-dlp
```

Some videos require login cookies or have download restrictions and may not work with a public URL.

## Project Files

- `vid2audio.sh` — Main interactive MP3 converter and video downloader.
- `install.sh` — Termux dependency installer and storage setup script.
- `.gitignore` — Prevents downloaded audio files from being committed.

## License and Responsible Use

Use this tool responsibly. Respect copyright, privacy, terms of service, and the rights of content creators.
