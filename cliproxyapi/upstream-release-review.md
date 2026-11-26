# CLIProxyAPI v8.1.5 静态源码审查

结论：**通过**。已批准中央构建与运行边界内，本轮静态增量未发现恶意代码或恶意依赖证据。

- 基线：v8.1.4 `38fe929502f19f7cce03c69c19aacddf30f1ef5e`；[已提交批准报告](https://github.com/naiba/Dockerfiles/blob/029e62674700eb2a33958a727da398b94ca7dff7/cliproxyapi/review-result.json)。
- 候选：[v8.1.5 / 13d87daf65d1614570bbb59e6a26898bf8fd6cc4](https://github.com/router-for-me/CLIProxyAPI/commit/13d87daf65d1614570bbb59e6a26898bf8fd6cc4)，官方非 draft/prerelease release，tag 直接指向该 commit。
- 163 个变更路径，与 compare 一致；84 个非测试文件、10,111 行差异按 blob SHA 校验，去掉 13 个纯 import hunk 后的 9,997 行全量筛查；执行器端点拼接、视频接口和新增 URL 逐处核对，翻译器与思考参数逻辑只做筛查。依赖未变。

## 语义结论

1. **Gemini/Vertex 执行器：** 端点仍由既有配置的 baseURL 拼接；新增的 Vertex API 版本判断只解析 baseURL 路径（`http://vertex1` 等只出现在注释里）。
2. **OpenAI 视频接口：** 把用户提交的 `reference_image_urls` 解析进请求载荷，服务端不新增抓取。
3. Antigravity 额度/重试/模型枚举，Kimi、xAI、OpenAI 兼容执行器，冷却与 Home：均为既有端点上的载荷与状态逻辑。
4. README 赞助链接（移除 xcode.best、chenju，新增 apipdx.com）和图片只是文档。
5. 增量中**没有**新主机、凭据头、进程执行、环境变量读取、文件写入或 embed。

中央 Dockerfile 不变，仅更新 workflow 源码 SHA。审查未执行上游代码、未运行测试或扫描；不部署或重启服务。本地证据：`/root/upstream-release-review/cliproxyapi-v8.1.5/`。

## 其他上游

- CPA Usage Keeper：**无新版**（v2.1.2）。Watchtower：**无新版**（v1.24.2）。
