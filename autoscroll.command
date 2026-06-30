#!/bin/bash
echo "🚀 autoscroll 설정을 시작합니다..."
mkdir -p ~/.hammerspoon

cat << 'INNER_EOF' >> ~/.hammerspoon/init.lua

-- [Autoscroll Configuration]
local scrollTimer = nil
local scrollSpeed = 1
local scrollInterval = 0.25 -- 기획 문서 읽기에 적합한 느리고 편안한 속도
local interruptTap = nil

local function stopScroll()
    if scrollTimer then
        scrollTimer:stop()
        scrollTimer = nil
    end
    if interruptTap then
        interruptTap:stop()
    end
end

interruptTap = hs.eventtap.new({
    hs.eventtap.event.types.keyDown,
    hs.eventtap.event.types.leftMouseDown,
    hs.eventtap.event.types.rightMouseDown,
    hs.eventtap.event.types.scrollWheel
}, function(ev)
    -- 우리가 발생시킨 가상 스크롤 이벤트는 무시
    if ev:getProperty(hs.eventtap.event.properties.eventSourceUserData) == 12345 then
        return false
    end
    
    -- 시작/정지 단축키(Cmd+Alt+Ctrl+S) 입력은 중단 이벤트에서 제외 (단축키에 온전히 맡김)
    if ev:getType() == hs.eventtap.event.types.keyDown then
        local flags = ev:getFlags()
        if ev:getKeyCode() == hs.keycodes.map["s"] and flags.cmd and flags.alt and flags.ctrl then
            return false
        end
    end
    
    -- 그 외 사용자의 키보드/마우스 입력이 감지되면 스크롤 즉시 정지
    stopScroll()
    return false
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "s", function()
    if scrollTimer then
        stopScroll()
    else
        -- 스크롤 시작
        scrollTimer = hs.timer.doEvery(scrollInterval, function()
            local scrollEvent = hs.eventtap.event.newScrollEvent({0, -scrollSpeed}, {}, "line")
            scrollEvent:setProperty(hs.eventtap.event.properties.eventSourceUserData, 12345)
            scrollEvent:post()
        end)
        interruptTap:start()
    end
end)
INNER_EOF

if [ ! -d "/Applications/Hammerspoon.app" ] && [ ! -d "$HOME/Applications/Hammerspoon.app" ]; then
    echo "스크롤 엔진(Hammerspoon)을 설치합니다..."
    if command -v brew &> /dev/null; then
        echo "Homebrew가 감지되어 안전하게 설치를 진행합니다..."
        brew install --cask hammerspoon
    else
        echo "직접 다운로드하여 설치합니다 (권한 오류 방지)..."
        curl -L https://github.com/Hammerspoon/hammerspoon/releases/latest/download/Hammerspoon.zip -o /tmp/Hammerspoon.zip
        mkdir -p ~/Applications
        unzip -q /tmp/Hammerspoon.zip -d ~/Applications/
        rm /tmp/Hammerspoon.zip
    fi
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
        <string>/usr/bin/open</string>
        <string>-a</string>
        <string>Hammerspoon</string>
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
