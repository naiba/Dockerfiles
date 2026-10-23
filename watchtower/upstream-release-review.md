# Watchtower v1.23.2 中央交付增量审查

**结论：通过，仅限已批准的中央构建与 scratch 运行边界。整版上游及无限制 CI/开发/测试工具链：暂缓。**

基线 `520f95dea6e3c99b3e0e656e4a2950af11d6397b` → `cd5946be205ea0a60dd31235a11f04ac9851ebf6`；官方 annotated tag `v1.23.2` 的对象 `c75ea87a9af863b253cff70e03333f966567663e` 已解析并再次核对到候选完整 SHA。

复用已完成的增量静态恶意行为审查及最终对账：474 个项目文件差异、23 个模块升级（954 个变化文件）、1501 个直接输入分片全部已读。1381 项上下文请求中 1287 项关闭，94 项按既有基线明确排除但仍未核验；中央材料阻断和未裁定项均为 0。没有将排除项改记为关闭，也没有声称本次应用更新时重新进行全部语义审查。

本次应用前核对 688 个候选源码 blob 的 Git SHA 与 SHA256：383 个候选增量、305 个已批准基线复用；增量 after 目录本身不是完整构建上下文。核对两份获批快照与当前文件的完整差异，仅替换版本、源码 pin 与编译器摘要，随后逐字节复制快照。构建门禁继续校验正式 tag 的完整 SHA、批准状态与两个构建文件 SHA256。

构建仅复制 `go.mod go.sum main.go cmd/ internal/ pkg/`，原生 linux/amd64 Go 1.27.3 builder 固定为 `sha256:8aa2821993207ae840ce09e4223217efcd14e01f71525db734faf4232bd59999`，交叉编译 amd64/arm64；保持受约束的 `go build`、scratch、同一 builder 的 CA 和内嵌时区。Dockerfile SHA256 `162d41dcf5bd90cdc09e1c95763a55e4b64c309f331f15931e4fc757b23cd58f`；工作流 SHA256 `7b4f67ec48b8b0ebf7110694aaf1c87c8cf207e2a7718af4beab17ba76d103dd`。

明确排除上游 CI/dev/docs/test/release、安装器及不由中央入口执行的工具。harden-runner 原生 agent、CPython/工具缓存、可变 latest/master、verspec 映射、测试 OCI 层和其他未核验开发工具保持原始缺口；8 条历史补充展示缺口不改记为已读。官方固定摘要编译器与系统层沿用基线信任输入，不声称逐字节语义核验。操作者提供的 hooks、Docker CLI、凭据助手、daemon、镜像及 Git/Compose 项目不属于批准制品。

[机器可读增量证据](incremental-review-evidence.json) 保存源码散列、覆盖、来源、94 项排除及完整对账文件散列；[批准门禁](review-approval.json) 绑定构建文件及增量证据。完整本地证据位于 `/root/upstream-release-review/watchtower-v1.23.2/`，不是公共下载地址。下方基线报告与 [基线证据](baseline-review-evidence.json) 保持历史原文，其中“本轮”“尚未构建”等措辞仅指基线审查当时。

