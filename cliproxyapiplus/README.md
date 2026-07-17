# CLIProxyAPIPlus Docker 构建

![Build Status](https://github.com/naiba/Dockerfiles/workflows/cliproxyapiplus/badge.svg)

从源码编译 CLIProxyAPIPlus 和 CLIProxyAPI。管理面板运行时自动下载，无需构建时集成。另从审计后的固定提交构建 CPA Usage Keeper 镜像用于用量统计。

- CLIProxyAPIPlus 镜像: `ghcr.io/naiba/cliproxyapiplus:ce`
- CPA Usage Keeper 镜像: `ghcr.io/naiba/cliproxyapiplus:keeper`
- 支持架构: `linux/amd64`, `linux/arm64`

## 项目结构

- **CLIProxyAPIPlus**: https://github.com/HsnSaboor/CLIProxyAPIPlus (Plus 增强版，构建 `ce`)
- **CLIProxyAPI** (上游): https://github.com/router-for-me/CLIProxyAPI
- **CPA Usage Keeper**: https://github.com/Willxup/cpa-usage-keeper（固定构建 `v1.13.3`，提交 `32321c0952d33c1c09444d5a30d44cf3930db00d`）

## 快速开始

### 方式一：使用预构建镜像（推荐）

```bash
docker login ghcr.io -u USERNAME -p TOKEN

cp config.example.yaml config.yaml
# 编辑 config.yaml 添加你的配置

docker run -d \
  -p 8317:8317 \
  -v $(pwd)/config.yaml:/app/config.yaml:ro \
  -v $(pwd)/auths:/root/.cli-proxy-api \
  -v $(pwd)/logs:/app/logs \
  ghcr.io/naiba/cliproxyapiplus:ce
```

### 方式二：Docker Compose

```yaml
services:
  cli-proxy-api-plus:
    image: ghcr.io/naiba/cliproxyapiplus:ce
    container_name: cli-proxy-api-plus
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

`ghcr.io/naiba/cliproxyapiplus:keeper` 从 `Willxup/cpa-usage-keeper` 的 `v1.13.3` 构建，并校验该 tag 指向审计后的完整提交 `32321c0952d33c1c09444d5a30d44cf3930db00d`，用于独立保存和展示 CLIProxyAPI 用量统计。运行前需要在 CLIProxyAPIPlus 的 `config.yaml` 中启用用量队列。`CPA_BASE_URL` 是 Keeper 访问 CPA 的服务端地址，`CPA_PUBLIC_URL` 是浏览器端“返回 CPA”的回跳地址；当浏览器实际使用的是其他域名、端口或路径时，请把它设为对应的公网可访问 URL。

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

同一个 CLIProxyAPIPlus 实例只应运行一个 Usage Keeper 消费用量队列。

## 自动构建（GitHub Actions）

- **CLIProxyAPIPlus CE workflow**: `.github/workflows/cliproxyapiplus.yml` 构建 `HsnSaboor/CLIProxyAPIPlus`，推送 `ce` 标签
- **CLIProxyAPI workflow**: `.github/workflows/cliproxyapi.yml` 从 `router-for-me/CLIProxyAPI` 的固定完整提交构建，推送 `latest` 和日期加短 SHA 标签
- **Keeper workflow**: `.github/workflows/cliproxyapiplus-keeper.yml` 校验 `cpa-usage-keeper` 的 `v1.13.3` tag 与审计提交一致后构建，推送 `keeper` 标签
- **手动触发**: 三个 workflow 都支持 `workflow_dispatch`
- **多架构**: `linux/amd64` + `linux/arm64`

构建流程：
1. CLIProxyAPIPlus CE workflow 直接构建 `HsnSaboor/CLIProxyAPIPlus`，生成 `ce`
2. CLIProxyAPI workflow 以固定完整 SHA detached checkout `router-for-me/CLIProxyAPI`，生成 `latest` 和日期加短 SHA 标签
3. Keeper workflow 解析 `v1.13.3` tag，校验其完整 SHA 后 detached checkout，再生成 `keeper`
4. 分别编译并注入版本信息，推送到 GitHub Container Registry

### 来源与不可变校验

- CLIProxyAPI workflow 直接获取并校验正式版本 `v7.2.84` 对应的完整提交 `fbe116071a0e46525edddd6398043eca8fd90a99`，然后以 detached HEAD 构建；workflow 实际以完整 SHA 为准。
- Keeper workflow 获取 `Willxup/cpa-usage-keeper` 的 `v1.13.3` tag，校验其解析到审计提交 `32321c0952d33c1c09444d5a30d44cf3930db00d`，然后以 detached HEAD 构建。

## 镜像标签

- `ghcr.io/naiba/cliproxyapiplus:ce` - CLIProxyAPIPlus CE 最新构建
- `ghcr.io/naiba/cliproxyapiplus:latest` - CLIProxyAPI 最新构建
- `ghcr.io/naiba/cliproxyapiplus:YYYYMMDD-<短 SHA>` - CLIProxyAPI 对应日期和源码短 SHA 的构建
- `ghcr.io/naiba/cliproxyapiplus:keeper` - CPA Usage Keeper，固定从 `Willxup/cpa-usage-keeper` 的 `v1.13.3` 审计提交构建

## 注意事项

1. CLIProxyAPIPlus CE、CLIProxyAPI 和 Keeper 使用不同 workflow，镜像标签请按用途选择
2. 管理面板运行时自动从 GitHub 下载，无需构建时集成
3. 首次拉取镜像需登录: `docker login ghcr.io -u USERNAME`
