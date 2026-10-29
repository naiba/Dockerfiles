# CLIProxyAPI v8.0.47 源码审查

结论：**通过**。在固定 SHA 增量和已批准中央构建/运行边界内，未发现恶意代码或恶意依赖证据。

- 官方仓库：`router-for-me/CLIProxyAPI`。
- 已批准基线：`v8.0.46` → `9717e325ba6ab2c7483ea93ccb5f2047eb2e7dd5`。
- 正式候选：`v8.0.47` → `90c447d3a8727d115aa7552ec93ce023736ed492`，官方 tag 直接解析到该完整 commit。
- 两端 554 个 tree 对象重算 SHA；完整树对比得到 27 个变更文件，与官方 compare 清单一致。全部 111,556 bytes、2,540 行完整 diff 已按 117 页实际阅读；逐文件校验 Git blob SHA、SHA-256，未依赖截断 patch。

审查前锁定中央 `golang:1.26-alpine`、`go mod download`、`CGO_ENABLED=0 GOOS=linux go build ./cmd/server`、发布 CI 二进制 `--help` 和 `alpine:3.22.0` 运行边界。66 项依赖清单、锁文件及构建/安装文件均未变，无新增、升级或来源变化依赖，复用 v8.0.46 已批准基线。示例配置未变。

按文档、插件 ABI/认证/请求补丁、WebSocket 拦截链、工具调用 ID 四组检查全部差异及测试。插件补丁受能力与 schema 门控，只处理当前请求；认证仍检查 provider 返回结果。中央无 CGO 构建使用 `unsupportedLoader`，不能加载标准动态库插件。WebSocket 后续消息保留逐消息授权、credential 启用检查和既有连接；ID 变更仅处理本地协议数据。未见新增外传接收方、隐蔽执行/下载、后门、破坏或未授权资源滥用证据。

逐文件不可变源码、完整 diff/hunk、实际阅读范围及 23 页共享敏感上下文见 [机器记录](review-result.json)。完整证据保存在 `/root/upstream-release-review/cliproxyapi-v8.0.47`。

本结论仅覆盖固定增量及中央交付边界；不认证第三方插件、边界外动态库运行模式及未执行开发/CI/工具链。未 clone、安装、构建、执行上游代码或产物，未运行测试或扫描。通过后触发的中央发布构建不是源审查证据。

同期官方 release/ref 检查：Keeper `v2.0.2` → `46fe6278db0c47a5460e882fa1742f15ab49bb14`、Watchtower `v1.23.2` → `cd5946be205ea0a60dd31235a11f04ac9851ebf6` 均无新版，保留 pin。发布不包含直接部署或服务重启。
