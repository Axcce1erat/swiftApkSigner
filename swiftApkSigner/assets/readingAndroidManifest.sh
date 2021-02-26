#!/bin/zsh
source ~/.zshrc
#  readingAndroidManifest.sh
#  swiftApkSigner
#
#  Created by Axel Schwarz on 25.02.21.
#
aapt dump badging $1 | grep 'package' | sed 's/\(^.*\) platformBuildVersionName.*/\1/'
#/Users/axelschwarz/Library/Developer/Xcode/DerivedData/swiftApkSigner-gqryovkkaznkrogfwnjulbdgxrqq/Build/Products/Debug/release_unsigned.apk
