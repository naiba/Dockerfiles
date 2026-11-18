# CLIProxyAPI v8.0.77 静态源码审查

结论：**通过**。已批准中央构建与运行边界内，本轮静态增量未发现恶意代码或恶意依赖证据。

- 基线：v8.0.69 `f7ae8feeb3710319f524730849fbe32fde1751e4`；[已提交批准报告](https://github.com/naiba/Dockerfiles/blob/1d2fee82700697cbaea549be8bbe6ea7b5080dd8/cliproxyapi/review-result.json)。
- 候选：[v8.0.77 / a5e8f69e56309e1ef6d6872e667da81fdfbce2ce](https://github.com/router-for-me/CLIProxyAPI/commit/a5e8f69e56309e1ef6d6872e667da81fdfbce2ce)，官方非 draft/prerelease release，tag 直接指向该 commit。
- compare 文件列表截断在 300，因此以两端完整 tree 重算：**725 个变更路径**（317 非测试、408 测试）。非测试 blob 按 Git blob SHA 拉取并本地重算校验。
- 非测试差异 29,314 行：299 个纯 import hunk 机械分离并记录完整 import 增减；其余 25,847 行实质差异全量做敏感模式筛查，网络、凭据、文件、插件链逐段阅读。

## 按业务链的语义结论

1. **JSON/正则库替换：** 189 个文件 `encoding/json` → `moego/json`，26 个 `regexp` → `moego/regexp`，均为同接口替换。
2. **Muse Code 端点（新增）：** `/muse-code/*` 挂在既有 `AuthMiddleware` 后；`/models` 本地生成，`config/search/browser_open` 仅转发到所选 Meta 凭据的 origin（`base_url` 或既有默认 `https://api.meta.ai`），请求/响应头白名单，查询参数剥离 `key`/`auth_token`，16MiB 限制，走既有 auth manager HTTP 路径。
3. **插件宿主：** 嵌入方自定义 interceptor host 的委派包装；调度器 continuity/exclude 回调在进程内执行，panic 时熔断。原生插件仍在批准边界外。
4. **管理端凭据：** 上传认证文件改为 auth 目录内 0600 临时文件原子写入，并核对已删除的来源；持久化走运营方已配置的既有 token store。管理密钥 bcrypt 校验加缓存（随机 HMAC 摘要，1 小时 TTL，最多 64 条）。
5. **SIWC/Antigravity：** SIWC 绑定按凭据自身的 `proxy_url` 校验后使用；TOS 申诉 URL 写日志前去掉 query/fragment。
6. **日志与 cloak：** 本地错误诊断有界（32 条）且经过脱敏，只用于日志；cloak 新增运营方配置的正则替换，非法规则跳过。
7. 实质增量中**未新增**上游主机名、HTTP client/dialer、exec/syscall、环境变量读取、`go:embed` 或 `linkname`。内嵌模型 JSON 只有模型元数据；README/资源/examples 不进入中央构建。

## 依赖

- **`github.com/MoeForge/moego`**：从 `router-for-me/moego v0.1.2`（replace）换成上游 `MoeForge/moego v0.1.0-alpha.4`。proxy `.info` 的 Origin 指向 `refs/tags/v0.1.0-alpha.4` → `7fd853048dbc…`（annotated tag 已解引用核对）；zip 的 h1 本地重算，与 go.sum、sum.golang.org 一致；`router-for-me/moego` 是它的 GitHub fork。实际使用 `json/ojson/regexp/base64`（以及 `internal/jsonsimd`）：闭包只引用标准库，没有 net、exec、syscall、plugin 或 env 读取；`os` 只用于 linux/arm64 读取 `/proc/self/auxv` 检测 AES；linkname 只指向 runtime 分配器；19 个汇编文件是 SIMD 内核，只有 CPUID/XGETBV，没有系统调用。png/webp 未被引用。
- **`go.etcd.io/bbolt`**：同一版本 v1.5.0 由 indirect 变为 direct；导入它的 `internal/kvstore/bolt_store.go` blob 未变。

构建参数不变；运行时基础镜像随后由停更的 `alpine:3.22.0`（2025-05）升到 `alpine:3.24`，运行时只安装 `tzdata`、`ca-certificates`，健康检查用 busybox `wget`。审查未 clone、安装、构建、执行上游代码，也未运行测试或扫描；不部署或重启服务；`provenance:false` 保留。机器报告：[review-result.json](review-result.json)；本地证据：`/root/upstream-release-review/cliproxyapi-v8.0.77/`。

## 其他上游

- CPA Usage Keeper：**通过**，v2.1.1 `5c97bee91678e3cd9e75201a8025bfcaadf77681`（见 `cliproxyapiplus/upstream-release-review.md`）。
- Watchtower：v1.24.1（tag 对象 `c82f7a2` → `f45081047d683daceb9d3196dc8569bb6b534879`）**通过**，单独提交；中央 builder 同步升级到 Go 1.27.4（见 `watchtower/upstream-release-review.md`）。
