# Mac Autoscroll

macOS 환경에서 Hammerspoon을 이용해 부드러운 자동 스크롤(Autoscroll) 기능을 설정해 주는 설치 스크립트입니다. 웹 브라우저나 문서 등에서 텍스트를 읽을 때 매우 유용합니다.

## ✨ 주요 기능
* **부드러운 스크롤**: 50 FPS 수준(0.02초 간격)의 픽셀 단위 스크롤로 눈이 편안하게 문서를 읽을 수 있습니다.
* **단축키 기반 조작**: 마우스를 만질 필요 없이 키보드 단축키로 스크롤을 켜고 끄거나 속도를 쉽게 조절할 수 있습니다.
* **자동 정지 (안전 장치)**: 스크롤 도중 사용자가 키보드를 누르거나, 마우스를 클릭하거나, 트랙패드를 조작하면 **자동으로 스크롤이 즉시 멈춥니다**.
* **자동 백그라운드 실행**: Mac을 재부팅해도 백그라운드에서 항상 대기하여 원할 때 언제든 사용할 수 있습니다.

## ⌨️ 단축키 안내
* **시작 / 정지 (Toggle)**: `Cmd + Option(Alt) + Ctrl + 아래 화살표(Down)`
* **속도 빠르게 (+1)**: `Cmd + Option(Alt) + Ctrl + 오른쪽 화살표(Right)`
* **속도 느리게 (-1)**: `Cmd + Option(Alt) + Ctrl + 왼쪽 화살표(Left)`

속도를 변경하면 화면 정중앙에 투명한 팝업 알림창으로 현재 속도(1~20)를 알려줍니다.

## 🚀 설치 방법

터미널(Terminal)을 열고 아래 명령어를 복사하여 붙여넣기만 하면, 바탕화면에 설치 파일이 생성되고 자동으로 실행됩니다.

```bash
curl -L -o ~/Desktop/autoscroll.command https://raw.githubusercontent.com/bbaemie1-cloud/mac-autoscroll/main/autoscroll.command && chmod +x ~/Desktop/autoscroll.command && open ~/Desktop/autoscroll.command
```

또는 이 저장소에서 `autoscroll.command` 파일을 직접 다운로드 한 뒤, 더블 클릭하여 실행하셔도 됩니다.
*(Hammerspoon 앱이 설치되어 있지 않다면 자동으로 다운로드하여 응용 프로그램 폴더에 설치합니다.)*

## ⚠️ 주의사항 (필수)
* 최초 실행 시 **'손쉬운 사용' 권한 요청 팝업**이 나타납니다.
* 스크롤 이벤트와 키보드 입력을 감지하기 위해 꼭 필요한 권한입니다.
* `시스템 설정 > 개인정보 보호 및 보안 > 손쉬운 사용`으로 이동하여 `Hammerspoon` 스위치를 **직접 켜주셔야** 단축키와 자동 정지 기능이 정상적으로 작동합니다.
