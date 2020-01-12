#!/bin/bash

baseurl="https://mirror.codebucket.de/claymore1297/LineageOS/"

if [ "$1" == "" ]; then
	>&2 echo "Usage: $0 <filename> [<baseurl>]"
	exit 1
fi

if [ "$2" != "" ]; then
	baseurl=$2
fi

file=$1
filename=$(basename $file)

if [ ! -e "$file" ]; then
	>&2 echo File \"$file\" not found
	exit 1
fi

version=$(cut -d '-' -f2 <<<"$filename")
romtype=$(cut -d '-' -f4 <<<"$filename")
target=$(cut -d '-' -f5 <<<"${filename%.*}")

datetime=$(unzip -p $file META-INF/com/android/metadata |grep post-timestamp | cut -d= -f2)
id=$(md5sum $file | awk '{ print $1 }')
size=$(stat -c %s $file)

url=${baseurl%%/}/$version/$target/$filename

cat << EOF
{
  "response": [
    {
      "datetime": "$datetime",
      "filename": "$filename",
      "id": "$id",
      "romtype": "$romtype",
      "size": "$size",
      "url": "$url",
      "version": "$version"
    }
  ]
}
EOF
