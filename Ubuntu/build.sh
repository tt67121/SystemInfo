#!/bin/bash

# 编译 C++ 项目的自动脚本
# 使用方法：将此脚本放在与 main.cpp 同级目录，然后执行：./compile_cpp.sh

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # 恢复默认颜色

# 项目信息
PROJECT_NAME="my_project"
SOURCE_FILE="main.cpp"
EXECUTABLE="DomeAPP"

# 显示编译模式选择菜单
echo -e "${YELLOW}请选择编译模式：${NC}"
echo "1. Debug (调试模式 - 包含调试信息，无优化)"
echo "2. Release (发布模式 - 优化代码，移除调试信息)"
echo

read -p "请输入选项 [1-2]: " choice
echo

# 根据选择设置编译模式
case $choice in
    1)
        BUILD_TYPE="debug"
        BUILD_DIR="build/${BUILD_TYPE}"
        COMPILER_FLAGS="-std=c++17 -g -O0 -Wall -Wextra -pedantic -D_DEBUG"
        echo -e "${YELLOW}已选择 DEBUG 模式编译${NC}"
        ;;
    2)
        BUILD_TYPE="release"
        BUILD_DIR="build/${BUILD_TYPE}"
        COMPILER_FLAGS="-std=c++17 -O3 -s -DNDEBUG -Wall -Wextra -pedantic"
        echo -e "${YELLOW}已选择 RELEASE 模式编译${NC}"
        ;;
    *)
        echo -e "${RED}错误：无效的选项 '$choice'${NC}"
        exit 1
        ;;
esac

# 通用编译设置
COMPILER="g++"
LINKER_FLAGS=""
INCLUDE_DIRS=""
LIBRARY_DIRS=""
LIBRARIES=""

# 检查源文件是否存在
if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "${RED}错误：未找到源文件 $SOURCE_FILE${NC}"
    exit 1
fi

# 创建构建目录
mkdir -p "$BUILD_DIR"

# 检查编译器是否安装
if ! command -v $COMPILER &> /dev/null; then
    echo -e "${YELLOW}未找到 $COMPILER，正在尝试安装...${NC}"
    sudo apt update
    sudo apt install -y build-essential
    if ! command -v $COMPILER &> /dev/null; then
        echo -e "${RED}安装 $COMPILER 失败，请手动安装${NC}"
        exit 1
    fi
    echo -e "${GREEN}$COMPILER 安装成功${NC}"
fi

# 编译代码
echo -e "${YELLOW}正在编译 $SOURCE_FILE...${NC}"
$COMPILER $COMPILER_FLAGS $INCLUDE_DIRS "$SOURCE_FILE" -o "$BUILD_DIR/$EXECUTABLE" $LIBRARY_DIRS $LIBRARIES $LINKER_FLAGS

# 检查编译结果
if [ $? -eq 0 ]; then
    echo -e "${GREEN}编译成功！可执行文件位于：$BUILD_DIR/$EXECUTABLE${NC}"
    
    # 询问是否运行程序
    read -p "是否运行程序？(y/n): " run_choice
    if [ "$run_choice" = "y" ] || [ "$run_choice" = "Y" ]; then
        echo -e "${YELLOW}正在运行程序...${NC}"
        cd "$BUILD_DIR"
        ./"$EXECUTABLE"
        cd ..
    fi
else
    echo -e "${RED}编译失败！请检查错误信息${NC}"
    exit 1
fi    
