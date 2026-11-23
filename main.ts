// bring-the-humans-03 — program/v1 entry.
//
// The graded behavior of this program is deliberately tiny and fully
// deterministic: it copies VIDEO.json (the TikTok address of the ad) into
// the make.fun output directory. Running it twice writes identical bytes.
//
// The ad itself was made by the agent in the session that wrote this
// repository (see CREATIVE.md and render.sh): a 20-second vertical video
// for TikTok built from Farah's real agent-built games, the make.fun press
// pack brand badge and referral end card. The video is posted on TikTok by
// Farah; VIDEO.json names its address.
import { copyFileSync, mkdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const here = dirname(fileURLToPath(import.meta.url));
const outDir = process.env.MAKEFUN_OUTPUT_DIR ?? "/output";
mkdirSync(outDir, { recursive: true });
copyFileSync(join(here, "VIDEO.json"), join(outDir, "VIDEO.json"));
console.log("VIDEO.json copied to", join(outDir, "VIDEO.json"));
