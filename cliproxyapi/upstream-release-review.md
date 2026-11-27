# CLIProxyAPI v8.1.8 静态源码审查

结论：**通过**。已批准中央构建与运行边界内，本轮静态增量未发现恶意代码或恶意依赖证据。

- 基线：v8.1.7 `47f18e4d82bd72f7d2b5ecf5ede93e4837a4625e`；[已提交批准报告](https://github.com/naiba/Dockerfiles/blob/fc6ff7a513ed2f095e2c1eff1d10ec10c71e20ec/cliproxyapi/review-result.json)。
- 候选：[v8.1.8 / dbe641f286a489ecb39e3c041c554371e6add864](https://github.com/router-for-me/CLIProxyAPI/commit/dbe641f286a489ecb39e3c041c554371e6add864)，官方非 draft/prerelease release，tag 直接指向该 commit。
- 75 个变更路径，与 compare 一致；45 个非测试文件、3,542 行差异按 blob SHA 校验并全量筛查；凭据文件写入、文件监听、插件回调/RPC、管理端认证文件和刷新链逐段阅读，翻译器与 schema 逻辑只做筛查。依赖未变。

## 语义结论

1. **凭据文件原子写入：** Claude/Kimi/xAI/Vertex 令牌和文件存储改为同目录临时文件、0600 权限、fsync 后 rename；写入路径与之前相同。
2. **文件监听：** 额外监听配置文件所在目录，并在本地解析配置的符号链接目标；过期的文件快照注册会被跳过并重新读取。
3. **插件宿主：** 新增 `host.context.done/wait` 回调与 `scheduler.pick.cancel`，只作用于插件自己的回调上下文。
4. 管理端重新启用认证文件时清除陈旧错误；停止自动刷新时等待进行中的持久化完成。Codex 终止错误映射、Gemini schema 与请求格式只是载荷逻辑。
5. 增量中**没有**新主机、凭据头、进程执行、环境变量读取或 embed。

中央 Dockerfile 不变（构建器 `golang:1.27-alpine3.24`，运行时 `alpine:3.24`），仅更新 workflow 源码 SHA。审查未执行上游代码、未运行测试或扫描；不部署或重启服务。本地证据：`/root/upstream-release-review/cliproxyapi-v8.1.8/`。

## 其他上游

- CPA Usage Keeper：**无新版**（v2.1.2）。Watchtower：**无新版**（v1.24.2）。
