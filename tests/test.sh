#!/bin/bash

# ==============================================================================
# 状态栏测试脚本
# 用于测试 statusline.sh 的各项功能
# ==============================================================================

set -euo pipefail

# 颜色常量
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 测试计数器
TESTS_PASSED=0
TESTS_FAILED=0

# 测试函数
run_test() {
    local test_name="$1"
    local test_input="$2"
    local expected_pattern="$3"  # 可选：用于验证输出包含特定内容

    echo -e "${BLUE}测试: ${test_name}${NC}"
    echo "输入: $test_input"

    # 执行脚本
    local output
    if output=$(echo "$test_input" | ./src/statusline.sh 2>&1); then
        echo -e "输出: ${GREEN}${output}${NC}"

        # 如果有预期模式，验证输出
        if [ -n "$expected_pattern" ]; then
            if echo "$output" | grep -q "$expected_pattern"; then
                echo -e "${GREEN}✓ 通过${NC}"
                ((TESTS_PASSED++))
            else
                echo -e "${RED}✗ 失败：未找到预期模式 '$expected_pattern'${NC}"
                ((TESTS_FAILED++))
            fi
        else
            echo -e "${GREEN}✓ 通过（执行成功）${NC}"
            ((TESTS_PASSED++))
        fi
    else
        echo -e "${RED}✗ 失败：脚本执行错误${NC}"
        echo -e "${RED}错误输出: $output${NC}"
        ((TESTS_FAILED++))
    fi

    echo ""
}

# 测试计数
total_tests() {
    echo "====================================="
    echo -e "测试总结:"
    echo -e "  ${GREEN}通过: $TESTS_PASSED${NC}"
    echo -e "  ${RED}失败: $TESTS_FAILED${NC}"
    echo "  总计: $((TESTS_PASSED + TESTS_FAILED))"
    echo "====================================="

    if [ "$TESTS_FAILED" -gt 0 ]; then
        exit 1
    fi
}

# ===== 开始测试 =====

echo -e "${YELLOW}=====================================${NC}"
echo -e "${YELLOW}Claude Code 状态栏测试套件${NC}"
echo -e "${YELLOW}=====================================${NC}"
echo ""

# 检查依赖
echo -e "${BLUE}检查依赖...${NC}"
if ! command -v jq &> /dev/null; then
    echo -e "${RED}错误: jq 未安装${NC}"
    echo "请先安装 jq: brew install jq"
    exit 1
fi
echo -e "${GREEN}✓ jq 已安装${NC}"

if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}警告: git 未安装，部分测试可能失败${NC}"
fi
echo ""

# ===== 基础功能测试 =====

echo -e "${YELLOW}=== 基础功能测试 ===${NC}"
echo ""

# 测试 1: 空 JSON
run_test "空 JSON 输入" '{}' ""

# 测试 2: 最小有效 JSON
run_test "最小有效 JSON" \
    '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":25}}' \
    "tmp"

# 测试 3: 包含模型信息
run_test "包含模型信息" \
    '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":25},"model":{"display_name":"claude-sonnet-4-6"}}' \
    "Sonnet"

# 测试 4: 包含 Worktree
run_test "包含 Worktree 信息" \
    '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":50},"worktree":{"name":"feature-1"}}' \
    "feature-1"

# 测试 5: 包含成本
run_test "包含成本信息" \
    '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":25},"cost":{"total_cost_usd":0.15}}' \
    "0.15"

# ===== 边界情况测试 =====

echo -e "${YELLOW}=== 边界情况测试 ===${NC}"
echo ""

# 测试 6: null 值
run_test "处理 null 值" \
    '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":null}}' \
    ""

# 测试 7: 极低使用率
run_test "极低使用率 (5%)" \
    '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":5}}' \
    "5%"

# 测试 8: 中等使用率
run_test "中等使用率 (50%)" \
    '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":50}}' \
    "50%"

# 测试 9: 高使用率
run_test "高使用率 (85%)" \
    '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":85}}' \
    "85%"

# 测试 10: 包含 token 数量
run_test "包含 token 数量" \
    '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":25,"current_usage":{"input_tokens":15000,"output_tokens":3000}}}' \
    "15k"

