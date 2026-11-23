# CLIProxyAPI v8.1.2 静态源码审查

结论：**通过**。已批准中央构建与运行边界内，本轮静态增量未发现恶意代码或恶意依赖证据。

- 基线：v8.1.1 `6eb8554f0ede597b2aa3e508ffb3f111d3c2b9e6`；[已提交批准报告](https://github.com/naiba/Dockerfiles/blob/fa57d0479f22f77cd931f63e6aacd2374109628c/cliproxyapi/review-result.json)。
- 候选：[v8.1.2 / 85225381d89915595598ed13766cd79890c03a84](https://github.com/router-for-me/CLIProxyAPI/commit/85225381d89915595598ed13766cd79890c03a84)，官方非 draft/prerelease release，tag 直接指向该 commit。
- 130 个变更路径，与 compare 一致；72 个非测试文件、6,925 行差异按 blob SHA 校验并全量筛查，执行器、缓存、Home、模型目录链逐段核对。根 `go.mod`/`go.sum` 未变。

## 语义结论

1. **Antigravity 执行器重构：** 抽出共用的请求准备函数，bearer 令牌仍只发往既有 Cloud Code 端点（`daily-cloudcode-pa.googleapis.com` 在基线已存在）。
2. **Copilot 执行器：** 拆分授权与发送，新增请求日志走既有记录路径；`TrustedAPI` 主机校验不变。
3. **缓存：** Antigravity 模型目录和思考分组写入既有 KV，键为认证 ID 的哈希；签名缓存增加按请求的作用域。日志助手新增有上限的内存响应捕获。
4. 思考参数、翻译器、冷却、Home 结果处理均为载荷与状态逻辑，无新增 I/O。README 赞助链接（10dianai.com）和图片只是文档，示例插件的 go.mod 不进入构建。

中央 Dockerfile 不变，仅更新 workflow 源码 SHA。审查未执行上游代码、未运行测试或扫描；不部署或重启服务。本地证据：`/root/upstream-release-review/cliproxyapi-v8.1.2/`。

## 其他上游

- CPA Usage Keeper：**无新版**（v2.1.1）。Watchtower：**无新版**（v1.24.1）。
