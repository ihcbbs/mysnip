#!/usr/bin/env fish
# ============================================================
# Fish 一键安装脚本
# 运行方式: fish setup-fish.fish
# 只需运行一次！
# ============================================================

echo "🐟 Fish Shell 一键配置"
echo "=========================================="

# 创建目录
mkdir -p ~/.config/fish/completions
mkdir -p ~/.config/fish/functions
mkdir -p ~/.config/fish/fisher

# 检查 Fisher 是否已安装
if functions -q fisher
    echo "✓ Fisher 已安装"
else
    echo "📦 正在安装 Fisher..."
    curl -sL https://git.io/fisher | source
    fisher update
end

# 安装插件
echo ""
echo "🔌 安装插件..."

set plugins \
    jethrokuan/z \
    PatrickF1/fzf.fish \
    jorgebucaran/autopair.fish

for plugin in $plugins
    echo "  → $plugin"
    fisher install $plugin 2>/dev/null
end

# 生成补全
echo ""
echo "📝 生成补全..."

if type -q docker
    echo "  → Docker"
    docker completion fish > ~/.config/fish/completions/docker.fish 2>/dev/null
end

if type -q rclone
    echo "  → rclone"
    rclone completion fish > ~/.config/fish/completions/rclone.fish 2>/dev/null
end

if type -q restic
    echo "  → restic"
    restic generate --fish-completion ~/.config/fish/completions/restic.fish 2>/dev/null
end

# 完成
echo ""
echo "=========================================="
echo "✅ 配置完成！"
echo ""
echo "已安装插件:"
fisher list
echo ""
echo "已生成补全:"
ls ~/.config/fish/completions/*.fish 2>/dev/null | xargs -n1 basename
echo ""
echo "请重新启动终端，或运行: exec fish"