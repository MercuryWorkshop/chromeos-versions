# Chrome OS Versions

This repo contains scripts for building a database which lists all Chrome OS platform versions and their corresponding Chrome browser versions.

A prebuilt copy of this database is available at: https://nightly.link/MercuryWorkshop/chromeos-versions/workflows/build/main/data.zip

## Explanation

[Each Chrome OS build has two version numbers.](https://www.chromium.org/chromium-os/developer-library/reference/release/understanding-chromeos-releases/) The first is the **platform version**, which is a 3 part version number which represents all of the system components of Chrome OS. The second is the **browser version** which is a 4 part version number that represents the version of the Chrome browser that shipped with the OS. 

Associating a platform version with a browser version is not very easy. There are many sources for this information, including [ChromiumDash](https://chromiumdash.appspot.com/serving-builds?deviceCategory=ChromeOS), the [Recovery Images JSON](https://dl.google.com/dl/edgedl/chromeos/recovery/recovery.json), and the [Chrome Releases Blog](https://chromereleases.googleblog.com/). These sources are not great to work with because they are often missing many version numbers and historical data. Sometimes these sources even disagree with each other as to what the browser version is for a certain platform version.

However, [there's another way to associate platform and browser versions](https://www.chromium.org/developers/version-numbers/), which can work universally. The [chromiumos-overlay](https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/) Git repository lists the current platform version at [`chromeos/config/chromeos_version.sh`](https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/main/chromeos/config/chromeos_version.sh). If we list every commit that ever modified that file, we can know every platform version which ever existed. Then, for each commit, we can look at the [`chromeos-base/chromeos-chrome/`](https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/main/chromeos-base/chromeos-chrome/) directory. This directory will contain a file which is named with the chrome version number, such as [`chromeos-chrome-104.0.5075.0_rc-r1.ebuild`](https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/1fa342edca98051a5f67ed85d736252581e5fa6d/chromeos-base/chromeos-chrome/chromeos-chrome-104.0.5075.0_rc-r1.ebuild). 

Repeating this process for every commit will give us a mapping of every Chrome OS platform version to its corresponding browser version.

## Copyright

This repository is licensed under the GNU GPL v3.

```
MercuryWorkshop/chromeos-versions: Database of Chrome OS version numbers
Copyright (C) 2025 ading2210

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```