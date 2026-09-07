# Pirate Lines

一款 2012 年发布的 iOS 益智策略游戏，基于 cocos2d-iphone 2.0 与 Objective-C 开发。
项目已完成现代化改造，可在 Xcode 27 / iOS 27 SDK 下构建，支持 64 位与现代设备屏幕。

- **产品名**：Pirate Lines
- **Bundle ID**：`com.xecudev.Grid`
- **开发者**：Yang Song / XecuDev, LLC（2012）
- **玩法**：海盗主题的点格棋（Dots and Boxes）变体，含单人闯关、CPU 对战与本地对战

---

## 网页版

游戏另有一个单人网页版，打开即玩，无需安装：

**https://songer522.github.io/Grid/**

源码位于 `web` 分支的 `pirate-lines-web/` 目录，用 Vite + 原生 JS 重写，与 iOS 版不共用
任何代码，但直接复用原版的美术资源与全部 96 张 TMX 关卡地图——关卡数据由脚本从
`Grid/Art/DAL_Level*-hd.tmx` 提取生成，因此路线布局与道具位置和 iOS 版一致。
CPU 对手是 `CPUBrain` 战术优先级的移植；联机对战、Game Center 与内购没有网页端对应实现，
均已省略。

分支分工：`master` 只用于 iOS 开发，`web` 承载网页版并经 GitHub Actions 自动部署到
GitHub Pages。两者不做合并。

---

## 技术栈

| 项目 | 现状 |
| --- | --- |
| 引擎 | cocos2d-iphone 2.0（`COCOS2D_VERSION 0x00020000`），源码内嵌 |
| 图形 | OpenGL ES 2.0 |
| 音频 | CocosDenshion（OpenAL + AVFoundation） |
| 数学库 | kazmath（含 32 位 ARM NEON 内联汇编） |
| 语言 | Objective-C，**手动引用计数（MRR）**，未启用 ARC |
| 部署目标 | iOS 16.0 |
| 架构 | `$(ARCHS_STANDARD)`（arm64） |
| 设备 | iPhone + iPad 通用（`TARGETED_DEVICE_FAMILY = "1,2"`），仅竖屏 |
| UI 层 | 游戏画面纯代码；图标走 asset catalog，启动图走 LaunchScreen.storyboard |
| 坐标系 | 固定设计分辨率（iPhone 320×480 / iPad 768×1024），等比居中适配 |

### 代码规模

- 应用层：88 个 `.m`/`.h` 文件，约 17,000 行
- 引擎与第三方库：约 62,000 行（`Grid/libs`）
- 关卡数据：386 个 TMX 地图文件（96 个关卡 × 4 套分辨率）

### 系统框架依赖

`UIKit`、`Foundation`、`CoreGraphics`、`QuartzCore`、`OpenGLES`、`OpenAL`、`AudioToolbox`、
`AVFoundation`、`GameKit`、`StoreKit`、`CFNetwork`、`SystemConfiguration`

---

## 目录结构

```
.
├── Grid.xcodeproj/           Xcode 工程
├── Grid/
│   ├── *.m / *.h             游戏逻辑（88 个文件）
│   ├── Art/                  386 个 TMX 关卡地图
│   ├── Resources/            Info.plist、Assets.xcassets、LaunchScreen、
│   │                         PrivacyInfo.xcprivacy、Grid.entitlements
│   ├── Sounds and Music/     背景音乐与音效
│   └── libs/
│       ├── cocos2d/          cocos2d-iphone 2.0 引擎源码
│       ├── CocosDenshion/    音频引擎
│       ├── kazmath/          矩阵与向量数学库
│       └── Extensions/       cocos2d-extensions 扩展集
└── README.md
```

### 核心模块

