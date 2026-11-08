# CLIProxyAPI v8.0.60 静态源码审查

结论：**通过**。在已批准中央构建与运行边界内，本轮增量未发现恶意代码或恶意依赖证据。

- 已批准基线：v8.0.57 `c2f402b45643f0740d70b9010fd7d8d0aab7ef65`；[上一版报告](https://github.com/naiba/Dockerfiles/blob/080eb0af43097507c9ef0c6e87eb318f2e32c4d8/cliproxyapi/review-result.json)。
- 候选：[v8.0.60 / 91e0dee827abf476f9f86246f68c500a112f7155](https://github.com/router-for-me/CLIProxyAPI/commit/91e0dee827abf476f9f86246f68c500a112f7155)。官方非预发布 release 的 tag 直接指向该完整 commit，提交前再次核对。
- 两端完整 Git tree 均未截断，重算 **127 个变化路径**，与 compare 清单一致；两端变化源码逐一匹配 Git blob，重新生成完整差异。
- 完整阅读 **68 个非测试文件、5,947 行差异**。另 59 个 `_test.go` 文件仅核对清单和来源，不参与中央构建，无需辅助解释，未展开或执行。

## 敏感链结论

1. **Codex / SIWC 刷新日志：** manager 为刷新绑定实际 token store，executor 显式路径也绑定对应目录；先 claim，再向既有 OpenAI OAuth 端点刷新，保存 receipt 后返回。刷新 POST 不跟随重定向；未知结果停止重放，不自动清除 claim。
2. **凭据持久化：** receipt 含 token，按新增文档要求与凭据同等保护。文件模式使用认证目录下 `.codex-refresh/<sha256>/receipt`，目录 0700、临时文件 0600，原子替换并同步；Git 在同一配置 remote 推送非 force 的 `refs/tags/cliproxy-refresh/`；S3 在同一配置 bucket/prefix 写入 `codex-refresh/`，签名条件 PUT 禁止重定向，仅删除本次随机探测对象；PostgreSQL 在原配置 schema 新增认证表对应日志表，参数化读写及限定键更新，没有全表删除。
3. **S3 新调用：** 对既有 MinIO v7.0.66 的 `PresignHeader → presignURL → newRequest → makeTargetURL` 做定向阅读；URL 由配置 endpoint、bucket、object 与既有 S3 region 规则构造，身份为原静态存储凭据，无新增独立接收方。不是对整个 MinIO 或传递图重新审计。
4. **OAuth 与插件：** Claude 新登录显式增加 `org:create_api_key` scope、state 使用 32 字节加密随机数；未增加自动创建 key 或其他秘密读取。OAuth provider 元数据用于保留登录入口身份。shadow cache、锁和 fallback 加载增量已读；其 cgo/Windows build tags 不进入本次 Linux CGO=0 交付，unsupported loader 的清理函数为空，不批准外部插件二进制。
5. **请求与流：** Devin 压缩沿同一 executor/model/auth；工具引用、system placement、图像能力校验、模型目录及响应转换均为 JSON 协议处理，不在服务器执行客户端工具。Claude 完成后 drain 原响应体、SSE keepalive 和刷新失败选择状态没有引入新目的地、隐藏执行或未经授权资源用途。

## 依赖、边界与局限

`go.mod`、`go.sum` 的 Git blob 在两端完全相同，无新增、升级或来源变化依赖；复用已批准基线。MinIO 定向核验固定官方提交 `5415e6c72a71610108fe05ee747ac760dd40094f`，官方 annotated tag 解引用与 Go registry Origin 一致。

中央 Dockerfile、构建参数与运行边界不变：Go 1.26 Alpine、`CGO_ENABLED=0`、`go build ./cmd/server/`、amd64/arm64、Alpine 3.22.0。仅更新 workflow 源码 SHA；未 clone、安装、构建、运行上游代码/产物、执行测试或扫描。通过后的现有中央发布 CI 独立于静态源审查。

机器记录见 [review-result.json](review-result.json)；[来源清单](release-source-evidence.json) 含逐路径 blob 与差异散列。完整 raw 源码、diff、树和官方元数据保存在 `/root/upstream-release-review/cliproxyapi-v8.0.60/`（本地证据，不是公共下载地址）。未变基线原始本地材料当前环境不可用，本轮复用的是仓库内已提交、带来源引用的批准报告，不声称重新验证旧阅读日志。

本结论不保证无漏洞、Bug 或性能问题，也不批准外部 Home 实现、操作员插件、上游发布产物或整个依赖生态。现有 `provenance:false` 限制保留；不自动部署或重启服务。

## 另两个上游

- CPA Usage Keeper：**无新版**，官方最新正式版 v2.0.3 仍为 `9db74cfc380d11064af80cf1626efd6e3d068217`，pin 不变。
- Watchtower：**无新版**，官方最新正式版 v1.24.0 的 tag 对象 `8ff4fafcdee91684e1db0f6e6e05ab3bb28386e7` 仍解析到 `147aa6a534428e68eb1ba4f71918f6f35404624d`，pin 不变。
