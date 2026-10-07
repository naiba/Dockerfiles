# 上游固定版本增量审查

## 结论与范围

两个组件均为 **通过**：在以下固定提交区间的完整差异和相关上下文中，未发现有代码证据支持的恶意外传、后门、隐藏下载执行、恶意删除或恶意依赖行为。该结论不是漏洞审计，也不保证未来动态下载的管理页面、插件或模型目录内容安全。

| 组件 | 原版本 / 完整 SHA | 候选正式版本 / 完整 SHA | 完整差异文件数 |
| --- | --- | --- | --- |
| CPA Usage Keeper | v1.15.9 / `3f1b29aa5b0b5284b75ec53573b5146cd50fea1b` | v1.15.10 / `b3592bff1e342c246d1324bcd99ba9b77232f315` | 78 |
| CLIProxyAPI | v8.0.13 / `d7914afdedca7af95ee974a42453dc49fc1388ce` | v8.0.20 / `0f96f568e4dbf6f84ad7399a74b78344c5eac7e6` | 376 |

候选 tag 的 GitHub git/ref 响应均为 `object.type=commit`，完整 SHA 与上表一致：

- [Keeper 正式发布](https://github.com/Willxup/cpa-usage-keeper/releases/tag/v1.15.10) · [固定 SHA 比较](https://github.com/Willxup/cpa-usage-keeper/compare/3f1b29aa5b0b5284b75ec53573b5146cd50fea1b...b3592bff1e342c246d1324bcd99ba9b77232f315)
- [CLIProxyAPI 正式发布](https://github.com/router-for-me/CLIProxyAPI/releases/tag/v8.0.20) · [固定 SHA 比较](https://github.com/router-for-me/CLIProxyAPI/compare/d7914afdedca7af95ee974a42453dc49fc1388ce...0f96f568e4dbf6f84ad7399a74b78344c5eac7e6)

## 完整性与依赖

- 逐个检查生产代码、测试、文档及配置的全部变更；跨文件敏感调用使用目标完整 SHA 的官方 raw source 补查。
- CLIProxyAPI 的 JSON compare 仅列出前 300 个文件，不能作为完整审查清单。改用官方 diff，检查全部 hunk 的增删行数，并与两端未截断 git tree 的 blob SHA 差异核对，确认覆盖 376 个文件。
- Keeper 官方 diff 为 78 个文件，与 compare 文件清单一致；所有 hunk 增删行数完整。
- 差异无二进制补丁、LFS 指针或子模块变更；候选 tree 无子模块及符号链接条目。
- 两组件的 `go.mod`、`go.sum`，以及 Keeper 的 `web/package.json`、`web/package-lock.json`、`docker-entrypoint.sh`，均通过两端官方 raw 文件逐字节比较确认未变。因此无新增、升级或来源变更的 Go/npm 安装依赖。
- 经用户确认，Keeper 的 `Dockerfile.keeper` 运行阶段跟随上游由 `alpine:3.20` 更新为 `alpine:3.24`，安装命令和构建阶段不变。官方[分支维护表](https://www.alpinelinux.org/releases/)列出 3.20 已转为 on-request 支持，3.24 常规支持截止于 2028-06-01；收益是维护周期和上游环境一致性，不主张未经测量的性能或体积收益。
- Docker 官方 `library/alpine:3.24` 注册表索引包含 `linux/amd64` 和 `linux/arm64`，核验时索引摘要为 `sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6`。Dockerfile 与上游一样使用 3.24 系列标签，未锁定此摘要；此记录仅用于本次元数据核验。
- 官方 Alpine 3.24 软件包目录确认 `ca-certificates`、`tzdata`、`su-exec` 在 `main/x86_64` 和 `main/aarch64` 均可用。本次基础镜像核验限于官方来源、架构、包元数据及 Dockerfile 静态检查，不代表对基础镜像全部软件包源码完成恶意代码审计，也未验证 CGO 产物的实际运行兼容性。
- 未 clone、安装、构建、运行上游源码或发布产物，未运行测试或漏洞扫描。

## Keeper 敏感路径依据

以下链接均固定于 `b3592bff1e342c246d1324bcd99ba9b77232f315`：

- [Claude 配额重置](https://github.com/Willxup/cpa-usage-keeper/blob/b3592bff1e342c246d1324bcd99ba9b77232f315/internal/quota/claude_reset.go)：`ResetClaude` 校验 grant ID 和组织 UUID，向固定 `https://api.anthropic.com/api/organizations/<UUID>/reset_rate_limits` 发起请求，通过现有 CPA 管理调用使用所选账户；未新增第三方接收地址。请求由已有重置入口及用户确认触发，结果不确定时不自动重试。
- [Kimi 凭证元数据读取](https://github.com/Willxup/cpa-usage-keeper/blob/b3592bff1e342c246d1324bcd99ba9b77232f315/internal/cpa/kimi.go)：从配置的 CPA 管理接口读取所选文件，仅返回 domain、base URL、type；解码失败使用固定错误文本。[站点选择](https://github.com/Willxup/cpa-usage-keeper/blob/b3592bff1e342c246d1324bcd99ba9b77232f315/internal/quota/kimi.go) 只在两个预设站点间切换，不把凭证中的任意 URL 当作发送目标。
- [配额配置](https://github.com/Willxup/cpa-usage-keeper/blob/b3592bff1e342c246d1324bcd99ba9b77232f315/internal/quota/config.go)：新增国际站目标为 `https://api.kimi.ai/coding/v1/usages`；Claude 请求仍指向 `api.anthropic.com`。
- [归档清理](https://github.com/Willxup/cpa-usage-keeper/blob/b3592bff1e342c246d1324bcd99ba9b77232f315/internal/repository/usage_event_archive.go)：新增删除限定于归档实体、截止日期和批次 ID；保留期小于 90 时直接返回。配置默认 `0`，需要显式启用才清理归档，不是隐蔽默认销毁。
- 前端变更为同源 API 调用、重置确认、提供商筛选 URL、站点徽标及展示状态，未新增秘密采集、第三方上传或动态执行入口。

## CLIProxyAPI 敏感路径依据

以下链接均固定于 `0f96f568e4dbf6f84ad7399a74b78344c5eac7e6`：

- [Grok CLI 版本查询](https://github.com/router-for-me/CLIProxyAPI/blob/0f96f568e4dbf6f84ad7399a74b78344c5eac7e6/internal/runtime/executor/helps/xai_version.go)：向 `https://registry.npmjs.org/@xai-official/grok/latest` 发送无正文 GET，仅设置 Accept/User-Agent，限制读取量并校验数字版本。版本进入内存及客户端标识；不读取 tarball 字段、不安装包、不执行 npm 脚本。官方注册表元数据虽含 postinstall，但这条代码路径不下载或调用它。
- [共享 GitHub 令牌](https://github.com/router-for-me/CLIProxyAPI/blob/0f96f568e4dbf6f84ad7399a74b78344c5eac7e6/internal/githubauth/token.go)：读取显式配置及兼容环境变量；`TokenForURL` 限定 HTTPS、精确 `api.github.com`、无 userinfo、默认端口或 443。[插件 HTTP 处理](https://github.com/router-for-me/CLIProxyAPI/blob/0f96f568e4dbf6f84ad7399a74b78344c5eac7e6/internal/pluginstore/github.go) 对重定向逐跳重新计算认证。此次没有改变既有插件安装启用条件、来源或加载机制。
- [可配置模型目录](https://github.com/router-for-me/CLIProxyAPI/blob/0f96f568e4dbf6f84ad7399a74b78344c5eac7e6/internal/registry/catalog_sources.go)：读取用户配置的绝对路径或 HTTP(S) 来源，下载请求无正文、不附加共享账户令牌。模型数据经 JSON 验证后更新内存；[Codex 加载器](https://github.com/router-for-me/CLIProxyAPI/blob/0f96f568e4dbf6f84ad7399a74b78344c5eac7e6/internal/registry/codex_client_models.go) 和 [Devin 加载器](https://github.com/router-for-me/CLIProxyAPI/blob/0f96f568e4dbf6f84ad7399a74b78344c5eac7e6/internal/registry/devin_models.go) 不执行下载内容。
- [Antigravity 账号模型探测](https://github.com/router-for-me/CLIProxyAPI/blob/0f96f568e4dbf6f84ad7399a74b78344c5eac7e6/sdk/cliproxy/antigravity_models.go)：向 Google 默认端点或账户显式配置的端点发送 project 与账户 Bearer token；结果用于模型权限及内存注册表，未新增秘密收集端点。
- [xAI 语音](https://github.com/router-for-me/CLIProxyAPI/blob/0f96f568e4dbf6f84ad7399a74b78344c5eac7e6/internal/runtime/executor/xai_executor_speech.go)：将调用者文本发往配置的 xAI base URL 加 `/tts`；[默认常量](https://github.com/router-for-me/CLIProxyAPI/blob/0f96f568e4dbf6f84ad7399a74b78344c5eac7e6/internal/auth/xai/types.go) 为 `api.x.ai` 和 `cli-chat-proxy.grok.com`，未新增第二接收方。
- [shell 工具转换](https://github.com/router-for-me/CLIProxyAPI/blob/0f96f568e4dbf6f84ad7399a74b78344c5eac7e6/internal/translator/openai/openai/responses/shell_tool.go)：仅转换显式声明的本地 shell 工具协议、参数、历史及响应，不启动本机进程。[附件规范化](https://github.com/router-for-me/CLIProxyAPI/blob/0f96f568e4dbf6f84ad7399a74b78344c5eac7e6/internal/translator/common/file_data.go) 只处理输入字符串和 MIME，不获取远程附件或读取本机文件。
- [凭据保存串行化](https://github.com/router-for-me/CLIProxyAPI/blob/0f96f568e4dbf6f84ad7399a74b78344c5eac7e6/sdk/cliproxy/auth/conductor_persistence.go)：克隆、锁定并合并既有保存结果，不新增保存目的地。Store、Home、认证登录、既有日志消费及插件加载的未变更实现不作为新增依赖重新审查；其未变更状态由两端 tree blob SHA 确认。

## 本仓库变更边界

更新两个 workflow 的固定 SHA、Keeper tag、Keeper 运行阶段 Alpine 基础镜像和对应文档；不修改运行时配置或管理密钥，不触发 workflow、镜像发布或部署。
