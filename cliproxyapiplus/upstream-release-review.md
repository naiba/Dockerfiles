# cpa-usage-keeper v2.0.3 静态源码审查

结论：**通过**。固定增量及中央交付边界内未发现恶意代码或恶意依赖证据。

- 基线：`46fe6278db0c47a5460e882fa1742f15ab49bb14`。
- 候选：[9db74cfc380d11064af80cf1626efd6e3d068217](https://github.com/Willxup/cpa-usage-keeper/commit/9db74cfc380d11064af80cf1626efd6e3d068217)，正式 release/tag 已解析为唯一完整 commit。
- 完整树重算并校验：80 个变更文件，68 个文本 diff、262,688 bytes，142 个两端 blob 哈希验证；全部逐页读完。
- 新增、升级或来源变更依赖：0；清单、锁文件与安装入口复用已批准且未变的基线。

上游 is_native_key/access_provider 元数据仅为统计身份编码；事务提交后通知内存合并队列，并在本地 SQLite 分批登记，不扫描历史、不执行插件、不新增远端目的地。

仅定向增列；注册采用参数化查询与冲突不覆盖，既有原生 key 同步限定 native；无批量破坏、隐蔽删除或持久化执行。

插件身份在 API key 登录和会话恢复入口被拒绝；管理设置路由仍经 adminMiddleware，插件原始 principal 不返回，展示稳定标签和来源。

单卡显隐、用户触发复制、别名编辑及布局/翻译调整，只沿既有 API；无新脚本加载、外传接收方或动态执行。

完整阅读文档迁移、上游二进制打包 workflow 仅增加 docs 复制、全部测试和配置；12 PNG 两端仅 IHDR/IDAT/IEND，CRC、zlib 流、像素长度和结束位置均验证，且截图不进入中央 COPY 边界。

审查开始前锁定中央构建及运行边界，见机器记录中的 boundary（Keeper 实际 CGO=1；CLIProxyAPI CGO=0）。逐文件 SHA、完整 diff/hunk、唯一阅读范围及共享上下文保存于 `/root/upstream-release-review/keeper-v2.0.3`。本目录机器报告记录证据哈希；原始证据和 [机器记录](keeper-review-result.json) 配套使用。

未重新认证未变的已批准基线依赖、开发/CI/action/toolchain 实现及第三方插件；不无限递归。

静态增量结论不保证无漏洞/无 Bug，不审查正确性、质量或性能。

审查中未 clone、安装、构建、执行上游代码/产物，也未运行测试或扫描。

批准后中央 CI 构建发布独立于源审查；来源链不是签名 attestation；不部署或重启。

Watchtower v1.23.2 `cd5946be205ea0a60dd31235a11f04ac9851ebf6` 无新版，保持 pin。
