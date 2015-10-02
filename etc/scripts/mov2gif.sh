#!/bin/bash

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

if [ "$1" = "-h" -o "$1" = "--help" ]; then
    echo "usage: mov2gif file [fps] [height] [weight]"
    exit 1
fi

if ! has "ffmpeg"; then
    echo "ffmpeg: not found" 1>&2
    exit 1
fi

if ! has "gifsicle"; then
    echo "gifsicle: not found" 1>&2
    exit 1
fi

if [ -z "$1" ]; then
    echo "too few arugments" 1>&2
    exit 1
fi
mov_file="$1"

if [ -z "$mov_file" -o ! -f "$mov_file" ]; then
    exit 1
fi

fps="${2:-10}"
out_file="$(basename "$mov_file")"
gif_file="$(dirname "$mov_file")"/"${out_file%.*}".gif

if [ -f "$gif_file" ]; then
    echo "$gif_file: already exists" 1>&2
    exit 1
fi

ffmpeg -i "$mov_file" -s "${3:-600}"x"${4:-400}" -pix_fmt rgb24 -r "$fps" -f gif - | gifsicle --optimize=3 --delay=3 >"$gif_file"
if [ $? -eq 0 ]; then
    echo "Created $gif_file"
fi
