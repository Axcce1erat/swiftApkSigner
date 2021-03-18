#!/bin/zsh
source ~/.zshrc
#  readingAndroidManifest.sh
#  swiftApkSigner
#
#  Created by Axel Schwarz on 25.02.21.
#
aapt dump badging $1 | grep 'package\|application-debuggable' | sed 's/\(^.*\) platformBuildVersionName.*/\1/'
