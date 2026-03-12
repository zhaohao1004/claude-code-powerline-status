#!/bin/bash

# ==============================================================================
# 项目验证脚本
# 验证所有文件是否正确创建
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}${BLUE}=====================================${NC}"
echo -e "${BOLD}${BLUE}  项目完整性验证${NC}"
echo -e "${BOLD}${BLUE}=====================================${NC}"
echo ""

# 必需文件列表
REQUIRED_FILES=(
    "statusline.sh"
    "test.sh"
    "demo.sh"
    "install.sh"
    "uninstall.sh"
    "README.md"
    "CONTRIBUTING.md"
    "CHANGELOG.md"
    "LICENSE"
    ".gitignore"
    "settings.example.json"
    "PROJECT_SUMMARY.md"
    "QUICK_REFERENCE.md"
)

# 可执行文件
EXECUTABLES=(
    "statusline.sh"
    "test.sh"
    "demo.sh"
    "install.sh"
    "uninstall.sh"
)

echo -e "${BOLD}检查必需文件...${NC}"
echo ""

missing_files=0
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        size=$(ls -lh "$file" | awk '{print $5}')
        echo -e "${GREEN}✓${NC} $file ($size)"
    else
        echo -e "${RED}✗${NC} $file ${RED}(缺失)${NC}"
        ((missing_files++))
    fi
done

echo ""

if [ $missing_files -gt 0 ]; then
    echo -e "${RED}错误: 缺少 $missing_files 个文件${NC}"
    exit 1
fi

echo -e "${BOLD}检查可执行权限...${NC}"
echo ""

permission_issues=0
for file in "${EXECUTABLES[@]}"; do
    if [ -x "$file" ]; then
        echo -e "${GREEN}✓${NC} $file (可执行)"
    else
        echo -e "${YELLOW}⚠${NC} $file ${YELLOW}(缺少执行权限)${NC}"
        ((permission_issues++))
    fi
done

echo ""

if [ $permission_issues -gt 0 ]; then
    echo -e "${YELLOW}建议: 运行以下命令添加执行权限${NC}"
    echo ""
    echo "  chmod +x ${EXECUTABLES[*]}"
    echo ""
fi

echo -e "${BOLD}检查依赖...${NC}"
echo ""

if command -v jq &> /dev/null; then
    jq_version=$(jq --version)
    echo -e "${GREEN}✓${NC} jq 已安装 ($jq_version)"
else
    echo -e "${RED}✗${NC} jq 未安装 ${RED}(必需)${NC}"
fi

if command -v git &> /dev/null; then
    git_version=$(git --version | awk '{print $3}')
    echo -e "${GREEN}✓${NC} git 已安装 ($git_version)"
else
    echo -e "${YELLOW}⚠${NC} git 未安装 ${YELLOW}(可选)${NC}"
fi

if command -v bc &> /dev/null; then
    bc_version=$(bc --version | head -1)
    echo -e "${GREEN}✓${NC} bc 已安装 ($bc_version)"
else
    echo -e "${YELLOW}⚠${NC} bc 未安装 ${YELLOW}(可选)${NC}"
fi

echo ""

echo -e "${BOLD}运行快速测试...${NC}"
echo ""

test_input='{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":25}}'
if output=$(echo "$test_input" | ./statusline.sh 2>&1); then
    echo -e "${GREEN}✓${NC} 状态栏脚本运行正常"
    echo ""
    echo "输出示例:"
    echo "$output"
else
    echo -e "${RED}✗${NC} 状态栏脚本运行失败"
    echo "错误: $output"
fi

echo ""

echo -e "${BOLD}项目统计${NC}"
echo ""

total_lines=$(wc -l *.sh 2>/dev/null | tail -1 | awk '{print $1}')
doc_size=$(du -sh *.md 2>/dev/null | tail -1 | awk '{print $1}')
total_files=$(ls -1 | wc -l | tr -d ' ')

echo "  总文件数: $total_files"
echo "  代码行数: $total_lines 行"
echo "  文档大小: $doc_size"
echo ""

echo -e "${BOLD}${GREEN}✅ 项目验证完成！${NC}"
echo ""
echo -e "${BOLD}下一步:${NC}"
echo ""
echo "  1. 运行测试套件:     ${BLUE}./test.sh${NC}"
echo "  2. 查看演示:         ${BLUE}./demo.sh${NC}"
echo "  3. 安装到系统:       ${BLUE}./install.sh${NC}"
echo "  4. 查看项目总结:     ${BLUE}cat PROJECT_SUMMARY.md${NC}"
echo "  5. 查看快速参考:     ${BLUE}cat QUICK_REFERENCE.md${NC}"
echo ""
