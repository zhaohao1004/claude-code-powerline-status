#!/bin/bash

# ==============================================================================
# Claude Code 状态栏安装脚本
# 自动安装和配置 Powerline 状态栏
# ==============================================================================

set -euo pipefail

# 颜色常量
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# 配置
CLAUDE_DIR="$HOME/.claude"
SCRIPT_NAME="statusline.sh"
BACKUP_SUFFIX=".backup.$(date +%Y%m%d_%H%M%S)"

# ===== 工具函数 =====

print_header() {
    echo ""
    echo -e "${BOLD}${BLUE}=====================================${NC}"
    echo -e "${BOLD}${BLUE}  Claude Code 状态栏安装程序${NC}"
    echo -e "${BOLD}${BLUE}=====================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

check_command() {
    local cmd="$1"
    local package="${2:-$1}"

    if command -v "$cmd" &> /dev/null; then
        print_success "$cmd 已安装"
        return 0
    else
        print_warning "$cmd 未安装"
        echo -e "  安装命令: ${YELLOW}brew install $package${NC} (macOS)"
        echo -e "           ${YELLOW}sudo apt-get install $package${NC} (Ubuntu/Debian)"
        return 1
    fi
}

backup_file() {
    local file="$1"

    if [ -f "$file" ]; then
        local backup="${file}${BACKUP_SUFFIX}"
        cp "$file" "$backup"
        print_info "已备份: $backup"
    fi
}

# ===== 主安装流程 =====

main() {
    print_header

    # 1. 检查依赖
    echo -e "${BOLD}步骤 1/5: 检查依赖${NC}"
    echo ""

    local deps_ok=true

    # jq 是必需的
    if ! check_command "jq"; then
        deps_ok=false
        print_error "jq 是必需依赖，请先安装"
    fi

    # git 是可选的
    if ! check_command "git"; then
        print_warning "git 未安装，Git 信息功能将不可用"
    fi

    # bc 是可选的
    if ! check_command "bc"; then
        print_warning "bc 未安装，成本显示功能可能受限"
    fi

    if [ "$deps_ok" = false ]; then
        echo ""
        print_error "缺少必需依赖，请先安装后再运行此脚本"
        exit 1
    fi

    echo ""

    # 2. 准备目录
    echo -e "${BOLD}步骤 2/5: 准备目录${NC}"
    echo ""

    if [ ! -d "$CLAUDE_DIR" ]; then
        mkdir -p "$CLAUDE_DIR"
        print_success "创建目录: $CLAUDE_DIR"
    else
        print_info "目录已存在: $CLAUDE_DIR"
    fi

    echo ""

    # 3. 安装脚本
    echo -e "${BOLD}步骤 3/5: 安装状态栏脚本${NC}"
    echo ""

    local target_file="$CLAUDE_DIR/$SCRIPT_NAME"

    # 备份现有文件
    if [ -f "$target_file" ]; then
        backup_file "$target_file"
    fi

    # 复制脚本
    if [ -f "$(dirname "$0")/../src/$SCRIPT_NAME" ]; then
        cp "$(dirname "$0")/../src/$SCRIPT_NAME" "$target_file"
        chmod +x "$target_file"
        print_success "脚本已安装: $target_file"
    else
        print_error "找不到源文件: src/$SCRIPT_NAME"
        print_info "请确保在项目目录中运行此脚本"
        exit 1
    fi

    echo ""

    # 4. 更新配置
    echo -e "${BOLD}步骤 4/5: 更新 Claude Code 配置${NC}"
    echo ""

    local settings_file="$CLAUDE_DIR/settings.json"

    # 备份配置文件
    if [ -f "$settings_file" ]; then
        backup_file "$settings_file"
    fi

    # 检查是否已有 statusLine 配置
    if [ -f "$settings_file" ]; then
        if jq -e '.statusLine' "$settings_file" > /dev/null 2>&1; then
            print_warning "配置文件中已存在 statusLine 配置"
            echo -e "  ${YELLOW}是否覆盖? (y/n)${NC}"
            read -r response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
                print_info "跳过配置更新"
                echo ""
                echo -e "${YELLOW}请手动添加以下配置到 $settings_file:${NC}"
                echo ""
                echo '  "statusLine": {'
                echo '    "type": "command",'
                echo '    "command": "~/.claude/statusline.sh",'
                echo '    "padding": 1'
                echo '  }'
                echo ""
                # 跳到步骤 5
                echo -e "${BOLD}步骤 5/5: 完成${NC}"
                echo ""
                print_success "安装完成！"
                echo ""
                echo -e "${BOLD}下一步:${NC}"
                echo "  1. 重启 Claude Code"
                echo "  2. 执行命令测试状态栏"
                echo ""
                exit 0
            fi
        fi

        # 更新配置文件
        local temp_file=$(mktemp)
        jq '. + {
            "statusLine": {
                "type": "command",
                "command": "~/.claude/statusline.sh",
                "padding": 1
            }
        }' "$settings_file" > "$temp_file" && mv "$temp_file" "$settings_file"

        print_success "配置已更新: $settings_file"
    else
        # 创建新的配置文件
        cat > "$settings_file" <<'EOF'
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 1
  }
}
EOF
        print_success "配置文件已创建: $settings_file"
    fi

    echo ""

    # 5. 完成
    echo -e "${BOLD}步骤 5/5: 完成${NC}"
    echo ""

    print_success "安装完成！"
    echo ""

    # 测试脚本
    echo -e "${BOLD}测试状态栏:${NC}"
    echo ""
    echo '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":25}}' \
        | "$target_file"
    echo ""

    # 显示下一步
    echo -e "${BOLD}下一步:${NC}"
    echo ""
    echo "  1. ${GREEN}重启 Claude Code${NC}"
    echo "     - 退出当前会话"
    echo "     - 重新运行 claude 命令"
    echo ""
    echo "  2. ${GREEN}测试状态栏${NC}"
    echo "     - 执行简单命令，观察状态栏显示"
    echo "     - 修改文件，观察 Git 状态变化"
    echo ""
    echo "  3. ${GREEN}自定义配置（可选）${NC}"
    echo "     - 编辑 $target_file"
    echo "     - 调整颜色、缓存时间等参数"
    echo ""

    # 显示卸载信息
    echo -e "${BOLD}卸载（如需要）:${NC}"
    echo ""
    echo "  rm $target_file"
    echo ""
    echo "  然后从 $settings_file 中删除 statusLine 配置"
    echo ""

    # 显示文档链接
    echo -e "${BOLD}文档和支持:${NC}"
    echo ""
    echo "  - README: $(cd "$(dirname "$0")/.." && pwd)/README.md"
    echo "  - 快速参考: docs/QUICK_REFERENCE.md"
    echo "  - 问题反馈: GitHub Issues"
    echo ""
}

# 执行主函数
main "$@"
