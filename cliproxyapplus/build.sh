#!/bin/bash
# build.sh - CLIProxyAPIPlus + WebUI 构建脚本
# 每次构建都会合并上游 CLIProxyAPI 更新

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== CLIProxyAPIPlus + WebUI 构建脚本 ===${NC}"

# 获取构建信息
VERSION=$(date +%Y%m%d-%H%M%S)
BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
COMMIT_SHA=$(git ls-remote https://github.com/router-for-me/CLIProxyAPIPlus.git HEAD | cut -f1 | cut -c1-7)
UPSTREAM_COMMIT=$(git ls-remote https://github.com/router-for-me/CLIProxyAPI.git HEAD | cut -f1 | cut -c1-7)

echo -e "${YELLOW}构建信息:${NC}"
echo "  版本: $VERSION"
echo "  构建日期: $BUILD_DATE"
echo "  CLIProxyAPIPlus Commit: $COMMIT_SHA"
echo "  上游 CLIProxyAPI Commit: $UPSTREAM_COMMIT"

# 检查 Docker
echo -e "${YELLOW}检查 Docker 环境...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}错误: Docker 未安装${NC}"
    exit 1
fi

# 构建镜像
echo -e "${YELLOW}开始构建 Docker 镜像...${NC}"
docker build \
    --build-arg VERSION="$VERSION" \
    --build-arg BUILD_DATE="$BUILD_DATE" \
    --build-arg COMMIT_SHA="$COMMIT_SHA" \
    -t cliproxyapplus:latest \
    -t cliproxyapplus:$VERSION \
    .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}构建成功!${NC}"
    echo ""
    echo "镜像标签:"
    echo "  - cliproxyapplus:latest"
    echo "  - cliproxyapplus:$VERSION"
    echo ""
    echo "运行方式:"
    echo "  docker-compose up -d"
else
    echo -e "${RED}构建失败!${NC}"
    exit 1
fi