| 模块 | 职责 |
| --- | --- |
| `AppDelegate` | 启动流程、CCDirector 初始化、Game Center 登录 |
| `GridModel` / `GridView` | 棋盘的数据模型与渲染层（MVC 分离） |
| `BoxArray` / `EdgeArray` / `Box` / `Edge` | 点格棋的格子与连线数据结构 |
| `CPUBrain` | 单人模式的 AI 对手 |
| `GameLayer` | 主游戏场景 |
| `MainMenu` / `ChooseIslandMenu` / `ChooseLevelMenu` / `UpgradeMenu` | 各级菜单场景 |
| `Database` | 基于 `NSKeyedArchiver` 的本地存档（写入 Documents 目录） |
| `GCHelper` | Game Center 认证与排行榜上报 |
| `InAppPurchaseManager` | StoreKit 内购（解锁完整版） |
| `AlertView` | `UIAlertView` 的兼容替代，底层为 `UIAlertController` |
| `PeerSession` / `PeerPickerController` | `GKSession` / `GKPeerPickerController` 的兼容替代，底层为 MultipeerConnectivity |
| `ReviewPrompt` | 评分提示，底层为 `SKStoreReviewController` |

### 资源与分辨率体系

项目使用 cocos2d 的后缀机制加载四套资源，在 `AppDelegate` 中注册：

```objc
[CCFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];
[CCFileUtils setiPadSuffix:@"-ipad"];
[CCFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];
```

布局坐标则通过 `DeviceSettings.h` 中的宏在 iPhone 基准（320×480）与 iPad 之间换算：

```objc
#define kScreenHeight   480
#define kScreenWidth    320
#define ADJUST_X(__x__) (IS_IPAD() == YES ? (__x__ * 2) + kXoffsetiPad : __x__)
```

也就是说，全部布局都硬绑定在 320×480 的设计基准上，通过整数倍缩放加固定偏移适配 iPad。
这套体系本身保留了下来；现代设备千差万别的长宽比由 `CCDirectorIOS` 的设计分辨率机制
统一吸收（见下文「屏幕适配」）。

---

## 改造记录

原项目在现代 Xcode 下无法编译，也无法在 64 位设备上运行。以下是逐项处理的结果。

### 64 位化

- `ARCHS` 从 `ARCHS_STANDARD_32_BIT` 改为 `$(ARCHS_STANDARD)`
- kazmath 的 32 位 ARM NEON 内联汇编改由 `KM_USE_NEON_ASM` 控制。原先的
  `#if defined(__ARM_NEON__)` 在 arm64 上同样成立，但那段汇编是 32 位语法，
  收窄条件后 arm64 自动走纯 C 的矩阵乘法实现
- `__ccContentScaleFactor` 在两处头文件里分别声明为 `float` 和 `CGFloat`，
  64 位下 `CGFloat` 是 `double`，类型不再一致，统一为 `CGFloat`
- `CCRotateTo`/`CCRotateBy` 里 `[target_ rotation]` 的 `target_` 是 `id`，
  现代 SDK 中存在返回 `CGVector` 的同名方法，加了显式类型转换
- 修正应用层的整型截断、浮点 `abs()` 与格式化字符串问题

### 已删除 API 的替换

| 原 API | 替换方案 |
| --- | --- |
| `UIAlertView`（48 处） | `AlertView` 兼容类，底层 `UIAlertController` |
| `iAd` / `ADBannerView` | 直接移除（调用早已被注释） |
| `GKLeaderboardViewController` | `GKGameCenterViewController` |
| `authenticateWithCompletionHandler:` | `GKLocalPlayer.authenticateHandler` |
| `GKMatchmaker.inviteHandler` | `GKLocalPlayerListener` |
| `SKPaymentTransaction.transactionReceipt` | `NSBundle.appStoreReceiptURL` |
| `presentModalViewController:` | `presentViewController:animated:completion:` |
| `shouldAutorotateToInterfaceOrientation:` | `supportedInterfaceOrientations` |
| `UIViewController.wantsFullScreenLayout` | 直接移除 |
| `UIAccelerometer` | 直接移除（游戏未使用重力感应） |
| `GKSession` | `PeerSession`，底层 MultipeerConnectivity |
| `GKPeerPickerController` | `PeerPickerController`，底层 `MCBrowserViewController` |
| `Appirater` | `ReviewPrompt`，底层 `SKStoreReviewController` |

`AlertView` 保留了 `UIAlertView` 的 delegate 与 tag 接口，48 个调用点和它们的
分发逻辑一行未改。它额外做了两件原来没有的事：把并发的弹窗排队，以及强制在主线程
present —— `UIAlertView` 能容忍从后台线程调用，`UIAlertController` 会直接崩溃。

