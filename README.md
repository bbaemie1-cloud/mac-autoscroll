# Mac Autoscroll

[English](#english) | [한국어](#한국어)

---

## English

An automated script that sets up smooth, hands-free autoscrolling on macOS using Hammerspoon. It is extremely useful for reading web pages, long documents, or code. **It works universally across all macOS applications** (Web browsers, IDEs, PDF readers, etc.) since it simulates standard system scrolling events.

### ✨ Key Features
* **Universal Compatibility**: Works in Google Chrome, Safari, VS Code, Notion, Preview, and any other application that supports scrolling.
* **Smooth Scrolling**: Enjoy 50 FPS (0.02s interval) pixel-perfect smooth scrolling for comfortable reading.
* **Hotkey Controls**: Start/stop the autoscroll or adjust the speed effortlessly using just your keyboard. No need to click any menus.
* **Auto-Stop Safety Feature**: The scroll stops instantly and automatically as soon as you touch your keyboard, mouse, or trackpad.
* **Background Execution**: Runs silently in the background. It will automatically load even after you reboot your Mac.

### ⌨️ Hotkeys
* **Start / Stop (Toggle)**: `Cmd + Option(Alt) + Ctrl + Down Arrow`
* **Jump to Top**: `Cmd + Option(Alt) + Ctrl + Up Arrow`
* **Increase Speed (+1)**: `Cmd + Option(Alt) + Ctrl + Right Arrow`
* **Decrease Speed (-1)**: `Cmd + Option(Alt) + Ctrl + Left Arrow`

Whenever you change the speed, a brief on-screen alert will show the current speed level (1~30).

### 🆕 Recent Updates (v1.1)
* **Jump to Top Shortcut**: Instantly teleport to the top of the page.
* **100 FPS Ultra-Smooth Scrolling**: Increased the tick rate for buttery-smooth visual scrolling.
* **Modern UI**: The alert message now features a sleek Midnight Blue & Mint color scheme and perfectly fades out after exactly 0.4 seconds.
* **Intelligent Modifier Handling**: The "Jump to Top" feature smartly waits for you to release modifier keys before triggering, completely avoiding macOS key collisions.
* **Auto-Accessibility Prompt**: A built-in security check now automatically prompts for Accessibility permissions on new installations.

### 🚀 Installation

Open your **Terminal** and run the following one-liner command. It will download the installation script to your Desktop and run it automatically.

```bash
curl -L -o ~/Desktop/autoscroll.command https://raw.githubusercontent.com/bbaemie1-cloud/NIBA-MacAutoscroll/main/autoscroll.command && chmod +x ~/Desktop/autoscroll.command && open ~/Desktop/autoscroll.command
```

Alternatively, you can manually download `autoscroll.command` from this repository and double-click it to install.
*(If Hammerspoon is not installed on your system, the script will automatically download and install it for you into your Applications folder.)*

### ⚠️ Important Notice (Accessibility Permissions)
* Upon first execution, macOS will prompt you for **Accessibility (손쉬운 사용)** permissions.
* This permission is strictly required to inject scroll events and detect user input for the auto-stop feature.
* Please go to `System Settings > Privacy & Security > Accessibility` and **toggle ON** `Hammerspoon` for the tool to work correctly.

### 🛑 Troubleshooting: "Apple cannot check it for malicious software"
If you downloaded the file manually (Method 2) and see a warning that the file cannot be opened because Apple cannot verify it:
1. **Right-click** (or `Control` + Click) the `autoscroll.command` file.
2. Select **Open** from the context menu.
3. A similar warning will appear, but this time there will be an **"Open"** button. Click it to run the script.

---

## 한국어

macOS 환경에서 Hammerspoon을 이용해 부드러운 자동 스크롤(Autoscroll) 기능을 설정해 주는 설치 스크립트입니다. 시스템 표준 스크롤 이벤트를 시뮬레이션하기 때문에 **웹 브라우저뿐만 아니라 macOS의 모든 응용 프로그램에서 완벽하게 동작합니다.** (크롬, 사파리, 노션, VS Code, PDF 뷰어 등)

### ✨ 주요 기능
* **모든 앱 호환**: 특정 앱에 종속되지 않고 스크롤이 가능한 모든 프로그램에서 동일하게 사용할 수 있습니다.
* **부드러운 스크롤**: 50 FPS 수준(0.02초 간격)의 픽셀 단위 스크롤로 눈이 편안하게 문서를 읽을 수 있습니다.
* **단축키 기반 조작**: 마우스를 만질 필요 없이 키보드 단축키로 스크롤을 켜고 끄거나 속도를 쉽게 조절할 수 있습니다.
* **자동 정지 (안전 장치)**: 스크롤 도중 사용자가 키보드를 누르거나, 마우스를 클릭하거나, 트랙패드를 조작하면 **자동으로 스크롤이 즉시 멈춥니다**.
* **자동 백그라운드 실행**: Mac을 재부팅해도 백그라운드에서 항상 대기하여 원할 때 언제든 사용할 수 있습니다.

### ⌨️ 단축키 안내
* **시작 / 정지 (Toggle)**: `Cmd + Option(Alt) + Ctrl + 아래 화살표(Down)`
* **최상단으로 순간이동**: `Cmd + Option(Alt) + Ctrl + 위 화살표(Up)`
* **속도 빠르게 (+1)**: `Cmd + Option(Alt) + Ctrl + 오른쪽 화살표(Right)`
* **속도 느리게 (-1)**: `Cmd + Option(Alt) + Ctrl + 왼쪽 화살표(Left)`

속도를 변경하면 화면 정중앙에 투명한 팝업 알림창으로 현재 속도(1~30)를 알려줍니다.

### 🆕 최신 업데이트 (v1.1)
* **최상단 순간이동 단축키 추가**: 단축키를 누르면 페이지 맨 위로 즉시 점프합니다.
* **100 FPS 극강의 부드러움**: 스크롤 갱신 주기를 100프레임 수준으로 높여 훨씬 더 매끄러운 스크롤을 제공합니다.
* **모던 UI 적용**: 알림창 디자인이 세련된 미드나잇 블루 & 민트 테마로 변경되었으며, 타이머 버그를 뚫고 0.4초 만에 깔끔하게 사라지도록 수정되었습니다.
* **스마트 키 충돌 방지**: '최상단 이동' 기능 실행 시 물리적인 수식 키(Cmd, Alt, Ctrl)가 완전히 떼어질 때까지 아주 짧게 기다렸다가 신호를 발사하여 macOS 특유의 단축키 씹힘/충돌 현상을 완벽히 해결했습니다.
* **자동 권한 요청 팝업**: 처음 설치하는 Mac 기기에서 '손쉬운 사용' 권한이 없을 경우, 스크립트가 이를 알아채고 경고창과 함께 애플 기본 권한 설정 팝업창을 알아서 띄워주도록 편의성을 대폭 개선했습니다.

### 🚀 설치 방법

터미널(Terminal)을 열고 아래 명령어를 복사하여 붙여넣기만 하면, 바탕화면에 설치 파일이 생성되고 자동으로 실행됩니다.

```bash
curl -L -o ~/Desktop/autoscroll.command https://raw.githubusercontent.com/bbaemie1-cloud/NIBA-MacAutoscroll/main/autoscroll.command && chmod +x ~/Desktop/autoscroll.command && open ~/Desktop/autoscroll.command
```

또는 이 저장소에서 `autoscroll.command` 파일을 직접 다운로드 한 뒤, 더블 클릭하여 실행하셔도 됩니다.
*(Hammerspoon 앱이 설치되어 있지 않다면 자동으로 다운로드하여 응용 프로그램 폴더에 설치합니다.)*

### ⚠️ 주의사항 (필수)
* 최초 실행 시 **'손쉬운 사용' 권한 요청 팝업**이 나타납니다.
* 스크롤 이벤트와 키보드 입력을 감지하기 위해 꼭 필요한 권한입니다.
* `시스템 설정 > 개인정보 보호 및 보안 > 손쉬운 사용`으로 이동하여 `Hammerspoon` 스위치를 **직접 켜주셔야** 단축키와 자동 정지 기능이 정상적으로 작동합니다.

### 🛑 문제 해결: "악성 코드가 없는지 확인할 수 없습니다" 팝업이 뜰 때
직접 파일을 다운로드하여 실행할 경우(방법 2), macOS의 보안 정책(Gatekeeper) 때문에 위와 같은 경고가 나타날 수 있습니다. 이럴 때는 다음 방법으로 해결하세요:
1. `autoscroll.command` 파일을 그냥 더블클릭하지 말고, **마우스 우클릭** (또는 `Control` 키를 누른 채로 클릭) 합니다.
2. 나타나는 메뉴에서 **[열기]** 를 선택합니다.
3. 동일한 경고창이 뜨지만 이번에는 **[열기]** 버튼이 활성화되어 있습니다. 열기를 누르시면 정상적으로 설치가 시작됩니다.
