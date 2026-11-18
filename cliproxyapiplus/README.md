# CLIProxyAPI 与 CPA Usage Keeper 镜像

![CLIProxyAPI](https://github.com/naiba/Dockerfiles/actions/workflows/cliproxyapi.yml/badge.svg) ![Keeper](https://github.com/naiba/Dockerfiles/actions/workflows/cliproxyapiplus-keeper.yml/badge.svg)

两个镜像都从审查过的固定完整提交构建，发布到同一个包 `ghcr.io/naiba/cliproxyapiplus`。管理面板运行时自动下载，无需构建时集成。

- CLIProxyAPI 镜像: `ghcr.io/naiba/cliproxyapiplus:latest`（构建配置在 [`../cliproxyapi/`](../cliproxyapi/)）
- CPA Usage Keeper 镜像: `ghcr.io/naiba/cliproxyapiplus:keeper`
- 支持架构: `linux/amd64`, `linux/arm64`

## 上游

- **CLIProxyAPI**: https://github.com/router-for-me/CLIProxyAPI（当前固定提交见 `.github/workflows/cliproxyapi.yml`，审查记录见 [CLIProxyAPI 审查记录](../cliproxyapi/upstream-release-review.md)）
- **CPA Usage Keeper**: https://github.com/Willxup/cpa-usage-keeper（当前固定 tag 与提交见 `.github/workflows/cliproxyapiplus-keeper.yml`，审查记录见 [Keeper 审查记录](upstream-release-review.md)）

## 快速开始

### 方式一：docker run

```bash
cp config.example.yaml config.yaml
# 编辑 config.yaml 添加你的配置

docker run -d \
  -p 8317:8317 \
  -v $(pwd)/config.yaml:/app/config.yaml:ro \
  -v $(pwd)/auths:/root/.cli-proxy-api \
  -v $(pwd)/logs:/app/logs \
  ghcr.io/naiba/cliproxyapiplus:latest
```

### 方式二：Docker Compose

```yaml
services:
  cli-proxy-api:
    image: ghcr.io/naiba/cliproxyapiplus:latest
    container_name: cli-proxy-api
    ports:
      - "8317:8317"
    volumes:
      - ./config.yaml:/app/config.yaml:ro
      - ./auths:/root/.cli-proxy-api
      - ./logs:/app/logs
    restart: unless-stopped
```

## 配置文件

创建 `config.yaml`（参考 `config.example.yaml`）:

```yaml
server:
  port: 8317
  api-keys:
    - "your-api-key-here"
```

## 访问方式

- API 服务: http://localhost:8317
- 管理面板: http://localhost:8317/management.html（运行时自动下载）

## CPA Usage Keeper

`ghcr.io/naiba/cliproxyapiplus:keeper` 由 workflow 校验 Keeper 的正式 tag 解析到审查过的完整提交后构建，用于独立保存和展示 CLIProxyAPI 用量统计。运行前需要在 CLIProxyAPI 的 `config.yaml` 中启用用量队列。`CPA_BASE_URL` 是 Keeper 访问 CPA 的服务端地址，`CPA_PUBLIC_URL` 是浏览器端“返回 CPA”的回跳地址；当浏览器实际使用的是其他域名、端口或路径时，请把它设为对应的公网可访问 URL。

> 升级提示：v2.0.0 涉及价格持久化及历史数据迁移，首次启动可能处于迁移阶段；升级前请保留独立的数据库备份。上游还会在正式 v2 版本启动后后台下载当前版本的 GitHub `version.txt` 附件，仅作内存文本校验，不保存或执行；该请求不携带应用业务数据，但接收方可观察出口 IP、版本及访问时间。

> 安全提示：`remote-management.allow-remote: true` 会开放管理接口能力。请仅在可信 Docker 网络、内网或防火墙保护下使用，使用高强度且唯一的 `secret-key`、`CPA_MANAGEMENT_KEY` 和 `LOGIN_PASSWORD`，不要提交这些密钥。Keeper 暴露到公网时必须保持 `AUTH_ENABLED=true`，并通过反向代理 HTTPS 或 Keeper TLS 配置提供加密访问。

```yaml
remote-management:
  allow-remote: true
  secret-key: "your-management-key-here"
usage-statistics-enabled: true
redis-usage-queue-retention-seconds: 3600
```

Docker 运行示例：

```bash
docker run -d \
  --name cpa-usage-keeper \
  --add-host=host.docker.internal:host-gateway \
  -p 8080:8080 \
  -v $(pwd)/keeper:/data \
  -e CPA_BASE_URL=http://host.docker.internal:8317 \
  -e CPA_PUBLIC_URL=http://localhost:8317 \
  -e CPA_MANAGEMENT_KEY=your-management-key \
  -e REDIS_QUEUE_ADDR=host.docker.internal:8317 \
  -e AUTH_ENABLED=true \
  -e LOGIN_PASSWORD=your-login-password \
  ghcr.io/naiba/cliproxyapiplus:keeper
```

同一个 CLIProxyAPI 实例只应运行一个 Usage Keeper 消费用量队列。

## 自动构建（GitHub Actions）

- **CLIProxyAPI**: `.github/workflows/cliproxyapi.yml` 以固定完整 SHA detached checkout `router-for-me/CLIProxyAPI`，用 `cliproxyapi/Dockerfile` 构建，推送 `latest` 和 `YYYYMMDD-<短 SHA>` 标签
- **Keeper**: `.github/workflows/cliproxyapiplus-keeper.yml` 获取固定 tag，校验其解析到审查过的完整提交后 detached checkout，用 `cliproxyapiplus/Dockerfile.keeper` 构建，推送 `keeper` 标签
- **触发**: 修改对应 Dockerfile 或 workflow 时自动构建，也支持 `workflow_dispatch`
- **多架构**: `linux/amd64` + `linux/arm64`

## 镜像标签

- `ghcr.io/naiba/cliproxyapiplus:latest` - CLIProxyAPI 最新审查版本
- `ghcr.io/naiba/cliproxyapiplus:YYYYMMDD-<短 SHA>` - CLIProxyAPI 对应日期和源码短 SHA 的构建
- `ghcr.io/naiba/cliproxyapiplus:keeper` - CPA Usage Keeper 最新审查版本
- `ghcr.io/naiba/cliproxyapiplus:ce` - 已停止更新：原先构建未审查的第三方 `HsnSaboor/CLIProxyAPIPlus`，workflow 已删除，请改用 `latest`

## 注意事项

1. 管理面板运行时自动从 GitHub 下载，无需构建时集成
2. 公开镜像支持匿名拉取
