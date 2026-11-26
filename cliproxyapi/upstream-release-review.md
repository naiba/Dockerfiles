# CLIProxyAPI v8.1.6 静态源码审查

结论：**通过**。已批准中央构建与运行边界内，本轮静态增量未发现恶意代码或恶意依赖证据。

- 基线：v8.1.5 `13d87daf65d1614570bbb59e6a26898bf8fd6cc4`；[已提交批准报告](https://github.com/naiba/Dockerfiles/blob/819c8e2758df621498a80b455cff55c673f55a62/cliproxyapi/review-result.json)。
- 候选：[v8.1.6 / 0aaf6d1c3a9eb28979145d13c831637254319c92](https://github.com/router-for-me/CLIProxyAPI/commit/0aaf6d1c3a9eb28979145d13c831637254319c92)，官方非 draft/prerelease release，tag 直接指向该 commit。
- 25 个变更路径，与 compare 一致；18 个非测试文件、**1,493 行差异全部逐行读完**。依赖未变。

## 语义结论

1. **Home 授权的本地插件执行**（`acp/` 前缀模型）：CPA 经既有 Home Redis 命令通道询问运营方的 Home（携带模型、请求头、查询参数），Home 返回插件、版本和配置摘要；CPA 只会执行已在本地加载、版本与配置摘要都匹配、且模型未被改动的插件。
2. 原生插件重新加载同一镜像时使用唯一的影子副本路径；新增读取插件静态模型目录的接口。
3. Codex WebSocket 在有活动回合时通过 `net.Conn` 延长读超时，并记录 duplex create/steer 状态。
4. 增量中**没有**新主机、进程执行、环境变量读取、文件写入或 embed。

中央 Dockerfile 不变（构建器 `golang:1.27-alpine3.24`，运行时 `alpine:3.24`），仅更新 workflow 源码 SHA。审查未执行上游代码、未运行测试或扫描；不部署或重启服务。本地证据：`/root/upstream-release-review/cliproxyapi-v8.1.6/`。

## 其他上游

- CPA Usage Keeper：**无新版**（v2.1.2）。Watchtower：**无新版**（v1.24.2）。
