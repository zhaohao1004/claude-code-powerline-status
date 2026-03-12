#!/bin/bash

# ==============================================================================
# 快速演示脚本
# 展示状态栏在不同场景下的显示效果
# ==============================================================================

set -euo pipefail

# 颜色常量
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}${BLUE}=====================================${NC}"
echo -e "${BOLD}${BLUE}  状态栏演示${NC}"
echo -e "${BOLD}${BLUE}=====================================${NC}"
echo ""

# 场景 1: 低使用率
echo -e "${BOLD}场景 1: 低 Context 使用率 (15%)${NC}"
echo ""
test_input='{
  "workspace": {
    "current_dir": "/Users/zhaohao/Projects/my-app"
  },
  "model": {
    "display_name": "claude-sonnet-4-6"
  },
  "context_window": {
    "used_percentage": 15,
    "current_usage": {
      "input_tokens": 8000,
      "output_tokens": 2000
    }
  }
}'
echo "$test_input" | ./statusline.sh
echo ""

# 场景 2: 中等使用率
echo -e "${BOLD}场景 2: 中等 Context 使用率 (50%) - 黄色警告${NC}"
echo ""
test_input='{
  "workspace": {
    "current_dir": "/Users/zhaohao/Projects/api-server"
  },
  "model": {
    "display_name": "claude-sonnet-4-6"
  },
  "context_window": {
    "used_percentage": 50,
    "current_usage": {
      "input_tokens": 50000,
      "output_tokens": 10000
    }
  }
}'
echo "$test_input" | ./statusline.sh
echo ""

# 场景 3: 高使用率
echo -e "${BOLD}场景 3: 高 Context 使用率 (85%) - 红色警告${NC}"
echo ""
test_input='{
  "workspace": {
    "current_dir": "/Users/zhaohao/Projects/large-codebase"
  },
  "model": {
    "display_name": "claude-sonnet-4-6"
  },
  "context_window": {
    "used_percentage": 85,
    "current_usage": {
      "input_tokens": 85000,
      "output_tokens": 15000
    }
  }
}'
echo "$test_input" | ./statusline.sh
echo ""

# 场景 4: 使用 Worktree
echo -e "${BOLD}场景 4: 使用 Git Worktree${NC}"
echo ""
test_input='{
  "workspace": {
    "current_dir": "/Users/zhaohao/Projects/web-app"
  },
  "model": {
    "display_name": "claude-opus-4-6"
  },
  "context_window": {
    "used_percentage": 35,
    "current_usage": {
      "input_tokens": 25000,
      "output_tokens": 5000
    }
  },
  "worktree": {
    "name": "feature-auth-system"
  }
}'
echo "$test_input" | ./statusline.sh
echo ""

# 场景 5: 显示成本
echo -e "${BOLD}场景 5: 显示累计成本${NC}"
echo ""
test_input='{
  "workspace": {
    "current_dir": "/Users/zhaohao/Projects/production-app"
  },
  "model": {
    "display_name": "claude-sonnet-4-6"
  },
  "context_window": {
    "used_percentage": 65,
    "current_usage": {
      "input_tokens": 65000,
      "output_tokens": 12000
    }
  },
  "cost": {
    "total_cost_usd": 2.47
  }
}'
echo "$test_input" | ./statusline.sh
echo ""

# 场景 6: 完整信息
echo -e "${BOLD}场景 6: 完整信息（所有字段）${NC}"
echo ""
test_input='{
  "workspace": {
    "current_dir": "/Users/zhaohao/Projects/enterprise-app"
  },
  "model": {
    "display_name": "claude-opus-4-6"
  },
  "context_window": {
    "used_percentage": 72,
    "current_usage": {
      "input_tokens": 72000,
      "output_tokens": 18000
    }
  },
  "worktree": {
    "name": "hotfix-security"
  },
  "cost": {
    "total_cost_usd": 5.89
  }
}'
echo "$test_input" | ./statusline.sh
echo ""

# 场景 7: 非 Git 目录
echo -e "${BOLD}场景 7: 非 Git 目录${NC}"
echo ""
test_input='{
  "workspace": {
    "current_dir": "/tmp"
  },
  "model": {
    "display_name": "claude-sonnet-4-6"
  },
  "context_window": {
    "used_percentage": 10,
    "current_usage": {
      "input_tokens": 5000,
      "output_tokens": 1000
    }
  }
}'
echo "$test_input" | ./statusline.sh
echo ""

echo -e "${BOLD}颜色说明:${NC}"
echo ""
echo -e "  ${GREEN}🟢 绿色${NC}: Context 使用率 0-39% (安全)"
echo -e "  ${YELLOW}🟡 黄色${NC}: Context 使用率 40-69% (注意)"
echo -e "  ${RED}🔴 红色${NC}: Context 使用率 70-100% (警告)"
echo ""

echo -e "${BOLD}提示:${NC}"
echo "  - 进度条显示: ▓ (已用) / ░ (剩余)"
echo "  - Git 状态: ✓ (干净) / ⚡ (有修改)"
echo "  - wt: 表示 Worktree 名称"
echo "  - \$ 后面是累计成本"
echo ""
