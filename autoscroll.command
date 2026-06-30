#!/bin/bash

echo "🚀 autoscroll 설정을 시작합니다..."

mkdir -p ~/.hammerspoon

# 덮어쓰기(>) 대신 이어쓰기(>>)를 사용하여 기존 설정을 보호합니다.
cat << 'INNER_EOF' >> ~/.hammerspoon/init.lua

-- [Autoscroll Configuration]
local scrollTimer = nil
local scrollSpeed = 4 -- 기본 속도 (부드러운 스크롤 픽셀량)
local scrollInterval = 0.02 -- 50 FPS 수준의 부드러운 갱신 주기
local interruptTap = nil

-- [Menu Bar Interface]
-- 전역 변수로 선언하여 가비지 컬렉터(GC)에 의해 삭제되는 것을 방지합니다.
speedMenu = hs.menubar.new()
if speedMenu then
    speedMenu:setTitle("AutoScroll")
end

function setSpeed(speed)
    scrollSpeed = speed
    updateMenu()
    hs.alert.show("스크롤 속도 변경: " .. speed)
end

function updateMenu()
    if not speedMenu then return end
    speedMenu:setMenu({
        { title = "자동 스크롤 속도 조절", disabled = true },
        { title = "-" },
        { title = "매우 느리게 (1px)", fn = function() setSpeed(1) end, checked = (scrollSpeed == 1) },
        { title = "느리게 (2px)", fn = function() setSpeed(2) end, checked = (scrollSpeed == 2) },
        { title = "조금 느리게 (3px)", fn = function() setSpeed(3) end, checked = (scrollSpeed == 3) },
        { title = "보통 (4px)", fn = function() setSpeed(4) end, checked = (scrollSpeed == 4) },
        { title = "빠르게 (6px)", fn = function() setSpeed(6) end, checked = (scrollSpeed == 6) },
        { title = "매우 빠르게 (8px)", fn = function() setSpeed(8) end, checked = (scrollSpeed == 8) },
        { title = "-" },
        { title = "현재 속도: " .. scrollSpeed .. "px / 0.02초", disabled = true }
    })
end

updateMenu()

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
    
    -- 시작/정지 단축키(Cmd+Alt+Ctrl+Down) 입력은 중단 이벤트에서 제외 (단축키에 온전히 맡김)
    if ev:getType() == hs.eventtap.event.types.keyDown then
        local flags = ev:getFlags()
        if ev:getKeyCode() == hs.keycodes.map["down"] and flags.cmd and flags.alt and flags.ctrl then
            return false
        end
    end
    
    -- 그 외 사용자의 키보드/마우스 입력이 감지되면 스크롤 즉시 정지
    stopScroll()
    return false
end)

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
INNER_EOF

# Homebrew가 설치되어 있는지 확인
if command -v brew >/dev/null 2>&1; then
    echo "Homebrew가 감지되었습니다. brew를 통해 Hammerspoon을 설치/업데이트합니다..."
    brew install --cask hammerspoon
else
    # Homebrew가 없으면 직접 다운로드 (권한 문제가 적은 ~/Applications 폴더 사용)
    echo "Homebrew가 없습니다. 수동으로 다운로드합니다..."
    mkdir -p ~/Applications
    curl -L https://github.com/Hammerspoon/hammerspoon/releases/latest/download/Hammerspoon.zip -o /tmp/Hammerspoon.zip
    echo "압축을 풀고 응용 프로그램 폴더(~/Applications)로 이동합니다..."
    unzip -qo /tmp/Hammerspoon.zip -d ~/Applications/
    rm /tmp/Hammerspoon.zip
fi

echo "Hammerspoon 설정(LaunchAgent)을 등록하여 부팅 시 자동 실행되도록 합니다..."
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

echo "Hammerspoon을 실행합니다..."
# 기존 프로세스 종료 후 재실행 시도
killall Hammerspoon 2>/dev/null || true
sleep 1
open -a Hammerspoon

echo "✅ 모든 설정이 완료되었습니다!"
echo "상단 메뉴 막대(Menubar)에 스크롤 아이콘(⬇️)이 추가되었습니다. 여기서 속도를 변경할 수 있습니다."
echo "단축키: Cmd + Alt + Ctrl + 아래 화살표"
echo "이제 사용해보세요!"
