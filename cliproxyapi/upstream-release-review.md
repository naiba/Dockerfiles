# CLIProxyAPI v8.0.40 增量源码审查

结论：**通过**。在下述固定范围及静态证据中，未发现新增恶意行为或恶意依赖证据。本结论不是漏洞、正确性或整个上游生态的认证。

## 正式版本与范围

| 项目 | 官方正式版 | 解析后的完整提交 | 结论 |
| --- | --- | --- | --- |
| CLIProxyAPI | v8.0.40 | `d946c4fba6fc9a5cfbca1f3d85184d62ad2fb683` | 通过 |
| CPA Usage Keeper | v2.0.0 | `fc8cbde97fe6baa35189e51115716865ce377ec2` | 无新版 |
| Watchtower | v1.23.2 | `cd5946be205ea0a60dd31235a11f04ac9851ebf6` | 无新版 |

CLIProxyAPI 从已批准的 v8.0.38 `0db19025571684b198a2ef508f99b41c717337e8` 审查到 v8.0.40，包括 v8.0.39 `ceb045a129d43f805e93a5e4aef3a59b108f34f7`。Watchtower 的 annotated tag 对象 `c75ea87a9af863b253cff70e03333f966567663e` 已 peel 至表中 commit；另外两项正式 tag 直接指向 commit。官方 release/ref、完整 tree、raw blob 与依赖注册表证据均保存在本轮证据目录。

先锁定中央提交 `de135b48c55a0beea6de09ceac53a8018900efd1` 的 Dockerfile/workflow，以及上一版六份已批准报告的校验值。实际交付为中央 Dockerfile 的 `go mod download`、`CGO_ENABLED=0 go build ./cmd/server`，最终镜像仅复制服务二进制及示例配置；不执行上游开发工作流、生成器或测试。

## 实际覆盖

完整两端 tree 与 compare 的变更集合一致，共 **120 文件**，逐文件读完完整增量差异，按配置、依赖、API、插件/用量、执行、转换、鉴权/watcher 七组共享上下文。两端 230 个实际存在的 blob 均按 Git blob SHA-1 核验，同时保存 SHA-256。未变行复用已批准基线，并非声称重新逐行阅读全部文件全文。

中间版有 8 个 blob 同时不同于两端，已单独下载、核验并读完其中间版至候选版差异；没有仅在中间版存在的路径。完整文件清单、每个 diff hunk 的不可变 URL/行号、blob/hash、依赖覆盖方式见 [机器可读记录](review-result.json)。

## 敏感路径依据

