# CLIProxyAPI v8.0.46 源码审查

结论：**通过**。在固定 SHA 增量和已批准的中央构建/运行边界内，未发现恶意代码或恶意依赖证据。

- 官方仓库：`router-for-me/CLIProxyAPI`。
- 已批准基线：`v8.0.45` → `ad8bdd3f20bef44f0684b8a6096a216b2c76040d`。
- 正式候选：`v8.0.46` → `9717e325ba6ab2c7483ea93ccb5f2047eb2e7dd5`，官方 tag 直接解析到该完整 commit。
- 两端 554 个 tree 对象重算 SHA；完整树对比得到 38 个变更文件，与官方 compare 清单一致。全部 172,512 bytes、4,284 行完整 diff 已按 170 个实际阅读页检查，没有使用截断 patch；每份源码均校验 Git blob SHA 和 SHA-256。

源审查前锁定 `golang:1.26-alpine`、`go mod download`、`CGO_ENABLED=0 go build ./cmd/server`、CI 二进制 `--help` 和 `alpine:3.22.0` 运行边界。依赖清单、锁文件、来源与构建脚本未变，复用 v8.0.45 已批准基线；示例配置仅修改注释。本次没有新增、升级或来源变更的依赖及安装脚本。

按文档/配置、响应压缩、模型注册、WebSocket 会话/中断、SSE/图像分帧五组阅读，包含全部测试差异。压缩器仅处理当前响应；模型索引仅维护内存能力计数；中断沿用会话查找、启用状态校验和既有 socket；SSE 恢复及元数据过滤仅处理协议数据，写回当前响应。未见新增外传目的地、隐蔽执行/下载、后门、破坏或未授权资源滥用证据。

逐文件不可变 blob、完整 diff/hunk、实际阅读范围和 15 个共享上下文页见 [机器记录](review-result.json)。不审查漏洞、Bug、正确性、质量、性能或测试断言，不运行上游代码、安装、构建、测试或扫描。未变依赖、外部服务及未来远程内容不作新的全量认证；未递归核验不参与中央交付的开发/CI 工具链。

三项目官方检查：CLIProxyAPI 通过本次增量审查；Keeper `v2.0.2` / `46fe6278db0c47a5460e882fa1742f15ab49bb14` 与 Watchtower `v1.23.2` / `cd5946be205ea0a60dd31235a11f04ac9851ebf6` 均无新版，保留 pin。

完整证据：`/root/upstream-release-review/cliproxyapi-v8.0.46`，含 `review-result.json/md`、完整树/blob/diff、实际阅读范围和依赖未变记录。批准后的 CI 构建仅属发布，终态及公开 GHCR 双架构/来源核验另存 `publication-result.json`；不部署、不重启服务。
