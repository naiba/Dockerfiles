# CLIProxyAPI v8.1.7 静态源码审查

结论：**通过**。已批准中央构建与运行边界内，本轮静态增量未发现恶意代码或恶意依赖证据。

- 基线：v8.1.6 `0aaf6d1c3a9eb28979145d13c831637254319c92`；[已提交批准报告](https://github.com/naiba/Dockerfiles/blob/b1910f16eb9a8725d9e0b619e9fbeeebde746c85/cliproxyapi/review-result.json)。
- 候选：[v8.1.7 / 47f18e4d82bd72f7d2b5ecf5ede93e4837a4625e](https://github.com/router-for-me/CLIProxyAPI/commit/47f18e4d82bd72f7d2b5ecf5ede93e4837a4625e)，官方非 draft/prerelease release，tag 直接指向该 commit。
- 9 个变更路径，与 compare 一致；6 个非测试文件、**734 行差异全部逐行读完**。依赖未变。

## 语义结论

1. **插件宿主：** 调度器选择时会等待正在进行的插件重载（最多 10 秒）；重新配置失败时保留或恢复上一份注册；选择插件文件出错时不再清空正在运行的插件；注册调用区分“被拒绝”与“已接受后失败”。
2. Gemini 的 OpenAI chat 转换把后续用户消息放到 functionResponse 之前；调度优先级池的选择微调。
3. 增量中**没有**新主机、进程执行、环境变量读取、文件写入或 embed。

中央 Dockerfile 不变（构建器 `golang:1.27-alpine3.24`，运行时 `alpine:3.24`），仅更新 workflow 源码 SHA。审查未执行上游代码、未运行测试或扫描；不部署或重启服务。本地证据：`/root/upstream-release-review/cliproxyapi-v8.1.7/`。

## 其他上游

- CPA Usage Keeper：**无新版**（v2.1.2）。Watchtower：**无新版**（v1.24.2）。