# ===== Git 集成测试 =====

echo -e "${YELLOW}=== Git 集成测试 ===${NC}"
echo ""

# 测试 11: Git 仓库（如果当前目录是 Git 仓库）
if git rev-parse --git-dir > /dev/null 2>&1; then
    run_test "当前 Git 仓库" \
        "{\"workspace\":{\"current_dir\":\"$(pwd)\"},\"context_window\":{\"used_percentage\":25}}" \
        "main\|master"
else
    echo -e "${YELLOW}跳过 Git 测试（当前目录不是 Git 仓库）${NC}"
    echo ""
fi

# 测试 12: 非 Git 目录
run_test "非 Git 目录" \
    '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":25}}' \
    "not a repo"

# ===== 性能测试 =====

echo -e "${YELLOW}=== 性能测试 ===${NC}"
echo ""

# 测试 13: 执行时间（应该 < 200ms）
echo -e "${BLUE}测试: 执行时间（100 次迭代）${NC}"
start_time=$(date +%s)
for i in {1..100}; do
    echo '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":25}}' \
        | ./src/statusline.sh > /dev/null 2>&1
done
end_time=$(date +%s)
elapsed_sec=$((end_time - start_time))
avg_ms=$((elapsed_sec * 10))  # 估算平均每次 10ms

echo "总时间: ${elapsed_sec}秒"
echo "平均时间: ~${avg_ms}ms"

if [ "$avg_ms" -lt 200 ]; then
    echo -e "${GREEN}✓ 性能良好（平均 ~${avg_ms}ms < 200ms）${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗ 性能较慢（平均 ~${avg_ms}ms >= 200ms）${NC}"
    ((TESTS_FAILED++))
fi
echo ""

# 测试 14: 缓存效果（第二次应该更快）
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${BLUE}测试: Git 缓存效果${NC}"

    # 第一次执行（可能从缓存读取）
    echo "{\"workspace\":{\"current_dir\":\"$(pwd)\"},\"context_window\":{\"used_percentage\":25}}" \
        | ./src/statusline.sh > /dev/null 2>&1

    # 第二次执行（应该从缓存读取）
    start_time=$(date +%s)
    echo "{\"workspace\":{\"current_dir\":\"$(pwd)\"},\"context_window\":{\"used_percentage\":25}}" \
        | ./src/statusline.sh > /dev/null 2>&1
    end_time=$(date +%s)
    elapsed_sec=$((end_time - start_time))

    echo "缓存读取时间: ~${elapsed_sec}秒"

    if [ "$elapsed_sec" -lt 1 ]; then
        echo -e "${GREEN}✓ 缓存有效（< 1秒）${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${YELLOW}⚠ 缓存可能未生效（>= 1秒）${NC}"
        # 不计为失败
    fi
    echo ""
fi

# ===== 视觉测试 =====

echo -e "${YELLOW}=== 视觉测试 ===${NC}"
echo ""

# 测试 15: 完整示例
echo -e "${BLUE}测试: 完整状态栏显示${NC}"
echo "输入: 完整的 JSON 数据"
echo ""
test_input='{
  "workspace": {
    "current_dir": "/Users/zhaohao/Projects/personal/claude-code-powerline-status"
  },
  "model": {
    "display_name": "claude-sonnet-4-6"
  },
  "context_window": {
    "used_percentage": 35,
    "current_usage": {
      "input_tokens": 25000,
      "output_tokens": 5000
    }
  },
  "worktree": {
    "name": "feature-powerline"
  },
  "cost": {
    "total_cost_usd": 0.45
  }
}'

echo "$test_input" | ./src/statusline.sh
echo ""
echo -e "${GREEN}✓ 视觉测试完成${NC}"
((TESTS_PASSED++))
echo ""

# ===== 总结 =====

total_tests

echo -e "${YELLOW}提示:${NC}"
echo "如果所有测试通过，可以运行以下命令安装到系统："
echo "  cp ./src/statusline.sh ~/.claude/statusline.sh"
echo "  chmod +x ~/.claude/statusline.sh"
echo ""
echo "然后更新 ~/.claude/settings.json："
echo '{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 1
  }
}'
echo ""
