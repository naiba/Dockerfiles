# CLIProxyAPI v8.1.1 静态源码审查

结论：**通过**。已批准中央构建与运行边界内，本轮静态增量未发现恶意代码或恶意依赖证据。

- 基线：v8.0.79 `6faa8d20b2673404cff70a2f2d9537ae0d0e684d`；[已提交批准报告](https://github.com/naiba/Dockerfiles/blob/3fdf979879a77d5a8ed47138236d53c7c169d66f/cliproxyapi/review-result.json)。
- 候选：[v8.1.1 / 6eb8554f0ede597b2aa3e508ffb3f111d3c2b9e6](https://github.com/router-for-me/CLIProxyAPI/commit/6eb8554f0ede597b2aa3e508ffb3f111d3c2b9e6)，官方非 draft/prerelease release，`git ls-remote` 显示 tag 直接指向该 commit。
- 本轮 gh 令牌失效，改用未认证的 Git trees API 取两端完整 tree，再从 codeload 下载两端完整源码归档；归档内每个文件都按 Git blob 重算并与 tree 一一对应，没有缺失或多余路径。
- **415 个变更路径**（212 非测试、203 测试），非测试差异 34,363 行：49 个纯 import hunk 机械分离，其余 33,882 行全量做敏感筛查，网络、凭据、存储、配置同步链逐段阅读；翻译器和调度逻辑只做了筛查。

## 语义结论

1. **新增 GitHub Copilot 提供方**（需运营方主动执行设备登录）：OAuth 设备流和令牌交换只发往 `github.com`、`api.github.com`，并禁止重定向；推理请求只发往白名单内的 `*.githubcopilot.com` 主机，每次请求前都会校验。
2. **配置文件：** 加锁的 CAS 写入（临时文件加 rename，权限 0600），支持配置上传；`server-id` 是本地部署 UUID，只经由已认证的管理 API 返回。
3. **存储后端：** 配置同步重构为 `config_mirror`；git/对象存储/Postgres 在基线就已同步配置；git 远端仍只来自运营方的 `GITSTORE_*` 设置。
4. **Antigravity：** 探测退避用访问令牌的 sha256 作为本地键，不外传；hub manifest 和 loadCodeAssist 地址与基线一致。
5. `conductor_execution.go` 中的 `unsafe` 只用于比较两个 interface 头是否相同。
6. README 赞助链接（fenno.ai、qiniu.com）变化只是文档。`cmd/fetch_copilot_models`、`cmd/fetch_codex_models` 是独立 main，不被 `cmd/server` 引用。

## 依赖

- `go 1.26.10` 未变，中央 `golang:1.26-alpine` 满足。
- `MoeForge/moego` alpha.4 → alpha.5：proxy Origin `c15aaab` 与解引用后的 tag 一致；改动为纯 Go，只引用标准库。
- `golang.org/x/crypto/net/sync/sys/text` 小版本升级。
- `gofrs/flock` 新增为直接依赖，但只被 `filelock_fcntl.go`（`aix || solaris`）引用，Linux 构建不编译；`go-billy/v6` 同版本由 indirect 转为 direct。
- 所有在中央构建中可达的变化模块：新旧 zip 均从 proxy.golang.org 获取，h1 与 go.sum、sum.golang.org 一致，可达包差异已做敏感筛查。

中央 Dockerfile 与构建参数不变，仅更新 workflow 源码 SHA。审查未 clone、安装、构建、执行上游代码，也未运行测试或扫描；不部署或重启服务。本地证据：`/root/upstream-release-review/cliproxyapi-v8.1.1/`。

## 其他上游

- CPA Usage Keeper：**无新版**（v2.1.1）。Watchtower：**无新版**（v1.24.1）。
