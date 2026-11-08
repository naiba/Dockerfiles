# CLIProxyAPI v8.0.61 静态源码审查

结论：**通过**。已批准中央构建与运行边界内，本轮静态增量未发现恶意代码或恶意依赖证据。

- 基线：v8.0.60 `91e0dee827abf476f9f86246f68c500a112f7155`；[已提交批准报告](https://github.com/naiba/Dockerfiles/blob/65dba1578ad319ed98fe6016965c43cbe999bd21/cliproxyapi/review-result.json)。
- 候选：[v8.0.61 / 681ce41b6e44c45b15b79378b003909d6ba29e68](https://github.com/router-for-me/CLIProxyAPI/commit/681ce41b6e44c45b15b79378b003909d6ba29e68)。官方非 draft/prerelease release 的 tag 直接解析到该完整 commit。
- 两端完整 tree 未截断，重算 **45 个变更路径**并与 compare 清单一致；两端变化 raw 源码逐一校验 Git blob，生成完整差异。
- 完整阅读 **29 个非测试文件、1,630 行差异**；另外 16 个 `_test.go` 仅核对路径和来源，不参与中央构建，无需辅助解释，未展开或执行。

## 按业务链的语义结论

1. **SIWC 续期与重新授权：** 接收并持久化 provider 返回的 `earliest_refresh_at`，调度与显式刷新均遵守该时间；新结果仅清理同一凭据对象内旧过期字段。重新授权从用户选择的既有认证文件读取已签发 client ID，复用原 OAuth URL，检查 callback client ID 一致。解析规则和 request ID 诊断未增加额外凭据读取或外传接收方。沿用上一版 claim/receipt 及存储边界。
2. **平台电源状态：** 新增 `siwc_power_darwin.go` 仅在 Darwin 编译，调用固定 `/usr/bin/pmset -g systemstate`，只读取电源能力、使用两秒超时，无 shell 拼接。中央 Linux 使用 `siwc_power_other.go` 的空检查，不执行此命令；未批准或运行 macOS 系统工具。
3. **会话绑定：** 新增显式 `session-affinity-rebind-on: never`，在已有绑定不可用时保留绑定并返回错误，限制重试和 credits fallback 到原凭据；仍从已有候选、缓存和会话指纹选择，没有新增认证绕过目的、第三方请求或隐藏状态持久化。
4. **协议与用量：** 孤立工具输出转换为 user 内容或与前序工具调用配对，Codex delegation 的既有特殊项保留；仅处理 JSON，不执行工具、下载脚本或创建代理进程。插件用量新增细分 token 计数字段，沿原回调传递，不新增内容或凭据通道。
5. **插件商店：** management list 的 `refresh=true/1` 改变已有 release 查询缓存策略，十秒刷新下限、共享并发限制和同一 `PrepareLatestRelease/FetchLatestRelease` 调用保留。完整补读 `plugin_store_release.go` 确认只读版本查询，不自动安装或执行插件。文档中的外部 Hermes 插件命令仅是文档，未运行或扩展为交付依赖。

## 依赖与中央边界

`go.mod` 与 `go.sum` 在两端的 blob 完全一致，无新增、升级或来源变化依赖；复用有来源证明的已批准基线，不扩审 Go 生态或未变库。

审查前校验中央 Dockerfile 和 workflow 散列与上一版批准证据一致。保持 Go 1.26 Alpine、`CGO_ENABLED=0`、`go build ./cmd/server/`、amd64/arm64 与 Alpine 3.22.0 运行时，仅更新 workflow 源码 SHA。原生插件和外部 Home 实现仍在原边界外。

审查未 clone、安装、构建、执行上游源码/产物、运行测试或扫描。通过后的既有中央发布 CI 独立于静态审查；不自动部署或重启服务。本结论不是漏洞、正确性或性能保证，现有 `provenance:false` 限制保留。

机器报告：[review-result.json](review-result.json)；逐路径来源及散列：[release-source-evidence.json](release-source-evidence.json)。完整树、raw、diff 和官方元数据保存在本地 `/root/upstream-release-review/cliproxyapi-v8.0.61/`。

## 其他上游

- CPA Usage Keeper：**无新版**，最新正式版 v2.0.3 的 tag 仍指向 `9db74cfc380d11064af80cf1626efd6e3d068217`。
- Watchtower：**无新版**，最新正式版 v1.24.0 的 annotated tag 对象 `8ff4fafcdee91684e1db0f6e6e05ab3bb28386e7` 仍解析到 `147aa6a534428e68eb1ba4f71918f6f35404624d`。
