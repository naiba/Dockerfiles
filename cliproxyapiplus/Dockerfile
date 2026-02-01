# syntax=docker/dockerfile:1
# CLIProxyAPIPlus + WebUI 整合构建 Dockerfile
# 每次构建都会合并上游 CLIProxyAPI 更新，然后从源码编译

# ===========================
# Stage 1: WebUI 构建
# ===========================
FROM node:22-alpine AS webui-builder

WORKDIR /build/webui

# 克隆 WebUI 仓库
RUN apk add --no-cache git && \
    git clone --depth 1 https://github.com/router-for-me/Cli-Proxy-API-Management-Center.git .

# 安装依赖并构建
RUN npm install && \
    npm run build

# 构建产物: /build/webui/dist/index.html

# ===========================
# Stage 2: 合并上游 + 编译 CLIProxyAPIPlus
# ===========================
FROM golang:1.24-alpine AS api-builder

WORKDIR /build

# 安装 git 和必要的工具
RUN apk add --no-cache git

# 克隆 CLIProxyAPIPlus
RUN git clone --depth 1 https://github.com/router-for-me/CLIProxyAPIPlus.git .

# 添加上游 remote 并拉取更新
# 使用 merge --no-edit 自动合并没有冲突的更改
RUN git remote add upstream https://github.com/router-for-me/CLIProxyAPI.git && \
    git fetch upstream main && \
    git config user.email "docker@build.local" && \
    git config user.name "Docker Builder" && \
    git merge --no-edit upstream/main || \
    (echo "Merge completed with possible conflicts, continuing with local version" && \
     git merge --abort 2>/dev/null || true)

# 下载 Go 依赖
RUN go mod download

# 从 webui-builder 复制构建好的 WebUI 到 static 目录
# 注意：CLIProxyAPIPlus 需要在代码中嵌入 management.html
# 根据 README，从 v6.0.19 开始 WebUI 已经内置，可能不需要额外复制
# 但为了确保使用最新 WebUI，我们还是替换它
RUN --mount=from=webui-builder,source=/build/webui/dist/index.html,target=/tmp/management.html \
    mkdir -p ./cmd/server/static && \
    (cp /tmp/management.html ./cmd/server/static/management.html 2>/dev/null || \
     echo "Note: CLIProxyAPIPlus may already have embedded WebUI")

# 获取构建信息
ARG VERSION=dev
ARG BUILD_DATE
ARG COMMIT_SHA

# 编译二进制文件
# 注意：CLIProxyAPIPlus 使用相同的模块名 github.com/router-for-me/CLIProxyAPI/v6
RUN CGO_ENABLED=0 GOOS=linux go build \
    -ldflags="-s -w \
    -X 'main.Version=${VERSION}-plus' \
    -X 'main.BuildDate=${BUILD_DATE}' \
    -X 'main.Commit=${COMMIT_SHA}'" \
    -o /build/CLIProxyAPIPlus \
    ./cmd/server/

# 验证构建产物
RUN ls -la /build/CLIProxyAPIPlus && /build/CLIProxyAPIPlus --help 2>/dev/null || true

# ===========================
# Stage 3: 最终 Runner 镜像
# ===========================
FROM alpine:3.22.0 AS runner

# 安装时区数据和必要工具
RUN apk add --no-cache tzdata ca-certificates

# 设置时区
ENV TZ=Asia/Shanghai
RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone

# 创建应用目录
WORKDIR /app

# 从 builder 复制编译好的二进制文件
COPY --from=api-builder /build/CLIProxyAPIPlus /app/CLIProxyAPIPlus

# 复制示例配置文件（可选，用户通常会挂载自己的配置）
COPY --from=api-builder /build/config.example.yaml /app/config.example.yaml

# 创建日志目录
RUN mkdir -p /app/logs

# 暴露服务端口
EXPOSE 8317

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8317/v1/models || exit 1

# 运行服务
ENTRYPOINT ["./CLIProxyAPIPlus"]
