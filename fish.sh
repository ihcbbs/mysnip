#!/bin/bash
# ============================================================================
# Fish Shell 配置安装脚本
# ============================================================================

FISH_CONFIG_DIR="$HOME/.config/fish"

echo "=== Fish Shell 配置安装 ==="

# 创建配置目录
mkdir -p "$FISH_CONFIG_DIR"
mkdir -p "$FISH_CONFIG_DIR/completions"
mkdir -p "$FISH_CONFIG_DIR/functions"
mkdir -p "$FISH_CONFIG_DIR/conf.d"

# 安装 Fisher（插件管理器）
echo ""
echo "1. 安装 Fisher 插件管理器..."
if ! type fish &>/dev/null; then
    echo "错误：请先安装 fish shell"
    exit 1
fi

# 使用 fish 执行安装
fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'

if [ $? -eq 0 ]; then
    echo "✓ Fisher 安装成功"
else
    echo "✗ Fisher 安装失败"
    exit 1
fi

# 安装 Fisher 插件
echo ""
echo "2. 安装 Fisher 插件..."
fish -c 'fisher update'

if [ $? -eq 0 ]; then
    echo "✓ 插件安装成功"
else
    echo "✗ 插件安装失败"
fi

# 生成命令补全
echo ""
echo "3. 生成命令补全..."

# rclone 补全
if type rclone &>/dev/null; then
    rclone completion fish > "$FISH_CONFIG_DIR/completions/rclone.fish" 2>/dev/null
    echo "✓ rclone 补全已生成"
else
    echo "- rclone 未安装，跳过补全"
fi

# restic 补全
if type restic &>/dev/null; then
    restic generate --fish-completion "$FISH_CONFIG_DIR/completions/restic.fish" 2>/dev/null
    echo "✓ restic 补全已生成"
else
    echo "- restic 未安装，跳过补全"
fi

# Docker 补全检查
if type docker &>/dev/null; then
    echo "✓ Docker 补全由 Fish 内置支持"
fi

# tmux 补全检查
if type tmux &>/dev/null; then
    echo "✓ tmux 补全由 Fish 内置支持"
fi

# 配置 tide 主题（交互式）
echo ""
echo "4. 配置 tide 主题..."
fish -c 'tide configure'

echo ""
echo "=== 安装完成 ==="
echo ""
echo "请重启 fish shell 或运行："
echo "  source ~/.config/fish/config.fish"
echo ""
echo "常用命令："
echo "  fisher list          # 列出已安装插件"
echo "  fisher update        # 更新所有插件"
echo "  fisher remove <name> # 移除插件"