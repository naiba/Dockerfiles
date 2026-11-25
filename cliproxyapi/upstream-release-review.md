# CLIProxyAPI v8.1.4 静态源码审查

结论：**通过**。已批准中央构建与运行边界内，本轮静态增量未发现恶意代码或恶意依赖证据。

- 基线：v8.1.2 `85225381d89915595598ed13766cd79890c03a84`；[已提交批准报告](https://github.com/naiba/Dockerfiles/blob/8d4697a4b8311a89f9dfeca6e312ca1bb17537d2/cliproxyapi/review-result.json)。
- 候选：[v8.1.4 / 38fe929502f19f7cce03c69c19aacddf30f1ef5e](https://github.com/router-for-me/CLIProxyAPI/commit/38fe929502f19f7cce03c69c19aacddf30f1ef5e)，官方非 draft/prerelease release，tag 直接指向该 commit。
- 221 个变更路径，与 compare 一致；117 个非测试文件、11,000 行差异按 blob SHA 校验，去掉 14 个纯 import hunk 后的 10,868 行全量筛查；插件宿主、Home 调度、缓存和平台电源文件逐段阅读，翻译器逻辑只做筛查。依赖未变。

## 语义结论

1. **Windows 电源检测：** 新增文件使用 Win32 系统调用，只在 Windows 编译；Linux 仍是空实现。`power_windows_state.go` 没有构建标签，但只引用 fmt/sync/time，是纯状态逻辑。
2. **Home 调度：** 可以指定本地已安装的插件执行器，经既有插件宿主解析；插件被熔断或禁用时返回 503。
3. Google `extra_body` 思考参数、各翻译器、推理重放墓碑、请求级错误规则清洗：均为载荷与状态逻辑。
4. README 赞助链接（移除 rapidproxy、新增 subrouter.ai）和 SVG 图片只是文档。
5. 增量中**没有**新主机、凭据头、Linux 下的进程执行、环境变量读取、文件写入或 embed。

中央 Dockerfile 不变，仅更新 workflow 源码 SHA。审查未执行上游代码、未运行测试或扫描；不部署或重启服务。本地证据：`/root/upstream-release-review/cliproxyapi-v8.1.4/`。

## 其他上游

- CPA Usage Keeper：**通过**，v2.1.2 `047ae17d6df33e643af054a47433ac7aec4179aa`（见 `cliproxyapiplus/upstream-release-review.md`）。
- Watchtower：**无新版**（v1.24.2）。
