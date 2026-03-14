#!/bin/bash
# 安装 Fish Shell 配置

set -e

FISH_CONFIG_DIR="$HOME/.config/fish"
FISH_FUNCTIONS_DIR="$FISH_CONFIG_DIR/functions"
FISH_COMPLETIONS_DIR="$FISH_CONFIG_DIR/completions"

echo "Installing Fish Shell configuration..."

# 创建目录
mkdir -p "$FISH_CONFIG_DIR"
mkdir -p "$FISH_FUNCTIONS_DIR"
mkdir -p "$FISH_COMPLETIONS_DIR"

# 创建配置文件（将上面的 config.fish 内容写入）
cat > "$FISH_CONFIG_DIR/config.fish" << 'EOF'
# [这里放入上面的 config.fish 内容]
EOF

# 创建插件列表文件
cat > "$FISH_CONFIG_DIR/fish_plugins" << 'EOF'
jorgebucaran/fisher
jorgebucaran/autopair.fish
jethrokuan/z
PatrickF1/fzf.fish
laughedelic/pisces
EOF

# 创建补全更新函数
cat > "$FISH_FUNCTIONS_DIR/update-completions.fish" << 'EOF'
# [这里放入上面的 update-completions.fish 内容]
EOF

echo "Configuration installed!"
echo ""
echo "Next steps:"
echo "1. Restart fish or run: source ~/.config/fish/config.fish"
echo "2. Install Fisher plugins: fisher update"
echo "3. Generate completions: update-completions"