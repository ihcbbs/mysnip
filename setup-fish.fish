#!/usr/bin/env fish
# ============================================================
# Fish 配置安装脚本
# 运行方式: fish setup-fish.fish
# ============================================================

echo "🐟 Setting up Fish shell configuration..."

# ------------------------------------------------------------
# 创建必要的目录
# ------------------------------------------------------------
mkdir -p ~/.config/fish/completions
mkdir -p ~/.config/fish/functions
mkdir -p ~/.config/fish/conf.d

# ------------------------------------------------------------
# 安装 Fisher（如果未安装）
# ------------------------------------------------------------
if not functions -q fisher
    echo "📦 Installing Fisher..."
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher install jorgebucaran/fisher
end

# ------------------------------------------------------------
# 安装推荐插件
# ------------------------------------------------------------
echo "🔌 Installing Fish plugins..."

# 目录跳转（替代 autojump/z）
fisher install jethrokuan/z

# FZF 集成（替代 fzf-zsh-plugin）
fisher install PatrickF1/fzf.fish

# 自动配对括号和引号
fisher install jorgebucaran/autopair.fish

# ------------------------------------------------------------
# 生成补全脚本
# ------------------------------------------------------------
echo "📝 Generating completions..."

# Docker
if type -q docker
    echo "  → Docker"
    docker completion fish > ~/.config/fish/completions/docker.fish 2>/dev/null
end

# rclone
if type -q rclone
    echo "  → rclone"
    rclone completion fish > ~/.config/fish/completions/rclone.fish 2>/dev/null
end

# restic
if type -q restic
    echo "  → restic"
    restic generate --fish-completion ~/.config/fish/completions/restic.fish 2>/dev/null
end

# ------------------------------------------------------------
# 完成
# ------------------------------------------------------------
echo ""
echo "✅ Fish configuration complete!"
echo ""
echo "Installed plugins:"
fisher list
echo ""
echo "Completions generated for:"
ls ~/.config/fish/completions/*.fish 2>/dev/null | xargs -n1 basename
echo ""
echo "Reload your shell or run: source ~/.config/fish/config.fish"
