# **WOMB BASSLINE**

**WOMB** is a random bassline generator script for **Monome Norns**, created by **HANJO** (Tokyo, Japan).  
It generates **16-step bassline patterns** synced to Norns' internal clock, with real-time control over **scale**, **root note**, and **note density**.  
WOMB outputs either **internal sound** via the `PolyPerc` engine or **MIDI notes** over USB.

---

## **FEATURES**

- **`K2`**: Toggle Output Mode (`INT` / `MIDI`)  
  - Hold **`K2`** + turn **`E3`** to adjust MIDI channel
- **`K3`**: Generate a new 16-step random bassline
- **`E1`**: Select musical scale
- **`E2`**: Set root note
- **`E3`**: Adjust note density (number of active steps)

---

## **OUTPUTS**

- **`INT`** (Internal):
  - Plays basslines through the built-in `PolyPerc` synth engine
- **`MIDI`**:
  - Sends bassline notes via USB MIDI to external devices

---

## **TECHNICAL DETAILS**

- Uses **Norns global tempo** (internal clock-sync)
- Real-time screen feedback:
  - Scale, Root Note, Density, Output Mode, and MIDI Channel
- **Scale Quantization** when switching scales
- **Root Note Transposition** without breaking sequences
- **Fully randomized 16-step patterns** with every trigger

---

## **REQUIREMENTS**

- **Monome Norns** (any model)
- **Optional**: External MIDI device connected via USB

---

## **CREDITS**

- Script by **HANJO**  
- Tokyo, Japan 🇯🇵

---
