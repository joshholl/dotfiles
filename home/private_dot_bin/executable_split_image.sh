#!/usr/bin/env bash

if ! command -v convert &> /dev/null
then 
  &>2 echo "You must install imagemagick before this command will work"
  exit 1
fi

large_file=$1

if [ ! -f "${large_file}" ]; then
  &>2 echo "${large_file} is not a file"
  exit 1
fi



file_dir=$(dirname -- "${large_file}")
file_name=$(basename -- "${large_file}")
extension="${file_name##*.}"
file_name="${file_name%.*}"




if [ -f "${file_dir}/${file_name}-left.${extension}" ]; then
  &>2 echo "Outputting the left file will overwrite an existing file"
  exit 1
fi

if [ -f "${file_dir}/${file_name}-right.${extension}" ]; then
  &>2 echo "Outputting the right file will overwrite an existing file"
  exit 1
fi

convert -crop "50%x100%" $large_file ${file_dir}/${file_name}-split.${extension}


if [ -f "${file_dir}/${file_name}-split-0.${extension}" ]; then
  mv ${file_dir}/${file_name}-split-0.${extension} ${file_dir}/${file_name}-left.${extension}
fi

if [ -f "${file_dir}/${file_name}-split-1.${extension}" ]; then
  mv ${file_dir}/${file_name}-split-1.${extension} ${file_dir}/${file_name}-right.${extension}
fi