用户已另行授权中央 commit/push 与 CI 镜像发布；审查通过不代替 CI 或公开 registry 验证。本地仅做静态 YAML/JSON、散列与精确替换验证，不构建、测试或扫描上游。发布结果另存本地证据目录，并同步 [镜像说明仓库](https://github.com/naiba-forks/watchtower)。不部署或重启服务器；既有自动更新服务可能独立响应 latest。

---

# Watchtower v1.23.1 基线最终证据对账

**结论：通过。** 仅限固定源码首次基线的静态恶意行为审查，以及已经记录的中央根模块构建与 scratch 运行边界。不是漏洞、功能、测试、发布产物或任意部署输入的批准。

固定提交：520f95dea6e3c99b3e0e656e4a2950af11d6397b。正式 tag 对象 5f139bc8c87ffb18f70d3c11dfc95106fbf02486 已解析到该唯一完整 commit。

原七份报告的52项gap全部逐项处置，另补齐actions原无最终报告的49个文件；六类运行时边界及四项传递调用闭环均已合并。限定范围内剩余材料缺口为0，findings为空。原报告的历史暂缓保持原样，由本报告给出当前结论。

可复核的完整映射、旧gap原文、逐文件覆盖记录、不可变源码链接、依赖来源、散列清单及边界细节见 [JSON报告](baseline-final-reconciliation.json)。

## 覆盖与证据终态

- 711个blob、7,872,203字节与固定树/清单相符；本轮再次核对每个本地文件的Git blob SHA-1、SHA-256和长度。
- 200个有界分段的实际输入、源字节、执行日志中的完整输入及结果文件散列再次匹配。174个文件的连续分段覆盖由完整覆盖审计验收；190段初始通过，10段由58条上下文闭环转为通过。
- 另655条原通过段上下文保留在覆盖审计中，不冒称已由58条闭环逐一处理，也不把覆盖统计当作敏感实现批准。
- 两个API golden可见性遗漏已由原审计13次实际有界读取修复；actions早期退出1的缺报告不再作为覆盖依据。
- PDF的21页、29份CMap与空映射字形、4个嵌入字体的137个hint程序（107种）、203个Type3字形与所有流已静态解释；本轮核对6个实际阅读的解码证据散列。
- 通知、Compose、Git、容器辅助四份报告分别有288、111、95、39条不可变证据，当前本地字节散列全部匹配；四个完成退出码均为0，报告各自无剩余gap。退出码与语义通过分别核验。

## 原始缺口逐项处置

| 原报告 / 缺口 | 当前处置及具体证据 |
| --- | --- |
| actions / 缺最终报告 | 49文件由实际分段输入/日志及十段上下文闭环替代原失败进程；见full-coverage-audit与source-segment-context-closure。 |
| api-git / G1 | registry 选择、file/native/memory store、helper get/list 的实际参数和继承环境已追到终端；Compose 全凭据交 daemon 与单镜像认证明确区分。helper 不捆绑在 scratch 中，不把其任意实现当已审。；challenge/Basic/Bearer、manifest/blob、mirror、age、release resolver、ratelimit 和上层 pull 调用已接通；保留 realm/重定向/重试可能跨主机携带认证的真实语义，不虚构全局同源保证。 证据：sensitive-boundary-closure.json:boundaries/docker-credential-helper, sensitive-boundary-closure.json:boundaries/registry-challenge-redirect-mirror, source-segment-context-closure.json:flows/registry_credentials；JSON保留全部源码引用。 |
| api-git / G2 | 依赖图输入/排序到 eligible 隐式重启、过滤/停止/重建/镜像删除、copy-file、自更新与临时 orchestrator、启动清理及 lifecycle exec 已接到具体 Docker ID 与配置来源；补齐 changelog/OCI/semver 辅助。保留显式 chain 跨 scope、orchestrator env 信任及 hook 输出边界。 证据：sensitive-boundary-closure.json:boundaries/update-self-orchestrator-cleanup-hooks, source-segment-context-closure.json:flows/update_selection, source-segment-context-closure.json:flows/dependency_restart；JSON保留全部源码引用。 |
| api-git / G3 | 依赖图输入/排序到 eligible 隐式重启、过滤/停止/重建/镜像删除、copy-file、自更新与临时 orchestrator、启动清理及 lifecycle exec 已接到具体 Docker ID 与配置来源；补齐 changelog/OCI/semver 辅助。保留显式 chain 跨 scope、orchestrator env 信任及 hook 输出边界。 证据：sensitive-boundary-closure.json:boundaries/update-self-orchestrator-cleanup-hooks, source-segment-context-closure.json:flows/update_selection, source-segment-context-closure.json:flows/dependency_restart；JSON保留全部源码引用。 |
| api-git / G4 | secret flag 文件、legacy URL、日志/模板/报告、队列到全部30个 provider/33个scheme及相关 HTTP/MQTT/XMPP 传输已连接。目标由显式配置或 provider 协议选择；保留代理/重定向、Matrix默认房间集合和非全面脱敏语义。 证据：sensitive-boundary-closure.json:boundaries/notification-url-secret-payload, source-segment-context-closure.json:flows/notifications, source-segment-context-closure.json:flows/runtime_logging；JSON保留全部源码引用。 |
| build-dependencies / G1 | 闭合：生产排除浮动开发/发布工具；仅限固定官方工具链、根模块 go build 与 scratch 白名单方案；没有把被排除实现升级为已审。 证据：build-provenance-closure.json:gap_disposition/G1, build-provenance-closure.json:scope/checked_in_execution_files/module_provenance/builder_runtime/proposed_central_build, central-production.Dockerfile；JSON保留全部源码引用。 |
| build-dependencies / G2 | 闭合：不构建/运行文档，不安装 Python 依赖；仅限固定官方工具链、根模块 go build 与 scratch 白名单方案；没有把被排除实现升级为已审。 证据：build-provenance-closure.json:gap_disposition/G2, build-provenance-closure.json:scope/checked_in_execution_files/module_provenance/builder_runtime/proposed_central_build, central-production.Dockerfile；JSON保留全部源码引用。 |
| build-dependencies / G3 | 版本来源闭合，选定敏感依赖实现已补审；第三方 Action 和发布工具不执行；仅限固定官方工具链、根模块 go build 与 scratch 白名单方案；没有把被排除实现升级为已审。 证据：build-provenance-closure.json:gap_disposition/G3, build-provenance-closure.json:scope/checked_in_execution_files/module_provenance/builder_runtime/proposed_central_build, central-production.Dockerfile；JSON保留全部源码引用。 |
| build-dependencies / G4 | 闭合：固定官方 Go builder 平台 manifest/config，scratch、同源证书与嵌入 tzdata；不再执行 APK/测试镜像/Action 容器安装链；仅限固定官方工具链、根模块 go build 与 scratch 白名单方案；没有把被排除实现升级为已审。 证据：build-provenance-closure.json:gap_disposition/G4, build-provenance-closure.json:scope/checked_in_execution_files/module_provenance/builder_runtime/proposed_central_build, central-production.Dockerfile；JSON保留全部源码引用。 |
| build-dependencies / G5 | registry 选择、file/native/memory store、helper get/list 的实际参数和继承环境已追到终端；Compose 全凭据交 daemon 与单镜像认证明确区分。helper 不捆绑在 scratch 中，不把其任意实现当已审。；challenge/Basic/Bearer、manifest/blob、mirror、age、release resolver、ratelimit 和上层 pull 调用已接通；保留 realm/重定向/重试可能跨主机携带认证的真实语义，不虚构全局同源保证。；API origin/分页/认证、Git HTTP/SSH、checkout/diff/tree/index/storage/Billy、agent/knownhosts/ssh_config 及 Compose Build/Up/create/context/plugin/memorystore/daemon 终端调用均有对应不可变源码证据。；secret flag 文件、legacy URL、日志/模板/报告、队列到全部30个 provider/33个scheme及相关 HTTP/MQTT/XMPP 传输已连接。目标由显式配置或 provider 协议选择；保留代理/重定向、Matrix默认房间集合和非全面脱敏语义。；配置加载到监听/路由、主 token 与独立 events token、config/update/events handlers、实际更新回调与 broadcaster 已接通；config 输出白名单，错误/事件文本不承诺全面脱敏。；依赖图输入/排序到 eligible 隐式重启、过滤/停止/重建/镜像删除、copy-file、自更新与临时 orchestrator、启动清理及 lifecycle exec 已接到具体 Docker ID 与配置来源；补齐 changelog/OCI/semver 辅助。保留显式 chain 跨 scope、orchestrator env 信任及 hook 输出边界。；分组外文档主题/生成的已签入静态资产由711文件覆盖与PDF闭环验收；未签入的 tplprev.wasm/wasm_exec.js 与 MkDocs 安装链仍排除。由此关闭 build-provenance-closure.json 的唯一 material 项 BASELINE-G5。 证据：sensitive-boundary-closure.json:boundaries/docker-credential-helper, sensitive-boundary-closure.json:boundaries/registry-challenge-redirect-mirror, sensitive-boundary-closure.json:boundaries/git-api-checkout-compose-build；JSON保留全部源码引用。 |
| configuration-runtime / assigned-visible-content | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| configuration-runtime / required-sensitive-call-chains | registry 选择、file/native/memory store、helper get/list 的实际参数和继承环境已追到终端；Compose 全凭据交 daemon 与单镜像认证明确区分。helper 不捆绑在 scratch 中，不把其任意实现当已审。；challenge/Basic/Bearer、manifest/blob、mirror、age、release resolver、ratelimit 和上层 pull 调用已接通；保留 realm/重定向/重试可能跨主机携带认证的真实语义，不虚构全局同源保证。；API origin/分页/认证、Git HTTP/SSH、checkout/diff/tree/index/storage/Billy、agent/knownhosts/ssh_config 及 Compose Build/Up/create/context/plugin/memorystore/daemon 终端调用均有对应不可变源码证据。；secret flag 文件、legacy URL、日志/模板/报告、队列到全部30个 provider/33个scheme及相关 HTTP/MQTT/XMPP 传输已连接。目标由显式配置或 provider 协议选择；保留代理/重定向、Matrix默认房间集合和非全面脱敏语义。；配置加载到监听/路由、主 token 与独立 events token、config/update/events handlers、实际更新回调与 broadcaster 已接通；config 输出白名单，错误/事件文本不承诺全面脱敏。；依赖图输入/排序到 eligible 隐式重启、过滤/停止/重建/镜像删除、copy-file、自更新与临时 orchestrator、启动清理及 lifecycle exec 已接到具体 Docker ID 与配置来源；补齐 changelog/OCI/semver 辅助。保留显式 chain 跨 scope、orchestrator env 信任及 hook 输出边界。 证据：sensitive-boundary-closure.json:boundaries/docker-credential-helper, sensitive-boundary-closure.json:boundaries/registry-challenge-redirect-mirror, sensitive-boundary-closure.json:boundaries/git-api-checkout-compose-build；JSON保留全部源码引用。 |
| containers / assigned_visibility | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| containers / sensitive_context | registry 选择、file/native/memory store、helper get/list 的实际参数和继承环境已追到终端；Compose 全凭据交 daemon 与单镜像认证明确区分。helper 不捆绑在 scratch 中，不把其任意实现当已审。；challenge/Basic/Bearer、manifest/blob、mirror、age、release resolver、ratelimit 和上层 pull 调用已接通；保留 realm/重定向/重试可能跨主机携带认证的真实语义，不虚构全局同源保证。；API origin/分页/认证、Git HTTP/SSH、checkout/diff/tree/index/storage/Billy、agent/knownhosts/ssh_config 及 Compose Build/Up/create/context/plugin/memorystore/daemon 终端调用均有对应不可变源码证据。；secret flag 文件、legacy URL、日志/模板/报告、队列到全部30个 provider/33个scheme及相关 HTTP/MQTT/XMPP 传输已连接。目标由显式配置或 provider 协议选择；保留代理/重定向、Matrix默认房间集合和非全面脱敏语义。；依赖图输入/排序到 eligible 隐式重启、过滤/停止/重建/镜像删除、copy-file、自更新与临时 orchestrator、启动清理及 lifecycle exec 已接到具体 Docker ID 与配置来源；补齐 changelog/OCI/semver 辅助。保留显式 chain 跨 scope、orchestrator env 信任及 hook 输出边界。 证据：sensitive-boundary-closure.json:boundaries/docker-credential-helper, sensitive-boundary-closure.json:boundaries/registry-challenge-redirect-mirror, sensitive-boundary-closure.json:boundaries/git-api-checkout-compose-build；JSON保留全部源码引用。 |
| docs-assets / G1 | PDF 21页、29份CMap、39处ActualText替换与空映射字形均已解释；4个TrueType字体137个hint程序（107个不同程序）及203个Type3字形已静态检查；294个流均分类，无未解释尾部或额外可执行动作。未执行PDF/字体。 证据：asset-container-closure.json:container/text/fonts/images/visibility, full-coverage-audit.json:binary_asset_validation；JSON保留全部源码引用。 |
| docs-assets / G2 | 闭合：生成的 WASM、wasm_exec.js、MkDocs/Action/Python 链不进入 COPY 白名单，不由 go build 生成或运行；仅限固定官方工具链、根模块 go build 与 scratch 白名单方案；没有把被排除实现升级为已审。 证据：build-provenance-closure.json:gap_disposition/G2, build-provenance-closure.json:scope/checked_in_execution_files/module_provenance/builder_runtime/proposed_central_build, central-production.Dockerfile；JSON保留全部源码引用。 |
| docs-assets / G3 | API origin/分页/认证、Git HTTP/SSH、checkout/diff/tree/index/storage/Billy、agent/knownhosts/ssh_config 及 Compose Build/Up/create/context/plugin/memorystore/daemon 终端调用均有对应不可变源码证据。 证据：sensitive-boundary-closure.json:boundaries/git-api-checkout-compose-build, source-segment-context-closure.json:flows/git_authorization, source-segment-context-closure.json:flows/git_compose_checkout；JSON保留全部源码引用。 |
| docs-assets / G4 | secret flag 文件、legacy URL、日志/模板/报告、队列到全部30个 provider/33个scheme及相关 HTTP/MQTT/XMPP 传输已连接。目标由显式配置或 provider 协议选择；保留代理/重定向、Matrix默认房间集合和非全面脱敏语义。 证据：sensitive-boundary-closure.json:boundaries/notification-url-secret-payload, source-segment-context-closure.json:flows/notifications, source-segment-context-closure.json:flows/runtime_logging；JSON保留全部源码引用。 |
| docs-assets / G5 | 依赖图输入/排序到 eligible 隐式重启、过滤/停止/重建/镜像删除、copy-file、自更新与临时 orchestrator、启动清理及 lifecycle exec 已接到具体 Docker ID 与配置来源；补齐 changelog/OCI/semver 辅助。保留显式 chain 跨 scope、orchestrator env 信任及 hook 输出边界。 证据：sensitive-boundary-closure.json:boundaries/update-self-orchestrator-cleanup-hooks, source-segment-context-closure.json:flows/update_selection, source-segment-context-closure.json:flows/dependency_restart；JSON保留全部源码引用。 |
| docs-assets / G6 | 配置加载到监听/路由、主 token 与独立 events token、config/update/events handlers、实际更新回调与 broadcaster 已接通；config 输出白名单，错误/事件文本不承诺全面脱敏。 证据：sensitive-boundary-closure.json:boundaries/api-config-update-events, source-segment-context-closure.json:flows/events_metrics, source-segment-context-closure.json:flows/runtime_logging；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/session/container_status_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/session/progress_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/session/report_benchmark_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/session/report_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/sorter/dependency_benchmark_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/sorter/dependency_fuzz_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/sorter/dependency_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/sorter/deployment_helpers_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/sorter/graph_benchmark_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/sorter/graph_fuzz_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/sorter/graph_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/sorter/mocks/Sorter.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/sorter/mocks/container.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/sorter/sorter_suite_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/sorter/sorter_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/sorter/test_helpers_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/sorter/time_benchmark_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/sorter/time_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/types/git_fuzz_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/types/git_test.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/types/mocks/Container.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/types/mocks/ContainerReport.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/types/mocks/ConvertibleNotifier.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/types/mocks/DelayNotifier.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/types/mocks/Filter.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/types/mocks/FilterableContainer.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/types/mocks/ImageInspector.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/types/mocks/Notifier.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / unread:pkg/types/mocks/Report.go | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| notifications-types / sorter-consumer-chain | 依赖图输入/排序到 eligible 隐式重启、过滤/停止/重建/镜像删除、copy-file、自更新与临时 orchestrator、启动清理及 lifecycle exec 已接到具体 Docker ID 与配置来源；补齐 changelog/OCI/semver 辅助。保留显式 chain 跨 scope、orchestrator env 信任及 hook 输出边界。 证据：sensitive-boundary-closure.json:boundaries/update-self-orchestrator-cleanup-hooks, source-segment-context-closure.json:flows/update_selection, source-segment-context-closure.json:flows/dependency_restart；JSON保留全部源码引用。 |
| registry / assigned-content-visibility | 原未读字节/文件由实际输入与日志支持的完整覆盖补齐；含测试、mock、golden 文件，只审静态行为，没有运行或评价其断言正确性。 证据：full-coverage-audit.json:integrity/coverage/initial_visibility_corrections, consolidated-file-review.json:files；JSON保留全部源码引用。 |
| registry / sensitive-call-chain-closure | challenge/Basic/Bearer、manifest/blob、mirror、age、release resolver、ratelimit 和上层 pull 调用已接通；保留 realm/重定向/重试可能跨主机携带认证的真实语义，不虚构全局同源保证。；registry 选择、file/native/memory store、helper get/list 的实际参数和继承环境已追到终端；Compose 全凭据交 daemon 与单镜像认证明确区分。helper 不捆绑在 scratch 中，不把其任意实现当已审。 证据：sensitive-boundary-closure.json:boundaries/registry-challenge-redirect-mirror, sensitive-boundary-closure.json:boundaries/docker-credential-helper, source-segment-context-closure.json:flows/registry_http；JSON保留全部源码引用。 |
| registry / external-credential-store-boundary | registry 选择、file/native/memory store、helper get/list 的实际参数和继承环境已追到终端；Compose 全凭据交 daemon 与单镜像认证明确区分。helper 不捆绑在 scratch 中，不把其任意实现当已审。 证据：sensitive-boundary-closure.json:boundaries/docker-credential-helper, source-segment-context-closure.json:flows/registry_credentials, source-segment-context-closure.json:flows/docker_connection；JSON保留全部源码引用。 |

## 后续残余与运行时 G5

| 旧残余 | 实际闭合 |
| --- | --- |
| notification-providers-transitive | 全30 provider/33 scheme及共有format/schema/redact、HTTP、MQTT/Paho/SOCKS、XMPP/Mellium/SASL/XML/JID到发送终点；closure-notification-providers-transitive.json。 |
| compose-sdk-transitive | Build/Up/create重建终端、prepareShellOut/endpoint、plugin discovery、context归档/下载、memory/native凭据、hook/provider/model/relay及独立DockerCli传输；closure-compose-sdk-transitive.json。 |
| git-checkout-transitive | checkout/status/diff/tree/index/storage/Billy/path、Git配置/传输与agent/knownhosts/ssh_config身份及目的地；closure-git-checkout-transitive.json。 |
| container-supporting-calls | changelog/OCI Read/semver SelectTag及其直接支持调用，接到已审报告、版本选择和Docker写操作；closure-container-supporting-calls.json。 |
| deployment-artifacts | 保留显式外部信任边界；scratch不包含helper/Git/buildx/daemon等程序，操作员配置输入不是未知内置工件。实际产物尚未构建，未伪造产物证明。 |
| build BASELINE-G5 | 原build G5的全部运行时及文档资产义务由上述闭环、六类边界、全覆盖和PDF证据合并验收；中央来源通过后唯一遗留材料项现已关闭。 |

## 配置行为与信任边界

- **Docker 更新与依赖重启：** 按配置选择容器、依赖关系及策略，检查镜像并停止、重建、启动、复制文件或清理选定对象；普通重建继承已有 Config/HostConfig。 证据：source-segment-context-closure.json:flows/update_selection/dependency_restart/docker_operations/copy_files, sensitive-boundary-closure.json:boundaries/update-self-orchestrator-cleanup-hooks。
- **自更新和清理权限：** ephemeral 使用显式旧ID等内部环境、socket/证书挂载和所选镜像；入口不额外证明旧ID等于当前实例。chain 可跨scope，孤立orchestrator按标签与年龄清理；不能宣称所有删除都受同一scope或cleanup开关约束。 证据：sensitive-boundary-closure.json:boundaries/update-self-orchestrator-cleanup-hooks。
- **生命周期命令：** 显式hook在目标容器中执行sh -c，可配置UID/GID、环境、超时；输出/错误可进入日志和通知。scratch无shell不意味着远端容器hook不可执行。 证据：source-segment-context-closure.json:flows/lifecycle_hooks, closure-compose-sdk-transitive.json:sensitive_flows/hooks。
- **registry认证与目的地：** 认证可能随registry realm、redirect、mirror/manifest重试到协议或配置选出的目标；不作全局同源或全面秘密不泄露保证。helper直接exec并继承环境，没有隐藏下载helper。 证据：sensitive-boundary-closure.json:boundaries/docker-credential-helper/registry-challenge-redirect-mirror。
- **Git工作树与身份：** 选择提交后的checkout/reset可创建、覆盖、删除项目文件和元数据；nil SSH auth可能用agent，ssh_config Hostname/Port、代理和insteadOf可改变实际目标。file后端有外部Git调用，scratch未捆绑Git。 证据：closure-git-checkout-transitive.json:sensitive_flows。
- **Compose服务与资源：** 服务筛选包括配置依赖/additional_contexts；可创建或启动依赖服务。AlwaysOkPrompt自动同意卷重建。挂载、seccomp、本地/URL/Git context和Dockerfile路径依配置，非Git根沙箱承诺。 证据：closure-compose-sdk-transitive.json:sensitive_flows/service-selection/container-configuration/classic-context。
- **Compose凭据与端点：** classic build向daemon交付全部收集凭据；显式use_api_socket可将socket与全凭据配置交服务。独立DockerCli按context/DOCKER_HOST选择端点，不能套用主client全部保护。 证据：closure-compose-sdk-transitive.json:sensitive_flows/credential-stores/secrets-config-socket/daemon-transport。
- **插件、provider与relay：** 可选buildx/provider/model程序发现与metadata请求本身会执行程序并继承环境；metadata不是签名。provider协议可请求导出镜像；成功发布端点后可条件拉取docker/compose-relay:v1或配置覆盖。无外部provider时不能完成该链；relay非scratch内置产物，镜像内容未获批准。 证据：closure-compose-sdk-transitive.json:sensitive_flows/bake-plugin/provider-model-relay。
- **通知与秘密：** 全部30个provider/33个scheme按配置或其协议服务发送日志、报告、模板；不保证全面脱敏或统一redirect allowlist。Matrix无rooms时发给全部已加入房间，日志可含token前3字符；附件/链接/远端动作按各provider实际实现处理。 证据：closure-notification-providers-transitive.json:provider_coverage/sensitive_flows/observations。
- **API与遥测：** config/update用主token，events用独立token并检查Origin，配置响应白名单；更新沿原策略和过滤器。SSE/日志可含错误文本。Compose/BuildKit tracing出口取显式OTEL环境或Docker context OTLP配置，无据此认定默认隐蔽遥测。 证据：sensitive-boundary-closure.json:boundaries/api-config-update-events, build-provenance-closure.json:sensitive_implementation_inspection。

关键源码锚点（均为不可变SHA；完整调用证据见JSON）：

- docker-credential-helper：[pkg/registry/trust.go:154](https://github.com/nicholas-fedor/watchtower/blob/520f95dea6e3c99b3e0e656e4a2950af11d6397b/pkg/registry/trust.go#L154-L397)。
- registry-challenge-redirect-mirror：[pkg/registry/auth/auth.go:212](https://github.com/nicholas-fedor/watchtower/blob/520f95dea6e3c99b3e0e656e4a2950af11d6397b/pkg/registry/auth/auth.go#L212-L266), [pkg/registry/auth/bearer.go:466](https://github.com/nicholas-fedor/watchtower/blob/520f95dea6e3c99b3e0e656e4a2950af11d6397b/pkg/registry/auth/bearer.go#L466-L496)。
- git-api-checkout-compose-build：[pkg/container/git/association.go:1](https://github.com/nicholas-fedor/watchtower/blob/520f95dea6e3c99b3e0e656e4a2950af11d6397b/pkg/container/git/association.go#L1), [internal/git/auth.go:96](https://github.com/nicholas-fedor/watchtower/blob/520f95dea6e3c99b3e0e656e4a2950af11d6397b/internal/git/auth.go#L96-L146)。
- notification-url-secret-payload：[internal/flags/flags.go:246](https://github.com/nicholas-fedor/watchtower/blob/520f95dea6e3c99b3e0e656e4a2950af11d6397b/internal/flags/flags.go#L246-L449), [internal/config/load.go:484](https://github.com/nicholas-fedor/watchtower/blob/520f95dea6e3c99b3e0e656e4a2950af11d6397b/internal/config/load.go#L484-L627)。
- api-config-update-events：[internal/config/run_config.go:40](https://github.com/nicholas-fedor/watchtower/blob/520f95dea6e3c99b3e0e656e4a2950af11d6397b/internal/config/run_config.go#L40-L100), [internal/api/config/endpoints.go:214](https://github.com/nicholas-fedor/watchtower/blob/520f95dea6e3c99b3e0e656e4a2950af11d6397b/internal/api/config/endpoints.go#L214-L276)。
- update-self-orchestrator-cleanup-hooks：[pkg/filters/filters.go:767](https://github.com/nicholas-fedor/watchtower/blob/520f95dea6e3c99b3e0e656e4a2950af11d6397b/pkg/filters/filters.go#L767-L950), [pkg/container/container_source.go:44](https://github.com/nicholas-fedor/watchtower/blob/520f95dea6e3c99b3e0e656e4a2950af11d6397b/pkg/container/container_source.go#L44-L156)。

## 来源与未获批准的范围

中央方案固定官方Go 1.27.2 builder的amd64 manifest sha256:3b15ba438c60ab8fabe5fee3b11025c0049e358b31feff384648f11fc8e335f8；跨编译linux/amd64、linux/arm64，不安装QEMU。根模块以CGO_ENABLED=0、GOTOOLCHAIN=local、-mod=readonly、-tags=timetzdata构建，只复制go.mod/go.sum/main.go/cmd/internal/pkg。最终scratch仅接收新构建Watchtower与同源证书，tzdata内嵌。Dockerfile证据散列为 2596940c69ef2fbf594baa9cae984c96a8a77981495cba4621a976af1e12b3e7。

328个基线模块版本、611条校验记录的来源已闭合；旧缺失Origin的73项已补齐。Fiber与Moby缺失/浮动Origin.Ref使用正式tag解析到固定SHA，没有用分支作为目标。元数据证明来源对应，不等于328版本全代码审查。敏感依赖实现按上述不可变代码闭环。

**原上游不受限工作流/文档构建与产物范围仍为暂缓。** build G1的浮动脚本/工具、G2的Python安装链、G3被排除Action/发布工具实现、G4测试/Action容器与被排除安装链，以及docs G2未生成WASM/支持脚本没有被虚构为已审。它们因明确不进入中央构建/运行输入而不阻塞本次限定基线；一旦引入需重新审查。

central-publication-workflow.yml仍是另行验证的未提交提案，不是上游信任证据。本轮未修改或使用它来证明上游通过。

## 局限与本轮操作

- 这是首次固定源码基线的静态恶意行为结论，不是版本差异审查、漏洞保证、功能/正确性/性能验证、测试结果或密码学/编译器形式化证明。
- 711个上游blob全量覆盖；不声称328个模块版本全部源码逐行审完。版本来源/校验记录与实际敏感实现阅读分别列示。未独立验证sumdb Merkle/signature，未下载模块zip。
- 固定官方Go工具链/系统层按既有来源闭环中的明确边界处理；只核验manifest/config来源和散列，不声称镜像层或整个OS/编译器逐字节语义检查。
- 通过仅适用于记录的中央根模块构建与scratch运行输入。原上游浮动release/dev/docs/security/test链、Python安装链、未生成WASM、第三方Action及发布工具实现、上游发布二进制/镜像没有因排除而获得批准。
- 操作员外部输入和配置不是未知内置产物；本审查核验其选择、参数、身份和副作用边界，不批准任意用户程序、daemon、镜像或Git/Compose项目。
- 实际构建尚未发生：没有输出镜像摘要、运行文件散列、SBOM或位级可复现性证实。后续构建须保留受审输入边界并记录产物证据；这不重新打开已闭合的源码材料缺口。
- central-publication-workflow.yml是另行验证的未提交提案，不是上游信任证据，也不用于支持本次恶意行为通过。
- 本轮做证据整合、内容读取及散列/结构核验，复用已完成的语义审查与实际可见性审计；没有声称在本轮重新逐行阅读全部711文件。部分早期探索输出超出边界或被截断，未作为完整可见性证据；所需结论使用后续有界字段读取和既存实际输入/日志核验。

本轮仅写本JSON、Markdown与baseline-review-status.md；没有仓库编辑、上游执行/安装/构建/测试/扫描、秘密访问、委派、commit/push、发布、部署或重启。源码基线通过与后续发布操作分开记录。
