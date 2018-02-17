#!/bin/bash

# based on the work of fastrizwaan
# https://stackoverflow.com/questions/30931/register-file-extensions-mime-types-in-linux#31836

APP=$1
NAME="$2"
EXT="$3"
COMMENT="$APP's data file"

# Create directories if missing
mkdir -p ~/.local/share/mime/packages

# Create mime xml 
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<mime-info xmlns=\"http://www.freedesktop.org/standards/shared-mime-info\">
    <mime-type type=\"application/x-$APP\">
        <comment>$COMMENT</comment>
        <icon name=\"application-x-$APP\"/>
        <glob pattern=\"*.$EXT\"/>
    </mime-type>
</mime-info>" > ~/.local/share/mime/packages/application-x-$APP.xml

