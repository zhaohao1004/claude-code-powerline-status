# Claude Code Powerline 状态栏

一个功能丰富、美观的 Powerline 风格状态栏，为 Claude Code 实时显示关键开发信息。

![Status Bar Preview](https://via.placeholder.com/800x40?text=claude-code-powerline-status%20%E2%9D%B0%20claude-code-powerline-status%20%E2%9D%B1%20%E2%9D%B0%20%E2%94%A0%20main%20%E2%9C%93%20%E2%9D%B1%20%E2%9D%B0%20wt:%20feature%20%E2%9D%B1%20%E2%9D%B0%20Sonnet%20%E2%9D%B1%20%E2%9D%B0%20ctx%20%E2%96%93%E2%96%93%E2%96%93%E2%96%93%E2%96%93%E2%90%90%E2%90%90%E2%90%90%E2%90%90%E2%90%90%2050%%20%E2%9D%B1)

## ✨ 功能特性

### 📊 核心信息显示

- **📂 项目信息** - 当前工作目录名称
- **🌿 Git 状态** - 分支名、文件状态（修改、暂存、未跟踪）
- **🎯 Context 使用率** - 实时显示 token 使用情况，带进度条可视化
- **🌳 Worktree 信息** - Git worktree 名称（如果使用）
- **🤖 模型信息** - 当前使用的 Claude 模型
- **💰 成本统计** - 累计 API 调用成本

### 🎨 视觉设计

- **Powerline 风格** - 现代化的分段设计，带箭头分隔符
- **动态颜色** - Context 使用率自动变色（绿→黄→红）
- **进度条** - 直观的 10 格进度条显示
- **256 色支持** - 丰富的颜色表现

### ⚡ 性能优化

- **智能缓存** - Git 状态缓存 5 秒，避免频繁调用
- **快速响应** - 平均执行时间 < 200ms
- **轻量级** - 纯 Bash 实现，无外部依赖（除 jq）

### 🛡️ 健壮性

- **完善的错误处理** - JSON 解析失败、非 Git 仓库等场景
- **优雅降级** - 缺少信息时显示默认值
- **跨平台** - 支持 macOS 和 Linux

## 📋 系统要求

### 必需依赖

- **Bash** 4.0+
- **jq** - JSON 解析器

### 可选依赖

- **git** - Git 信息获取（无 git 时降级显示）
- **bc** - 数学计算（用于成本显示）

### 终端要求

- 支持 256 色
- 支持 UTF-8 字符（Powerline 符号）

## 🚀 快速开始

### 前置要求

确保系统已安装：
- **jq** (必需) - JSON 解析器
- **git** (可选) - Git 信息显示
- **bc** (可选) - 成本计算

**macOS:**
```bash
brew install jq git bc
```

**Ubuntu/Debian:**
```bash
sudo apt-get install jq git bc
```

### 方式 1: 一键安装（推荐）

```bash
# 克隆仓库
git clone https://github.com/zhaohao1004/claude-code-powerline-status.git
cd claude-code-powerline-status

# 安装到系统
./run.sh install
```

### 方式 2: 手动安装

```bash
# 1. 复制脚本到 Claude 配置目录
cp src/statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh

# 2. 更新配置文件
# 编辑 ~/.claude/settings.json，添加 statusLine 配置
```

### 验证安装

```bash
# 运行测试
./run.sh test

# 查看演示
./run.sh demo

# 验证项目
./run.sh verify
```

### 3. 配置 Claude Code

编辑 `~/.claude/settings.json`：

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 1
  }
}
```

### 4. 重启 Claude Code

重启 Claude Code 以使配置生效。

## 📁 项目结构

```
claude-code-powerline-status/
├── README.md                    # 项目文档
├── LICENSE                      # MIT 许可证
├── CHANGELOG.md                 # 版本更新日志
├── run.sh                       # 便捷运行脚本
│
├── src/                         # 源代码
│   └── statusline.sh            # 主状态栏脚本
│
├── scripts/                     # 工具脚本
│   ├── install.sh               # 安装脚本
│   ├── uninstall.sh             # 卸载脚本
│   ├── demo.sh                  # 演示脚本
│   └── verify.sh                # 验证脚本
│
├── tests/                       # 测试文件
│   └── test.sh                  # 测试套件
│
├── docs/                        # 文档
│   ├── CONTRIBUTING.md          # 贡献指南
│   ├── PROJECT_SUMMARY.md       # 项目总结
│   └── QUICK_REFERENCE.md       # 快速参考
│
└── config/                      # 配置示例
    └── settings.example.json    # Claude Code 配置示例
```

## 🧪 测试

### 运行测试套件

```bash
./run.sh test
```

测试包括：
- ✅ JSON 解析
- ✅ Git 信息获取
- ✅ Worktree 显示
- ✅ Context 使用率
- ✅ 颜色变化
- ✅ 性能测试
- ✅ 边界情况

## 📖 使用示例

### 示例 1: 干净的 Git 仓库

```
 ❰ my-project ❱   main ✓ ❱  Sonnet ❱  ctx ▓▓░░░░░░░░ 25% (15k/3k) ❱
