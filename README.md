# Pirate Lines

一款 2012 年发布的 iOS 益智策略游戏，基于 cocos2d-iphone 2.0 与 Objective-C 开发。
本文档记录项目的原始技术栈现状，作为现代化改造的参照基线。

- **产品名**：Pirate Lines
- **Bundle ID**：`com.xecudev.Grid`
- **开发者**：Yang Song / XecuDev, LLC（2012）
- **玩法**：海盗主题的点格棋（Dots and Boxes）变体，含单人闯关、CPU 对战与本地对战

---

## 技术栈

| 项目 | 现状 |
| --- | --- |
| 引擎 | cocos2d-iphone 2.0（`COCOS2D_VERSION 0x00020000`），源码内嵌 |
| 图形 | OpenGL ES 2.0 |
| 音频 | CocosDenshion（OpenAL + AVFoundation） |
| 数学库 | kazmath（含 32 位 ARM NEON 内联汇编） |
| 语言 | Objective-C，**手动引用计数（MRR）**，未启用 ARC |
| 工程格式 | `objectVersion 46`，Xcode 3.2 兼容格式 |
| 部署目标 | iOS 4.3 |
| 架构 | `ARCHS_STANDARD_32_BIT`（仅 armv7） |
| 设备 | iPhone + iPad 通用（`TARGETED_DEVICE_FAMILY = "1,2"`），仅竖屏 |
| UI 层 | 纯代码，无 xib / storyboard / asset catalog |

### 代码规模

- 应用层：88 个 `.m`/`.h` 文件，约 17,000 行
- 引擎与第三方库：约 62,000 行（`Grid/libs`）
- 关卡数据：386 个 TMX 地图文件（96 个关卡 × 4 套分辨率）

### 系统框架依赖

`UIKit`、`Foundation`、`CoreGraphics`、`QuartzCore`、`OpenGLES`、`OpenAL`、`AudioToolbox`、
`AVFoundation`、`GameKit`、`StoreKit`、`CFNetwork`、`SystemConfiguration`、`iAd`

---

## 目录结构

```
.
├── Grid.xcodeproj/           Xcode 工程
├── Grid/
│   ├── *.m / *.h             游戏逻辑（88 个文件）
│   ├── Art/                  386 个 TMX 关卡地图
│   ├── Resources/Info.plist  应用配置
│   ├── Sounds and Music/     背景音乐与音效
│   └── libs/
│       ├── cocos2d/          cocos2d-iphone 2.0 引擎源码
│       ├── CocosDenshion/    音频引擎
│       ├── kazmath/          矩阵与向量数学库
│       └── Extensions/       cocos2d-extensions 扩展集
├── Default*.png              旧式启动图
└── Icon_*.png                旧式应用图标
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
| `Appirater` | 第三方评分提示库 |

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

这意味着**全部布局都硬绑定在 320×480 的设计基准上**，通过整数倍缩放加固定偏移适配 iPad。
现代设备的 19.5:9 长宽比与安全区完全不在这套体系的考虑范围内。

---

## 已知障碍

按严重程度排列。以下问题在现代 Xcode 下会直接导致编译失败或运行时崩溃。

### 1. 架构：仅 32 位

- `ARCHS = ARCHS_STANDARD_32_BIT` 产出的二进制在现代 iOS 上无法运行
- `Grid/libs/kazmath/src/neon_matrix_impl.c` 使用 32 位 ARM NEON 内联汇编，在 arm64 下编译失败
- 应用层约 94 处 `int` 强制转换需核对 64 位下的类型宽度

### 2. 已从 SDK 删除的 API

| API | 状态 | 影响位置 |
| --- | --- | --- |
| `iAd.framework` / `ADBannerView` | iOS 10 起废弃，SDK 已移除 | `GridView.h` / `GridView.m` |
| `GKLeaderboardViewController` | iOS 14 删除 | `GCHelper.h` / `GCHelper.m` |
| `UIViewController.wantsFullScreenLayout` | 已移除 | `AppDelegate.m` |
| `UIAlertView` | iOS 9 起废弃，已移除 | 7 个文件共 48 处 |
| `presentModalViewController:` / `dismissModalViewControllerAnimated:` | 已移除 | `AppDelegate.m` |
| `shouldAutorotateToInterfaceOrientation:` | 已移除 | `AppDelegate.m` |
| `SKPaymentTransaction.transactionReceipt` | 已移除 | `InAppPurchaseManager.m` |
| `authenticateWithCompletionHandler:` | 已移除 | `GCHelper.m` |
| `MPMoviePlayerController` | 已移除 | `libs/Extensions/CCVideoPlayer`（未被引用） |

### 3. 启动流程过时

`AppDelegate.m` 用 `[window_ addSubview:navController_.view]` 而非设置 `rootViewController`，
这是 iOS 5 之前的写法，在 iOS 13+ 会导致视图控制器生命周期与旋转事件异常。

### 4. 屏幕适配

最宽只适配到 iPhone 5 的 1136×640。现代设备存在刘海、灵动岛与 home indicator，
且长宽比达到 19.5:9，直接运行会出现黑边、拉伸或 UI 被系统组件遮挡。

### 5. 上架合规缺失

- 无 `PrivacyInfo.xcprivacy`（Privacy Manifest），当前为 App Store 强制要求
- 无 `LaunchScreen.storyboard`，仍使用已不受支持的 `Default.png` 系列启动图
- 无 asset catalog，图标最大只到 144×144，缺 1024×1024 marketing icon
- Info.plist 缺 `ITSAppUsesNonExemptEncryption` 声明

### 6. 其他

- `Database.m` 使用已废弃的 `NSKeyedUnarchiver initForReadingWithData:`，未启用 secure coding
- 工程内残留 `_sconsign.dblite`、`Song.pbxuser`、`Song.mode1v3.xml`、`xcuserdata` 等历史文件

### 好消息

- `iAd` 的实际调用早已被注释（`//[self loadiAd];`），只剩 header 引用与空 delegate，**可直接删除而无需接入新广告 SDK**
- `CCVideoPlayer` 扩展未被任何代码引用，可整体移除
- 游戏核心逻辑（棋盘模型、AI、关卡数据）与平台 API 解耦良好，改造过程中无需改动

---

## 现代化路线

保留全部 Objective-C 游戏逻辑与 cocos2d 2.x 引擎，仅修复平台兼容性问题，目标是重新上架 App Store。

| 阶段 | 内容 |
| --- | --- |
| 0 | 建立基线：现代 Xcode 打开工程，全量编译获取真实错误清单，清理历史文件 |
| 1 | 64 位化：切到 `ARCHS_STANDARD`，处理 NEON 汇编与类型宽度问题 |
| 2 | 工程现代化：抬高部署目标，建 asset catalog 与 LaunchScreen，移除 iAd 与 CCVideoPlayer |
| 3 | 替换已删除 API：重写启动流程与旋转逻辑，48 处 `UIAlertView` 迁移 |
| 4 | 服务层：重写 IAP 收据校验、Game Center 认证与排行榜，评分提示换 `SKStoreReviewController` |
| 5 | 屏幕适配：现代长宽比与安全区，修正硬编码坐标 |
| 6 | 上架合规：Privacy Manifest、加密声明、签名与 archive，真机全量回归 |

---

## 构建

```sh
open Grid.xcodeproj
```

改造完成前，本工程无法在现代 Xcode 上成功构建。
