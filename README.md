# Catburglar — Simplified Chinese Edition

A Simplified Chinese localization fork of [Catburglar](https://bitbucket.org/JohnGabrielUK/catburglar/src/master/), a stealth game by John Gabriel created for Godot Wild Jam #63. You play as **Cynth**, a cat burglar sneaking through mansions, dodging guards, and making off with the goods.

## What's New

- **Full Simplified Chinese UI** — menus, HUD, briefings, subtitles, and credits fully localized
- **Chinese voice-over** — 18 VO lines (briefings, in-level dialogues, ending) with automatic language-based switching
- **Translation pipeline fixes** — resolved upstream PO issues including trailing-space mismatches, `fuzzy`-flagged entries blocking translations, and dynamically generated strings missed by POT extraction
- **Chinese UI polish** — fixed briefing text overflow on Level 3, added bold Chinese font support, adjusted menu spacing

## Getting Started

1. Install [Godot 4.2+](https://godotengine.org/)
2. Open this project directory in Godot
3. Press F5 to run

## Switching Languages

In-game: **Settings → Language → English / 简体中文**

Language switching applies to:
- UI text
- Mission objectives
- Dialogue subtitles
- Voice-over audio

## Project Layout

```
game/
├── audio/vo/          # English VO (18 .ogg files)
├── audio/vo/zh/       # Chinese VO (18 .ogg files)
├── fonts/             # Fonts (including Hiragino Sans GB for Chinese)
├── objects/           # Scene objects (HUD, menus, prompts)
├── scenes/            # Game scenes (title, briefing, levels, ending)
├── scripts/           # Game logic (dialogues, constants, settings)
├── translations/      # Translation files
│   ├── zh_CN.po       # Main Simplified Chinese translation
│   └── Extra_zh_CN.po # Supplemental translations for dynamic strings
└── project.godot      # Godot project config
```

## Credits

- **Original game** — [John Gabriel](https://johngabrieluk.itch.io/catburglar): directing, writing and developing
- **Pixel art** — Jerico Landry
- **Digital art and character design** — Kyveri
- **Voice of Cynth (EN)** — Carrie Drovdlic
- **Music** — Sacha Feldman
- **Simplified Chinese localization** — this repo's contributors

## License

This project continues under the upstream [MIT License](LICENSE).
