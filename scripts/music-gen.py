#!/usr/bin/env python3
"""Generate an original, licence-clean synth music bed for the
bring-the-humans-03 V2 TikTok ad. Pure numpy synthesis — no samples,
no copyrighted material. 128 BPM, A minor, kick/hats/clap + bass + arp,
with a gentle pump on the kick. Output: 20s stereo WAV, 44.1kHz.
"""
import numpy as np
import wave

SR = 44100
DUR = 20.0
N = int(SR * DUR)
t = np.arange(N) / SR

BPM = 128
BEAT = 60.0 / BPM            # 0.46875 s
BAR = 4 * BEAT               # 1.875 s

# Chord roots per bar: Am, F, C, G (Hz)
ROOTS = [110.00, 87.31, 130.81, 98.00]
# A-minor pentatonic for the arp (Hz)
ARP_NOTES = [440.00, 523.25, 587.33, 659.25, 783.99, 880.00]


def sine(freq, phase=0.0):
    return np.sin(2 * np.pi * freq * t + phase)


def env(start, dur, decay):
    """Exponential-decay envelope starting at `start` (seconds)."""
    e = np.zeros(N)
    i0 = int(start * SR)
    i1 = min(N, int((start + dur) * SR))
    if i1 > i0:
        tt = np.arange(i1 - i0) / SR
        e[i0:i1] = np.exp(-tt / decay)
    return e


def add_pulse(track, start, dur, decay, wave_fn):
    """Add a decaying pulse of wave_fn (callable over local time) to track."""
    i0 = int(start * SR)
    i1 = min(N, int((start + dur) * SR))
    if i1 <= i0:
        return track
    tt = np.arange(i1 - i0) / SR
    track[i0:i1] += wave_fn(tt) * np.exp(-tt / decay)
    return track


music = np.zeros(N)
kick_env = np.zeros(N)
rng = np.random.default_rng(7)

# --- kick on every beat: sine sweep 160 -> 45 Hz, 0.14s ---
n_beats = int(DUR / BEAT) + 1
for b in range(n_beats):
    s = b * BEAT
    i0 = int(s * SR)
    i1 = min(N, int((s + 0.16) * SR))
    if i1 <= i0:
        continue
    tt = np.arange(i1 - i0) / SR
    freq = 45 + (160 - 45) * np.exp(-tt / 0.03)
    phase = 2 * np.pi * np.cumsum(freq) / SR
    music[i0:i1] += np.sin(phase) * np.exp(-tt / 0.05) * 0.95
    kick_env[i0:i1] += np.exp(-tt / 0.09)

# --- hats on offbeat 8ths: short noise bursts ---
for b in range(n_beats * 2):
    s = b * BEAT / 2 + BEAT / 2
    if s >= DUR:
        break
    i0 = int(s * SR)
    i1 = min(N, int((s + 0.04) * SR))
    if i1 <= i0:
        continue
    tt = np.arange(i1 - i0) / SR
    noise = rng.standard_normal(i1 - i0)
    # crude high-pass: differentiate
    noise = np.diff(noise, prepend=0.0)
    music[i0:i1] += noise * np.exp(-tt / 0.012) * 0.16

# --- clap on beats 2 and 4 of each bar ---
for bar in range(int(DUR / BAR) + 1):
    for beat_in_bar in (1, 3):
        s = bar * BAR + beat_in_bar * BEAT
        if s >= DUR:
            continue
        i0 = int(s * SR)
        i1 = min(N, int((s + 0.12) * SR))
        if i1 <= i0:
            continue
        tt = np.arange(i1 - i0) / SR
        noise = rng.standard_normal(i1 - i0)
        # band-ish: smooth then differentiate twice for a snap
        noise = np.convolve(noise, np.ones(8) / 8, mode="same")
        noise = np.diff(noise, prepend=0.0)
        music[i0:i1] += noise * np.exp(-tt / 0.03) * 0.30

# --- bass: 8th notes on the bar root, saw-ish (harmonic sum) ---
for bar in range(int(DUR / BAR) + 1):
    root = ROOTS[bar % len(ROOTS)]
    for e8 in range(8):
        s = bar * BAR + e8 * BEAT / 2
        if s >= DUR:
            continue
        # accent on 1 and 3.5
        amp = 0.34 if e8 in (0, 7) else 0.22
        i0 = int(s * SR)
        i1 = min(N, int((s + 0.22) * SR))
        if i1 <= i0:
            continue
        tt = np.arange(i1 - i0) / SR
        bass_wave = np.zeros(i1 - i0)
        for h, a in ((1, 1.0), (2, 0.45), (3, 0.22), (4, 0.10)):
            bass_wave += a * np.sin(2 * np.pi * root * h * tt)
        bass_wave /= 1.77
        music[i0:i1] += bass_wave * np.exp(-tt / 0.09) * amp

# --- arp: 16th-note plucks, pentatonic, quiet and bright ---
seq = [0, 2, 4, 5, 4, 2, 3, 1]
for bar in range(int(DUR / BAR) + 1):
    for s16 in range(16):
        s = bar * BAR + s16 * BEAT / 4
        if s >= DUR:
            continue
        f = ARP_NOTES[seq[(s16 + bar) % len(seq)]]
        i0 = int(s * SR)
        i1 = min(N, int((s + 0.16) * SR))
        if i1 <= i0:
            continue
        tt = np.arange(i1 - i0) / SR
        pluck = np.sin(2 * np.pi * f * tt) + 0.3 * np.sin(2 * np.pi * f * 2 * tt)
        music[i0:i1] += pluck * np.exp(-tt / 0.05) * 0.10

# --- gentle pump: duck the bed slightly on each kick ---
music *= 1.0 - 0.22 * np.clip(kick_env, 0, 1)

# --- master: soft clip + normalize to -1 dB peak ---
music = np.tanh(music * 1.4)
peak = np.max(np.abs(music))
music = music / peak * 0.89

stereo = np.stack([music, music], axis=1)
pcm = (stereo * 32767).astype("<i2")

out = "build/v2/music.wav"
with wave.open(out, "wb") as w:
    w.setnchannels(2)
    w.setsampwidth(2)
    w.setframerate(SR)
    w.writeframes(pcm.tobytes())
print("wrote", out, "dur", DUR, "peak", round(float(np.max(np.abs(music))), 3))
