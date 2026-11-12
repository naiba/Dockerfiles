# CLIProxyAPI v8.0.69 静态源码审查

结论：**通过**。已批准中央构建与运行边界内，本轮静态增量未发现恶意代码或恶意依赖证据。

- 基线：v8.0.61 `681ce41b6e44c45b15b79378b003909d6ba29e68`；[已提交批准报告](https://github.com/naiba/Dockerfiles/blob/84987a15f7bc62c9c41f99637eae976571eaf45c/cliproxyapi/review-result.json)。
- 候选：[v8.0.69 / f7ae8feeb3710319f524730849fbe32fde1751e4](https://github.com/router-for-me/CLIProxyAPI/commit/f7ae8feeb3710319f524730849fbe32fde1751e4)。官方非 draft/prerelease release 的 tag 直接解析到该完整 commit。
- 核验 `go.mod`/`go.sum` blob SHA 与基线完全一致，无依赖变化。
- 完整阅读 **68 个非测试文件、25,517 行差异**；另外 59 个 `_test.go` 仅核对路径和来源，不参与中央构建，未展开或执行。

## 按业务链的语义结论

1. **`--login-proxy` flag：** 将 `proxy_url` 写入凭据配置，仅作用于 OAuth 登录流程，不影响运行时请求路由到上游 AI 提供商。
2. **`DeferredAPICapture` 请求日志：** 32MiB 请求 / 512KiB 响应大小限制，仅在 error-only 日志模式生效；不引入新外传端点。
3. **`/v1/tunnel` WebSocket 端点（`wstunnel/`）：** Hub 以 apiKey 隔离 realm，连接前必须持有有效 reservation；数据帧上限 64MiB，控制帧上限 4096 字节；所有流量保持在现有认证边界内；连接关闭时 unregisterPeer 通知 realm，无新外部目的地。
4. **`ReadMetadataHomeCloak` 等辅助函数：** 仅读取内存中的 metadata map，无网络调用。
5. **推理重放缓存：** `encoding/json` 替换为 `ojson`，格式兼容，无新 I/O；`PeekAntigravityReasoningReplayItems*` 为只读路径，不创建 tombstone。
6. **Home 客户端心跳：** 更严格的 PONG 验证（仅接受不带 payload 的 PONG），无新目的地。
7. **`SanitizeAntigravity`/`SanitizeDevin`：** 内存中配置规范化，无 I/O。
8. **WebSocket keepalive 重构：** 改为基于 `lastHeartbeat` 的绝对 deadline，纯内存时序，无新外传。
9. **cooldown/quota 状态机改进：**
   - `forceCooldownSeeded`/`forceCooldownUntil`/`credQuotaForceUntil` 合并机制：单次初始化，取更大值，纯内存状态传播，无外传。
   - `CooldownSignals`/`ForceCooldownUntil` 等持久化字段写入已有本地 KV 存储，不引入新外部目的地。
   - `rejectedClaudeSignalsForCooldown`：过滤上游响应的 `anthropic-ratelimit-unified-*` 头部子集，不发出新 HTTP 请求。
10. **调度器重构（`scheduler.go`/`scheduler_weighted.go`/`selector.go`/`selector_weighted.go`）：**
    - `rebuildAuths` 增量保留 model shard 和 mixed cursors，避免配置重载丢失轮转进度。
    - `WeightedRoundRobinSelector` 改为 `weightedPoolState` + `weightedReservation`，epoch 隔离防止已删除 ID 污染新注册的同名凭据；所有逻辑为纯内存权重调度，无网络/文件/系统调用。
    - `claudeCooldownSummaryLocked`：只读内存遍历，返回 Anthropic 配额头部信号。
    - `modelCooldownError.Headers()`：在 Claude cooldown 时附加 `Anthropic-Ratelimit-Unified-*` 头部，来源为上游响应头部的过滤子集，`SafeResponseHeaders()` 仅输出 `Retry-After`。
    - `ForgetAuth`/`ForgetAuthUpTo`：epoch-gated 永久凭据移除，纯内存操作。
11. **`session/claude_thread.go`（新增，107 行）：** `RememberClaudeThreadAuth` 将 authID 字符串写入已有 KV store（`kvstore.KVSetNXBestEffort`，TTL 24h，key 格式 `claude:thread-auth:v1:<hash>:<hash>`）；`ClaudeThreadAuth` 从相同 KV store 读取；无新外部目的地。
12. **`usage/home_selection.go`（新增，37 行）：** context value，不可变副本语义，无 I/O。
13. **`service_config.go`：** `newRoutingSelectorWithExisting` 在策略不变时复用现有 `WeightedRoundRobinSelector` 实例（保留计数器），无新网络调用。
14. **`service_executors.go`：** `ClaudeExecutor.WithConfig` 复用现有 executor 实例，无新网络调用。
15. **`pluginabi/types.go`：** `ErrorCode*` 常量和 `CredentialScoped` 字段，含方法文档；纯常量/struct 扩展，无网络调用。

## 依赖与中央边界

`go.mod` 与 `go.sum` blob 与基线 v8.0.61 完全一致，无新增、升级或来源变化依赖；复用有来源证明的已批准基线，不扩审 Go 生态或未变库。

审查前校验中央 Dockerfile 和 workflow 散列与上一版批准证据一致。保持 Go 1.26 Alpine、`CGO_ENABLED=0`、`go build ./cmd/server/`、amd64/arm64 与 Alpine 3.22.0 运行时，仅更新 workflow 源码 SHA（`681ce41` → `f7ae8fe`）。原生插件和外部 Home 实现仍在原边界外。

审查未 clone、安装、构建、执行上游源码/产物、运行测试或扫描。通过后的既有中央发布 CI 独立于静态审查；不自动部署或重启服务。本结论不是漏洞、正确性或性能保证，现有 `provenance:false` 限制保留。

机器报告：[review-result.json](review-result.json)。完整 diff 保存在本地 `/root/upstream-release-review/cliproxyapi-v8.0.69/`。

## 其他上游（本轮同步审查）

- CPA Usage Keeper：**通过**，v2.1.0 `41b34f12dbef209292765415b860583aad5afc09`（详见 `cliproxyapiplus/upstream-release-review.md`）。
- Watchtower：**无新版**，最新正式版 v1.24.0 annotated tag 对象 `8ff4fafcdee91684e1db0f6e6e05ab3bb28386e7` 仍解析到 `147aa6a534428e68eb1ba4f71918f6f35404624d`。
