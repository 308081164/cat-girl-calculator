# 🐱 猫猫计算器

一个复古像素风格的计算器应用，带有可爱的像素风猫娘角色动画。

## 版本

### 📱 Flutter 移动版（Android/iOS）

位于项目根目录，使用 Flutter + Dart 实现。

**特性：**
- 8 种猫娘交互状态（idle/pushedAway/sleeping/happy/confused/squished/shocked/celebrating)
- 像素风 CustomPainter 动画系统
- CRT 扫描线显示效果
- Press Start 2P 像素字体
- 霓虹赛博朋克配色（深蓝黑背景 + 青绿品红霓虹色）

**构建：**
```bash
flutter pub get
flutter build apk --release
```

APK 产物： `build/app/outputs/flutter-apk/app-release.apk`

### 🪟 Windows 桌面版

位于 `windows_version/` 目录，使用 Python + tkinter 实现。

**特性:**
- 像素精灵动画系统（5 种状态：idle/blink/walk/sleep/shock）
- 黄绿色清新主题
- 支持平方、平方根、倒数、百分号等运算
- 可打包为 EXE 安装程序

**运行:**
```powershell
cd windows_version
pip install -r requirements.txt
python calculator.py
```

**构建 EXE:**
```powershell
pip install pyinstaller
pyinstaller --clean --noconfirm calculator.spec
```
产物： `dist/LittleComputer.exe`

## GitHub Actions CI/CD

两个版本都支持 GitHub Actions 自动构建:

- **Flutter 版**：推送到 main 分支自动构建 APK
- **Windows 版**：推送 tag 或手动触发构建 EXE 安装包

## 猫娘状态说明

