# 快速参考卡片

## 🚀 快速开始（30 秒）

```bash
# 1. 克隆并安装
git clone https://github.com/zhaohao1004/claude-code-powerline-status.git
cd claude-code-powerline-status && ./install.sh

# 2. 重启 Claude Code
# 退出当前会话，重新运行 claude 命令
```

## 📋 命令速查

### 安装和测试
```bash
./install.sh      # 安装状态栏
./test.sh         # 运行测试套件
./demo.sh         # 查看演示
./uninstall.sh    # 卸载状态栏
```

### 手动测试
```bash
# 基础测试
echo '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":25}}' \
  | ~/.claude/statusline.sh

# 完整测试
echo '{
  "workspace": {"current_dir": "/tmp"},
  "model": {"display_name": "claude-sonnet-4-6"},
  "context_window": {
    "used_percentage": 50,
    "current_usage": {"input_tokens": 25000, "output_tokens": 5000}
  },
  "worktree": {"name": "feature-1"},
  "cost": {"total_cost_usd": 1.23}
}' | ~/.claude/statusline.sh
```

## 🎨 颜色说明

| 使用率 | 颜色 | 含义 |
|--------|------|------|
| 0-39%  | 🟢 绿色 | 安全 |
| 40-69% | 🟡 黄色 | 注意 |
| 70-100% | 🔴 红色 | 警告 |

## 🔧 配置位置

```
~/.claude/
├── statusline.sh    # 主脚本
└── settings.json    # Claude Code 配置
```

## ⚙️ settings.json 示例

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 1
  }
}
```

## 📊 显示信息

| 分段 | 信息 | 示例 |
|------|------|------|
| 项目 | 当前目录 | `❰ my-app ❱` |
| Git | 分支+状态 | ` main ✓` |
| Worktree | 名称 | `wt: feature-1` |
| 模型 | 名称 | `Sonnet` |
| Context | 使用率 | `ctx ▓▓▓░░ 35%` |
| 成本 | 累计 | `$1.23` |

## 🐛 故障排查

### 状态栏不显示
```bash
# 1. 检查权限
ls -l ~/.claude/statusline.sh

# 2. 检查配置
jq . ~/.claude/settings.json

# 3. 手动测试
echo '{"workspace":{"current_dir":"/tmp"}}' \
  | ~/.claude/statusline.sh
```

### Git 信息不显示
```bash
# 检查 Git
git status
git --version
```

### 颜色异常
```bash
# 测试终端
echo -e "\033[41m Red \033[0m"
echo $TERM
```

## 🔍 性能优化

```bash
# 调整缓存时间（编辑 statusline.sh）
CACHE_TTL=10  # 默认 5 秒，增加到 10 秒
```

## 📝 日志查看

```bash
# 调试模式
claude --debug

# 查看错误
echo '{"workspace":{"current_dir":"/tmp"}}' \
  | bash -x ~/.claude/statusline.sh
```

## 🆘 获取帮助

- 📖 文档: `README.md`
- 🐛 问题: GitHub Issues
- 💬 讨论: GitHub Discussions
- 🤝 贡献: `CONTRIBUTING.md`

## 📦 依赖检查

```bash
# 必需
jq --version

# 可选
git --version
bc --version
```

## 🗑️ 卸载

```bash
./uninstall.sh
# 或手动
rm ~/.claude/statusline.sh
# 从 settings.json 删除 statusLine 配置
```

---

**保存此卡片以便快速查阅！**