```

### 示例 2: 有修改的 Git 仓库

```
 ❰ my-project ❱   feature-1 ⚡ M:3 S:1 ❱  Sonnet ❱  ctx ▓▓▓▓▓░░░░░ 50% ❱
```

### 示例 3: 使用 Worktree

```
 ❰ my-project ❱   main ✓ ❱  wt: feature-auth ❱  Sonnet ❱  ctx ▓▓▓▓▓▓▓░░░ 75% ❱  $0.85 ❱
```

### 示例 4: 非 Git 目录

```
 ❰ tmp ❱  not a repo ❱  Sonnet ❱  ctx ▓▓░░░░░░░░ 25% ❱
```

## 🎨 颜色说明

### Context 使用率颜色

| 使用率 | 颜色 | 说明 |
|--------|------|------|
| 0-39%  | 🟢 绿色 | 低使用率，安全区域 |
| 40-69% | 🟡 黄色 | 中等使用率，注意 |
| 70-100%| 🔴 红色 | 高使用率，接近上限 |

### Git 状态图标

| 图标 | 说明 |
|------|------|
| ✓    | 工作区干净 |
| ⚡    | 有文件修改 |
| M:n  | n 个修改的文件 |
| S:n  | n 个已暂存的文件 |
| ?:n  | n 个未跟踪的文件 |

## ⚙️ 配置选项

### 基本配置

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 1
  }
}
```

**参数说明：**
- `type`: 固定为 `"command"`
- `command`: 脚本路径（必须是绝对路径）
- `padding`: 水平间距（0-10），推荐 1

### 高级配置

修改 `statusline.sh` 中的常量：

```bash
CACHE_TTL=5           # Git 缓存时间（秒）
COLOR_BLUE=34         # 项目名背景色
COLOR_GREEN=28        # Git 背景色
COLOR_YELLOW=220      # 中等使用率颜色
COLOR_RED=196         # 高使用率颜色
```

## 🔧 故障排查

### 状态栏不显示

1. **检查脚本权限：**
   ```bash
   ls -l ~/.claude/statusline.sh
   # 应该显示 -rwxr-xr-x
   ```

2. **检查配置格式：**
   ```bash
   jq . ~/.claude/settings.json
   ```

3. **手动测试脚本：**
   ```bash
   echo '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":25}}' \
     | ~/.claude/statusline.sh
   ```

4. **查看错误日志：**
   ```bash
   claude --debug
   ```

### Git 信息不显示

- 确认当前目录是 Git 仓库：`git status`
- 检查 Git 是否安装：`git --version`
- 检查文件权限：`ls -la .git`

### 颜色显示异常

- 检查终端支持：`echo $TERM`
- 测试颜色：`echo -e "\033[41m Red Background \033[0m"`
- 尝试更换终端（推荐 iTerm2、Alacritty）

### 性能问题

- 增加缓存时间：编辑脚本中的 `CACHE_TTL`
- 减少显示项：注释掉不需要的分段
- 检查磁盘 I/O：确保缓存目录可写

## 📚 API 参考

### JSON 输入格式

Claude Code 会通过 stdin 传递以下 JSON 数据：

```json
{
  "workspace": {
    "current_dir": "/path/to/project"
  },
  "model": {
    "display_name": "claude-sonnet-4-6"
  },
  "context_window": {
    "used_percentage": 35.5,
    "current_usage": {
      "input_tokens": 25000,
      "output_tokens": 5000
    }
  },
  "worktree": {
    "name": "feature-1"
  },
  "cost": {
    "total_cost_usd": 0.45
  }
}
```

### 输出格式

脚本输出 ANSI 转义序列，Claude Code 会自动渲染：

```bash
\033[48;5;34m\033[38;5;231m claude-code-powerline-status \033[0m\033[48;5;28m\033[38;5;34m \033[0m...
```

## 🤝 贡献

欢迎贡献！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解详情。

### 开发设置

```bash
# 克隆仓库
git clone https://github.com/zhaohao1004/claude-code-powerline-status.git
cd claude-code-powerline-status

# 运行测试
./run.sh test

# 本地测试
echo '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":25}}' \
  | ./src/statusline.sh
```

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🙏 致谢

- [Claude Code](https://code.claude.com/) - Anthropic 的官方 CLI 工具
- [Powerline](https://github.com/powerline/powerline) - 状态栏设计灵感
- [cc-usage-bar](https://github.com/lionhylra/cc-usage-bar) - 参考实现

## 📝 更新日志

### v1.0.0 (2026-03-12)

- ✨ 初始版本发布
- 🎨 Powerline 风格设计
- 📊 Git 状态显示
- 🎯 Context 使用率可视化
- ⚡ 智能缓存机制
- 🛡️ 完善的错误处理

---

**开发者：** [zhaohao1004](https://github.com/zhaohao1004)

**问题反馈：** [GitHub Issues](https://github.com/zhaohao1004/claude-code-powerline-status/issues)

**文档：** [README.md](https://github.com/zhaohao1004/claude-code-powerline-status#readme)
