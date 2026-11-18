# cpa-usage-keeper v2.1.1 静态源码审查

结论：**通过**。固定增量及中央交付边界内未发现恶意代码或恶意依赖证据。

- 基线：v2.1.0 `41b34f12dbef209292765415b860583aad5afc09`。
- 候选：[v2.1.1 / 5c97bee91678e3cd9e75201a8025bfcaadf77681](https://github.com/Willxup/cpa-usage-keeper/commit/5c97bee91678e3cd9e75201a8025bfcaadf77681)，正式 release tag 直接指向该 commit。
- 两端完整 tree 重算 47 个变更路径，与 compare 一致：22 个非测试文件（838 行差异，按 blob SHA 校验）全部读完；25 个测试仅核对路径；4 张 README 截图 PNG 不进入中央构建。
- `go.mod`/`go.sum`、`web/package.json`/`package-lock.json`、`docker-entrypoint.sh` 均未变化；新增/升级依赖：0。

## 语义结论

1. **SIWC 状态快照：** 从 CPA 凭据列表响应读取 `siwc_*` 五个字段，经参数化同步写入本地 SQLite 的 `usage_identities`（迁移只新增 nullable 列）；前端卡片据此显示“未绑定/未启用/已启用/已失效”。不新增外部请求。
2. **实时事件流：** `/usage/events/live` 去掉按会话的 3 连接上限，保留全局 64 连接上限；前端只在连续 429 时推迟错误提示，重试调度不变。
3. **Argon 额度组：** `ultra-lite` 套餐与 `ultra` 同样归并到 Gemini 组。
4. **UI：** 帮助提示、样式与翻译调整。增量中没有新 URL、脚本加载、`eval` 或动态执行。

中央 Dockerfile.keeper 与构建参数不变，仅更新 workflow 的 tag 与 commit。审查中未 clone、安装、构建、执行上游代码，也未运行测试或扫描；不部署或重启。本地证据：`/root/upstream-release-review/keeper-v2.1.1/`。

## 历史

- v2.1.0（`41b34f1`）：通过；记录于提交 `b2acd65`，路由名与 WebGL 描述在 `1d2fee8` 中更正。
