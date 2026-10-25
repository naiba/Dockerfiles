# CLIProxyAPI v8.0.43 增量源码审查

结论：**通过**。在已锁定的中央构建与运行范围内，未发现本次增量引入恶意行为或恶意依赖的证据；无实质性未解决证据缺口。

| 项目 | 官方正式版 | 完整提交 SHA | 结论 |
| --- | --- | --- | --- |
| CLIProxyAPI | v8.0.43 | `307803510bce87f986fcf7b1a84190f105c7b4aa` | 通过 |
| CPA Usage Keeper | v2.0.1 | `5604768d352a1a85dd5c087b4e85bd657a159a02` | 无新版，保留 pin |
| Watchtower | v1.23.2 | `cd5946be205ea0a60dd31235a11f04ac9851ebf6` | 无新版，保留 pin |

审查范围为 `bc0643405a1d0adf77dd0f109972ac3313d66397` → `307803510bce87f986fcf7b1a84190f105c7b4aa`。官方 release 与 tag/ref 已解析并固定到完整 commit SHA，递归 tree 均完整且未截断；基线 tree 与上一版批准证据完全一致。完整比较得到 76 个变更文件、292236 字节差异，逐文件完整读取并校验两端 Git blob 与 SHA-256；涵盖所有变更源码、模型数据和测试，无变更的文档、配置、二进制、LFS 或子模块。

中央边界沿用现有 `golang:1.26-alpine`、`go mod download`、`CGO_ENABLED=0 GOOS=linux go build ./cmd/server/` 及构建内 `--help`；运行镜像为 `alpine:3.22.0`，包含 tzdata、ca-certificates、编译产物和示例配置。中央 Dockerfile 不变。68 个依赖清单、锁文件及构建/安装相关路径均未变化；新增使用的外部 import 已存在于批准的 go.mod/go.sum，无新增、升级或来源变更依赖。

按 OAuth 管理与插件代理、模型与执行器、协议与 schema、Watcher 与认证、SDK 路由与 WebSocket、Home 重试六组审查。敏感上下文确认管理 POST OAuth 入口受管理鉴权约束；代理由显式请求配置传入；CallerScope 为带前缀的 SHA-256；Vertex 默认地址改为 Google 全局端点。其余变更为请求/响应转换、状态协调和重试。未见恶意外传、隐蔽执行/下载、后门、未授权破坏或资源滥用。

仅作静态恶意行为审查，不评价漏洞、Bug、正确性或测试质量；未 clone、安装、构建、测试、扫描或运行上游。复用有哈希证明的未变批准基线，不递归认证未参与中央交付的开发、CI 和工具链。获准后 CI 构建属于发布，不作为源码审查证据；不直接部署或重启服务。

完整逐文件范围、不可变 blob、差异哈希、模块依据及边界见 [review-result.json](review-result.json)。原始证据与实际阅读覆盖保存在 `/root/upstream-release-review/cliproxyapi-v8.0.43`，发布结果另存 `publication-result.json`。
