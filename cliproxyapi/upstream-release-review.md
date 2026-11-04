# CLIProxyAPI v8.0.53 静态源码审查

结论：**通过**。完整固定增量及中央交付边界内未发现恶意代码或恶意依赖证据。

- 已批准基线：v8.0.51 `7cad1cb7df48c6c5ffb7ff0b34ef8198806115bc`。
- 中间正式版：v8.0.52 `6e6afab99a1939525ecb6bb1f0873c8e7a9df877`。
- 候选：[v8.0.53 / 01b24f1f95dc9b309765212c52b25b25e005ff01](https://github.com/router-for-me/CLIProxyAPI/commit/01b24f1f95dc9b309765212c52b25b25e005ff01)。三版官方 ref 均解析为完整 commit。
- 官方完整树推导 **764 个变更路径**，不是 compare 截断的 300 个。1,527 个源码 blob/SHA-256 核验一致；8,487,329 字节完整差异全部语义阅读，逐路径结论与实际范围无缺口。
- 两段分别涉及 728、73 个路径。37 个重叠路径核验三侧 111 个 blob；第一段 2,142 个编辑块以相同基线位置及相同有序替换内容复用净差异，另 51 个编辑块上下文与全部第二段差异补读，共 186,315 字节。没有仅凭整文件未回退而省略中间态。

主要变更是 JSON/base64 库迁移、Doc 请求与响应构造、缓存恢复和协议字段转换。已检查凭据来源、缓存身份、提供方请求、管理接口、shell/apply-patch 工具数据及插件加载调用链：工具文本仅作协议数据；插件预检仅对显式配置的本地插件副本执行本进程探针；刷新保留禁用状态。测试文件实际断言和新增用例已静态阅读，没有以测试执行或 CI 代替源码判断。

中央 `./cmd/server` 构建中新增 `github.com/MoeForge/moego v0.1.0-alpha.1` 通过显式 replace 使用 `github.com/router-for-me/moego v0.1.1`，固定来源为 `26980205a70fcda21ad1c3add7ca14f84f21a835`。官方 ref、注册表 origin、module/sumdb 与源码 blob 已核验；54 个生产 Go/汇编文件完整阅读，包括架构实现及 ARM64 原始指令静态解码。未见隐藏网络、执行、下载或安装钩子；有效模块无传递依赖。tidwall 移除及旧 checksum 清理不作为新依赖；x/term 仅补既有版本的 module checksum。

复用已批准中央 Dockerfile、运行边界和未变基线。三个嵌套示例使用原 MoeForge alpha，已核验官方 tag 与注册表来源；其实现及未进入中央交付的开发/CI/工具链不作认证，不递归扩展范围。

逐文件不可变 SHA、blob/SHA-256、完整差异阅读范围、具体语义结论与共享上下文见 [机器记录](review-result.json)。原始分页账本及补充证据：`/root/upstream-release-review/cliproxyapi-v8.0.53`。

仅静态恶意行为审查，不作漏洞、Bug、质量或性能结论；未 clone、安装、构建或执行上游代码/产物，未运行测试或扫描。用户配置的第三方插件、提供方及远端内容不在固定源码认证范围。批准后既有 CI 构建不作为审查证据；工作流 `provenance:false`，发布来源链核验不是签名构建证明。无部署或重启。

Keeper v2.0.3 `9db74cfc380d11064af80cf1626efd6e3d068217`、Watchtower v1.23.2 `cd5946be205ea0a60dd31235a11f04ac9851ebf6` 沿用上轮无新版核对，保留 pin。
