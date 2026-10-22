#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
models="$root/models"
mkdir -p "$models"

if ! ollama show mock-coding-local >/dev/null 2>&1; then
  if ! ollama show qwen3:4b-instruct >/dev/null 2>&1; then
    ollama pull qwen3:4b-instruct
  fi
  ollama create mock-coding-local -f "$root/scripts/Modelfile"
fi

if [[ ! -f "$models/sherpa-onnx-moonshine-tiny-en-int8/encode.int8.onnx" ]]; then
  curl -fsSL --retry 2 \
    https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-moonshine-tiny-en-int8.tar.bz2 \
    | tar -xj -C "$models"
fi

if [[ ! -f "$models/vits-piper-en_US-lessac-medium/en_US-lessac-medium.onnx" ]]; then
  curl -fsSL --retry 2 \
    https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-piper-en_US-lessac-medium.tar.bz2 \
    | tar -xj -C "$models"
fi

printf 'Local speech models ready in %s\n' "$models"
