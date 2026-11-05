# CLIProxyAPI v8.0.57 静态源码审查

结论：**通过**。在已批准中央构建与运行边界内，本轮增量未发现恶意代码或恶意依赖证据。

- 已批准基线：v8.0.54 `78a9cc9aaa8ae90a66300d9cbddfe7c894307622`。
- 候选：[v8.0.57 / c2f402b45643f0740d70b9010fd7d8d0aab7ef65](https://github.com/router-for-me/CLIProxyAPI/commit/c2f402b45643f0740d70b9010fd7d8d0aab7ef65)，官方正式 release 的 tag 直接解析为该提交。
- 核对完整变更清单共 **127 个路径**，读完 **85 个非测试文件、6,800 行完整差异**，17 个阅读页记录精确范围及语义结论。其余 42 个 `_test.go` 文件不参与中央构建，本轮无需辅助解释，未展开或执行。
- 两侧完整 tree 均未截断，变化源码逐一校验 Git blob；完整 diff、阅读页及范围一致性已核验。哈希仅证明来源和覆盖，不替代语义阅读。

## 语义结论

错误分类、日志、模型缓存、凭据路由及 provider 请求转换沿既有配置端点和身份边界。新增 `tool_search` 只转换客户端工具调用 JSON，没有在服务器执行工具。OpenAI-compatible 摘要请求沿相同 baseURL/apiKey。

新增本地 KV 默认保存于 `<auth-dir>/kv.db`，可显式改路径或禁用；使用文件权限 0600 和 `cpa_kv` bucket，定时清理过期项。Home 优先且不可用时不自动落本地，Service 管理启动、重配和关闭。Claude 日期 pin 的持久化用途已明示。

## 新依赖

唯一新增模块 `go.etcd.io/bbolt v1.5.0`，官方来源 `etcd-io/bbolt`，不可变提交 `e7a8b2dd498494a3766ba24dd94d3509e5588485`。官方 annotated tag 解引用、registry Origin、sumdb 与候选 go.sum 一致。

已核验中央 KV 到 Open、事务、bucket、游标和页写回的敏感链：打开、映射、同步和扩容都作用于传入的同一数据库文件；没有额外网络目的地、shell 或隐藏凭据读取。Linux 运行时外部库为既有 `x/sys/unix`，选中版本仍为根模块的 v0.48.0。CLI、生成器、测试和非 Linux 后端未被当作实际运行调用展开。

## 边界与证据

继续使用中央 Go 1.26 Alpine / `CGO_ENABLED=0` / `go build ./cmd/server/` 和 Alpine 3.22.0 运行时；仅更新 workflow SHA。复用未变的 moego v0.1.2 与原生插件禁用基线。审查阶段没有运行上游代码、安装、构建、测试或扫描；通过后才执行现有发布 CI。

完整报告见 [review-result.json](review-result.json)，含逐路径范围与不可变 blob。原始来源、17 页语义回执、依赖调用链和完整性校验保存在 `/root/upstream-release-review/cliproxyapi-v8.0.57/`。

本结论不保证漏洞、正确性或性能；来源一致不等于签名供应链证明，现有 `provenance:false` 限制保留。发布镜像后不自动部署或重启服务器。
