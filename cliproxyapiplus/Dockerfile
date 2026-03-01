# syntax=docker/dockerfile:1
# CLIProxyAPIPlus Dockerfile
# 构建前需准备好已合并 upstream 的源码及 WebUI 产物作为 context
# （workflow 或 build.sh 负责 clone + merge + WebUI 构建）

# ===========================
# Stage 1: 编译 CLIProxyAPIPlus
# ===========================
FROM golang:1.26-alpine AS api-builder

WORKDIR /build

# 复制已合并的源码（含 WebUI 产物）
COPY . .

# 下载 Go 依赖
RUN go mod download

# 获取构建信息
ARG VERSION=dev
ARG BUILD_DATE
ARG COMMIT_SHA

# 编译二进制文件
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
# Stage 2: 最终 Runner 镜像
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
