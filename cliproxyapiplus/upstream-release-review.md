# 上游固定版本增量审查

## CLIProxyAPI v8.0.35 增量审查

结论：**通过**。Keeper v2.0.0 无新版，固定 SHA `fc8cbde97fe6baa35189e51115716865ce377ec2` 不变。

### 范围与完整性

- 基线 `e7d4c7316fca3fe0e852866f4e611cb4f2fa0764`（v8.0.34），候选 `ae3ee3be303fb07fb8173279923413005bf32177`（v8.0.35），官方 tag 再次解析一致。
- [完整比较](https://github.com/router-for-me/CLIProxyAPI/compare/e7d4c7316fca3fe0e852866f4e611cb4f2fa0764...ae3ee3be303fb07fb8173279923413005bf32177)：6 个提交、32 个变更文件，diff 3,965 行、161,981 字节。两端未截断递归树、compare 文件集合和 diff 节一致，hunk 行数已校验。全部生产、文档及测试差异分段静态阅读，敏感上下文按候选 tree 校验 Git blob。
- go.mod/go.sum 未变；没有依赖新增、升级或来源变更，无构建脚本、二进制、LFS、子模块或特殊文件模式变化。

### 敏感路径与证据

- [SIWC 管理流程](https://github.com/router-for-me/CLIProxyAPI/blob/ae3ee3be303fb07fb8173279923413005bf32177/internal/api/handlers/management/oauth_siwc.go)、[路由](https://github.com/router-for-me/CLIProxyAPI/blob/ae3ee3be303fb07fb8173279923413005bf32177/internal/api/server_management_v8.go)：发起绑定要求既有管理鉴权，Home 模式禁用；只能选择服务器管理的本地 Codex OAuth 文件。回调仅挂可用性中间件，依赖随机 state、服务端 PKCE 和会话目标，不要求管理 Key；不应描述为所有回调都经管理鉴权。回调 URL 仅解析、不抓取，也不启动监听；目标、redirect、设备 ID 和 PKCE 不能由回调重定向。
- [OAuth 交换](https://github.com/router-for-me/CLIProxyAPI/blob/ae3ee3be303fb07fb8173279923413005bf32177/internal/auth/codex/siwc_auth.go)：授权 URL 为 `https://auth.openai.com/api/accounts/authorize`，code、issued client ID、PKCE verifier、固定 redirect/resource POST 到 `https://auth.openai.com/api/accounts/oauth/token`。沿已有配置代理及标准 HTTP 客户端，不保证禁止重定向；没有向额外隐藏地址发送外层凭据。错误响应对管理端使用固定消息，不回传上游正文/token。
- [凭据提交](https://github.com/router-for-me/CLIProxyAPI/blob/ae3ee3be303fb07fb8173279923413005bf32177/sdk/cliproxy/auth/codex_siwc_bind.go)、[原子写入](https://github.com/router-for-me/CLIProxyAPI/blob/ae3ee3be303fb07fb8173279923413005bf32177/internal/auth/codex/token.go)：重验 auth-dir 归属、常规文件、注册 epoch 和外层账号，读取最新文件，仅替换 siwc 分区及 use_siwc；同目录临时文件显式 0600 后 rename，失败清理自身临时文件。v8 上传/删除和取消协调提交，不增加无关删除。成功后沿既有 manager/运行时模型注册 hook 发布；插件仍属高信任边界，不声称凭据完全不会进入既有 hook。
- [搜索结果缓存](https://github.com/router-for-me/CLIProxyAPI/blob/ae3ee3be303fb07fb8173279923413005bf32177/internal/cache/claude_web_search_result_cache.go)：已有可选缓存在 Home 模式改用配置 Home KV，原始搜索结果 content 通过 SET 发送，索引为会话和 tool-use ID 的 SHA256，不是内容脱敏。GET 后 EXPIRE 滑动续期，默认24小时；Home 分支不应用本地 LRU 条数上限，也不回退到本地。补查 Home commandClient/地址构造，连接配置 host/port，TLS 依配置；没有新增硬编码隐藏接收方。非 Home 仍是本地缓存，不抓取搜索结果 URL。
- [压缩共享实现](https://github.com/router-for-me/CLIProxyAPI/blob/ae3ee3be303fb07fb8173279923413005bf32177/internal/runtime/executor/helps/antigravity_compaction.go)：Kimi/Meta 显式 compaction_trigger 生成摘要请求，沿当前凭据和既有 provider URL；默认分别为 api.kimi.com 或 api.kimi.ai 的 coding/v1/responses、api.meta.ai/v1/responses，也可使用配置 base_url。摘要 capsule 沿既有固定密钥 AES-GCM 封装并返回请求方，重放转换为 developer 文本；不把固定密钥封装当保密保证，不执行其文本。无独立下载执行或额外后台资源任务。
- Gin 日志移除 v8 OAuth 查询串，不代表其他日志/正文全面脱敏；Gemini schema 仅移除 readOnly/writeOnly 注解。全部测试差异为静态审阅：本地 httptest、合成 token、临时文件/符号链接及模拟 KV；未执行测试，未用 mock、断言或 CI 结果替代生产敏感链证据。

未安装、构建或执行上游代码/制品，未运行测试或扫描。结论仅覆盖本次增量恶意行为，不作漏洞、功能或性能判定；通过后的授权 CI 构建不作为审查证据，不部署或重启。

## CLIProxyAPI v8.0.34 增量审查

结论：**通过**。Keeper 最新正式版仍为 v2.0.0，tag SHA `fc8cbde97fe6baa35189e51115716865ce377ec2` 未变，结论为 **无新版**。

### 范围与完整性

- 基线：`2422c6b0f5fe16495320fa29456493874c1977a0`（v8.0.33）；候选：`e7d4c7316fca3fe0e852866f4e611cb4f2fa0764`（v8.0.34）。官方 tag 直接指向该完整 commit，更新前再次核对一致。
- [官方比较](https://github.com/router-for-me/CLIProxyAPI/compare/2422c6b0f5fe16495320fa29456493874c1977a0...e7d4c7316fca3fe0e852866f4e611cb4f2fa0764)：28 个提交、127 个变更文件；完整 diff 14,522 行、629,935 字节。两端未截断递归树、compare 文件集合及 diff 节一致，全部 hunk 行数完整。分 46、33、48 文件三组逐文件静态审阅，并补查直接敏感调用链；下载上下文均按候选 tree 验证 Git blob。
- `go.mod`、`go.sum` 未变，无依赖新增、升级或来源变化；无发布脚本、基础镜像、二进制、LFS、子模块或特殊模式变化。

### 敏感路径与证据

- [Vertex 执行器](https://github.com/router-for-me/CLIProxyAPI/blob/e7d4c7316fca3fe0e852866f4e611cb4f2fa0764/internal/runtime/executor/gemini_vertex_executor.go)及 [URL 构造](https://github.com/router-for-me/CLIProxyAPI/blob/e7d4c7316fca3fe0e852866f4e611cb4f2fa0764/internal/runtime/executor/helps/vertex_openapi.go)：新增 OpenAPI 模型路由，服务账户经既有 Google OAuth 库取得 access token，再以 Bearer 交给兼容执行器的 `/chat/completions`。默认 Google 全局或区域端点，显式 base_url 可改变接收方；API key 路径不交换 token。补查 NormalizeServiceAccountMap 只规范化私钥并保留 token_uri 等字段，不是秘密脱敏，也不把 token 接收方限定为 Google。没有新增隐藏目标或私钥直接拼入模型请求。
- [搜索结果缓存](https://github.com/router-for-me/CLIProxyAPI/blob/e7d4c7316fca3fe0e852866f4e611cb4f2fa0764/internal/cache/claude_web_search_result_cache.go)及 [读写辅助](https://github.com/router-for-me/CLIProxyAPI/blob/e7d4c7316fca3fe0e852866f4e611cb4f2fa0764/internal/runtime/executor/helps/claude_web_search_results.go)：默认关闭，启用且 Responses 来源时缓存 Claude 返回的原始搜索结果 content。进程内 map/LRU，默认 24 小时、1024 条，读取续期；条目数限制不等于总字节上限。会话及 tool-use ID 派生索引，非 execution scope 结合调用方 key 摘要；补查内部 execution metadata 赋值和发送路径。仅恢复 assistant 缺失内容后参与正常上游请求/计数，不抓取结果 URL、不写远端缓存。原生 Claude SSE 直通分支并非均执行缓存写入。
- [Antigravity 额度刷新](https://github.com/router-for-me/CLIProxyAPI/blob/e7d4c7316fca3fe0e852866f4e611cb4f2fa0764/internal/runtime/executor/antigravity_executor_credits.go)：调整过期提示和刷新调度，沿既有配置 base_url 或 `https://cloudcode-pa.googleapis.com/v1internal:loadCodeAssist` POST，Bearer 携带 access token，正文 metadata.ideType=ANTIGRAVITY。Home KV 存额度/锁/冷却状态而非该 token；trace 包装原 transport，仅记录主机、操作及连接信息，不另发请求。不将既有启用 credits 的请求描述成永不消费额度。
- [图片 handler](https://github.com/router-for-me/CLIProxyAPI/blob/e7d4c7316fca3fe0e852866f4e611cb4f2fa0764/sdk/api/handlers/openai/openai_images_handlers.go)：模型别名/前缀用于选择既有 manager/provider；补查图片专用入口、xAI Execute 分支、xaiImageEndpointPath、xaiChatBaseURL 和 executeImages。xAI POST 路径为 `/images/generations` 或 `/images/edits`，Bearer 发往配置地址，默认 API 模式 `https://api.x.ai/v1`、OAuth 模式 `https://cli-chat-proxy.grok.com/v1`。没有模型名派生的隐藏接收者；插件路线仍为既有高信任执行边界，普通客户端保留既有重定向行为。
- [请求日志](https://github.com/router-for-me/CLIProxyAPI/blob/e7d4c7316fca3fe0e852866f4e611cb4f2fa0764/internal/runtime/executor/helps/logging_helpers.go)：沿既有日志路径处理 URL、headers、body、身份及响应。关闭 RequestLog 仍可能保存延迟日志闭包及最多 32 MiB body；URL、body、label、非 API key AuthValue 和错误并非统一脱敏。自定义 header 可覆盖认证头和 Host，不修改 req.URL；这些既有边界不因新路由消失，也未发现额外日志接收方。
- 签名/路由后缀及 schema 改动只进行 JSON、Base64、字符串和本地引用转换，未执行解码载荷或远程 schema。Codex 历史搜索工具声明交给上游，不是在代理内执行网页工具。watcher 变动保留不完整认证文件对应的内存状态；管理 Modify 沿既有持久化/钩子，未新增文件破坏或秘密接收者。插件锁调整未新增插件来源。
- 全部测试差异静态审阅，临时凭据文件截断/删除指向测试目录；工具名 exec/bash 与命令字符串是协议夹具，不构成命令执行。补查 Home 客户端仅连接回环模拟 RESP 服务，Vertex 私钥当场随机生成、token URI 指向测试服务，专用 transport 将 Google 请求改投本地。未以 mock 空实现、断言或测试结果代替生产发送链证据，未运行测试。

未安装、构建或执行上游代码及发布产物，未运行测试或扫描。结论仅覆盖固定增量的恶意行为，不作漏洞、功能或性能判定，不递归认证未变化依赖及基础设施。通过后的授权 CI 构建不是审查证据；直接更新并发布镜像，不部署或重启。

## CPA Usage Keeper v2.0.0 增量审查

结论：**通过**。用户在了解 `version.txt` 自动请求的地址、数据边界和不执行行为后，明确接受并授权升级。CLIProxyAPI 保持 v8.0.33，本轮不修改其 pin。

### 范围与完整性

- 基线：`71a41cc2d1cce8d75b42473adf31f2616ad8085e`（v1.15.11）；候选：`fc8cbde97fe6baa35189e51115716865ce377ec2`（v2.0.0）。更新前重新核对官方 tag，直接指向该完整 commit。
- [官方比较](https://github.com/Willxup/cpa-usage-keeper/compare/71a41cc2d1cce8d75b42473adf31f2616ad8085e...fc8cbde97fe6baa35189e51115716865ce377ec2)：166 个提交，完整 diff 为 85,781 行、3,984,638 字节。compare JSON 达到 300 文件上限，未将它视为完整清单；两棵未截断递归树核对出 646 个变化路径，644 个 diff 节包含两处重命名，覆盖全部路径并校验全部 hunk 行数。
- 八个分区逐文件静态检查全部差异，随后补查存储、网络、接口发布链及目录解析上下文，并按候选 tree 校验所下载源码的 Git blob。跨区调用证据已合并；没有将测试断言或 CI 当作实现证据。
- `go.mod` 仅将既有 `golang.org/x/text v0.20.0` 改为 indirect；`go.sum`、前端清单和锁文件无变更。无新增或升级模块。发布策略复用既有 `actions/checkout@v6`；不递归认证未变化的 Actions、依赖或外部 Homebrew tap。唯一二进制差异为删除旧 `avatar-catalog.webp`，无新增/修改二进制、LFS、子模块或特殊模式变化。

### 敏感路径与证据

- [版本附件客户端](https://github.com/Willxup/cpa-usage-keeper/blob/fc8cbde97fe6baa35189e51115716865ce377ec2/internal/releasecheck/client.go)、[持久化重试](https://github.com/Willxup/cpa-usage-keeper/blob/fc8cbde97fe6baa35189e51115716865ce377ec2/internal/releasecheck/runner.go)、[启动装配](https://github.com/Willxup/cpa-usage-keeper/blob/fc8cbde97fe6baa35189e51115716865ce377ec2/internal/app/app.go)：就绪后后台 GET `https://github.com/Willxup/cpa-usage-keeper/releases/download/<version>/version.txt`。仅匹配正式 v2.x.y；空请求体、无应用鉴权或业务字段，默认客户端无 Cookie Jar，可标准重定向。最多读 1025 字节，要求不超过 1024 字节且文本等于当前版本，然后丢弃；不落盘、安装或执行。失败间隔六小时、每版本最多五次，状态保存本地。接收方可观察出口 IP、版本及时间，不把它描述为查询最新版本。用户已明确接受该行为，不据此认定恶意。
- [CPA 客户端](https://github.com/Willxup/cpa-usage-keeper/blob/fc8cbde97fe6baa35189e51115716865ce377ec2/internal/cpa/client.go)：管理 Key 仍发往配置 CPA；v8 凭据/供应商配置调用读取或写回完整凭据列表，不声称数据已全部脱敏。Redis 对配置或 CPA 推导地址 AUTH，订阅 usage/errors 或 LPOP usage/queue，后者真实消费队列消息。未发现额外秘密收集端点、任意 Redis 命令或下载执行链。
- [价格目录](https://github.com/Willxup/cpa-usage-keeper/blob/fc8cbde97fe6baa35189e51115716865ce377ec2/internal/pricingmetadata/client.go)：显式管理员拉取后 GET `https://models.dev/api.json` 或 `https://raw.githubusercontent.com/BerriAI/litellm/main/model_prices_and_context_window.json`，仅加 Accept JSON、不上传本地模型/凭据；普通客户端允许重定向。响应作为 JSON 价格数据解析，定价编译为固定条件和数值计算，不执行脚本。
- [路由权限](https://github.com/Willxup/cpa-usage-keeper/blob/fc8cbde97fe6baa35189e51115716865ce377ec2/internal/api/router.go)、[重算服务](https://github.com/Willxup/cpa-usage-keeper/blob/fc8cbde97fe6baa35189e51115716865ce377ec2/internal/service/pricing_recalculation.go)：价格保存/删除、同步应用、重算及凭证操作挂管理员组，认证关闭时按配置放行。重算由明确请求受理，固定热事件 ID 上限和时间范围，暂停相关消费/读取后分批更新费用及汇总；已提交批次不承诺整体回滚。前端关闭不取消已受理任务。额度查询仍经 CPA 代理到供应商，消费 reset 权益与普通刷新分开，通过确认后的管理操作触发。
- [备份](https://github.com/Willxup/cpa-usage-keeper/blob/fc8cbde97fe6baa35189e51115716865ce377ec2/internal/backup/backup.go)、[旧库保护](https://github.com/Willxup/cpa-usage-keeper/blob/fc8cbde97fe6baa35189e51115716865ce377ec2/internal/repository/pricing_legacy_protection.go)、[迁移](https://github.com/Willxup/cpa-usage-keeper/blob/fc8cbde97fe6baa35189e51115716865ce377ec2/internal/repository/migration/migration.go)：整库备份含既有凭据与原始数据，写配置 BackupDir 的日期目录，不上传；保留期清理会 RemoveAll 过期日期目录的全部内容，不只是数据库文件。首次旧库流程先备份和哈希绑定再迁移。固定迁移包含废弃排名表/列/设置删除、Overview 清空重建及既有历史表重整；不是无破坏性升级，也不承诺自动恢复。失败路径输出人工恢复说明，不自动覆盖数据库。
- [前端 API](https://github.com/Willxup/cpa-usage-keeper/blob/fc8cbde97fe6baa35189e51115716865ce377ec2/web/src/lib/api.ts)：所示请求指向部署 BasePath 下的 Keeper API，携带会话；嵌入就绪通知仅发送固定 type，不带密钥。管理员 Key 设置接口可返回完整 Key，日志下载和用量导出返回请求方，不能宣称所有输出已脱敏。可选上游响应记录可能包含账号信息，日志默认 stderr 或配置本地文件，保留已有 hook 边界。
- [发布工作流](https://github.com/Willxup/cpa-usage-keeper/blob/fc8cbde97fe6baa35189e51115716865ce377ec2/.github/workflows/binary-release.yml)：正式制品到当前仓库 Release，容器到对应 GHCR；Homebrew token 仅用于指定 tap，修改选定 formula 版本、官方 URL 和校验值。打包未加入实际 .env、数据库或用户凭据。基准工具可显式启动指定程序/systemd 单元并删除自身数据库副本，测试含临时库删表、子测试强杀及真实启动调用，不描述为全部无副作用；均未执行。

未安装、构建或执行上游代码及发布产物，未运行测试或扫描。审查仅覆盖固定提交的增量恶意行为，不作功能、漏洞或性能结论。通过后更新 pin 并由授权 CI 构建发布；CI 不是静态审查证据，不部署或重启服务。

## CLIProxyAPI v8.0.33 增量审查

结论：**通过**。Keeper 最新正式版仍为 v1.15.11，tag SHA `71a41cc2d1cce8d75b42473adf31f2616ad8085e` 未变，结论为 **无新版**。

### 范围与完整性

- 基线：`911f49cbd49f4fe2516979754a7488a3fd14fe64`（v8.0.32）；候选：`2422c6b0f5fe16495320fa29456493874c1977a0`（v8.0.33）。官方 tag ref 直接指向该完整 commit。
- [官方完整比较](https://github.com/router-for-me/CLIProxyAPI/compare/911f49cbd49f4fe2516979754a7488a3fd14fe64...2422c6b0f5fe16495320fa29456493874c1977a0) 包含 25 个提交、90 个变更文件，分三组（28、33、29 项）逐文件阅读全部差异，并补查敏感上下文。两端未截断 recursive git tree 的变更集合与 compare、完整 diff 一致，全部 hunk 行数完整；三组报告覆盖全部文件，补取源码的 Git blob SHA 与候选 tree 一致。
- `go.mod`、`go.sum` 未变，没有依赖新增、升级或来源变更，没有安装脚本、基础镜像、二进制、LFS、子模块或特殊文件模式变化。

### 敏感路径与证据

- [mDNS 发现实现](https://github.com/router-for-me/CLIProxyAPI/blob/2422c6b0f5fe16495320fa29456493874c1977a0/internal/discovery/zeroconf.go)：替换服务公告和主机响应实现，新增 UDP 5353 监听、冲突探测、重命名及 goodbye。组播发往 `224.0.0.251:5353`、`[ff02::fb]:5353`，单播回复报文源 IP/端口，不能声称所有接收方都经过严格同网段校验。传播主机名、接口地址、实例、端口及 TXT 元数据；补查 `BuildServiceSpec`、`BuildTXTRecords`，标准路径只构造路由、认证方式标记及实例信息，没有采集 API key。调用方自供 TXT 不等于经过秘密过滤。探测每候选三次、最多八个候选，公告重复两次；未发现命令分发、下载执行或独立恶意资源任务。
- [Antigravity SDK 入口](https://github.com/router-for-me/CLIProxyAPI/blob/2422c6b0f5fe16495320fa29456493874c1977a0/sdk/auth/antigravity.go)：新增包装函数显式启动既有版本刷新。补查两端 blob 未变的 [antigravity_version.go](https://github.com/router-for-me/CLIProxyAPI/blob/2422c6b0f5fe16495320fa29456493874c1977a0/internal/misc/antigravity_version.go)，由 sync.Once 启动，立即查询后每三小时刷新，context 取消退出。GET 固定 `https://antigravity-hub-auto-updater-974169037036.us-central1.run.app/manifest/latest-arm64-mac.yml`，空正文及固定 UA，无凭据或聊天内容；标准客户端仍可按既有规则重定向。最多读取 4096 字节，仅取 YAML version 并验证三段数字，写入内存缓存、日志及 UA，无程序下载、落盘安装或执行。
- [认证快照](https://github.com/router-for-me/CLIProxyAPI/blob/2422c6b0f5fe16495320fa29456493874c1977a0/sdk/cliproxy/auth/types.go)：绑定源文件路径及规范化 JSON 的 SHA-256，提交前通过 os.ReadFile 比较；路径及摘要字段不参与 JSON 序列化，没有新增文件破坏或外传。管理上传／字段更新增加 excluded_models 类型校验，更新进入既有凭据保存路径；排除规则、快照 fence 与配置摘要变化处理模型发布状态，没有新增认证绕过。
- [插件与模型发布](https://github.com/router-for-me/CLIProxyAPI/blob/2422c6b0f5fe16495320fa29456493874c1977a0/sdk/cliproxy/service_executors.go)：原始凭据仍可交给既有插件，插件返回的认证更新进入 Manager；发布被替代后最多再次注册一次，并可能再次进入既有探测路径，不声称没有秘密传播。日志新增认证 ID、provider、模型数量及错误；未新增秘密接收方或插件下载来源。目录归属、路径 ID 规范化和 DisableType 元数据变化没有新增执行权限。
- [流式错误处理](https://github.com/router-for-me/CLIProxyAPI/blob/2422c6b0f5fe16495320fa29456493874c1977a0/internal/runtime/executor/claude_executor_stream.go)：完整上游错误 JSON 可进入既有日志、错误包装和 usage/plugin 链，其他执行器新增截断失败记录；不保证错误文本不含敏感信息。没有新增目的地址或认证数据采集。Meta 订阅事件及客户端转发过滤不代表原始日志也被清除。thinking、rate-limit 和 schema 改动为请求参数及响应数据转换，不在代理内执行工具或解码下载载荷。
- 所有测试差异均静态审阅：多数使用本地 httptest、内存 transport、合成凭据及 t.TempDir；mDNS 测试确有真实局域网组播／单播及接口地址传播，不能称为全部离线。测试删除限于所建临时认证文件，未发现真实凭据收集或无关目录破坏。本次没有执行测试。
- 三种语言 README 新增 Hermes 插件仓库、目录链接及显式安装命令，不是构建依赖或自动安装步骤；不认证外链插件及其未来内容。

未安装、构建或执行上游代码或发布产物，未运行测试或漏洞扫描；通过后的授权 CI 构建不作为审查证据。结论仅覆盖上述固定提交的增量恶意代码/依赖审查，不递归认证未变化的基础设施或外部插件，不作功能或漏洞判定。按约定直接更新、commit、push 并跟踪触发的 CI，不部署或重启服务。

## CLIProxyAPI v8.0.32 增量审查

结论：**通过**。Keeper 最新正式版仍为 v1.15.11，tag SHA `71a41cc2d1cce8d75b42473adf31f2616ad8085e` 未变，结论为 **无新版**。

### 范围与完整性

- 基线：`355fd10e76b82e03ba6625acc583b900286e4bf2`（v8.0.31）；候选：`911f49cbd49f4fe2516979754a7488a3fd14fe64`（v8.0.32）。官方 tag ref 直接指向该完整 commit。
- [官方完整比较](https://github.com/router-for-me/CLIProxyAPI/compare/355fd10e76b82e03ba6625acc583b900286e4bf2...911f49cbd49f4fe2516979754a7488a3fd14fe64) 包含 6 个提交、42 个变更文件；分为生产及文档 29 项、测试源码 13 项，逐文件阅读全部差异，另补查敏感调用链。两端未截断 recursive git tree 的变更集合与 compare、完整 diff 一致，全部 hunk 行数完整；两组报告逐文件覆盖全部 42 项，补取源码的 Git blob SHA 与候选 tree 一致。
- `go.mod`、`go.sum` 未变，没有新增、升级或来源变更的依赖、安装脚本或基础镜像变化，无 LFS、子模块或特殊文件模式变化。唯一二进制变化为下述静态图片。

### 敏感路径与证据

- [Devin 配额刷新](https://github.com/router-for-me/CLIProxyAPI/blob/911f49cbd49f4fe2516979754a7488a3fd14fe64/sdk/cliproxy/auth/conductor_refresh.go)：日／周额度耗尽增加凭据级冷却及定时复查，刷新观测用于解除相应冷却，保留独立模型限制。补查执行器 `Refresh` 及未变化的 [FetchUserStatus](https://github.com/router-for-me/CLIProxyAPI/blob/911f49cbd49f4fe2516979754a7488a3fd14fe64/internal/auth/devin/user_status.go)：仍向默认 `https://server.codeium.com` 或凭据显式配置的 `base_url` 请求固定 GetUserStatus 路径。会话令牌进入 Basic 头和 protobuf，并携带既有客户端信息、系统类型及设备指纹；不是不发送凭据，但未新增秘密接收方或聊天内容上传。
- [冷却持久化](https://github.com/router-for-me/CLIProxyAPI/blob/911f49cbd49f4fe2516979754a7488a3fd14fe64/sdk/cliproxy/auth/conductor_cooldown.go)：新增独立模型状态副本及传播标志，通过已有 `CooldownStateStore.Save` 保存。接收方仍为配置注入的 store，没有自建远端地址。记录包含凭据标识、模型、期限及错误，错误文本可能包含已有敏感数据；不声称存储仅在本地或记录不含敏感信息。
- [Claude 请求处理](https://github.com/router-for-me/CLIProxyAPI/blob/911f49cbd49f4fe2516979754a7488a3fd14fe64/internal/runtime/executor/claude_executor_request.go)：thinking binding 在模型、显式 thinking 模式及已签名历史等条件满足时补入 `drop_block`，保留调用方已有设置；beta header 沿用既有处理与配置覆盖。没有新增认证绕过、签名伪造或网络目的地。会话日期保留配置、默认值及 diagnostics map 清理处理进程内日期状态；没有新增文件删除、下载或执行载荷。
- [工具参数清理](https://github.com/router-for-me/CLIProxyAPI/blob/911f49cbd49f4fe2516979754a7488a3fd14fe64/internal/util/translator.go)：名称消歧、无参数对象、占位字段、组合 schema 与参数片段处理均为 JSON 数据转换。补查未变化的 `gemini_schema.go`，只展开本地 `#/` 引用，未解析或外部引用转为描述并清除，不下载远程 schema，也不执行工具。Meta 终止事件变化沿用既有响应及用量路径，没有新增接收方。
- [赞助图片](https://github.com/router-for-me/CLIProxyAPI/blob/911f49cbd49f4fe2516979754a7488a3fd14fe64/assets/kedaya.jpg)：50,663 字节，Git blob `72b8ec2667b065f7f8751c74d42d5461c927a76c` 与候选 tree 一致。静态解析 JPEG 标记及段边界，648×648、8-bit、三通道 baseline JPEG，仅 JFIF APP0 元数据，无注释或其他 APP 段、无 EOI 后尾随数据；显示内容为卡通头像。README 中为显式注册链接和本地图片引用，无脚本或凭据拼接。本次不认证外链站点、像素隐写或解码器安全。
- 13 个测试文件全部差异已作恶意代码静态阅读。新增请求捕获与断连测试使用本机 httptest、固定模拟 key，配置写入使用 t.TempDir；签名及命令字符串作为协议样例，不作为程序执行。冷却恢复测试使用内存状态及序列化；未发现真实凭据收集、隐藏下载执行或无关文件破坏。

未安装、构建或执行上游代码或发布产物，未运行测试或漏洞扫描；通过后的授权 CI 构建不作为审查证据。结论仅覆盖上述固定提交的增量恶意代码/依赖审查，不递归认证未变化的基础设施、外部插件或未来动态内容，也不作功能或漏洞判定。按约定更新 pin、文档并直接 commit、push，跟踪触发的 CI，不部署或重启服务。

## CLIProxyAPI v8.0.31 增量审查

结论：**通过**。Keeper 最新正式版仍为 v1.15.11，tag SHA `71a41cc2d1cce8d75b42473adf31f2616ad8085e` 未变，结论为 **无新版**。

### 范围与完整性

- 基线：`0d18d3b365be000eeaee7de4615f9da596b2059d`（v8.0.28）；候选：`355fd10e76b82e03ba6625acc583b900286e4bf2`（v8.0.31）。官方 tag ref 直接指向该完整 commit。
- [官方完整比较](https://github.com/router-for-me/CLIProxyAPI/compare/0d18d3b365be000eeaee7de4615f9da596b2059d...355fd10e76b82e03ba6625acc583b900286e4bf2) 包含 28 个提交、127 个变更文件；按大小分为四组（31、32、32、32 个文件）逐文件静态阅读全部差异，并补查跨组敏感调用及候选完整源码。两端未截断 recursive git tree 的变更集合与完整 diff 一致，全部 hunk 行数完整；报告逐文件覆盖集合核对通过，补取源码的 Git blob SHA 与官方 tree 一致。
- 根 `go.mod`、`go.sum` 未变。唯一新增模块清单 `internal/pluginhost/testdata/loader_unix_reload_plugin/go.mod` 只有模块名和 Go 1.26 声明，没有第三方依赖、replace 或安装脚本。没有依赖升级或来源变更、基础镜像、二进制、LFS、子模块或特殊文件模式变化。

### 敏感路径与证据

- [插件影子副本](https://github.com/router-for-me/CLIProxyAPI/blob/355fd10e76b82e03ba6625acc583b900286e4bf2/internal/pluginhost/shadow.go)：从既有配置插件目录选出的本地动态库复制到系统临时目录下 `cliproxy-pluginhost/pid-<PID>`，按内容摘要命名。补查 `platform.go`、`config.go` 和宿主加载入口：文件 ID 经过字符规则校验，插件需配置启用，没有新增下载来源。清理会实际删除当前目录中的匹配副本，以及确认进程不存在的旧 PID 目录；Unix 用信号 0 探测，Windows 用进程等待状态探测，Windows 删除失败可安排重启时删除。不是无文件副作用，但未发现无关目录清除或杀进程载荷。
- [Unix 加载器](https://github.com/router-for-me/CLIProxyAPI/blob/355fd10e76b82e03ba6625acc583b900286e4bf2/internal/pluginhost/loader_unix.go) 与 Windows 加载器改为保留已映射动态库及回调上下文到进程结束，包括初始化失败后的部分路径。逻辑关闭仍调用插件 shutdown，清空调用入口并删除宿主回调登记；补查 Windows 回调入口，未登记 ID 返回失败。**逻辑卸载不等于移除驻留插件代码或停止任意插件线程**。未发现内置恶意插件或隐蔽载荷，不为外部插件二进制背书，也不将映射保留声称为无资源影响。
- [配置上传预处理](https://github.com/router-for-me/CLIProxyAPI/blob/355fd10e76b82e03ba6625acc583b900286e4bf2/internal/config/config_load.go)：种子配置上传到既有 Git/S3/PostgreSQL 后端前，在本地将有效管理密钥转为 bcrypt，并检查清理后是否仍保留明文标量。失败时 Git 启动入口删除刚复制的种子配置；没有新增远端接收方或无关文件删除。ETag、来源哈希、配置修改锁与重载顺序变化沿用当前配置路径；管理认证未被此次变化放开。
- [单文件认证快照](https://github.com/router-for-me/CLIProxyAPI/blob/355fd10e76b82e03ba6625acc583b900286e4bf2/internal/watcher/auth_file_snapshot.go)：整文件删除事件处理前重新检查既有认证来源路径，调用现有合成器和已配置插件解析器。补查 `SynthesizeAuthFile`、`ParseAuths`、`callParseAuths`：原始凭据 JSON 会交给既有活动 AuthProvider，不能称为不传递秘密；本次未增加隐藏接收方。认证与模型发布的 registration/generation/epoch 条件检查仅控制既有内存状态更新及回调，没有新增特殊账号或授权后门。
- [翻译错误处理](https://github.com/router-for-me/CLIProxyAPI/blob/355fd10e76b82e03ba6625acc583b900286e4bf2/internal/runtime/executor/helps/apply_patch.go)：提取 Claude 错误 JSON，向当前响应及既有用量记录路径传播。补查失败报告和缓冲用量函数，未增加上传目标；文件名中的 apply_patch 不代表在代理内执行补丁。SIWC configuration_update、Schema、工具 ID 与模型目录变更均处理协议数据；Claude beta、请求 ID 与诊断开关作用于既有请求，没有新收集端点。TLS 变化为握手超时及错误分类，生产构造未注入测试根证书或新目的地。
- 测试文件及新增 C/Go 插件源码均已静态审阅。插件测试包含显式 `go build -buildmode=c-shared` 与加载测试产物，测试插件仅返回标记及关闭计数；没有执行本次测试。补查 Vertex 模拟凭据和 transport：密钥为测试生成，目标重写为传入的本地测试服务。目录删除、权限修改和测试子进程关闭限于所示测试资源，未发现恶意执行或真实凭据收集。

未安装、构建或执行上游代码或发布产物，未运行测试或漏洞扫描；通过后的授权 CI 构建不作为审查证据。结论仅覆盖上述固定提交的增量恶意代码/依赖审查，不是功能、漏洞或外部插件认证。按约定更新 pin、文档并直接 commit、push，跟踪触发的 CI，不部署或重启服务。

## CLIProxyAPI v8.0.28 / Keeper v1.15.11 增量审查

两个组件结论均为 **通过**。在以下固定 SHA 区间的完整差异及直接敏感上下文中，未发现有代码证据支持的恶意外传、后门、隐藏下载执行、恶意破坏或恶意依赖行为。

### 范围与完整性

- CLIProxyAPI：`bf9341629ef2300ac9d846a2e80fe2756f63a671`（v8.0.27）→ `0d18d3b365be000eeaee7de4615f9da596b2059d`（v8.0.28）；[官方完整比较](https://github.com/router-for-me/CLIProxyAPI/compare/bf9341629ef2300ac9d846a2e80fe2756f63a671...0d18d3b365be000eeaee7de4615f9da596b2059d)，28 个提交、85 个文件，按大小分三组（28、29、28 个文件）逐文件阅读全部变更。
- Keeper：`b3592bff1e342c246d1324bcd99ba9b77232f315`（v1.15.10）→ `71a41cc2d1cce8d75b42473adf31f2616ad8085e`（v1.15.11）；[官方完整比较](https://github.com/Willxup/cpa-usage-keeper/compare/b3592bff1e342c246d1324bcd99ba9b77232f315...71a41cc2d1cce8d75b42473adf31f2616ad8085e)，16 个提交、48 个文件，按大小分两组（23、25 个文件）逐文件阅读全部变更。
- 两个官方 tag ref 均直接指向上述完整 commit。两端未截断 recursive git tree 的变更集合与完整 diff 一致，全部 hunk 行数核对通过；没有二进制、LFS 指针、子模块或特殊文件模式变化。
- 两项目的依赖清单及锁文件 blob SHA 均未变化；没有依赖升级或来源变更、安装脚本或基础镜像变化。Keeper 新增 Fluent UI 图标为已完整审阅的内联静态 SVG path 与许可证文本，不引入包、远程加载或执行脚本。

### CLIProxyAPI 敏感路径

- [传输包装器](https://github.com/router-for-me/CLIProxyAPI/blob/0d18d3b365be000eeaee7de4615f9da596b2059d/sdk/httptransport/decorator.go)：通过 context 显式注入 Decorator，并在代理、uTLS、Devin、Antigravity 客户端选定 transport 后包装。无回调时返回原客户端；Antigravity 抑制中间包装并在完成 transport 配置后应用。该回调可以访问认证头、请求与响应正文，也可以改变传输行为；“只观察、必须委托”的注释不是强制约束。新增注册示例位于测试，生产改动提供注入、继承与应用接口，没有内置收集回调或新增目的地；外部 SDK 调用者提供的回调仍属于高信任代码，不在本次认证范围。
- [配置与宿主快照](https://github.com/router-for-me/CLIProxyAPI/blob/0d18d3b365be000eeaee7de4615f9da596b2059d/sdk/api/handlers/handlers.go)：配置、路由宿主和拦截器改用同步读取。补查 `Server.getConfig`、`CurrentConfig`、`ModelRouterHostSnapshot` 和 [CloneForRuntime](https://github.com/router-for-me/CLIProxyAPI/blob/0d18d3b365be000eeaee7de4615f9da596b2059d/internal/config/clone.go)，为加锁读取及内存克隆，没有替换秘密、放开管理认证或引入远端配置源。OAuth 回调仍调用既有 pending-session 文件写入入口。
- [插件模型注册](https://github.com/router-for-me/CLIProxyAPI/blob/0d18d3b365be000eeaee7de4615f9da596b2059d/sdk/cliproxy/service_executors.go)：补查 `tryRegisterPluginModelsForAuthWithConfig`，沿用既有 ModelsForAuth、认证更新及模型注册路径，将配置快照用于排除规则、别名和前缀。没有新增插件加载来源；既有插件可以接触凭据，不为外部插件背书。
- [Codex SSE 扫描器](https://github.com/router-for-me/CLIProxyAPI/blob/0d18d3b365be000eeaee7de4615f9da596b2059d/internal/runtime/executor/helps/codex_sse_scanner.go)：新增流事件解析、缓冲和诊断，接入既有响应记录回调，未新增上传或执行路径。工具搜索、Schema 规范化、Claude 工具名称还原和 Interactions ID 变化处理请求响应中的数据，不在代理内执行 Bash、MCP 工具或补丁。模型目录和 README 变化未新增执行载荷。

### Keeper 敏感路径

- [追踪元数据迁移](https://github.com/Willxup/cpa-usage-keeper/blob/71a41cc2d1cce8d75b42473adf31f2616ad8085e/internal/repository/migration/20261008_usage_event_trace_metadata.go)：为已有事件表与归档表幂等新增 execution_id、trace_id、node_kind、is_fork、is_compaction。Redis 解码将这些字段写入既有实体，归档复制列表同步扩展；没有新增删表、历史数据扫描上传或外部接收方。
- [剪贴板](https://github.com/Willxup/cpa-usage-keeper/blob/71a41cc2d1cce8d75b42473adf31f2616ad8085e/web/src/utils/clipboard.ts)：日志与 User-Agent 的复制由界面交互触发，使用 clipboard.writeText，失败后通过临时 textarea 和浏览器 execCommand('copy') 回退并清理节点；不是 shell 执行，不读取剪贴板或发送日志到网络。
- xAI 配额明细、缓存刷新状态、请求元数据浮层、图表和本地化为现有数据处理及界面交互变化；未发现隐藏外传、恶意指令或新增远程执行。Responses total-only 修改限定于数值归一化。
- 补查 [用量测试数据库](https://github.com/Willxup/cpa-usage-keeper/blob/71a41cc2d1cce8d75b42473adf31f2616ad8085e/internal/service/test/usage_fixtures_test.go)、迁移与配额测试辅助函数，数据库目标为 t.TempDir 下 SQLite。新增迁移测试的删除限定于隔离库的迁移记录；补查 `ProcessRedisUsageInbox` 及直接处理函数，沿用已落库消息解码、事务写入和既有统计通知，不因测试 BaseURL 新增请求。

未安装、构建或执行上游代码或发布产物，未运行测试或漏洞扫描。测试文件仅作恶意代码静态阅读；通过后的授权 CI 构建不作为审查证据。结论仅覆盖上述固定提交的增量，不保证功能正确性、外部插件或未来动态内容安全。按约定更新 pin、文档并直接 commit、push，跟踪两项 CI，不部署或重启服务。

## CLIProxyAPI v8.0.27 增量审查

结论：**通过**。Keeper 最新正式版仍为 v1.15.10，tag SHA `b3592bff1e342c246d1324bcd99ba9b77232f315` 未变，结论为 **无新版**。

- 基线：`a27799ec2b0cc5a60e49970d5467829ceaab8131`（v8.0.26）；候选：`bf9341629ef2300ac9d846a2e80fe2756f63a671`（v8.0.27）。官方 tag ref 直接指向该完整 commit。
- [完整比较](https://github.com/router-for-me/CLIProxyAPI/compare/a27799ec2b0cc5a60e49970d5467829ceaab8131...bf9341629ef2300ac9d846a2e80fe2756f63a671) 包含 3 个提交、20 个变更文件。逐文件审阅全部变更行；两端未截断 recursive git tree 的变更集合与官方完整 diff 一致，全部 hunk 行数完整。
- `go.mod`、`go.sum` blob SHA 均未变化；无新增或变更依赖、安装脚本、基础镜像、二进制、LFS 指针、子模块及特殊文件模式。未安装、构建、运行上游代码或产物，未运行测试或漏洞扫描；审查通过后的授权 CI 构建不作为审查证据。
- [配置和定时器](https://github.com/router-for-me/CLIProxyAPI/blob/bf9341629ef2300ac9d846a2e80fe2756f63a671/sdk/api/handlers/handlers.go)：新增默认关闭的 `send-keepalive-before-ft`，同时需要正数 keepalive 间隔才生效。定时器工厂及测试替换入口没有新增远程调用入口、载荷下载或执行行为。
- [启动包装器](https://github.com/router-for-me/CLIProxyAPI/blob/bf9341629ef2300ac9d846a2e80fe2756f63a671/sdk/api/handlers/stream_forwarder.go) 与 Claude、Gemini、Interactions、OpenAI Chat/Completions、Responses、Images 处理器：仍向既有 auth manager 传递原请求参数；启用后在等待启动或首 token 时向当前响应连接写入固定 `: keep-alive` SSE 注释，取消时传递取消信号并等待启动返回。未新增数据收集、网络目的地、认证绕过或隐蔽计算任务。
- 补查候选 [Responses 完整源码](https://github.com/router-for-me/CLIProxyAPI/blob/bf9341629ef2300ac9d846a2e80fe2756f63a671/sdk/api/handlers/openai/openai_responses_handlers.go) 中 `sanitizeResponsesInitialErrorMessage`、`sanitizeResponsesStreamErrorMessage`、`responsesStreamErrorText`、`logResponsesStreamError` 和 `forwardResponsesStream`：心跳提交后改走既有流式错误净化与当前客户端 SSE 输出；净化分支清除原始 Body 和 DirectResponse，使用既有错误文本处理与日志入口，没有新增秘密接收方。结论不递归认证未变化的执行器、日志及取消实现，也不作功能或漏洞判定。
- 七个测试文件的全部差异均已静态审阅，内容为内存模拟执行器、channel 定时协调、请求/响应断言及配置克隆样例；未发现恶意载荷。三种语言 README 仅增加 sub2api 展示链接，没有把外链项目变为构建依赖、下载或安装步骤；本次不为外链仓库背书。

结论限定上述固定提交的增量恶意代码/依赖审查。通过后按约定直接 commit、push 并跟踪 CI，不部署或重启服务。

## CLIProxyAPI v8.0.26 增量审查

结论：**通过**。Keeper 最新正式版仍为 v1.15.10，tag SHA `b3592bff1e342c246d1324bcd99ba9b77232f315` 未变，结论为 **无新版**。

- 基线：`091ff27f31285ec4fd1dd5823b44f7f51fb8f48b`（v8.0.24）；候选：`a27799ec2b0cc5a60e49970d5467829ceaab8131`（v8.0.26）。官方 tag ref 直接指向该完整 commit。
- [完整比较](https://github.com/router-for-me/CLIProxyAPI/compare/091ff27f31285ec4fd1dd5823b44f7f51fb8f48b...a27799ec2b0cc5a60e49970d5467829ceaab8131) 包含 14 个提交、113 个变更文件。分四组逐文件静态审阅（1、39、36、37 个文件），其中大型模型 JSON 单独覆盖全部 11 个差异块；另补查候选完整源码及跨组敏感调用链。两端未截断 recursive git tree 的变更集合与官方完整 diff 一致，全部 hunk 行数完整。
- `go.mod`、`go.sum` blob SHA 均未变化；无新增或变更依赖、安装脚本、基础镜像、二进制、LFS 指针、子模块及特殊文件模式。审查未安装、构建、执行上游代码或产物，未运行测试或漏洞扫描；通过后的授权 CI 构建不作为审查证据。
- [SIWC 授权](https://github.com/router-for-me/CLIProxyAPI/blob/a27799ec2b0cc5a60e49970d5467829ceaab8131/internal/auth/codex/siwc_auth.go) 与 [绑定入口](https://github.com/router-for-me/CLIProxyAPI/blob/a27799ec2b0cc5a60e49970d5467829ceaab8131/internal/cmd/siwc_bind.go)：由显式 `-siwc-bind` 命令触发，使用随机 state/nonce、PKCE 与回调 state 检查；令牌兑换和刷新默认发送到 `auth.openai.com`，API 默认到 `api.openai.com/v1`，未新增隐藏接收方。绑定目标解析真实路径并限定既有 auth-dir 中的 Codex 文件。后台刷新需要已有 SIWC refresh token/client ID，不会偷偷创建新授权；测试端点替换仅在测试中出现。
- [凭据写入](https://github.com/router-for-me/CLIProxyAPI/blob/a27799ec2b0cc5a60e49970d5467829ceaab8131/internal/auth/codex/token.go) 与 [公共持久化](https://github.com/router-for-me/CLIProxyAPI/blob/a27799ec2b0cc5a60e49970d5467829ceaab8131/sdk/cliproxy/auth/codex_persist.go)：以凭据对象对应路径、文件名或 auth-dir 定位文件，对 outer/SIWC 分区按 token 版本合并，使用同目录临时文件、0600 权限、重命名和进程间锁。Windows 新增系统 DLL 调用限于 LockFileEx/UnlockFileEx。删除限于自身临时文件；没有新增无关文件销毁、下载执行或存储上传目的地。
- [插件保存解析](https://github.com/router-for-me/CLIProxyAPI/blob/a27799ec2b0cc5a60e49970d5467829ceaab8131/internal/pluginhost/auth_callbacks.go)：凭据原始 JSON 会进入 ParseAuths，不能描述成不传递秘密。补查 [auth_provider.go](https://github.com/router-for-me/CLIProxyAPI/blob/a27799ec2b0cc5a60e49970d5467829ceaab8131/internal/pluginhost/auth_provider.go)（两端 blob 未变）：有 provider 时选对应已注册能力，无 provider 时在活动且未熔断的 AuthProvider 中尝试。未发现新增秘密插件或收集端点；既有插件仍属于高信任边界，不为外部插件二进制背书。
- [模型目录 JSON](https://github.com/router-for-me/CLIProxyAPI/blob/a27799ec2b0cc5a60e49970d5467829ceaab8131/internal/registry/models/codex_client_models.json)：包含模型容量、实验上下文、升级目标及 browser/Wallet 确认策略变化。补查嵌入加载、缓存与模板生成，确认相关提示词确实可能下发给客户端，不视为无效文本。新增策略承认连接器已取得的匹配批准，没有发现伪造批准、指定攻击者收款方、无批准支付或秘密数据披露指令；本结论不认证外部客户端及 Wallet 的实际授权执行。模型抓取仍使用既有 ChatGPT Codex endpoint，无新增下载执行链。
- 其余变化为请求体大小限制与 413 错误传播、凭据刷新调度、会话亲和性和配额目录、WebSocket 会话复用与按凭据清理。补查全局中间件及连接配置选择：未新增正文外传，既有连接沿用建立时配置，新连接使用当前配置，无隐蔽代理替换。测试变更使用内存对象、本地 HTTP/WebSocket 服务及临时目录，未发现恶意执行或真实凭据收集证据。

结论限定上述固定提交的增量恶意代码/依赖审查，不是功能或漏洞认证。通过后按约定直接 commit、push 并跟踪 CI，不部署或重启服务。

## CLIProxyAPI v8.0.24 增量审查

结论：**通过**。Keeper 最新正式版仍为 v1.15.10，tag 对应的完整 SHA 未变，结论为 **无新版**。

- 基线：`d318bcc3afb9ea8782862f5e8cdb541afdc9dfa5`（v8.0.23）；候选：`091ff27f31285ec4fd1dd5823b44f7f51fb8f48b`（v8.0.24）。官方 tag ref 直接指向该 commit。
- [完整比较](https://github.com/router-for-me/CLIProxyAPI/compare/d318bcc3afb9ea8782862f5e8cdb541afdc9dfa5...091ff27f31285ec4fd1dd5823b44f7f51fb8f48b) 含 31 个提交、97 个变更文件。完整文本差异分为四组逐文件审查（22、25、25、25 项，包含两个图片条目）；对用量信息、持久化与工具搜索再补查候选 SHA 的完整源码。两端未截断 recursive git tree 的变更集合与官方完整 diff 一致，全部文本 hunk 行数完整。
- `go.mod`、`go.sum` blob SHA 均未变化，无依赖新增、升级或来源变更；无构建、安装脚本或基础镜像变更，无 LFS 指针、子模块或特殊文件模式变更。未安装、构建、运行上游代码、产物、测试或漏洞扫描。
- [工具搜索转换](https://github.com/router-for-me/CLIProxyAPI/blob/091ff27f31285ec4fd1dd5823b44f7f51fb8f48b/internal/translator/claude/openai/responses/claude_openai-responses_tool_search.go)：新增显式配置与请求上下文开关、工具能力声明、调用/结果及命名空间转换，不支持时剥离相关字段。已补查 Claude 执行与 token 计数入口：转换处理客户端提供的工具和模型输出，不在服务端执行 shell 或工具，不新增请求目的地。测试中的 exec_command、命令字符串和 golden 均作为协议数据处理。
- [用量记录](https://github.com/router-for-me/CLIProxyAPI/blob/091ff27f31285ec4fd1dd5823b44f7f51fb8f48b/sdk/cliproxy/usage/manager.go)：新增认证来源/native 标记，并在记录缺失时从请求上下文补入客户端 API key。这确实扩大了明文客户端 key 的传播覆盖，不能称为脱敏。已追踪原生认证 principal、pluginhost adapter 与 [queue.go](https://github.com/router-for-me/CLIProxyAPI/blob/091ff27f31285ec4fd1dd5823b44f7f51fb8f48b/internal/redisqueue/queue.go)：记录交给现有注册插件，统计队列为进程内 buffer/channel，并非新增 Redis 外连；未发现新增隐藏收集地址。既有插件属于高信任执行边界，本结论不为用户加载的插件二进制或队列下游消费者背书。
- [Antigravity 能力缓存](https://github.com/router-for-me/CLIProxyAPI/blob/091ff27f31285ec4fd1dd5823b44f7f51fb8f48b/sdk/cliproxy/antigravity_models.go) 与 [元数据持久化](https://github.com/router-for-me/CLIProxyAPI/blob/091ff27f31285ec4fd1dd5823b44f7f51fb8f48b/sdk/cliproxy/auth/conductor_persistence.go)：保存模型 ID、项目、endpoint 等能力提示；保存路径会携带完整认证对象并覆盖 skip-persist 标记。补查后台队列、取消/版本边界及 Git/S3/PostgreSQL 完整存储实现，仍写入用户配置的既有后端，没有另建凭据外传目标。探测默认访问既有 Google endpoint，显式配置的 base URL 仍属于原有信任边界。
- 存储变化将 context 传到 Git 网络操作，并让对象/数据库存储在本地文件未变时继续完成远端保存；新增操作回调在可见测试中用于替身。既有 Git 恢复、历史重写和镜像清理有实际文件副作用，但本次未发现针对无关数据的新破坏路径。WebSocket 错误处理只调整连接关闭与内存断连通知顺序；其余请求转换、缓存控制、调用 ID 摘要、模型目录和冷却结果变化未发现恶意执行或外传证据。
- 二进制单独核验：`assets/aiberm.png` 仅删除；[新增 modelflare.png](https://github.com/router-for-me/CLIProxyAPI/blob/091ff27f31285ec4fd1dd5823b44f7f51fb8f48b/assets/modelflare.png) 原始字节的 Git blob SHA 为 `91bd54198dbc69656947135700ccad4cadf7f700`，与官方 tree 一致。PNG 为 2370×1200、8-bit RGBA；全部 chunk CRC 正确，仅含 IHDR/pHYs/sRGB/gAMA/tEXt/IDAT/IEND，文本为 `Software=Figma`，IEND 后无尾随数据；IDAT 解压长度与扫描行匹配，filter 字节有效，无额外压缩流。README 只以本地图片及显式赞助链接引用，没有下载执行链。此核验不声称排除像素隐写或认证任意图片解码器。

本结论限定固定提交间新增恶意行为及变更依赖审查，不是功能、漏洞或全量基础设施认证。通过后直接更新 pin、文档并创建本地 commit；不自动 push 或部署。

## CLIProxyAPI v8.0.23 增量审查

结论：**通过**。Keeper 仍为 v1.15.10，tag SHA 未变，结论为 **无新版**。

- 基线：`67465884ca179a8f9098328d03a361b50003fdd7`（v8.0.22）；候选：`d318bcc3afb9ea8782862f5e8cdb541afdc9dfa5`（v8.0.23）。官方 tag ref 直接指向该完整 commit。
- [完整比较](https://github.com/router-for-me/CLIProxyAPI/compare/67465884ca179a8f9098328d03a361b50003fdd7...d318bcc3afb9ea8782862f5e8cdb541afdc9dfa5) 包含 10 个提交、26 个文件（15 个生产文件、11 个测试文件），已逐个完整读取。两端未截断 git tree 的差异与完整 diff 文件集合一致，全部 hunk 行数完整。
- `go.mod`、`go.sum` 的两端 blob SHA 相同；无新增或变更的依赖、安装脚本、基础镜像，无二进制、LFS 或子模块差异。未运行上游代码、测试或漏洞扫描。
- [工具调用 ID](https://github.com/router-for-me/CLIProxyAPI/blob/d318bcc3afb9ea8782862f5e8cdb541afdc9dfa5/internal/runtime/executor/helps/tool_call_ids.go)：新增可逆 Base64 编码和字段级别替换，只处理调用 ID，不执行工具、解码后的字符串或命令；Devin 发送前还原 ID，Claude 仅规范化 tool_use/tool_result 的 ID 字段。
- [WebSocket interrupt](https://github.com/router-for-me/CLIProxyAPI/blob/d318bcc3afb9ea8782862f5e8cdb541afdc9dfa5/internal/runtime/executor/codex_websockets_executor.go)：终态响应 ID 与当前 socket 绑定，迟到的 interrupt 返回无操作；活动请求仍检查账户启用状态后写入原 socket。没有新增连接、凭据来源或远端地址。[诊断记录](https://github.com/router-for-me/CLIProxyAPI/blob/d318bcc3afb9ea8782862f5e8cdb541afdc9dfa5/sdk/api/handlers/openai/openai_responses_websocket_input.go) 仅保存类型、ID 摘要和固定 outcome，不复制任意扩展字段、原始 ID 或 transport 错误到新增 timeline 记录。
- [Home 调度](https://github.com/router-for-me/CLIProxyAPI/blob/d318bcc3afb9ea8782862f5e8cdb541afdc9dfa5/sdk/cliproxy/auth/conductor_home_execution.go)：仅对已经由现有 Home dispatch 选出的凭据跳过本地可用性过滤。已补查选择、执行会话绑定与流式路径上下文；普通本地选择仍执行 filterExecutionModels，未新增公共认证绕过入口、Home 目的地或凭据上传。
- [首 token 计时](https://github.com/router-for-me/CLIProxyAPI/blob/d318bcc3afb9ea8782862f5e8cdb541afdc9dfa5/internal/runtime/executor/openai_compat_executor.go)：改用既有 round-trip 包装与有效 token 观察函数。补查 usage_helpers.go、chat_ttft_helpers.go，确认沿用原 transport，只更改计时和模型观察，不新增采集终点。
- 其他变更为图片请求中的上游模型名称、Claude 系统消息插入位置、流式 usage 输出时机及 xAI socket 状态复位，操作范围为既有请求响应和内存会话。测试包含本地 HTTP/WebSocket 服务、模拟 transport、虚拟时钟和具体断言；全部静态阅读，没有通过执行测试来判断安全。

本次只更新 CLIProxyAPI pin 和文档。结论限定上述固定提交间的增量恶意行为审查，不保证功能正确性或未来动态内容安全。

## CLIProxyAPI v8.0.22 增量审查

结论：**通过**。Keeper 仍为 v1.15.10，tag SHA 未变，结论为 **无新版**。

- 基线：`54946fa3dfa29c6ca7312ac141a92cdd5e413771`（v8.0.21）；候选：`67465884ca179a8f9098328d03a361b50003fdd7`（v8.0.22）。官方 tag ref 为直接 commit 引用。
- [完整比较](https://github.com/router-for-me/CLIProxyAPI/compare/54946fa3dfa29c6ca7312ac141a92cdd5e413771...67465884ca179a8f9098328d03a361b50003fdd7) 共 6 个提交、20 个文件（13 个生产文件、7 个测试文件），已逐个完整阅读。官方 diff 与两端未截断 git tree 的 blob 差异一致，全部 hunk 行数完整。
- `go.mod`、`go.sum` 两端 blob SHA 相同；没有依赖、安装脚本、基础镜像、二进制、LFS 或子模块变化。未运行上游代码、测试或漏洞扫描。
- [Responses interrupt](https://github.com/router-for-me/CLIProxyAPI/blob/67465884ca179a8f9098328d03a361b50003fdd7/sdk/api/handlers/openai/openai_responses_websocket_input.go)：控制帧由当前客户端连接触发，校验 response ID 并检查账户启用状态；会话 ID 由服务端为当前连接生成。[上游发送](https://github.com/router-for-me/CLIProxyAPI/blob/67465884ca179a8f9098328d03a361b50003fdd7/internal/runtime/executor/codex_websockets_executor.go) 仅复用当前活动 socket，不重新选凭据、不拨号或重放。HTTP 分支取消当前请求并向当前客户端返回 incomplete 事件，不新增外传目的地。
- [Claude compaction](https://github.com/router-for-me/CLIProxyAPI/blob/67465884ca179a8f9098328d03a361b50003fdd7/internal/runtime/executor/claude_executor_compaction.go)：显式 compact 请求或 compaction_trigger 触发摘要生成，复用同一 Claude 执行器和账户；摘要包装及重放仅操作内存 JSON。补查 [compaction helper](https://github.com/router-for-me/CLIProxyAPI/blob/67465884ca179a8f9098328d03a361b50003fdd7/internal/runtime/executor/helps/antigravity_compaction.go) 的完整实现：现有 AES-GCM/Base64 包装只产生摘要数据，没有解码执行、额外文件读取或上传。工具历史仅保留为结构化内容或文本，不在代理内执行工具；用户 payload 规则仍可覆盖默认 tool_choice。
- [插件取消选用](https://github.com/router-for-me/CLIProxyAPI/blob/67465884ca179a8f9098328d03a361b50003fdd7/internal/pluginhost/host.go)：配置禁用或取消选择的插件走既有卸载流程，移除运行时状态、关闭该插件 HTTP 资源并调用 shutdown。已读取 detachPlugin 完整函数，没有新增插件下载、隐蔽加载或文件删除路径。
- 其余生产变更为 Claude 限额时间计算、模型输出上限和 Antigravity token 统计；只处理头部、注册表或请求响应数据，未增加秘密采集或执行入口。
- 测试使用本地 HTTP/WebSocket 服务、模拟凭据和插件替身；已静态检查全部测试变更及断言，未将测试结果或发布说明作为安全证据。

本次仅更新 CLIProxyAPI pin 与对应文档。以上结论限定固定 SHA 的增量恶意行为审查，不代表功能正确性或未来动态内容的安全保证。

## CLIProxyAPI v8.0.21 增量审查

结论：**通过**。Keeper 最新正式版仍为 v1.15.10，tag SHA 与现有固定值一致，结论为 **无新版**。

- 基线：`0f96f568e4dbf6f84ad7399a74b78344c5eac7e6`（v8.0.20）；候选：`54946fa3dfa29c6ca7312ac141a92cdd5e413771`（v8.0.21）。官方 tag ref 直接指向该 commit。
- [完整比较](https://github.com/router-for-me/CLIProxyAPI/compare/0f96f568e4dbf6f84ad7399a74b78344c5eac7e6...54946fa3dfa29c6ca7312ac141a92cdd5e413771) 包含 5 个提交、19 个文件，已逐个读取全部差异，包括测试。两端未截断 git tree 的 blob 差异清单与 diff 完全一致，各 hunk 行数完整。
- `go.mod`、`go.sum` 两端 blob SHA 相同，无依赖、安装脚本、基础镜像变化，无二进制、LFS 或子模块差异。
- [Vertex Interactions](https://github.com/router-for-me/CLIProxyAPI/blob/54946fa3dfa29c6ca7312ac141a92cdd5e413771/internal/runtime/executor/gemini_vertex_executor.go#L1318)：仅 Interactions 请求且账户显式启用时进入新路径；默认目标为 `https://aiplatform.googleapis.com` 的 `/v1beta1/.../interactions`，自定义 base URL 来自账户配置。认证使用现有 API key 或服务账号 token 交换；未新增第二接收方或凭据采集路径。已补查同文件的 `vertexCreds`、`vertexAPICreds`、`vertexAccessToken` 上下文。
- [共享 Interactions 辅助函数](https://github.com/router-for-me/CLIProxyAPI/blob/54946fa3dfa29c6ca7312ac141a92cdd5e413771/internal/runtime/executor/helps/gemini_interactions.go)：由原 Gemini 代码提取，操作请求 JSON、版本头及 SSE 字节，无下载执行或文件操作。
- [Meta reasoning 处理](https://github.com/router-for-me/CLIProxyAPI/blob/54946fa3dfa29c6ca7312ac141a92cdd5e413771/internal/runtime/executor/openai_responses_signature.go)：新增保留请求中未知格式加密 reasoning 的选项，仅转换请求内容，不解密执行或改变发送目的地。
- [配置规范化](https://github.com/router-for-me/CLIProxyAPI/blob/54946fa3dfa29c6ca7312ac141a92cdd5e413771/internal/config/config_yaml.go)：调整 YAML 节点显示风格，经既有管理保存入口调用，不改变配置写入目标或管理认证。
- [批量模型注册](https://github.com/router-for-me/CLIProxyAPI/blob/54946fa3dfa29c6ca7312ac141a92cdd5e413771/sdk/cliproxy/service_plugins.go)：比较账户 generation 并复用现有注册流程更新调度状态；新增测试钩子默认为 nil，无外部执行入口、额外下载或持久化后门。
- 测试变更使用模拟凭据、本地 HTTP 服务和临时配置文件；批量注册的空执行器仅为接口替身，实际测试断言检查模型排除和账户选择。未执行测试或上游代码；审查不作功能正确性保证。

本次仅更新 CLIProxyAPI workflow 的 pin 和对应文档；下面保留前次审查记录。

## v8.0.20 / Keeper v1.15.10 审查结论与范围

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
