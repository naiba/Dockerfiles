#!/bin/bash
# build.sh - CLIProxyAPIPlus + WebUI 本地构建脚本
# 先 clone CLIProxyAPIPlus 并合并上游 CLIProxyAPI，再构建 Docker 镜像

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR=$(mktemp -d)
# 脚本退出时清理临时目录
trap "rm -rf $BUILD_DIR" EXIT

echo -e "${GREEN}=== CLIProxyAPIPlus + WebUI 构建脚本 ===${NC}"

# 检查 Docker
echo -e "${YELLOW}检查 Docker 环境...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}错误: Docker 未安装${NC}"
    exit 1
fi

# Clone CLIProxyAPIPlus 并合并上游
echo -e "${YELLOW}克隆 CLIProxyAPIPlus ...${NC}"
git clone https://github.com/router-for-me/CLIProxyAPIPlus.git "$BUILD_DIR/plus-build"
cd "$BUILD_DIR/plus-build"

echo -e "${YELLOW}设置上游并合并 CLIProxyAPI ...${NC}"
git remote add upstream https://github.com/router-for-me/CLIProxyAPI.git
git fetch upstream main
git config user.email "docker@build.local"
git config user.name "Docker Builder"
git merge --no-edit upstream/main || \
    (echo -e "${YELLOW}合并冲突，保留 Plus 版本${NC}" && \
     git merge --abort 2>/dev/null || true)

# 复制 Dockerfile 到构建目录
cp "$SCRIPT_DIR/Dockerfile" "$BUILD_DIR/plus-build/"

# 获取构建信息
PLUS_COMMIT=$(git rev-parse --short HEAD)
VERSION="$(date +%Y%m%d)-${PLUS_COMMIT}"
BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo -e "${YELLOW}构建信息:${NC}"
echo "  版本: $VERSION"
echo "  构建日期: $BUILD_DATE"
echo "  合并后 Commit: $PLUS_COMMIT"

# 构建镜像
echo -e "${YELLOW}开始构建 Docker 镜像...${NC}"
docker build \
    --build-arg VERSION="$VERSION" \
    --build-arg BUILD_DATE="$BUILD_DATE" \
    --build-arg COMMIT_SHA="$PLUS_COMMIT" \
    -t cliproxyapiplus:latest \
    -t cliproxyapiplus:$VERSION \
    "$BUILD_DIR/plus-build"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}构建成功!${NC}"
    echo ""
    echo "镜像标签:"
    echo "  - cliproxyapiplus:latest"
    echo "  - cliproxyapiplus:$VERSION"
    echo ""
    echo "运行方式:"
    echo "  docker-compose up -d"
else
    echo -e "${RED}构建失败!${NC}"
    exit 1
fi