### 联机对战

游戏有两种联机方式，损坏程度完全不同。

**互联网对战**基于 `GKMatch`，这个类至今仍受完整支持，问题出在 delegate 签名：代码用的是
iOS 8 就被取代的 `playerID` 字符串版本（`match:didReceiveData:fromPlayer:` 等）。
选择子对不上，现代 GameKit 根本不会调用它们，于是联机既不报错也收不到任何数据。
改成 `GKPlayer` 版本即可恢复。

**近距离对战**基于 `GKSession` 与 `GKPeerPickerController`，两者都已从 SDK 移除，
只能改用 MultipeerConnectivity。这里同样采用兼容层的做法：`PeerSession` 与
`PeerPickerController` 保持原有的接口形状，四个界面里的联机逻辑一行未改。
`PeerPickerController` 在浏览的同时也广播自己，复现 `GKPeerPickerController`
双方对称发现的行为。

MultipeerConnectivity 的回调在后台队列上派发，而这些回调会直接改动 cocos2d 的场景状态，
因此 `PeerSession` 统一转回主线程后再交给游戏——这和 `AlertView` 遇到的是同一类问题。

近距离对战现在需要本地网络权限（`NSLocalNetworkUsageDescription` 与 `NSBonjourServices`），
玩家首次进入该模式时系统会弹出授权请求，这是 MultipeerConnectivity 的固有要求。

### 屏幕适配

游戏的全部坐标都写死在固定的设计空间里，而 cocos2d 2.0 直接把视图尺寸当作场景的
坐标系，没有"设计分辨率"的概念。原版 iPhone 上两者恰好相等，现代设备上场景就只画
在了视图的一角。

`CCDirectorIOS` 现在接受一个设计尺寸，把场景等比放大居中到视图中，多余部分留黑边。
`convertToGL:` / `convertToUI:` 做了对应的逆变换，触摸位置仍然准确。

同时修复了 `IS_IPAD()`：它原本写在 `#ifdef UI_USER_INTERFACE_IDIOM` 里，而这个符号
在现代 SDK 中已不是预处理宏，导致条件不成立、宏被固定成 `NO`，**整个 iPad 布局分支
被静默地编译掉了**。

### 上架合规

- 新增 `PrivacyInfo.xcprivacy`，声明 `NSUserDefaults` 与文件时间戳的使用理由
- 新增 `Grid.entitlements` 声明 Game Center 权限
- Info.plist 补 `ITSAppUsesNonExemptEncryption`，移除已不再需要的 `accelerometer` 硬件要求
- asset catalog 提供 1024×1024 图标，`LaunchScreen.storyboard` 取代 `Default.png` 系列

---

## 遗留事项

改造未覆盖以下几点，需要在提交前另行处理。

- **应用图标精度**：现有最大的原始素材是 512×512 的 `iTunesArtwork.png`，
  当前的 1024×1024 图标由它放大而来。上架前应替换为原始设计稿导出的版本。
- **联机对战的实机联通性**：代码已迁移完毕，编译、界面呈现与接口调用均已验证，
  但两台设备实际配对、对局同步、断线重连只能在两台真机上验证。
- **存档与联机消息的序列化**：约 30 处使用已废弃的
  `NSKeyedArchiver initForWritingWithMutableData:`。这些 API 仍然可用，
  且直接决定存档格式与联机线格式，贸然迁移会破坏老玩家的存档，因此保持原样。
- **App Store Connect 配置**：需确认原有的 IAP product ID 与排行榜 ID 仍然有效。
- **真机回归**：模拟器上已验证 iPhone 与 iPad 的启动、渲染、弹窗与触摸映射，
  但 IAP 购买与恢复、Game Center 登录与排行榜必须在真机加签名后才能完整验证。

---

## 构建

```sh
open Grid.xcodeproj
```

命令行构建与归档：

```sh
xcodebuild -project Grid.xcodeproj -scheme Grid \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' build

xcodebuild -project Grid.xcodeproj -scheme Grid \
  -sdk iphoneos -configuration Release \
  -archivePath build/Grid.xcarchive archive
```

归档需要有效的签名身份与包含 Game Center 能力的 provisioning profile。
