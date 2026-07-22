#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="@WALLPAPER_DIR@"
DEFAULT_WALLPAPER="@DEFAULT_WALLPAPER@"
STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper-index"
HP_CONF="${XDG_CONFIG_HOME:-$HOME/.config}/hyprpanel/config.json"

mapfile -t WALLPAPERS < <(
  find "$WALLPAPER_DIR" -maxdepth 1 -type f \( \
    -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \
  \) | sort
)

if ((${#WALLPAPERS[@]} == 0)); then
  echo "No wallpapers found in $WALLPAPER_DIR" >&2
  exit 1
fi

index_for_path() {
  local target="$1"
  local i
  for i in "${!WALLPAPERS[@]}"; do
    if [[ "${WALLPAPERS[$i]}" == "$target" ]]; then
      echo "$i"
      return 0
    fi
  done
  return 1
}

wait_for_awww() {
  local tries=20
  while ((tries > 0)); do
    if awww query >/dev/null 2>&1; then
      return 0
    fi
    sleep 0.5
    tries=$((tries - 1))
  done
  echo "awww-daemon IPC not ready after waiting; proceeding anyway" >&2
  return 1
}

update_hyprpanel_wallpaper() {
  local path="$1"
  local colors_file="${XDG_CACHE_HOME:-$HOME/.cache}/wallust/hyprpanel-colors.json"
  if [[ -f "$HP_CONF" ]] && command -v jq >/dev/null; then
    local tmp
    tmp="$(mktemp)"
    if [[ -f "$colors_file" ]]; then
      jq --arg img "$path" --slurpfile patch "$colors_file" \
        '. + $patch[0] | .["wallpaper.image"] = $img' "$HP_CONF" >"$tmp"
    else
      jq --arg img "$path" '.["wallpaper.image"] = $img' "$HP_CONF" >"$tmp"
    fi
    mv "$tmp" "$HP_CONF"
  fi
}

apply_wallpaper() {
  local path="$1"
  wait_for_awww
  awww img "$path" --transition-type grow --transition-fps 60
  wallust run "$path"
  update_hyprpanel_wallpaper "$path"
}

current_index=0
if [[ -f "$STATE_FILE" ]]; then
  current_index="$(cat "$STATE_FILE")"
fi

if [[ "${1:-}" == "--init" ]]; then
  if index_for_path "$DEFAULT_WALLPAPER" >/dev/null 2>&1; then
    current_index="$(index_for_path "$DEFAULT_WALLPAPER")"
  fi
else
  current_index=$(( (current_index + 1) % ${#WALLPAPERS[@]} ))
fi

selected="${WALLPAPERS[$current_index]}"
echo "$current_index" >"$STATE_FILE"
apply_wallpaper "$selected"
