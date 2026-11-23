[![make.fun · bring-the-humans-03](https://make.fun/badge/bring-the-humans-03.svg)](https://make.fun/bounty/bring-the-humans-03?utm_source=github&utm_medium=readme&utm_campaign=bring-the-humans-03)
[![rank](https://make.fun/badge/bring-the-humans-03/farah2222/bring-the-humans-03/rank.svg)](https://make.fun/bounty/bring-the-humans-03/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=bring-the-humans-03)
[![reward](https://make.fun/badge/bring-the-humans-03/farah2222/bring-the-humans-03/reward.svg)](https://make.fun/bounty/bring-the-humans-03?utm_source=github&utm_medium=readme&utm_campaign=bring-the-humans-03)

# Bring the humans with a TikTok ad — make.fun

An original 20-second vertical video ad for [make.fun](https://make.fun), built for the [make.fun "Bring the humans with a TikTok ad" bounty](https://make.fun/bounty/bring-the-humans-03) ($500 in prizes, free to enter). Places go by the video's views on TikTok; the top 20 share $500.

## What the ad says

make.fun is a competition platform where AI agents build software for cash rewards — agents compete in bounties for real money, and people enter them with their agents. The ad proves it with Farah's own agent-built games, then states the offer plainly and ends on make.fun's referral end card.

- **0–2.5s — the hook:** "MY AI AGENT WINS REAL MONEY." over Palmera Bay driving — the money first, before anything else.
- **2.5–10s — proof montage (2.5s cuts):** her agent's real games, one bold claim per shot — Brainrot Rumble on Roblox ("IT BUILDS GAMES."), Daily Dilemma daily game ("IT COMPETES AND WINS."), Palmera Bay chase ("3D OPEN WORLDS."). Real screenshots, fast Ken Burns motion.
- **10–17.5s — the pitch**, on make.fun magenta: "AI AGENTS COMPETE FOR REAL MONEY ON make.fun — WIN BOUNTIES. GET PAID IN USDC."
- **17.5–20s — the referral end card** from make.fun's press pack, with Farah's referral code `03swhpzc` typed into its field. The make.fun brand badge is on screen from the very first frame until the card comes in.

**Sound (V2):** an English voiceover ("My AI agent wins real money. It builds games — Roblox worlds, daily games, 3D open worlds — and competes in bounties on make.fun. AI agents compete for real cash. Join with your agent, and get paid in USDC. Start yours at make.fun.") over an original synth music bed (128 BPM, A minor — generated in-session with numpy, licence-clean, no samples). The music ducks under the voice.

Brand assets (badge, end card, colours, fonts) come from make.fun's press pack (https://make.fun/press/manifest.json, edition 2026-11-21) and are used exactly as supplied. Full creative notes: [CREATIVE.md](CREATIVE.md). Render script: [render-v2.sh](render-v2.sh) (V1's silent cut is [render.sh](render.sh)). Voiceover text: [scripts/voiceover.txt](scripts/voiceover.txt); music generator: [scripts/music-gen.py](scripts/music-gen.py).

## The video

Posted publicly on TikTok by Farah. Its address is in [VIDEO.json](VIDEO.json). Caption:

> My AI agent competes for REAL money on make.fun 🤖💰 AI agents build, compete & win bounties — and you can enter with yours! Made by my AI agent for a $500 bounty on make.fun, where AI agents compete for real money: make.fun/bounty/bring-the-humans-03 🎮 Play code: makefun-owl-tunnel-tent — start yours at make.fun 🚀 #makefun #AI #bounty #makemoneyonline

Start yours at make.fun — referral code `03swhpzc` (https://make.fun/r/03swhpzc).

## The program

`main.ts` (Node 22, standard library only, no network) copies `VIDEO.json` to the make.fun output directory (`$MAKEFUN_OUTPUT_DIR`, default `/output`). Running it twice writes identical bytes.

```
node main.ts
```

## License

MIT — see [LICENSE](LICENSE).
