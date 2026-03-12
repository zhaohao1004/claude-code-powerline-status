# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个 Claude Code Powerline 状态栏项目，为 Claude Code CLI 工具提供实时状态显示。项目使用纯 Bash 实现，通过读取 stdin 的 JSON 数据并输出 ANSI 转义序列来渲染 Powerline 风格的状态栏。

## 核心命令

### 测试和验证
```bash
# 运行完整测试套件
./run.sh test

# 查看演示（7个场景）
./run.sh demo

# 验证项目完整性
./run.sh verify
```

### 安装和卸载
```bash
# 安装到系统
./run.sh install

# 从系统卸载
./run.sh uninstall
```

### 本地测试
```bash
# 测试特定 JSON 输入
echo '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":25}}' \
  | ./src/statusline.sh

# 调试模式
bash -x ./src/statusline.sh <<< '{"workspace":{"current_dir":"/tmp"}}'
```

## 架构设计

### 核心脚本：src/statusline.sh

**数据流：**
```
stdin (JSON) → jq 解析 → 提取数据 → 构建 Powerline 分段 → stdout (ANSI 转义序列)
```

**主要函数模块：**

1. **JSON 解析层** (`safe_jq`, 主函数中的数据提取)
   - 从 stdin 读取 JSON
   - 提取：current_dir, model_name, used_percentage, input_tokens, output_tokens, worktree_name, cost
   - 使用 `// "default"` 语法处理 null 值

2. **Powerline 渲染层** (`powerline_segment`, `render_progress_bar`)
   - 全局变量 `last_bg_color` 跟踪上一段背景色
   - 分段 = 分隔符（上一段背景色→当前背景色）+ 内容
   - 使用 256 色 ANSI 转义序列：`\033[48;5;{bg}m\033[38;5;{fg}m`

3. **信息获取层** (`build_*_segment` 系列)
   - **项目名**：`basename $cwd`
   - **Git 信息**：`git status --porcelain` + 缓存（5秒 TTL）
   - **Context**：百分比 → 动态颜色 + 进度条（▓/░）
   - **模型**：简化显示名称（claude-sonnet-4-6 → Sonnet）
   - **Worktree/成本**：可选显示

4. **缓存机制** (`get_cache_file`, `read_cache`, `write_cache`)
   - 缓存路径：`/tmp/claude-statusline-{hash}.cache`
   - 基于文件修改时间判断过期
   - 主要用于 Git 信息（避免频繁调用 git status）

### 分段显示顺序
```
项目名 → Git 信息 → Worktree（可选）→ 模型 → Context → 成本（可选）
```

### 颜色方案
- 项目名：蓝色 (34)
- Git：绿色 (28)
- Worktree：紫色 (61)
- 模型：橙色 (208)
- Context：动态（绿 <40% → 黄 40-69% → 红 ≥70%）
- 成本：灰色 (236)

## 关键技术细节

### Powerline 分隔符实现
分隔符的颜色规则：
- 前景色 = 上一段的背景色
- 背景色 = 当前段的背景色
- 第一个分段没有分隔符

### Git 信息缓存
- 缓存键：`git-{cwd}` 的 SHA256 哈希
- TTL：5 秒（`CACHE_TTL` 常量）
- 过期检查：当前时间 - 文件修改时间 < TTL
- 缓存整个渲染后的分段（包含 ANSI 转义序列）

### 进度条算法
```bash
filled = percentage / 10  # 10格进度条
empty = 10 - filled
bar = '▓' * filled + '░' * empty
```

### 错误处理策略
1. JSON 解析失败 → 输出默认状态栏
2. 非 Git 仓库 → 显示 "not a repo"
3. null 值 → 使用默认值（`safe_jq` 函数）
4. 缺少依赖（jq）→ 返回错误

## 测试架构

### tests/test.sh 包含：
- **基础功能测试**：JSON 解析、模型信息、Worktree、成本
- **边界测试**：null 值、极值（5%、85%）
- **Git 集成测试**：Git 仓库、非 Git 目录
- **性能测试**：100次迭代（应 < 200ms/次）、缓存效果
- **视觉测试**：完整示例输出

