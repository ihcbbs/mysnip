# ============================================================
# Fish Shell Configuration
# 转换自原 Zsh 配置，精简优化版
# ============================================================

# ------------------------------------------------------------
# PATH 设置（已修正原配置的覆盖问题）
# ------------------------------------------------------------
# 注意：Fish 使用列表，不会覆盖系统 PATH
set -gx PATH /sbin /bin /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin $PATH

# ------------------------------------------------------------
# 环境变量
# ------------------------------------------------------------
set -gx EDITOR nano
set -gx BAT_THEME "ansi-light"
set -gx LC_CTYPE en_US.UTF-8

# ------------------------------------------------------------
# Fisher 插件管理器
# ------------------------------------------------------------
# 如果 Fisher 未安装，自动安装
if not functions -q fisher
    echo "Installing Fisher..."
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher install jorgebucaran/fisher
end

# ------------------------------------------------------------
# 常用插件（根据原配置转换）
# ------------------------------------------------------------
# 安装以下插件: 
#   fisher install jethrokuan/z                  # 目录跳转（替代 autojump/z）
#   fisher install PatrickF1/fzf.fish            # 模糊搜索
#   fisher install jorgebucuan/autopair.fish     # 自动配对括号
#   fisher install laughedelic/pisces            # 自动补全引号、括号

# ------------------------------------------------------------
# 别名设置
# ------------------------------------------------------------
alias lk 'k --no-vcs' 2>/dev/null  # 仅在 k 命令存在时生效

# ------------------------------------------------------------
# Fish 内置功能替代原 Zsh 插件
# ------------------------------------------------------------
# Fish 原生支持以下功能，无需插件：
# - 语法高亮（内置）
# - 自动建议（内置，基于历史记录）
# - 命令补全（内置）

# ------------------------------------------------------------
# 光标移动快捷键（Fish 默认已支持）
# ------------------------------------------------------------
# Ctrl+A: 行首
# Ctrl+E: 行尾
# Ctrl+B: 后退一个字符
# Ctrl+F: 前进一个字符
# Alt+B:  后退一个词
# Alt+F:  前进一个词
# Ctrl+U: 删除到行首
# Ctrl+K: 删除到行尾
# Ctrl+W: 删除前一个词

# ------------------------------------------------------------
# 自定义函数
# ------------------------------------------------------------
# 快速向上跳转目录
function ..
    cd ..
end

# 快速回到上一级目录（替代原来的 \eo 绑定）
abbr -a .. 'cd ..'

# ------------------------------------------------------------
# 启动消息
# ------------------------------------------------------------
if status is-interactive
    # 只在交互式 shell 中显示
end

# ============================================================
# 补全配置
# ============================================================

# ------------------------------------------------------------
# Docker 补全（自动生成）
# ------------------------------------------------------------
if type -q docker
    set -l docker_completion ~/.config/fish/completions/docker.fish
    if not test -f $docker_completion
        echo "Generating Docker completions..."
        mkdir -p ~/.config/fish/completions
        docker completion fish > $docker_completion 2>/dev/null
    end
end

# ------------------------------------------------------------
# rclone 补全（自动生成）
# ------------------------------------------------------------
if type -q rclone
    set -l rclone_completion ~/.config/fish/completions/rclone.fish
    if not test -f $rclone_completion
        echo "Generating rclone completions..."
        mkdir -p ~/.config/fish/completions
        rclone completion fish > $rclone_completion 2>/dev/null
    end
end

# ------------------------------------------------------------
# restic 补全（自动生成）
# ------------------------------------------------------------
if type -q restic
    set -l restic_completion ~/.config/fish/completions/restic.fish
    if not test -f $restic_completion
        echo "Generating restic completions..."
        mkdir -p ~/.config/fish/completions
        restic generate --fish-completion $restic_completion 2>/dev/null
    end
end

# ------------------------------------------------------------
# tmux 补全
# ------------------------------------------------------------
# Fish 3.5+ 内置 tmux 补全，无需额外配置
# Fish 4.0+ 支持完整的动态 tmux 子命令补全

# ============================================================
# 本地配置（可选）
# ============================================================
# 如果有本地配置文件，可以在这里加载
# source ~/.config/fish/local.fish
