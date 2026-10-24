# CLIProxyAPI v8.0.42 增量源码审查

结论：**通过**。在锁定的中央构建与运行范围内，未发现本次增量引入恶意行为或恶意依赖的证据；无实质性未解决证据缺口。仅检查恶意外传、隐蔽执行/下载、后门、破坏及未授权资源使用，不评价漏洞、Bug 或测试质量。

| 项目 | 官方正式版 | 完整提交 SHA | 结论 |
| --- | --- | --- | --- |
| CLIProxyAPI | v8.0.42 | `bc0643405a1d0adf77dd0f109972ac3313d66397` | 通过 |
| CPA Usage Keeper | v2.0.1 | `5604768d352a1a85dd5c087b4e85bd657a159a02` | 无新版 |
| Watchtower | v1.23.2 | `cd5946be205ea0a60dd31235a11f04ac9851ebf6` | 无新版 |

审查范围：已批准 v8.0.41 `8289ec4c71ad914d0612c2776352b76ba3d355a6` → v8.0.42。正式 release/tag 已解析至上述完整 commit。两端完整 Git 树逐目录重算 tree SHA；73 份两端源码和必要上下文逐一重算 blob SHA-1 与 SHA-256。完整树差集为 **35 文件**，完整增量差异 135170 字节全部读完，包括新增文件全文、测试和文档；compare 仅作辅助证据。

开始时锁定中央基线 `6efa8da6fc311b61cc42d6e07f07c8256624ef57`。沿用已批准的 Go 二进制与示例配置交付边界、Dockerfile 和运行方式。未变行及依赖复用批准基线；不声称重读整个仓库。完整 hunk、实际读取范围、未变基线范围及不可变 blob 见 [机器记录](review-result.json)。依赖清单、checksum、来源与安装脚本无变更；新增 import 使用既有 gin v1.10.1、gjson v1.18.0。

敏感路径：

- [插件请求与 HTTP 桥接](https://github.com/router-for-me/CLIProxyAPI/blob/bc0643405a1d0adf77dd0f109972ac3313d66397/internal/pluginhost/http_bridge.go#L534)：既有请求中应用模型思考和用户载荷规则；跨源重定向移除凭据头；流式错误仅增加状态及重试元数据，无新增下载或执行入口。
- [调用者作用域](https://github.com/router-for-me/CLIProxyAPI/blob/bc0643405a1d0adf77dd0f109972ac3313d66397/internal/runtime/executor/antigravity_reasoning_replay.go#L101)：上下文中的调用者 key 经 CallerScope 和缓存命名空间哈希处理；补读完整调用链，没有新增原始凭据外传。
- [Git 存储恢复](https://github.com/router-for-me/CLIProxyAPI/blob/bc0643405a1d0adf77dd0f109972ac3313d66397/internal/store/gitstore.go#L1210)：扩大损坏错误判定，沿用配置远端、仓库/恢复目录和备份回滚路径，没有新增删除目标或远端。
- Home 连接取消、日志文件名处理、token 计数、模型与响应转换均沿既有业务路径。新增测试静态读完；HTTP 测试使用本地 httptest，未执行测试。

审查期间未 clone、安装、构建、执行上游或发布产物，未运行测试或扫描器。未递归审查不参与中央交付的开发/CI 工具链。沿用未变依赖和工具链的批准基线；这不是其重新认证。批准后的 CI 与公开 GHCR 核验单独记录，不作为源码审查证据。现有 workflow 的 `provenance: false` 不提供密码学构建证明；发布核对固定源码链及 OCI source/revision 元数据。

证据目录：`/root/upstream-release-review/cliproxyapi-v8.0.42`；发布终态另存 `publication-result.json`。Keeper/Watchtower pin 保持不变，不部署或重启服务。
