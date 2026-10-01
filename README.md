# Vid2Audio

**Video to MP3 downloader ya Termux**

> **Developer By Mrcode Technologi. from Tanzania**

Vid2Audio inaruhusu mtumiaji kuchagua aina ya link, kuweka URL moja, kuibadilisha kuwa MP3 na kuihifadhi moja kwa moja kwenye:

```text
~/storage/downloads/Vid2Audio
```

## Platforms

1. YouTube
2. Facebook Reels
3. Instagram video / Reels
4. TikTok video

## Installation kwenye Termux

```bash
pkg update -y
pkg install -y git
cd ~
git clone https://github.com/King-pe/Vid2Audio.git
cd Vid2Audio
bash install.sh
```

Kama tayari ume-clone repository hii, tumia tu:

```bash
cd /path/ya/Vid2Audio
bash install.sh
```

## Kuendesha

```bash
bash vid2audio.sh
```

Au:

```bash
./vid2audio.sh
```

Installer inaweka `python`, `ffmpeg`, `yt-dlp`, inaomba ruhusa ya storage, na inatengeneza folder la downloads.

## Muhimu

- Tumia URL za **public**; video zinazohitaji login au zilizo private zinaweza kukataa kupakuliwa.
- Pakua na kubadilisha video/audio ambayo una ruhusa nayo au ambayo sheria za platform zinaruhusu.
- Link moja hubadilishwa kwa wakati mmoja; playlist nzima haipakuliwi kwa makusudi.
- MP3 hutolewa kwa quality ya juu kupitia `ffmpeg`.

## Kusasisha yt-dlp

```bash
python -m pip install --upgrade yt-dlp
```

## Troubleshooting

**`yt-dlp: command not found`**

```bash
python -m pip install --upgrade yt-dlp
```

**`ffmpeg: command not found`**

```bash
pkg install ffmpeg
```

**Instagram/Facebook/TikTok inakataa URL**

Hakikisha video ni public, URL haijakatika, na `yt-dlp` imepitwa na wakati. Baadhi ya videos zinahitaji login/cookies na hazita-download bila uthibitisho huo.

Mrcodex1 tanzania