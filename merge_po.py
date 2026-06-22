#!/usr/bin/env python3
"""
Merge DeepSeek CSV, Codex CSV, and existing PO into a context-rich PO file.

DeepSeek CSV columns:  category, section, key, original_text
Codex CSV columns:     category, key, text, source
"""

import csv
import re
import os

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

DEEPSEEK_CSV = "/Users/motoki/Downloads/Catburglar_extracted_files/fromDeepSeek_extracted/text/all_translatable_text.csv"
CODEX_CSV    = "/Users/motoki/Downloads/Catburglar_extracted_files/fromCodex_extracted_20260525_145633/texts/translatable_texts.csv"
PO_IN        = os.path.join(SCRIPT_DIR, "translations", "zh_CN.po")
PO_OUT       = os.path.join(SCRIPT_DIR, "translations", "zh_CN.po")

# ── Non-translatable strings to exclude ─────────────────────────────────────
NON_TRANSLATABLE = {
    # Godot internal / file paths
    "user://settings.ini",
    # File extensions
    ".ogg",
    # Format strings
    "%02d:%02d.%03d",
    # UI concatenation symbols
    "[", "]", "...", "$",
    # Scene editor placeholders (replaced at runtime)
    "Menu Title", "Action Name", "Button", "Tickbox", "Selector", "Value",
    "Volume", "[Space] /", "X",
    # Debug / error log
    "Unknown setting:",
}


def parse_deepseek(path):
    """Return dict: text -> list of '[category / section] key: xxx'."""
    data = {}
    with open(path, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            text = row["original_text"].strip()
            if text in NON_TRANSLATABLE:
                continue
            ctx = f'[{row["category"]} / {row["section"]}] key: {row["key"]}'
            data.setdefault(text, []).append(ctx)
    return data


def parse_codex(path):
    """Return dict: text -> list of 'path:lineno'."""
    data = {}
    with open(path, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            text = row["text"].strip()
            if text in NON_TRANSLATABLE:
                continue
            src = row["source"]
            # script_string entries have lineno appended like "scripts/dialogues.gd:911"
            # extract just the path part for readable display
            data.setdefault(text, []).append(src)
    return data


def parse_po(path):
    """Return list of dicts preserving order: {msgid, msgstr, comments}."""
    entries = []
    with open(path, encoding="utf-8") as f:
        content = f.read()

    # Split into blocks: header first, then msgid/msgstr pairs
    blocks = re.split(r'\n(?=msgid )', content)

    header = blocks[0] if blocks else ""

    for block in blocks[1:]:
        m_id = re.search(r'msgid "(.*)"', block)
        m_str = re.search(r'msgstr "(.*)"', block, re.DOTALL)
        if not m_id:
            continue

        msgid = m_id.group(1).replace('\\n', '\n')

        # Preserve existing comments (lines before msgid)
        comment_lines = []
        for line in block.split('\n')[:m_id.start()]:
            stripped = line.strip()
            # Keep existing reference and extracted comments
            if stripped.startswith('#') and not stripped.startswith('#,'):
                comment_lines.append(stripped)

        entries.append({
            "msgid": msgid,
            "msgstr": m_str.group(1) if m_str else "",
            "existing_comments": comment_lines,
        })

    return header, entries


def build_section_order(category, section):
    """Return a sort key tuple for a given category and section."""
    cat_order = {
        "menu_ui": 0,
        "hud": 1,
        "briefing_screen": 2,
        "level_briefings": 3,
        "dialogues": 4,
        "hints": 5,
        "loot_descriptions": 6,
        "in_game_objectives": 7,
        "level_complete_screen": 8,
        "credits": 9,
        "ending_screen": 10,
    }
    return (cat_order.get(category, 99), section)


def main():
    deepseek = parse_deepseek(DEEPSEEK_CSV)
    codex = parse_codex(CODEX_CSV)
    header, po_entries = parse_po(PO_IN)

    # ── Build merged data ────────────────────────────────────────────────
    # all_texts: set of all known msgid strings
    all_texts = set(deepseek.keys()) | set(codex.keys())
    for e in po_entries:
        all_texts.add(e["msgid"])

    # Build merged entries dict
    merged = {}
    for text in sorted(all_texts, key=lambda t: t.lower()):
        ctxs = deepseek.get(text, [])
        srcs = codex.get(text, [])
        # Remove duplicate contexts
        ctxs_unique = list(dict.fromkeys(ctxs))
        srcs_unique = list(dict.fromkeys(srcs))
        merged[text] = {"contexts": ctxs_unique, "sources": srcs_unique}

    # ── Find existing translation for each text ──────────────────────────
    translations = {}
    for e in po_entries:
        translations[e["msgid"]] = e["msgstr"]

    # ── Determine primary category for sorting ───────────────────────────
    def primary_sort_key(text):
        """Extract the first category/section from DeepSeek for sorting."""
        ctxs = merged[text]["contexts"]
        if ctxs:
            # Parse "[category / section] key: xxx"
            m = re.match(r'\[(\S+) / (\S+)\]', ctxs[0])
            if m:
                return build_section_order(m.group(1), m.group(2))
        return (99, "zzz")

    sorted_texts = sorted(all_texts, key=primary_sort_key)

    # ── Write output ─────────────────────────────────────────────────────
    lines = [header.rstrip()]

    # Add annotation explaining comment conventions
    lines.append('')
    lines.append('#. 上下文标注: [category / section] key: key_name')
    lines.append('#.   category  = 文本大类 (menu_ui / dialogues / hints / ...)')
    lines.append('#.   section   = 子分类 (title_menu / level1 / gameplay / ...)')
    lines.append('#.   key       = 唯一标识符')
    lines.append('#:  源码位置: 文件路径:行号')
    lines.append('#, fuzzy  标记为待翻译')
    lines.append('')

    for text in sorted_texts:
        info = merged[text]
        translation = translations.get(text, "")

        # Determine if this is a new entry (not in PO)
        is_new = text not in translations

        # Determine if this is PO-only (not in either CSV)
        is_po_only = (not info["contexts"] and not info["sources"])

        # Build comment block
        for ctx in info["contexts"]:
            lines.append(f'#. {ctx}')
        for src in info["sources"]:
            lines.append(f'#: {src}')
        if is_po_only:
            lines.append('#. [unknown] — not found in extracted CSV sources')
        if is_new:
            lines.append('#, fuzzy')

        # Escape newlines in msgid/msgstr
        escaped_text = text.replace('"', '\\"').replace('\n', '\\n')
        # Godot PO uses literal newlines in msgstr, but escaped in msgid
        lines.append(f'msgid "{escaped_text}"')

        if translation:
            escaped_trans = translation.replace('"', '\\"').replace('\n', '\\n')
        else:
            escaped_trans = ""
        lines.append(f'msgstr "{escaped_trans}"')
        lines.append('')

    with open(PO_OUT, "w", encoding="utf-8") as f:
        f.write('\n'.join(lines))

    # ── Report ───────────────────────────────────────────────────────────
    new_count = sum(1 for t in sorted_texts if t not in translations)
    existing_count = sum(1 for t in sorted_texts if t in translations)
    print(f"Output: {PO_OUT}")
    print(f"  Existing translations: {existing_count}")
    print(f"  New (fuzzy, waiting): {new_count}")
    print(f"  PO-only (unknown src): {sum(1 for t in sorted_texts if not merged[t]['contexts'] and not merged[t]['sources'])}")


if __name__ == "__main__":
    main()
