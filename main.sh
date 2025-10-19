#!/bin/bash

set -e

base_dir="$(realpath -m  $(dirname "$0"))"
data_dir="$base_dir/data"
downloads_dir="$base_dir/downloads"
repo_dir="$downloads_dir/chromiumos-overlay"

platform_regex='[ -](\d+\.\d+\.\d+)$'
chrome_regex='(\d+\.\d+\.\d+\.\d+)'

mkdir -p "$downloads_dir"
mkdir -p "$data_dir"

echo "setting up overlay repo"
if [ ! -d "$repo_dir" ]; then
  git clone "https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay" "$repo_dir"
fi

cd "$repo_dir"
echo "updating overlay repo"
git pull

echo "exporting commit log"
#the platform version is stored in chromeos/config/chromeos_version.sh, 
#so we will look for git commits which modify that file
git log --all --format='%H %s' -- chromeos/config/chromeos_version.sh | pcre2grep "$platform_regex" > "$downloads_dir/commits.txt"

echo "reading version numbers from commits"
rm -f "$downloads_dir/versions.csv"
while read line; do
  #the chrome browser version is stored in the directory chromeos-base/chromeos-chrome/
  #it'll look something like chromeos-chrome-65.0.3311.0-r1.ebuild
  hash="$(echo "$line" | cut -d' ' -f1)"
  platform_ver="$(echo "$line" | pcre2grep -o1 "$platform_regex")"
  chrome_ver="$(git ls-tree -r --name-only "$hash" 'chromeos-base/chromeos-chrome' | pcre2grep -o1 "$chrome_regex" | sort --version-sort | tail -n1)"
  if [ "$chrome_ver" ]; then
    echo "$platform_ver,$chrome_ver" >> "$downloads_dir/versions.csv"
  fi
done < "$downloads_dir/commits.txt"

echo "exporting versions as csv"
sort -u --version-sort "$downloads_dir/versions.csv" > "$data_dir/data.csv"

echo "done"