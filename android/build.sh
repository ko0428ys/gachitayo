#!/usr/bin/env bash
# 같이타요 APK 빌드 (Android SDK 없이 apktool + uber-apk-signer 사용)
# 필요: Java 17+
#   tools/apktool.jar  ← https://github.com/iBotPeaches/Apktool/releases (2.10.0)
#   tools/signer.jar   ← https://github.com/patrickfav/uber-apk-signer/releases (1.3.0)
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p assets out
cp ../index.html assets/index.html        # 웹 앱을 그대로 APK에 넣는다
java -jar ../tools/apktool.jar b . -o out/unsigned.apk
java -jar ../tools/signer.jar -a out/unsigned.apk -o out/signed
cp out/signed/unsigned-aligned-debugSigned.apk out/gachitayo.apk
echo "완성: android/out/gachitayo.apk"
