# cpa-usage-keeper v2.1.2 静态源码审查

结论：**通过**。固定增量及中央交付边界内未发现恶意代码或恶意依赖证据。

- 基线：v2.1.1 `5c97bee91678e3cd9e75201a8025bfcaadf77681`。
- 候选：[v2.1.2 / 047ae17d6df33e643af054a47433ac7aec4179aa](https://github.com/Willxup/cpa-usage-keeper/commit/047ae17d6df33e643af054a47433ac7aec4179aa)，正式 release tag 直接指向该 commit。
- 182 个变更路径，与 compare 一致：104 个非测试文件（16,739 行差异，按 blob SHA 校验），Go 部分全部读完，Web 部分做了网络调用、动态代码、存储和外部 URL 筛查；78 个测试只核对路径。
- `go.mod`/`go.sum`、`web/package.json`/`package-lock.json`、`docker-entrypoint.sh` 均未变化。

## 语义结论

1. **新增 Meta 额度查询：** 通过既有的 CPA 管理接口下载该 Meta 凭据（与已批准的 Kimi 查询同一模式），取出 `dca:` 令牌，经 CPA 的管理 api-call 代理请求 Meta 官方 `https://api.meta.ai/muse-code/key`；令牌不保存、不写日志。
2. **新增 `/usage/identities/:id/models`：** 挂在既有管理员认证组下，对本地 SQLite 做参数化查询。
3. **Web：** 凭据卡片/列表/模型用量界面重构，只调用同源 API；`localStorage` 只保存列表视图偏好；没有 eval、动态脚本或外部 URL。

中央 Dockerfile.keeper 随后升级构建器：web 构建 `node:24-alpine` → `node:26-alpine3.24`（Node 26 LTS），Go 构建 `golang:1.26-alpine` → `golang:1.27-alpine3.24`；发布前已用 Node 26 执行 `npm ci` 与前端构建、用 Go 1.27.4 做 CGO 编译验证，lockfile、入口脚本和 `alpine:3.24` 运行时不变。审查中未执行上游代码、未运行测试或扫描；不部署或重启。本地证据：`/root/upstream-release-review/keeper-v2.1.2/`。

## 历史

- v2.1.1（`5c97bee`）：通过。
- v2.1.0（`41b34f1`）：通过；记录于提交 `b2acd65`，路由名与 WebGL 描述在 `1d2fee8` 中更正。
