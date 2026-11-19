# CLIProxyAPI v8.0.79 静态源码审查

结论：**通过**。已批准中央构建与运行边界内，本轮静态增量未发现恶意代码或恶意依赖证据。

- 基线：v8.0.77 `a5e8f69e56309e1ef6d6872e667da81fdfbce2ce`；[已提交批准报告](https://github.com/naiba/Dockerfiles/blob/e22c1137a7e796089d8a73dd8a7cb5673888e4bb/cliproxyapi/review-result.json)。
- 候选：[v8.0.79 / 6faa8d20b2673404cff70a2f2d9537ae0d0e684d](https://github.com/router-for-me/CLIProxyAPI/commit/6faa8d20b2673404cff70a2f2d9537ae0d0e684d)，官方非 draft/prerelease release，tag 直接指向该 commit。
- 两端完整 tree 重算 **91 个变更路径**，与 compare 一致；52 个非测试文件按 blob SHA 校验，**4,107 行差异全部逐行读完**；39 个测试文件只核对路径。`go.mod`/`go.sum` 未变。

## 按业务链的语义结论

1. **Claude OAuth：** 新增 `oauth-include-create-api-key`（默认 true），只决定既有 Anthropic 授权 URL 里的 scope 字符串。刷新前新增就绪检查：`/usr/bin/pmset -g systemstate` 只在 darwin 构建标签下编译，中央 Linux 构建使用空实现，与已批准的 v8.0.61 SIWC 检查同一模式。
2. **Codex 会话指令：** 客户端通过 `client_metadata` 标记主动开启；按已认证调用方加显式会话 ID，把不超过 32KiB 的基线指令存入既有 KV（TTL 24 小时）或有上限的内存表；恢复出的指令不写入上游请求日志；标记在发出前剥离并校验，不会发给上游。
3. **Codex 执行器：** 大块 hunk 是 difflib 对既有函数体的重新对齐，`chatgpt.com/backend-api/codex` 默认地址在基线就已存在。
4. **Home：** 调度连续性查询和 `scheduler_context`（请求/追踪/会话 ID、模型名）走既有的、运营方配置的 Home Redis 命令通道。
5. **用量队列：** 记录新增 `base_url`、`auth_id`、`selection_id` 元数据，写入既有本地队列（Home/Keeper 消费），不含凭据。
6. **其他：** 插件宿主新增同步外部用量投递接口（panic 熔断）与响应拦截 `Kind` 字段；Antigravity 探测连接改为 HTTP/1.1 且沿用既有代理设置；配置迁移告警顺序、工具 schema `uniqueItems` 剥离、Interactions→Gemini 参数缓冲（50MiB 上限）、模型表条目，均无新增 I/O。
7. 增量中**没有**新主机、Linux 下的进程执行、环境变量读取、文件写入、embed 或 linkname。

中央 Dockerfile 与构建参数不变，仅更新 workflow 源码 SHA。审查未 clone、安装、构建、执行上游代码，也未运行测试或扫描；不部署或重启服务；`provenance:false` 保留。机器报告：[review-result.json](review-result.json)；本地证据：`/root/upstream-release-review/cliproxyapi-v8.0.79/`。

## 其他上游

- CPA Usage Keeper：**无新版**，v2.1.1 `5c97bee91678e3cd9e75201a8025bfcaadf77681`。
- Watchtower：**无新版**，v1.24.1 `f45081047d683daceb9d3196dc8569bb6b534879`。
