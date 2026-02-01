# CLIProxyAPIPlus + WebUI Docker 构建

![Build Status](https://github.com/naiba/Dockerfiles/workflows/cliproxyapiplus/badge.svg)

每次从源码编译 CLIProxyAPIPlus，自动合并上游 CLIProxyAPI 更新，并整合最新 WebUI。

- 镜像地址: `ghcr.io/naiba/cliproxyapiplus:latest`
- 支持架构: `linux/amd64`, `linux/arm64`

## 项目结构

- **CLIProxyAPIPlus**: https://github.com/router-for-me/CLIProxyAPIPlus (Plus 增强版)
- **CLIProxyAPI** (上游): https://github.com/router-for-me/CLIProxyAPI
- **WebUI**: https://github.com/router-for-me/Cli-Proxy-API-Management-Center

## 构建特性

1. **自动合并上游**: 每次构建时自动 `git merge upstream/main`
2. **WebUI 集成**: 同时构建最新 WebUI（单文件 HTML）
3. **多阶段构建**: 分离构建环境和运行环境，最终镜像最小化
4. **版本信息注入**: 编译时注入版本号、构建日期、commit hash

## 快速开始

### 方式一：使用预构建镜像（推荐）

GitHub Actions 每天自动构建并推送镜像到 GitHub Container Registry：

```bash
# 1. 登录 GitHub Container Registry
docker login ghcr.io -u USERNAME -p TOKEN

# 2. 准备配置文件
cp config.example.yaml config.yaml
# 编辑 config.yaml 添加你的配置

# 3. 运行
docker run -d \
  -p 8317:8317 \
  -v $(pwd)/config.yaml:/app/config.yaml:ro \
  -v $(pwd)/auths:/root/.cli-proxy-api \
  -v $(pwd)/logs:/app/logs \
  ghcr.io/naiba/cliproxyapiplus:latest
```

### 方式二：Docker Compose（使用预构建镜像）

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

### 方式三：本地构建

```bash
./build.sh
# 或
docker build -t cliproxyapiplus:latest .
```

## 配置文件

创建 `config.yaml`（参考 `config.example.yaml`）:

```yaml
server:
  port: 8317
  api-keys:
    - "your-api-key-here"

# 其他配置...
```

## 目录结构

```
.
├── Dockerfile          # 多阶段构建文件
├── docker-compose.yml  # Compose 配置
├── build.sh           # 一键构建脚本
├── config.yaml        # 你的配置文件（需自行创建）
├── auths/             # 认证数据（自动创建）
└── logs/              # 日志目录（自动创建）
```

## 访问方式

- API 服务: http://localhost:8317
- WebUI 管理界面: http://localhost:8317/management.html

## 自动构建（GitHub Actions）

GitHub Actions 工作流自动执行以下操作：

- **定时触发**: 每天凌晨 2 点 (UTC) 自动检查上游更新
- **代码推送**: 推送 Dockerfile 修改时自动构建
- **手动触发**: 支持 workflow_dispatch 手动触发
- **多架构**: 同时构建 `linux/amd64` 和 `linux/arm64`

### 工作流特性

1. 获取 CLIProxyAPIPlus 和 CLIProxyAPI 的最新 commit hash
2. 自动合并上游更新（`git merge upstream/main`）
3. 编译注入版本信息（日期 + commit hash）
4. 推送到 GitHub Container Registry
5. 使用 Docker Buildx 缓存加速构建

## 更新策略

每次运行 `docker build` 或 `./build.sh` 时：
1. 拉取 CLIProxyAPIPlus 最新代码
2. 拉取上游 CLIProxyAPI 最新代码
3. 自动合并上游更改（如有冲突会保留 Plus 版本）
4. 拉取 WebUI 最新代码
5. 重新编译所有组件

## 镜像标签

- `ghcr.io/naiba/cliproxyapiplus:latest` - 最新构建
- `ghcr.io/naiba/cliproxyapiplus:YYYYMMDD-COMMIT` - 带日期和 commit 的版本
- `ghcr.io/naiba/cliproxyapiplus:SHA` - 基于 commit SHA 的版本

## 注意事项

1. 合并上游时如有冲突，会保留 Plus 版本的更改
2. WebUI 从 v6.0.19 开始已内置，Dockerfile 会尝试替换为最新版本
3. 最终 runner 镜像基于 alpine:3.22.0，体积小巧
4. 首次拉取镜像需要登录 GitHub：`docker login ghcr.io -u USERNAME`
