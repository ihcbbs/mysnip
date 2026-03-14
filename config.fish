# ~/.config/fish/config.fish - Fish Shell 配置文件
# 由 zsh 配置转换而来

# ============================================================================
# 环境变量设置
# ============================================================================

# PATH 设置
set -gx PATH /sbin /bin /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin $PATH

# 默认编辑器
set -gx EDITOR nano

# bat 主题
set -gx BAT_THEME ansi-light

# 设置 locale
set -gx LC_CTYPE en_US.UTF-8

# ============================================================================
# 别名设置
# ============================================================================

alias lk 'k --no-vcs'

# ============================================================================
# Fisher 插件管理器安装
# ============================================================================

# 如果 Fisher 未安装，自动安装
if not functions -q fisher
    echo "Installing Fisher..."
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

# ============================================================================
# 补全脚本生成（docker、rclone、restic、tmux）
# ============================================================================

# 补全文件存放目录
set -l completion_dir $__fish_config_dir/completions
mkdir -p $completion_dir

# Docker 补全
if command -q docker
    if not test -f $completion_dir/docker.fish
        echo "Generating Docker completion..."
        docker completion fish > $completion_dir/docker.fish 2>/dev/null
    end
end

# Rclone 补全
if command -q rclone
    if not test -f $completion_dir/rclone.fish
        echo "Generating Rclone completion..."
        rclone genautocomplete fish $completion_dir/rclone.fish 2>/dev/null
    end
end

# Restic 补全
if command -q restic
    if not test -f $completion_dir/restic.fish
        echo "Generating Restic completion..."
        restic generate --fish-completion $completion_dir/restic.fish 2>/dev/null
    end
end

# Tmux 补全（fish 通常自带，如果没有则从网上获取）
if command -q tmux
    if not test -f $completion_dir/tmux.fish
        echo "Downloading Tmux completion..."
        curl -sL https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux > $completion_dir/tmux.fish 2>/dev/null
    end
end

# LXC 补全（如果 lxc 命令存在）
if command -q lxc
    if not test -f $completion_dir/lxc.fish
        echo "Generating LXC completion..."
        lxc completion fish > $completion_dir/lxc.fish 2>/dev/null
    end
end

# ============================================================================
# 目录跳转工具（z 插件）初始化
# ============================================================================

# z 插件会在 Fisher 安装后自动加载
# 如果使用 autojump
if test -f ~/.autojump/etc/profile.d/autojump.fish
    source ~/.autojump/etc/profile.d/autojump.fish
end

# ============================================================================
# 终端标题设置（替代原 zsh 的 precmd）
# ============================================================================

function fish_set_title --on-variable PWD
    echo -n \e]1337\;CurrentDir=(pwd)\a
end

# ============================================================================
# 自定义提示符（可选，替代 oh-my-zsh 主题）
# ============================================================================

# 简洁的提示符（类似原 half-life 主题）
function fish_prompt
    set -l last_status $status
    set -l cwd (prompt_pwd)
    
    # 用户名和主机名
    set_color cyan
    echo -n $USER
    set_color normal
    echo -n '@'
    set_color yellow
    echo -n (hostname -s)
    set_color normal
    echo -n ':'
    
    # 当前目录
    set_color green
    echo -n $cwd
    set_color normal
    
    # Git 状态（如果需要）
    if command -q git
        if git rev-parse --is-inside-work-tree >/dev/null 2>&1
            set -l branch (git branch --show-current 2>/dev/null)
            if test -n "$branch"
                set_color magenta
                echo -n " ($branch)"
                set_color normal
            end
        end
    end
    
    # 提示符符号
    if test $last_status -eq 0
        set_color green
    else
        set_color red
    end
    echo -n ' $ '
    set_color normal
end

# ============================================================================
# 右侧提示符（可选，显示时间）
# ============================================================================

function fish_right_prompt
    set_color brblack
    echo -n (date '+%H:%M:%S')
    set_color normal
end