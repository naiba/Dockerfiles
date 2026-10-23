# Watchtower

固定上游：[`nicholas-fedor/watchtower v1.23.2`](https://github.com/nicholas-fedor/watchtower/tree/cd5946be205ea0a60dd31235a11f04ac9851ebf6)。

目标镜像：`ghcr.io/naiba-forks/watchtower`，架构 `linux/amd64`、`linux/arm64`；标签 `v1.23.2-cd5946b`、`v1.23.2`、`latest`。发布状态以 [Actions](https://github.com/naiba/Dockerfiles/actions/workflows/watchtower.yml) 和实际 registry 清单为准。

## 审查与构建

当前 v1.23.2 增量审查仅在既有中央源码白名单与 scratch 交付边界内通过，整版上游及无限制工具链执行仍为暂缓。已读 474 个项目差异、23 个模块升级、1501 个直接输入分片；1381 项上下文请求中 1287 项关闭、94 项按基线排除且仍未核验，中央材料阻断为 0。见 [审查报告](upstream-release-review.md) 和 [增量证据](incremental-review-evidence.json)。首次基线的 711 文件审查及 [基线证据](baseline-review-evidence.json) 原样保留。这是恶意行为来源审查，不是漏洞、功能或兼容性保证。原始阅读记录保存在维护者的 `/root/upstream-release-review/watchtower-v1.23.1/` 与 `/root/upstream-release-review/watchtower-v1.23.2/`，报告中的该路径不是公共下载地址。

中央工作流验证正式 tag 对应的完整 SHA，并校验批准记录中的 Dockerfile/工作流哈希。源码白名单为 `go.mod go.sum main.go cmd/ internal/ pkg/`。使用 Go 1.27.3（linux/amd64 摘要 `sha256:8aa2821993207ae840ce09e4223217efcd14e01f71525db734faf4232bd59999`），在 amd64 runner 交叉编译；不运行上游生成、安装或发布脚本。最终 scratch 镜像仅包含程序及固定 builder 的 CA，时区数据内嵌。

发布使用环境 `ALL` 的 `NAIBA_PAT`；只允许 master 发布，构建过程不接收此凭据。发布前验证两个子镜像真实架构、源码与中央提交标签，按摘要组装清单，并回读核验。多标签更新非原子；失败后可重跑失败任务，架构暂存标签绑定 run ID，版本及 latest 按已校验清单恢复。

`naiba-forks/watchtower` 仅存说明；实际维护在本仓库。镜像 source 标签用于关联说明仓库，`ba.nai.watchtower.upstream.source` / `revision` 标注真实上游。旧 fork 特性（包括 `WATCHTOWER_DISABLE_IMAGES`）不作兼容承诺。scratch 不附带 shell、Docker CLI 或 credential helper；这些外部程序不属于本次批准的镜像输入。

只发布镜像，不自动修改部署或重启服务；已有自动更新服务若监听标签，可能自行拉取新版本。
