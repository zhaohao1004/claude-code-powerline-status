#!/bin/bash

# ==============================================================================
# 项目根目录便捷脚本
# 提供统一的入口来运行各种命令
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 显示帮助信息
show_help() {
    cat << 'EOF'
Claude Code Powerline Status Bar - 项目管理工具

用法: ./run.sh <命令>

命令:
  install     安装状态栏到系统
  uninstall   从系统卸载状态栏
  test        运行测试套件
  demo        运行演示脚本
  verify      验证项目完整性
  help        显示此帮助信息

示例:
  ./run.sh install    # 安装到系统
  ./run.sh test       # 运行所有测试
  ./run.sh demo       # 查看演示

更多信息请访问: https://github.com/zhaohao1004/claude-code-powerline-status
EOF
}

# 主逻辑
case "${1:-help}" in
    install)
        echo "📦 安装状态栏..."
        "$SCRIPT_DIR/scripts/install.sh"
        ;;
    uninstall)
        echo "🗑️  卸载状态栏..."
        "$SCRIPT_DIR/scripts/uninstall.sh"
        ;;
    test)
        echo "🧪 运行测试套件..."
        "$SCRIPT_DIR/tests/test.sh"
        ;;
    demo)
        echo "🎬 运行演示..."
        "$SCRIPT_DIR/scripts/demo.sh"
        ;;
    verify)
        echo "✅ 验证项目..."
        "$SCRIPT_DIR/scripts/verify.sh"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ 未知命令: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
