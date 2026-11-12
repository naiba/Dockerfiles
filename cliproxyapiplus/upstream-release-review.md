# cpa-usage-keeper v2.1.0 静态源码审查

结论：**通过**。固定增量及中央交付边界内未发现恶意代码或恶意依赖证据。

- 基线：v2.0.3 `9db74cfc380d11064af80cf1626efd6e3d068217`。
- 候选：[v2.1.0 / 41b34f12dbef209292765415b860583aad5afc09](https://github.com/Willxup/cpa-usage-keeper/commit/41b34f12dbef209292765415b860583aad5afc09)，正式 release tag 已解析为唯一完整 commit。
- 完整 Go 差异 + Web 差异逐页读完；新增/升级依赖：0。

## 语义结论

1. **SSE 实时事件流（`/api/usage/sse`）：** 仅调用本机内部 UsageService，注册 EventSource，goroutine 推送结构化消息（usage count + alert）；无第三方外部端点，无数据外传。
2. **模型目录端点（`/api/model/list`）：** 读取已有 auth-data/model 配置返回列表；不新增外部调用。
3. **Argon 额度组（ArgonGroup 聚合）：** 在已有 SQLite 存储中新增 group 字段，聚合查询；无新外部目的地。
4. **MaxID 分页限制：** 参数化查询追加 `id <= :max_id` 约束；不引入外部调用。
5. **Web 前端（5,460 行）：** WebGL 背景动效（纯 Three.js canvas）、SSE/模型客户端均只调用 Keeper 本机端点（`/api/…`）；SVG 品牌图标（MIT）无外部引用；无 `eval`、动态脚本加载或外部 CDN 调用。

## 依赖与中央边界

Go 依赖清单（go.mod/go.sum）与基线相比无任何变化；复用已批准且未变的基线依赖，不扩审。

中央 Dockerfile.keeper 和 workflow 仅更新源码 SHA（`9db74cf` → `41b34f1`，tag `v2.0.3` → `v2.1.0`）；构建参数和运行边界保持不变。

审查中未 clone、安装、构建、执行上游代码/产物，也未运行测试或扫描。批准后中央 CI 构建发布独立于源审查；不部署或重启。

完整 diff 保存在本地 `/root/upstream-release-review/keeper-v2.1.0/`。

## 其他上游（本轮同步审查）

- CLIProxyAPI：**通过**，v8.0.69 `f7ae8feeb3710319f524730849fbe32fde1751e4`（详见 `cliproxyapi/upstream-release-review.md`）。
- Watchtower：**无新版**，最新正式版 v1.24.0 annotated tag 对象 `8ff4fafcdee91684e1db0f6e6e05ab3bb28386e7` 仍解析到 `147aa6a534428e68eb1ba4f71918f6f35404624d`。
