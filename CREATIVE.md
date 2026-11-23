# Bring the humans 03 — creative decision (recorded in-session, 2026-11-23)

## Competition
bring-the-humans-03 — "Bring the humans with a TikTok ad". $500 pot (1st $100). Deadline 2026-11-24 19:00 UTC = 25 Nov 02:00 WIB. Ranking: views only, top 20 share $500. Only real views count.

## Creative decision
A 20-second vertical (1080x1920, 30fps, silent) ad. Structure:
- **Hook + proof montage (0–12s):** Farah's REAL agent-built games as proof her agent builds and competes — fast cuts, one bold claim per shot, Ken Burns motion over real screenshots (blurred-fill background + sharp foreground):
  - 0–3s Palmera Bay driving (gta6-01 entry-r6) — "MY AI AGENT / BUILDS GAMES."
  - 3–6s Brainrot Rumble Golden Hour (roblox-brainrot-01) — "ROBLOX / WORLDS."
  - 6–9s Daily Dilemma results (devpost-reddit-game) — "DAILY / GAMES."
  - 9–12s Palmera Bay chase — "3D OPEN / WORLDS."
- **Pitch (12–17.5s):** solid make.fun magenta #C41C83 — "AI AGENTS / COMPETE FOR / REAL MONEY / ON make.fun" + sub "WIN BOUNTIES. GET PAID IN USDC." (boilerplate wording: make.fun is a competition platform where AI agents build software for cash rewards; winners claim in USDC.)
- **End card (17.5–20s):** the real press-pack transparent card webm laid over the last 2.5s; referral code 03swhpzc appears in the field once it rests (card rest_s 1.433 → t=18.933), JetBrains Mono Bold 62px ink #191419, caret covered white (per manifest geometry).
- **Brand badge:** the real press-pack 9:16 badge overlay, full-frame at 100%, from frame 0 until the card comes in (t=17.5). Own text kept 24px+ clear of it; all on-screen text inside the TikTok safe zone (x 120–960, y 269–1248).
- **Brand rules honoured:** make.fun written lowercase with the dot; colours only magenta #C41C83 / ink #191419 / white; Inter Bold for headlines (brand heading font), JetBrains Mono Bold for the code; badge and card used exactly as supplied, never recoloured/redrawn/stretched.
- **Audio:** none (silent, text-driven — TikTok viewers watch muted; no licensed music sourced).

## Assets (all from make.fun press pack, manifest 2026-11-21, zip sha256 verified 65653009…)
- press/make-fun-press-kit.zip (sha256 matches manifest)
- brand-badge/9x16/makefun-badge-9x16.png (rgba, badge at 120,272 330x128)
- referral-card/9x16/makefun-card-9x16-transparent.webm (VP9, 150 frames @ 60fps = 2.5s; ffmpeg decodes it opaque — overlaid as-is, unmodified; the 90% magenta wash reads as the official card)
- Field geometry (manifest): field 153,1174 774x194; code box 210,1232 510x78, centre_y 1271; caret cover 208,1230 9x82 white; code font JetBrains Mono 700, 62px, #191419.

## Why this creative
Views decide the places, so the ad opens with motion + a bold claim in the first second, proves it with three different real games in 12 seconds (range = credibility), then states the offer plainly (agents compete for real money) and ends on the referral card. No fabricated footage: every game shot is a real screenshot of Farah's own entries.

## V2 (2026-11-23, same session thread) — sound + stronger hook + caption fix
V1 was silent; TikTok is sound-on, and the reference video to beat runs 31s with a
day-1-vs-day-7 story. V2 keeps V1's proven structure and press-pack assets but:
- **Sound:** English voiceover (TTS, Helio voice) over an original synth music
  bed (128 BPM, A minor, kick/hats/clap + bass + arp — generated in-session by
  `scripts/music-gen.py` with numpy, licence-clean, no samples). Music is
  sidechain-ducked under the voice (ffmpeg `sidechaincompress`); mix verified
  20.0s, mean −26.3 dB, max −7.8 dB, no silence anywhere (voice 0–16.5s).
- **Voiceover script** (`scripts/voiceover.txt`, 41 words, 16.5s): "My AI agent
  wins real money. It builds games — Roblox worlds, daily games, 3D open
  worlds — and competes in bounties on make.fun. AI agents compete for real
  cash. Join with your agent, and get paid in USDC. Start yours at make.fun."
- **Money-first hook + faster cuts:** 0–2.5s "MY AI AGENT WINS / REAL MONEY.",
  then 2.5s cuts (was 3s) with a faster Ken Burns zoom (0.12); montage is
  0–10s, pitch 10–17.5s, end card 17.5–20s. Total still 20s.
- **Safe-zone fix found in V2 frame review:** "MY AI AGENT WINS" at 110px
  measures 1059px wide (centered x=10..1069) — outside the TikTok safe zone
  (x 120–960) and under the right action rail. Fixed: hook line 1 renders at
  86px (≈823px, x=128..951); line 2 stays 110px. All other lines measured
  ≤757px and already fit. Re-rendered and re-verified (frame t=0.5).
- **Render bug fixed:** ffmpeg filtergraph pads can be consumed only once —
  the voice pad fed both `sidechaincompress` and `amix`, which failed binding.
  Fix: `asplit=2` the voice into a sidechain branch and a mix branch.
- **Caption fix (important):** V1's caption wrongly carried the REFERRAL code
  `03swhpzc` as the play code. The caption must carry the PLAY code. Farah's
  verified play code for this competition is `makefun-owl-tunnel-tent`
  (GET /api/competitions/bring-the-humans-03/play-code?n=0; n=1
  makefun-ranch-petunia-museum, n=2 makefun-jigsaw-gazelle-dune — n=0 only).
  The referral code `03swhpzc` belongs ONLY in the end card (and the repo's
  referral link line), never as the caption's play code. README updated.
- V1 kept as `video-v1.mp4` next to `video.mp4` (V2). V2 sha256:
  `56646ede2f9141f0c76bfc42c1eaddf88ed886412d03d1171072f3150f3bea22`
  (20.0s, 1080×1920, 30fps, H.264 + AAC 160k). Frames re-checked at t=0.5,
  3.5, 7.5, 12.0, 19.5 — badge from frame 1, end card + code at 19.5.
