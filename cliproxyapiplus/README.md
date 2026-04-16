# CLIProxyAPIPlus Docker 构建

![Build Status](https://github.com/naiba/Dockerfiles/workflows/cliproxyapiplus/badge.svg)

每天自动从源码编译 CLIProxyAPIPlus，并合并上游 CLIProxyAPI 更新。管理面板运行时自动下载，无需构建时集成。

- 镜像地址: `ghcr.io/naiba/cliproxyapiplus:latest`
- 支持架构: `linux/amd64`, `linux/arm64`

## 项目结构

- **CLIProxyAPIPlus**: https://github.com/router-for-me/CLIProxyAPIPlus (Plus 增强版)
- **CLIProxyAPI** (上游): https://github.com/router-for-me/CLIProxyAPI

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
  ghcr.io/naiba/cliproxyapiplus:latest
```

### 方式二：Docker Compose

```yaml
services:
  cli-proxy-api-plus:
    image: ghcr.io/naiba/cliproxyapiplus:latest
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

## 自动构建（GitHub Actions）

- **定时触发**: 每天凌晨 2 点 (UTC)
- **代码推送**: 推送 Dockerfile 修改时自动构建
- **手动触发**: 支持 workflow_dispatch
- **多架构**: `linux/amd64` + `linux/arm64`

构建流程：
1. Clone CLIProxyAPIPlus
2. 合并上游 CLIProxyAPI 最新代码
3. 编译并注入版本信息
4. 推送到 GitHub Container Registry

## 镜像标签

- `ghcr.io/naiba/cliproxyapiplus:latest` - 最新构建
- `ghcr.io/naiba/cliproxyapiplus:YYYYMMDD-COMMIT` - 带日期和 commit 的版本

## 注意事项

1. 合并上游时如有冲突，构建会失败
2. 管理面板运行时自动从 GitHub 下载，无需构建时集成
3. 首次拉取镜像需登录: `docker login ghcr.io -u USERNAME`
