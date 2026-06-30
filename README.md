# Mac Autoscroll

macOS 환경에서 Hammerspoon을 이용해 부드러운 자동 스크롤(Autoscroll) 기능을 설정해 주는 설치 스크립트입니다.

## 기능
* **단축키**: `Cmd + Option(Alt) + Ctrl + S`
* 단축키를 누르면 0.02초마다 1픽셀씩 아래로 자동 스크롤됩니다. 다시 누르면 멈춥니다.
* Hammerspoon 앱이 설치되어 있지 않다면 자동으로 다운로드하여 응용 프로그램 폴더에 설치합니다.

## 설치 방법 (터미널)

아래 명령어를 복사하여 Mac의 터미널(Terminal)에 붙여넣고 실행하세요.

```bash
cat << 'EOF' > ~/Desktop/autoscroll.command && chmod +x ~/Desktop/autoscroll.command && clear && echo "✅ 바탕화면에 autoscroll.command 파일이 성공적으로 생성되었습니다! 더블클릭하여 실행해주세요."
#!/bin/bash
echo "🚀 autoscroll 설정을 시작합니다..."
mkdir -p ~/.hammerspoon

# 덮어쓰기(>) 대신 이어쓰기(>>)를 사용하여 기존 설정을 보호합니다.
cat << 'INNER_EOF' >> ~/.hammerspoon/init.lua

-- [Autoscroll Configuration]
local scrollTimer = nil
local scrollSpeed = 1
local scrollInterval = 0.02

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "S", function()
    if scrollTimer then
        scrollTimer:stop()
        scrollTimer = nil
    else
        scrollTimer = hs.timer.doEvery(scrollInterval, function()
            hs.eventtap.scrollWheel({0, -scrollSpeed}, {}, "pixel")
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

echo "프로그램을 실행합니다."
open -a Hammerspoon
echo "================================================="
echo "✅ 설치 및 설정이 완료되었습니다!"
echo "⚠️ [중요] 화면에 '손쉬운 사용' 권한 요청 팝업이 뜹니다."
echo "시스템 설정을 열고 Hammerspoon 스위치를 직접 켜주셔야 작동합니다."
echo "================================================="
EOF
```

## 파일로 배포하기
이 저장소에 있는 `autoscroll.command` 파일을 다운로드 받은 후 더블클릭하여 실행해도 동일하게 설치가 진행됩니다.

## 주의사항
* 최초 실행 시 **'손쉬운 사용' 권한 요청 팝업**이 나타납니다.
* `시스템 설정 > 개인정보 보호 및 보안 > 손쉬운 사용`으로 이동하여 `Hammerspoon` 스위치를 켜주셔야 스크롤 기능이 정상적으로 작동합니다.
