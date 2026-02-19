#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title Toggle Ollama
# @vicinae.mode compact
# @vicinae.icon 🦙
# @vicinae.description Start or stop the Ollama LLM service

if systemctl is-active --quiet ollama.service; then
  sudo systemctl stop ollama.service
  echo "🦙 Ollama stopped"
else
  sudo systemctl start ollama.service
  echo "🦙 Ollama started"
fi
