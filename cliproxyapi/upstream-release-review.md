# CLIProxyAPI v8.0.41 增量源码审查

结论：**通过**。在当前中央构建/运行范围内，未发现本次增量引入恶意行为或恶意依赖的证据。仅检查恶意外传、隐蔽执行/下载、后门、破坏及未授权资源使用，不评价漏洞、Bug 或测试质量。

| 项目 | 官方正式版 | 完整提交 SHA | 结论 |
| --- | --- | --- | --- |
| CLIProxyAPI | v8.0.41 | `8289ec4c71ad914d0612c2776352b76ba3d355a6` | 通过 |
| CPA Usage Keeper | v2.0.1 | `5604768d352a1a85dd5c087b4e85bd657a159a02` | 无新版 |
| Watchtower | v1.23.2 | `cd5946be205ea0a60dd31235a11f04ac9851ebf6` | 无新版 |

审查范围为已批准 v8.0.40 `d946c4fba6fc9a5cfbca1f3d85184d62ad2fb683` → v8.0.41。官方 release 均非 draft/prerelease，tag 已解析为完整 commit；Watchtower annotated tag 已 peel。完整两端 Git 树逐目录重算 tree SHA，85 个两端源码 blob 重算 Git blob SHA-1 与 SHA-256。完整树差集为 **47 文件**，全部完整增量差异已读，包括新增文件与测试；不以 compare 文件数作为完整性依据。

中央基线为 `d4ca9aa89029e67ff1f18341104c4a8be9c32463`；Dockerfile/workflow 与上次批准发布一致。交付仍为 Go 服务二进制与示例配置。未变行和依赖复用批准基线，不声称重读整个仓库。没有依赖清单、checksum、来源或构建/安装配置变化。逐文件旧/新 blob、全部 hunk 范围、未变基线范围、模块结论和共享上下文见 [机器可读记录](review-result.json)。

## 敏感路径

- [Home 延迟上报与探测](https://github.com/router-for-me/CLIProxyAPI/blob/8289ec4c71ad914d0612c2776352b76ba3d355a6/internal/home/cluster_latency.go#L209)：向现有 Home 连接发送实例 ID 和节点 RTT 元数据；探测仅限已知集群节点，使用既有 TLS 配置、PING、超时和退避。已补读节点发现、证书加载、命令池和 capability 门控，无新增第三方接收方或凭据导出。
- [RESP 读取](https://github.com/router-for-me/CLIProxyAPI/blob/8289ec4c71ad914d0612c2776352b76ba3d355a6/internal/api/redis_queue_protocol.go#L436)：输入长度预算与连接回收；管理鉴权上下文未变。
- [Gemini 执行器](https://github.com/router-for-me/CLIProxyAPI/blob/8289ec4c71ad914d0612c2776352b76ba3d355a6/internal/runtime/executor/gemini_executor.go#L243)：拒绝/截断响应沿现有错误与用量路径处理；转换器、模型目录、thoughtSignature 和用量合并仅调整协议数据。
- [本地 Schema 引用](https://github.com/router-for-me/CLIProxyAPI/blob/8289ec4c71ad914d0612c2776352b76ba3d355a6/internal/util/gemini_schema.go#L1131)：本地约束合并与参数清理，没有远程引用抓取或代码执行。

审查期间未 clone、安装、构建或运行上游代码、测试或发布产物，也未扫描漏洞。未递归审查不参与中央交付的开发工具链。批准后的 CI 构建和公开 GHCR 验证单独记录；当前 workflow 的 `provenance: false` 不提供构建证明，本轮只核对 CI 固定源码链与 OCI source/revision 元数据。

证据目录：`/root/upstream-release-review/cliproxyapi-v8.0.41`；发布终态另存 `publication-result.json`。Keeper/Watchtower pin 和项目文件保持不变，不部署或重启服务。
