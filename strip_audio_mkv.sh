#!/bin/bash
# keep only audio track 1
# keep no subtitle tracks
# or use -map 0:m:language:eng

loglevel='warning'
opts='-hide_banner -loglevel ${loglevel}'
count=$(ls -la new-*.mkv | wc -l)

displaytime () {
    local T=$SECONDS
    local D=$((T/60/60/24))
    local H=$((T/60/60%24))
    local M=$((T/60%60))
    local S=$((T%60))
    [[ $D > 0 ]] && printf '%d days ' $D
    [[ $H > 0 ]] && printf '%d hours ' $H
    [[ $M > 0 ]] && printf '%d minutes ' $M
    [[ $D > 0 || $H > 0 || $M > 0 ]] && printf 'and '
    printf '%d seconds\n' $S
}

echo "Found ${count} files to modify."

for x in *.mkv ; do
    echo -ne "Muxing ${x}..."
    ffmpeg ${opts} -i "${x}" -map 0:v -map 0:a:0 -map -0:s -c copy "new-${x}"
#    ffmpeg -hide_banner -loglevel info -i "${x}" -map 0:v -map 0:m:language:eng -map -0:s -c copy "new-${x}"
    echo "Done."
done

echo -e "${count} new files were created.\n"
echo -e "Deleting old files...\n"
rm -fv !(new-*.mkv)
echo -e "Renaming new files to old file names.\n"
for n in new-*.mmkv ; do
    mv -v "$n" "$(echo "$n" | sed s/new-//)"
done

time=$(displaytime)
echo -e "Completed in ${time}.\n"

exit 0