- [插件鉴权与解码请求体](https://github.com/router-for-me/CLIProxyAPI/blob/d946c4fba6fc9a5cfbca1f3d85184d62ad2fb683/internal/pluginhost/adapters_auth.go#L193)：向既有、身份仍有效的已加载鉴权插件提供 raw/decoded body；解码受大小、窗口、并发限制，没有新外传目标。
- [WebSocket 每轮鉴权](https://github.com/router-for-me/CLIProxyAPI/blob/d946c4fba6fc9a5cfbca1f3d85184d62ad2fb683/sdk/api/handlers/openai/openai_responses_websocket.go#L266)：继续经过前端 access manager；共享 provider 链的拒绝路径已核对。
- [Codex 凭据选择](https://github.com/router-for-me/CLIProxyAPI/blob/d946c4fba6fc9a5cfbca1f3d85184d62ad2fb683/internal/runtime/executor/codex_executor_auth.go#L486)：客户端 UA 决定同一 credential 的 outer/SIWC 分区，仍使用配置或既有 OpenAI/Codex 目标；没有新增凭据接收站点。
- [用量队列](https://github.com/router-for-me/CLIProxyAPI/blob/d946c4fba6fc9a5cfbca1f3d85184d62ad2fb683/internal/redisqueue/plugin.go#L146)：新增 tier/speed 字段沿现有启用条件和 Redis 队列/插件路径传递。
- [Vertex 目标](https://github.com/router-for-me/CLIProxyAPI/blob/d946c4fba6fc9a5cfbca1f3d85184d62ad2fb683/internal/runtime/executor/helps/vertex_openapi.go#L377)：新增 us/eu regional endpoint 仍为 `googleapis.com`，由显式 location 选择。
- [认证文件快照](https://github.com/router-for-me/CLIProxyAPI/blob/d946c4fba6fc9a5cfbca1f3d85184d62ad2fb683/sdk/cliproxy/auth/conductor_lifecycle.go#L381)：重读、持久化与 runtime 状态保留的调用上下文已核对，没有额外持久化或破坏目标。

## 本次依赖变化

根 `go.mod`/`go.sum` 确有变化：go-billy/v6 → alpha.2、go-git/v6 → alpha.5、go-toml/v2 → `v2.4.3-0.20260624044523-35f78d5908f1`，以及 x/crypto .57、x/net .60、x/sync .23、x/sys .48、x/text .42、x/term .46。Go directive 为 1.26.10。共 11 个新增版本的 Go proxy `.info/.mod`、sum.golang.org 记录与项目 checksum 对照；其中 crypto .56、text .41 仅为中间 checksum。所有来源解析至完整 commit；伪版本采用官方 registry Origin.Hash 与官方 commit tree/raw go.mod 互证。

依赖按中央交付相关的恶意行为边界审查：官方来源/清单、完整 tree 差集、变更文件导入/全局初始化/调用导航，以及必要敏感函数源码。每个文件分别记录完整 diff 阅读、语法导航与共享上下文、删除基线复用、Unicode 字面量结构核验等方式；**不声称逐行读完所有依赖 diff 或认证整个依赖树**。

- go-git 的 HTTP/stream v2 协商继续使用调用方会话、配置 endpoint 和已有 authorizer；[FetchV2](https://github.com/go-git/go-git/blob/fc18716c90bcd8e8c935742431e26e260ab7ef60/internal/transport/v2.go#L152)、[pack 文件来源](https://github.com/go-git/go-git/blob/fc18716c90bcd8e8c935742431e26e260ab7ef60/storage/filesystem/dotgit/dotgit.go#L530)、共享 FD 生命周期及删除路径均已补读。新增 receive hooks 是调用方传入的内存函数，无自动发现或执行仓库脚本。
- go-toml 变更文件的导入、初始化与调用清单没有网络、进程、环境或任意文件访问；[bridge init](https://github.com/pelletier/go-toml/blob/35f78d5908f1ccf0b5b3fd7927b3aeb538c352af/unstable/bridge.go#L9) 仅连接解析器。读写、MarshalText/UnmarshalTOML 等回调的完整函数上下文已读，来源为调用方 Reader/Writer/目标值。
- x/net 所有仍存在的纳入文件完整 diff 已读；[UDP 地址选择](https://github.com/golang/net/blob/18ece0ce30bc35fa81fe72028bf309bb3ff3f4a5/quic/udp.go#L33) 仅针对会话 peer 查询本地地址，没有额外 payload/接收方。HTTP/2、QUIC 更改沿现有连接。移除的 HTTP/3 文件按完整 tree 确认并复用旧基线。
- go-billy、x/crypto、x/sync、x/sys、x/term 纳入范围的完整源码差异已读。x/text 代码差异已读，Unicode 大表只对纯字面量结构及其消费者作静态核对，不宣称语义测试。

依赖测试、生成器、开发工作流、非 amd64/arm64 源码、独立 x509roots/fallback 子模块不在中央构建范围；本轮不重新审查整套编译器和无关开发依赖。没有 clone、安装、构建或执行上游代码/发布产物，没有运行测试或漏洞扫描。批准后的中央 CI 构建独立记录，不作为源码审查依据。

本轮证据目录：`/root/upstream-release-review/cliproxyapi-v8.0.40`。发布结果另存 `publication-result.json`；仅更新批准的 pin 与文档，Keeper/Watchtower pin 保持原值，不部署或重启服务。
