# cpa-usage-keeper v2.1.0 静态源码审查

结论：**通过**。固定增量及中央交付边界内未发现恶意代码或恶意依赖证据。

- 基线：v2.0.3 `9db74cfc380d11064af80cf1626efd6e3d068217`。
- 候选：[v2.1.0 / 41b34f12dbef209292765415b860583aad5afc09](https://github.com/Willxup/cpa-usage-keeper/commit/41b34f12dbef209292765415b860583aad5afc09)，正式 release tag 已解析为唯一完整 commit。
- 两端完整 tree 重算 115 个变更路径：17 个 Go 生产文件（1,125 行）与 45 个 Web 生产文件（5,456 行）差异逐页读完；12 个 Go 测试、39 个 Web 测试仅核对路径；其余 README 与测试 testdata 不进入中央构建。
- `go.mod`/`go.sum`、`web/package.json`/`package-lock.json`、`docker-entrypoint.sh` 均未变化；新增/升级依赖：0。

## 语义结论

1. **请求事件实时流（`/usage/events/live`，SSE）：** 在既有认证路由组内向浏览器推送本地请求事件；前端 `requestEventsSSE.ts` 只连接同源 Keeper 端点；无第三方外部端点，无数据外传。
2. **模型目录端点（`/models`）：** 返回本地已有模型/定价数据供前端目录展示；不新增外部调用。
3. **Argon 额度组（ArgonGroup 聚合）：** 在已有 SQLite 存储中新增 group 字段，聚合查询；无新外部目的地。
4. **MaxID 分页限制：** 参数化查询追加 `id <= :max_id` 约束；不引入外部调用。
5. **Web 前端（5,460 行）：** 登录页 WebGL 背景动效（`loginBackdrop.ts`，原生 `canvas.getContext('webgl')` 着色器，无第三方库）、SSE/模型客户端均只调用同源 Keeper 端点；lobe-icons SVG 品牌图标（MIT，仅 `xmlns` 命名空间 URL）无外部加载；无 `eval`、动态脚本加载或外部 CDN 调用。

## 依赖与中央边界

更正：提交 `b2acd65` 中的路由名与“Three.js”描述有误，此处已按 diff 修正，结论不变。依赖清单与基线相比无任何变化；复用已批准且未变的基线依赖，不扩审。

中央 Dockerfile.keeper 和 workflow 仅更新源码 SHA（`9db74cf` → `41b34f1`，tag `v2.0.3` → `v2.1.0`）；构建参数和运行边界保持不变。

审查中未 clone、安装、构建、执行上游代码/产物，也未运行测试或扫描。批准后中央 CI 构建发布独立于源审查；不部署或重启。

完整 diff 保存在本地 `/root/upstream-release-review/keeper-v2.1.0/`。

## 其他上游（本轮同步审查）

- CLIProxyAPI：**通过**，v8.0.69 `f7ae8feeb3710319f524730849fbe32fde1751e4`（详见 `cliproxyapi/upstream-release-review.md`）。
- Watchtower：**无新版**，最新正式版 v1.24.0 annotated tag 对象 `8ff4fafcdee91684e1db0f6e6e05ab3bb28386e7` 仍解析到 `147aa6a534428e68eb1ba4f71918f6f35404624d`。
