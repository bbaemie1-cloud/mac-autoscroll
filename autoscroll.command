#!/bin/bash
echo "🚀 autoscroll 설정을 시작합니다..."
mkdir -p ~/.hammerspoon

# 덮어쓰기(>) 대신 이어쓰기(>>)를 사용하여 기존 설정을 보호합니다.
cat << 'INNER_EOF' >> ~/.hammerspoon/init.lua

-- [Autoscroll Configuration]
local scrollTimer = nil
local scrollSpeed = 1
local scrollInterval = 0.05

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "s", function()
    if scrollTimer then
        scrollTimer:stop()
        scrollTimer = nil
    else
        scrollTimer = hs.timer.doEvery(scrollInterval, function()
            -- 크롬에서 작동하도록 "pixel" 대신 "line" 단위 사용
            hs.eventtap.scrollWheel({0, -scrollSpeed}, {}, "line")
        end)
    end
end)
INNER_EOF

if [ ! -d "/Applications/Hammerspoon.app" ]; then
    echo "스크롤 엔진(Hammerspoon)을 다운로드합니다..."
    curl -L https://github.com/Hammerspoon/hammerspoon/releases/latest/download/Hammerspoon.zip -o /tmp/Hammerspoon.zip
    echo "압축을 풀고 응용 프로그램 폴더로 이동합니다..."
    unzip -q /tmp/Hammerspoon.zip -d /Applications/
    rm /tmp/Hammerspoon.zip
else
    echo "스크롤 엔진이 이미 설치되어 있습니다."
fi

echo "자동 실행(LaunchAgent) 설정을 추가합니다..."
mkdir -p ~/Library/LaunchAgents
cat << 'PLIST_EOF' > ~/Library/LaunchAgents/org.hammerspoon.Hammerspoon.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>org.hammerspoon.Hammerspoon</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Applications/Hammerspoon.app/Contents/MacOS/Hammerspoon</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
PLIST_EOF
launchctl load ~/Library/LaunchAgents/org.hammerspoon.Hammerspoon.plist 2>/dev/null || true

echo "프로그램을 실행합니다."
open -a Hammerspoon
echo "================================================="
echo "✅ 설치 및 설정이 완료되었습니다!"
echo "⚠️ [중요] 화면에 '손쉬운 사용' 권한 요청 팝업이 뜹니다."
echo "시스템 설정을 열고 Hammerspoon 스위치를 직접 켜주셔야 작동합니다."
echo "================================================="