### 运行单个测试
```bash
# 修改 tests/test.sh，只保留需要的 run_test 调用
./tests/test.sh
```

## 开发工作流

### 1. 修改代码
```bash
# 使用 shellcheck 检查语法
shellcheck src/statusline.sh

# 格式化代码（可选）
shfmt -w src/statusline.sh
```

### 2. 测试验证
```bash
# 运行测试套件
./run.sh test

# 查看视觉效果
./run.sh demo

# 手动测试特定场景
echo '{"workspace":{"current_dir":"/path/to/git/repo"},"context_window":{"used_percentage":75}}' \
  | ./src/statusline.sh
```

### 3. 调试技巧
```bash
# 查看变量值
bash -x ./src/statusline.sh <<< '{"workspace":{"current_dir":"/tmp"}}' 2>&1 | grep "pct_int"

# 查看 ANSI 输出
echo '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":50}}' \
  | ./src/statusline.sh | cat -v

# 测试 JSON 解析
echo '{"workspace":{"current_dir":"/tmp"}}' | jq '.workspace.current_dir // "unknown"'
```

## 代码风格指南

遵循 Google Shell Style Guide，关键点：
- 使用 `local` 声明局部变量
- 函数名使用 snake_case
- 常量使用 UPPER_CASE
- 使用 `[[ ]]` 而不是 `[ ]` 进行条件测试
- 使用 `$((expression))` 进行算术运算
- 使用 `readonly` 声明常量

## 常见修改场景

### 添加新的分段
1. 在 `build_statusline()` 中提取数据
2. 创建 `build_new_segment()` 函数
3. 在适当位置调用（注意 `last_bg_color` 的重置）
4. 更新测试用例
5. 更新 demo.sh 演示

### 修改颜色方案
1. 修改 `COLOR_*` 常量
2. 调整 `get_context_color()` 的阈值
3. 更新文档中的颜色说明

### 调整缓存策略
1. 修改 `CACHE_TTL` 常量（默认 5 秒）
2. 或在 `build_git_segment()` 中调整缓存逻辑

### 添加新的 Git 信息
1. 修改 `build_git_segment()` 函数
2. 解析 `git status --porcelain` 输出
3. 注意性能影响（考虑缓存）

## 依赖关系

**必需依赖：**
- `jq` - JSON 解析（无可替代）

**可选依赖：**
- `git` - Git 信息获取
- `bc` - 成本计算（浮点运算）
- `shasum` / `sha256sum` - 缓存键生成

## 配置说明

Claude Code 配置文件：`~/.claude/settings.json`
```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 1
  }
}
```

- `type`: 固定为 "command"
- `command`: 脚本绝对路径
- `padding`: 水平间距（0-10）

## 项目文件结构

```
status-bar/
├── src/statusline.sh        # 主脚本（核心实现）
├── tests/test.sh            # 测试套件
├── scripts/                 # 工具脚本
│   ├── install.sh          # 安装脚本
│   ├── uninstall.sh        # 卸载脚本
│   ├── demo.sh             # 演示脚本
│   └── verify.sh           # 验证脚本
├── run.sh                   # 便捷入口脚本
├── config/                  # 配置示例
│   └── settings.example.json
└── docs/                    # 文档
    ├── CONTRIBUTING.md
    ├── PROJECT_SUMMARY.md
    └── QUICK_REFERENCE.md
```

## 性能考虑

- 目标执行时间：< 200ms
- Git 信息缓存：避免频繁调用 `git status`
- 使用 `--no-optional-locks` 避免 Git 锁竞争
- 避免子进程：使用 bash 内置功能（`${var%.*}` 代替 `cut`）
- 缓存文件清理：脚本退出时删除超过 1 天的缓存

## 已知限制

1. **终端要求**：需要 256 色支持和 UTF-8 字符（Powerline 符号）
2. **Bash 版本**：需要 Bash 4.0+（使用 `[[ ]]` 和 `$(( ))` 语法）
3. **Git 缓存**：在 5 秒内可能不反映最新的 Git 状态
4. **跨平台**：`stat` 命令在 macOS 和 Linux 之间有差异（已处理）
