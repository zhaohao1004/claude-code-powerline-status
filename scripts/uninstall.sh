#!/bin/bash

# ==============================================================================
# Claude Code 状态栏卸载脚本
# 移除状态栏脚本和配置
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
    echo -e "${BOLD}${BLUE}  Claude Code 状态栏卸载程序${NC}"
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

# ===== 主卸载流程 =====

main() {
    print_header

    # 确认卸载
    echo -e "${YELLOW}警告: 此操作将卸载 Claude Code 状态栏${NC}"
    echo ""
    echo "将要删除:"
    echo "  - $CLAUDE_DIR/$SCRIPT_NAME"
    echo "  - settings.json 中的 statusLine 配置"
    echo ""
    echo -e "${YELLOW}是否继续? (y/n)${NC}"
    read -r response

    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_info "已取消卸载"
        exit 0
    fi

    echo ""

    # 1. 移除脚本
    echo -e "${BOLD}步骤 1/2: 移除状态栏脚本${NC}"
    echo ""

    local target_file="$CLAUDE_DIR/$SCRIPT_NAME"

    if [ -f "$target_file" ]; then
        # 备份
        local backup="${target_file}${BACKUP_SUFFIX}"
        cp "$target_file" "$backup"
        print_info "已备份: $backup"

        # 删除
        rm "$target_file"
        print_success "脚本已删除: $target_file"
    else
        print_warning "脚本不存在: $target_file"
    fi

    echo ""

    # 2. 移除配置
    echo -e "${BOLD}步骤 2/2: 移除 statusLine 配置${NC}"
    echo ""

    local settings_file="$CLAUDE_DIR/settings.json"

    if [ -f "$settings_file" ]; then
        # 备份配置文件
        cp "$settings_file" "${settings_file}${BACKUP_SUFFIX}"
        print_info "已备份: ${settings_file}${BACKUP_SUFFIX}"

        # 移除 statusLine 配置
        local temp_file=$(mktemp)
        jq 'del(.statusLine)' "$settings_file" > "$temp_file" && mv "$temp_file" "$settings_file"

        print_success "配置已移除: $settings_file"
    else
        print_warning "配置文件不存在: $settings_file"
    fi

    echo ""

    # 3. 清理缓存
    echo -e "${BOLD}清理缓存文件${NC}"
    echo ""

    local cache_count
    cache_count=$(find /tmp -name "claude-statusline-*.cache" 2>/dev/null | wc -l | tr -d ' ')

    if [ "$cache_count" -gt 0 ]; then
        find /tmp -name "claude-statusline-*.cache" -delete 2>/dev/null
        print_success "已清理 $cache_count 个缓存文件"
    else
        print_info "无需清理缓存"
    fi

    echo ""

    # 完成
    echo -e "${BOLD}卸载完成${NC}"
    echo ""

    echo -e "${BOLD}后续步骤:${NC}"
    echo ""
    echo "  1. 重启 Claude Code"
    echo "  2. 如需重新安装，运行: ./install.sh"
    echo ""

    # 显示备份信息
    if [ -f "${target_file}${BACKUP_SUFFIX}" ]; then
        echo -e "${BOLD}备份文件:${NC}"
        echo ""
        echo "  - ${target_file}${BACKUP_SUFFIX}"
        echo "  - ${settings_file}${BACKUP_SUFFIX}"
        echo ""
        echo "  如需恢复，手动复制备份文件即可"
        echo ""
    fi
}

# 执行主函数
main "$@"
