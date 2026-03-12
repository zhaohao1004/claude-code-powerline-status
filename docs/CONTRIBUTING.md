# 贡献指南

感谢你对 Claude Code 状态栏项目的兴趣！我们欢迎所有形式的贡献。

## 🌟 贡献方式

### 报告问题

如果你发现了 bug 或有功能建议：

1. 检查 [Issues](https://github.com/zhaohao1004/claude-code-powerline-status/issues) 中是否已经有相关问题
2. 如果没有，创建新的 Issue，包含：
   - 清晰的标题和描述
   - 复现步骤（如果是 bug）
   - 预期行为和实际行为
   - 系统信息（OS、Bash 版本等）
   - 相关日志或截图

### 提交代码

1. **Fork 仓库**
   ```bash
   git clone https://github.com/zhaohao1004/claude-code-powerline-status.git
   cd claude-code-powerline-status
   ```

2. **创建分支**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **进行修改**
   - 遵循现有的代码风格
   - 添加必要的注释
   - 更新相关文档

4. **测试**
   ```bash
   # 运行测试套件
   ./test.sh

   # 测试特定场景
   ./demo.sh
   ```

5. **提交更改**
   ```bash
   git add .
   git commit -m "描述你的更改"
   ```

   提交消息格式：
   - `feat: 添加新功能`
   - `fix: 修复 bug`
   - `docs: 文档更新`
   - `style: 代码格式调整`
   - `refactor: 重构`
   - `test: 测试相关`
   - `chore: 构建/工具相关`

6. **推送分支**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **创建 Pull Request**
   - 清楚描述 PR 的目的和改动
   - 关联相关的 Issue
   - 等待代码审查

## 📝 开发指南

### 代码风格

**Bash 脚本:**
- 使用 `shellcheck` 检查代码
- 遵循 [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- 使用有意义的变量名
- 添加必要的注释

**示例:**
```bash
# 好的例子
get_context_color() {
    local pct="$1"
    local pct_int=${pct%.*}

    if [ "$pct_int" -lt 40 ]; then
        echo "$COLOR_GREEN"
    elif [ "$pct_int" -lt 70 ]; then
        echo "$COLOR_YELLOW"
    else
        echo "$COLOR_RED"
    fi
}

# 不好的例子
gcc() {
  local p=$1
  if [ $p -lt 40 ]; then
    echo 28
  fi
}
```

### 测试要求

- 所有新功能必须包含测试
- 确保现有测试通过
- 测试覆盖率尽可能高

### 文档要求

- 更新 README.md（如有必要）
- 添加必要的代码注释
- 更新 CHANGELOG.md

## 🏗️ 项目结构

```
claude-code-powerline-status/
├── statusline.sh          # 主脚本
├── test.sh                # 测试套件
├── demo.sh                # 演示脚本
├── install.sh             # 安装脚本
├── uninstall.sh           # 卸载脚本
├── README.md              # 用户文档
├── CONTRIBUTING.md        # 贡献指南
├── LICENSE                # MIT 许可证
├── settings.example.json  # 配置示例
└── CHANGELOG.md           # 更新日志
```

## 🔧 本地开发

### 设置开发环境

```bash
# 1. 克隆仓库
git clone https://github.com/zhaohao1004/claude-code-powerline-status.git
cd claude-code-powerline-status

# 2. 安装开发依赖
brew install shellcheck shfmt  # macOS

# 3. 运行测试
./test.sh

# 4. 测试特定场景
echo '{"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":25}}' \
  | ./statusline.sh
```

### 调试技巧

```bash
# 启用调试模式
bash -x ./statusline.sh <<< '{"workspace":{"current_dir":"/tmp"}}'

# 查看详细输出
set -x  # 在脚本中启用
set +x  # 在脚本中禁用

# 测试 JSON 解析
echo "$input" | jq '.' | less

# 测试 Git 命令
git -C "/path/to/repo" status --porcelain
```

## 📋 检查清单

提交 PR 前请确认：

- [ ] 代码通过 `shellcheck` 检查
- [ ] 所有测试通过
- [ ] 添加了必要的注释
- [ ] 更新了相关文档
- [ ] 遵循代码风格指南
- [ ] 没有引入新的警告
- [ ] 提交消息清晰明了

## 🎯 优先级

我们特别欢迎以下贡献：

1. **Bug 修复** - 高优先级
2. **性能优化** - 高优先级
3. **文档改进** - 中优先级
4. **新功能** - 需讨论
5. **代码重构** - 中优先级

## 🤝 行为准则

- 尊重所有贡献者
- 保持友好和专业
- 接受建设性批评
- 关注对社区最有利的事情

## 📞 联系方式

- **Issues**: [GitHub Issues](https://github.com/zhaohao1004/claude-code-powerline-status/issues)
- **Pull Requests**: [GitHub PRs](https://github.com/zhaohao1004/claude-code-powerline-status/pulls)
- **讨论**: [GitHub Discussions](https://github.com/zhaohao1004/claude-code-powerline-status/discussions)

## 📜 许可证

通过贡献代码，你同意你的代码将在 MIT 许可证下发布。

---

再次感谢你的贡献！🎉
