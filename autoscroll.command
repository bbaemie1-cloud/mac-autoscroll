#!/bin/bash
set -e

echo "자동 스크롤 기능 설치를 시작합니다..."

# 1. Hammerspoon 설정 디렉토리 생성
mkdir -p ~/.hammerspoon

# 2. init.lua 파일 생성
cat << 'EOF' > ~/.hammerspoon/init.lua
-- [Autoscroll Configuration]
local scrollTimer = nil
local scrollSpeed = 2 -- 기본 속도 (부드러운 스크롤 픽셀량)
local scrollInterval = 0.01 -- 100 FPS 수준의 부드러운 갱신 주기
local interruptTap = nil

-- 알림 메시지(인터페이스) 투명도 및 스타일 설정
local alertStyle = {
    fillColor = { white = 0, alpha = 0.3 }, -- 배경 투명도 (0.0 투명 ~ 1.0 불투명)
    strokeColor = { white = 1, alpha = 0.2 }, -- 테두리 투명도
    textColor = { white = 1, alpha = 0.9 }, -- 글씨 투명도
    radius = 15,
    textSize = 27,
    fadeInDuration = 0.1, -- 나타나는 애니메이션 속도
    fadeOutDuration = 0.1 -- 사라지는 애니메이션 속도
}

-- 속도 조절 함수
local alertTimer = nil
local function changeSpeed(delta)
    scrollSpeed = scrollSpeed + delta
    if scrollSpeed < 1 then scrollSpeed = 1 end
    if scrollSpeed > 30 then scrollSpeed = 30 end
    
    hs.alert.closeAll(0.0) -- 이전 알림 즉시 삭제
    hs.alert.show("자동 스크롤 속도: " .. scrollSpeed, alertStyle)
    
    -- 엔진 버그 우회: 강제로 0.4초 뒤에 알림 메시지를 삭제하는 타이머 생성
    if alertTimer then alertTimer:stop() end
    alertTimer = hs.timer.doAfter(0.4, function()
        hs.alert.closeAll(0.1)
    end)
end

-- 단축키: 속도 줄이기 (Cmd+Alt+Ctrl+Left)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "left", function()
    changeSpeed(-1)
end)

-- 단축키: 속도 늘리기 (Cmd+Alt+Ctrl+Right)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "right", function()
    changeSpeed(1)
end)

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
    
    -- 시작/정지/속도조절 단축키 입력은 중단 이벤트에서 제외
    if ev:getType() == hs.eventtap.event.types.keyDown then
        local flags = ev:getFlags()
        local keyCode = ev:getKeyCode()
        if flags.cmd and flags.alt and flags.ctrl then
            if keyCode == hs.keycodes.map["down"] or keyCode == hs.keycodes.map["left"] or keyCode == hs.keycodes.map["right"] then
                return false
            end
        end
    end
    
    -- 그 외 사용자의 입력이 감지되면 스크롤 즉시 정지
    stopScroll()
    return false
end)

-- 단축키: 스크롤 시작/정지 (Cmd+Alt+Ctrl+Down)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "down", function()
    if scrollTimer then
        stopScroll()
    else
        -- 스크롤 시작
        scrollTimer = hs.timer.doEvery(scrollInterval, function()
            local scrollEvent = hs.eventtap.event.newScrollEvent({0, -scrollSpeed}, {}, "pixel")
            scrollEvent:setProperty(hs.eventtap.event.properties.eventSourceUserData, 12345)
            scrollEvent:post()
        end)
        interruptTap:start()
    end
end)
EOF

echo "스크립트가 성공적으로 저장되었습니다."

if [ ! -d "/Applications/Hammerspoon.app" ]; then
    echo "스크롤 엔진(Hammerspoon)을 다운로드합니다..."
    curl -L "https://github.com/Hammerspoon/hammerspoon/releases/download/1.1.1/Hammerspoon-1.1.1.zip" -o /tmp/Hammerspoon.zip
    echo "압축을 풀고 응용 프로그램 폴더로 이동합니다..."
    unzip -q /tmp/Hammerspoon.zip -d /Applications/
    rm /tmp/Hammerspoon.zip
else
    echo "스크롤 엔진이 이미 설치되어 있습니다."
fi

# 3. 백그라운드 서비스(LaunchAgent) 설정
cat << 'EOF' > ~/Library/LaunchAgents/org.hammerspoon.autostart.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>org.hammerspoon.autostart</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/open</string>
        <string>-a</string>
        <string>Hammerspoon</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <dict>
        <key>SuccessfulExit</key>
        <false/>
    </dict>
</dict>
</plist>
EOF

echo "백그라운드 서비스가 등록되었습니다."

# LaunchAgent 적용 및 Hammerspoon 실행
launchctl load ~/Library/LaunchAgents/org.hammerspoon.autostart.plist 2>/dev/null || true
open -a Hammerspoon

echo "==================================================="
echo "설치가 완료되었습니다!"
echo "단축키 Cmd+Alt+Ctrl+화살표아래(Down)를 누르면 자동 스크롤이 시작됩니다."
echo "단축키 Cmd+Alt+Ctrl+화살표왼쪽(Left)/오른쪽(Right)을 눌러 속도를 조절하세요!"
echo "==================================================="
