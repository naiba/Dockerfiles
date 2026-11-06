# Watchtower

固定上游：[`nicholas-fedor/watchtower v1.24.0`](https://github.com/nicholas-fedor/watchtower/tree/147aa6a534428e68eb1ba4f71918f6f35404624d)。

目标镜像：`ghcr.io/naiba-forks/watchtower`，架构 `linux/amd64`、`linux/arm64`；标签 `v1.24.0-147aa6a`、`v1.24.0`、`latest`。发布状态以 [Actions](https://github.com/naiba/Dockerfiles/actions/workflows/watchtower.yml) 和实际 registry 清单为准。

## 审查与构建

v1.23.2 → v1.24.0 的静态恶意行为增量审查**通过**，限既有中央构建与 scratch 交付边界。主项目 928 个变化路径按 636 个对齐单元核销；此前暂缓的 Compose 环境/标签文件、默认 process collector 和 RPC/codec 适用性证据已补齐，31 份适用 RPC 生产增量另有独立回执。没有恢复被撤销的聚合阅读声明。

见 [审查报告](upstream-release-review.md)、[增量证据](incremental-review-evidence.json) 和 [候选版最终结果](candidate-release-review.json)。首次 [基线证据](baseline-review-evidence.json) 保留；历史增量记录可从 Git 历史追溯。原始证据位于维护者的 `/root/upstream-release-review/watchtower-v1.24.0/`，不是公共下载地址。这是恶意行为来源审查，不是漏洞、功能或兼容性保证。

中央工作流验证正式 tag 对应的完整 SHA，并校验批准记录中的 Dockerfile/工作流哈希。源码白名单为 `go.mod go.sum main.go cmd/ internal/ pkg/`。使用 Go 1.27.3（linux/amd64 摘要 `sha256:8aa2821993207ae840ce09e4223217efcd14e01f71525db734faf4232bd59999`），在 amd64 runner 交叉编译；不运行上游生成、安装或发布脚本。最终 scratch 镜像仅包含程序及固定 builder 的 CA，时区数据内嵌。

发布使用环境 `ALL` 的 `NAIBA_PAT`；只允许 master 发布，构建过程不接收此凭据。发布前验证两个子镜像真实架构、源码与中央提交标签，按摘要组装清单，并回读核验。多标签更新非原子；失败后可重跑失败任务，架构暂存标签绑定 run ID，版本及 latest 按已校验清单恢复。

`naiba-forks/watchtower` 仅存说明；实际维护在本仓库。镜像 source 标签用于关联说明仓库，`ba.nai.watchtower.upstream.source` / `revision` 标注真实上游。旧 fork 特性（包括 `WATCHTOWER_DISABLE_IMAGES`）不作兼容承诺。scratch 不附带 shell、Docker CLI 或 credential helper；这些外部程序不属于本次批准的镜像输入。

只发布镜像，不自动修改部署或重启服务；已有自动更新服务若监听标签，可能自行拉取新版本。
