#!/bin/bash

# Must be in same directory to run

DIR="."
GITHUB_LOGO="$DIR/github.png"
TEMP_LOGO="$DIR/github_resized.png"

find "$DIR" -name "*_github.png" -exec rm {} \;

for IMAGE in "$DIR"/*.png; do
    if [[ "$IMAGE" == "$GITHUB_LOGO" ]]; then
        continue
    fi

    OUTPUT_IMAGE="${IMAGE%.png}_with_github.png"

    WIDTH=$(magick identify -format %w "$IMAGE")
    HEIGHT=$(magick identify -format %h "$IMAGE")

    # Size for the new logo (30% of og image height)
    LOGO_HEIGHT=$((HEIGHT / 3))

    # Resize github logo 
    magick convert "$GITHUB_LOGO" -background none -resize x$LOGO_HEIGHT "$TEMP_LOGO"

    LOGO_WIDTH=$(magick identify -format %w "$TEMP_LOGO")
    LOGO_HEIGHT=$(magick identify -format %h "$TEMP_LOGO")

    COMBINED_WIDTH=$((WIDTH + LOGO_WIDTH))
    magick convert -size ${COMBINED_WIDTH}x${HEIGHT} xc:none "$IMAGE" -geometry +0+0 -composite "$TEMP_LOGO" -geometry +${WIDTH}+0 -gravity SouthWest -composite "$OUTPUT_IMAGE"

    echo "Created $OUTPUT_IMAGE"
done

rm "$TEMP_LOGO"
