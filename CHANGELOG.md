# 更新日志

本项目的所有重要更改都将记录在此文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
并且本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### 新增
- 📁 重新组织项目结构 - 更清晰的目录层次
  - `src/` - 源代码
  - `scripts/` - 工具脚本
  - `tests/` - 测试文件
  - `docs/` - 文档
  - `config/` - 配置示例
- 🚀 添加 `run.sh` 便捷脚本 - 统一的项目入口
- 📖 更新所有文档中的路径引用

### 改进
- 🔧 脚本路径引用更新为相对路径
- 📚 文档结构更清晰

### 计划中
- 支持自定义主题
- 添加配置文件支持
- 支持更多 Git 状态信息（ahead/behind）
- OSC 8 可点击链接支持
- 国际化支持

## [1.0.0] - 2026-03-12

### 新增
- ✨ 初始版本发布
- 📂 项目信息显示 - 当前工作目录名称
- 🌿 Git 状态显示 - 分支名、文件状态（修改、暂存、未跟踪）
- 🎯 Context 使用率可视化 - 进度条和百分比显示
- 🌳 Worktree 信息 - Git worktree 名称显示
- 🤖 模型信息 - 当前使用的 Claude 模型（Sonnet/Opus/Haiku）
- 💰 成本统计 - 累计 API 调用成本显示

### 视觉设计
- 🎨 Powerline 风格分段设计
- 🌈 256 色支持
- 📊 10 格进度条（▓/░）
- 🔀 Powerline 箭头分隔符
- 🎨 动态颜色变化：
  - 🟢 绿色：Context < 40%
  - 🟡 黄色：Context 40-69%
  - 🔴 红色：Context ≥ 70%

### 性能优化
- ⚡ 智能缓存机制 - Git 状态缓存 5 秒
- 🚀 快速响应 - 平均执行时间 < 200ms
- 💾 临时缓存文件自动清理

### 健壮性
- 🛡️ 完善的错误处理
  - JSON 解析失败处理
  - 非 Git 仓库降级显示
  - 缺失字段的默认值处理
- 🔄 优雅降级
- 🌍 跨平台支持（macOS/Linux）

### 工具和文档
- 📖 完整的 README 文档
- 🧪 测试套件（13 个测试用例）
- 🎬 演示脚本（7 个场景）
- 📦 安装/卸载脚本
- 📋 配置示例
- 🤝 贡献指南
- 📜 MIT 许可证

### 技术细节
- 纯 Bash 实现
- 依赖：jq（必需）、git（可选）、bc（可选）
- 兼容 Bash 4.0+
- 支持 UTF-8 和 256 色终端

---

## 版本说明

- **[Unreleased]**: 计划中的功能
- **[1.0.0]**: 首个正式版本

## 升级指南

### 从无到 1.0.0

```bash
# 1. 克隆仓库
git clone https://github.com/zhaohao1004/claude-code-powerline-status.git
cd claude-code-powerline-status

# 2. 运行安装脚本
./install.sh

# 3. 重启 Claude Code
```

---

[Unreleased]: https://github.com/zhaohao1004/claude-code-powerline-status/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/zhaohao1004/claude-code-powerline-status/releases/tag/v1.0.0
