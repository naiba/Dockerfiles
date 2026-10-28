# CLIProxyAPI v8.0.45 源码审查

结论：**通过**。在固定 SHA 增量和既有中央镜像交付边界内，未发现恶意代码或恶意依赖证据。

- 官方仓库：`router-for-me/CLIProxyAPI`。
- 已批准基线：`v8.0.44` → `1f917e77c4562623aa49e9804d999524151a2f96`。
- 正式候选：`v8.0.45` → `ad8bdd3f20bef44f0684b8a6096a216b2c76040d`，官方 tag 直接解析到该完整 commit。
- 两端完整树逐层重算 Git SHA；123 个变更文件与官方 compare 清单一致，完整 diff 共 1,507,465 bytes，未使用截断 patch。
- 122 个文件的原始完整 diff 已读。模型目录的完整结构差异和六种独有长字符串差异已读；88 处长字符串按哈希引用共享原文及已批准基线的相同部分，可无损还原原始 diff。未把未逐字显示的重复原始页记为已读。逐文件 blob、SHA-256、hunk 和实际阅读范围见 [机器记录](review-result.json)。

源审查前锁定中央构建/运行边界：`golang:1.26-alpine`、`go mod download`、`CGO_ENABLED=0 go build ./cmd/server`、CI 中二进制 `--help`，运行于 `alpine:3.22.0`。本轮全部变化位于 `internal/` 和 `sdk/`；依赖清单、版本、来源、安装行为及构建/配置文件未变，复用 v8.0.44 已批准基线。

按 HTTP/SDK、模型目录、执行与 Home 会话、协议转换/签名/用量四组审查完整差异，含全部新增及变更测试。管理刷新路由沿用管理认证；目录从既有默认或显式配置源读取并解析为 JSON；模型提示仅作数据处理。Devin patch 参数仅包装，Vertex partialArgs 仅组装内存 JSON，图片格式回调只调整响应字段，用量身份快照仍走既有插件/配置 Redis 链。未见隐藏下载/执行、凭据外传、后门、破坏或未授权资源滥用。

三项目官方检查：CLIProxyAPI 更新至上述 pin；Keeper `v2.0.2`（`46fe6278db0c47a5460e882fa1742f15ab49bb14`）和 Watchtower `v1.23.2`（`cd5946be205ea0a60dd31235a11f04ac9851ebf6`）均为**无新版**，保留 pin。

审查仅静态阅读，未 clone、安装、构建、测试、扫描或执行上游代码。不评价漏洞、Bug、正确性或测试质量；不递归认证未变开发/CI/工具链。未来远程目录内容、用户另行配置的插件及外部服务不在本次认证范围。批准后的 CI 仅作发布证据，不作为源码审查依据；不部署或重启服务。

完整证据：`/root/upstream-release-review/cliproxyapi-v8.0.45`，含 `review-result.json/md`、完整树/blob/diff、可还原的模型文本共享证据、实际范围及依赖未变记录。发布终态和公开 GHCR 多架构/来源核验另存 `publication-result.json`。
