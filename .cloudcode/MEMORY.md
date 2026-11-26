# 上游版本审查约定

- 用户确认（本轮审查复盘）：以当前已批准版本完整 commit SHA 到最新正式版解析后完整 commit SHA 的增量为主，不重新审查整个仓库。必须核对完整变更清单，不能把 GitHub compare 截断结果当作完整差异。
- 用户确认（审查耗时复盘）：主项目增量完整检查；依赖先核对来源、实际选中版本与中央构建引用的包，再追踪相关敏感调用链。模块升级不等于全库函数参与交付，包导入不等于函数调用；禁止先通读整个依赖再判断是否相关。未使用的包、开发工具和测试依赖不展开，不重审 Go 生态；测试仅作为相关改动的辅助证据，不另做测试质量、正确性或性能审计。
- 开始即锁定上一版已批准的中央镜像构建入口、参数及运行边界。复用有来源证明的未变基线；静态引用不明确时定向核验，不用无限递归、执行上游代码或全库阅读替代范围判断。
- 按业务调用链合并阅读和证据记录，遵守输出上限但避免大量过细切片、重复对账及重复覆盖统计。已完成工作保持关闭，只补有理由的调用链缺口；保留语义化命名的证据与进度，观察超时不重做。
- 边界外未核验项明确披露，不冒充通过，也不默默扩大或改变批准范围。中央交付范围内有实质性证据缺口时仍暂缓；工作量大不是停止审查的理由。
- 审查与发布不授权直接部署或重启服务器。具体静态审查范围、结论及提交规范遵循 AGENTS.md。
- 仓库的三个固定 SHA 受审上游为 router-for-me/CLIProxyAPI（`.github/workflows/cliproxyapi.yml`，交付 cliproxyapiplus:latest）、Willxup/cpa-usage-keeper（`cliproxyapiplus-keeper.yml`，交付 :keeper）和 nicholas-fedor/watchtower（`watchtower.yml`）；旧的浮动 CLIProxyAPIPlus `ce` workflow 及其 Dockerfile 已按用户要求删除（`ce` 标签停止更新）。
- 查新版时必须把最新 release 的 tag 解析到完整 commit SHA 再与 pin 比对，不能只比 tag 名或用未认证 curl 的缓存结果。
- 上游 compare 文件列表上限 300，超过时用两端完整 tree 重算变更清单；可复用 `/root/upstream-release-review/` 下的 collect_fixed_sha_diff.py、split_import_only_hunks.py、go_module_reachable_packages.py、go_cross_module_reachability.py、go_dependency_reachable_diff.py。
- Watchtower Dockerfile 用 GOTOOLCHAIN=local 固定 builder 摘要；上游 go.mod 的 go 版本升高时必须同步换官方 golang alpine builder 摘要，并重算 review-approval.json 中的构建文件散列。
- 用户要求“该更新就更新”：审查通过直接更新 pin；中央 Dockerfile 的基础镜像/工具版本过时（如固定到旧补丁版、落后于上游 Dockerfile 的主版本）也直接更新、提交并跟踪 CI，不必先问。
- 用户要求：每次“再来”检查上游更新时，同时检查所有 Dockerfile 的构建器和运行环境能否升级，有就一起升级。检查项：Go 最新稳定小版本（cliproxyapi、keeper、watchtower 摘要；watchtower 还要对齐上游 go.mod）、Node 最新 LTS（keeper web）、Python 最新稳定版（akshare，同步改 APP_HOME 路径）、Alpine 最新小版本、akshare 版本；浮动标签（beanstalkd 的 alpine、php8-fpm 的 bitnami latest）靠每周定时重建。
- 构建器/运行环境升级的验证方式：Go/Node 先用对应官方工具链在本地按中央 Dockerfile 参数编译已审查的固定源码；Python 先用 pip dry-run 确认 x86_64/aarch64 全部依赖有该版本的预编译 wheel；发布后从 GHCR 镜像层核对关键路径存在。
