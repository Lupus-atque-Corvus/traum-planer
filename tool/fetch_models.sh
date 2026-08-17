#!/usr/bin/env bash
# Lädt die lokalen Modellgewichte für Phase 8 (STT), die aus Größengründen
# nicht in Git liegen (siehe .gitignore). Läuft unter Git Bash (Windows),
# macOS und Linux — überall wo curl vorhanden ist.
set -euo pipefail

ZIEL_VERZEICHNIS="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/assets/whisper"
mkdir -p "$ZIEL_VERZEICHNIS"

DATEI="$ZIEL_VERZEICHNIS/ggml-small.bin"
if [ -f "$DATEI" ]; then
  echo "Bereits vorhanden: $DATEI"
  exit 0
fi

echo "Lade Whisper 'small' (mehrsprachig, ~465 MB) nach $DATEI …"
curl -L --progress-bar -o "$DATEI" \
  "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.bin"

echo "Fertig."
