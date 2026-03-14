# ============================================================================
# Fish Shell Configuration
# 转换自 zsh 配置，适配 Fish shell
# ============================================================================

# ----------------------------------------------------------------------------
# 环境变量设置
# ----------------------------------------------------------------------------
set -gx PATH /sbin /bin /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin $PATH

# 编辑器设置
set -gx EDITOR nano

# Bat 主题
set -gx BAT_THEME ansi-light

# 语言设置
set -gx LC_CTYPE en_US.UTF-8

# ----------------------------------------------------------------------------
# Fisher 插件管理器初始化
# 注意：不要在 config.fish 中自动安装 Fisher，避免循环安装 bug
# Fisher 只需要手动安装一次：
#   curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
# ----------------------------------------------------------------------------

# 如果 Fisher 已安装，加载插件
if functions -q fisher
    # Fisher 已安装，插件会自动通过 fish_plugins 文件加载
end

# ----------------------------------------------------------------------------
# Fish 内置功能启用
# Fish 自带 autosuggestions 和 syntax highlighting，只需启用
# ----------------------------------------------------------------------------
# 启用自动建议（Fish 3.0+ 默认启用）
set -g fish_autosuggestion_enabled 1

# ----------------------------------------------------------------------------
# 别名设置
# ----------------------------------------------------------------------------
alias lk 'k --no-vcs'

# ----------------------------------------------------------------------------
# 命令补全生成
# Docker、rclone、restic、tmux 补全设置
# ----------------------------------------------------------------------------
# 创建补全目录（如果不存在）
mkdir -p $__fish_config_dir/completions

# rclone 补全（如果 rclone 已安装）
if type -q rclone
    if not test -f $__fish_config_dir/completions/rclone.fish
        echo "生成 rclone 补全文件..."
        rclone completion fish > $__fish_config_dir/completions/rclone.fish
    end
end

# restic 补全（如果 restic 已安装）
if type -q restic
    if not test -f $__fish_config_dir/completions/restic.fish
        echo "生成 restic 补全文件..."
        restic generate --fish-completion $__fish_config_dir/completions/restic.fish 2>/dev/null
    end
end

# Docker 补全：Fish 4.0+ 自带 Docker 补全
# 如果需要增强版，安装：fisher install barnybug/docker-fish-completion

# tmux 补全：Fish 自带 tmux 补全

# ----------------------------------------------------------------------------
# iTerm2 集成（如果使用 iTerm2）
# ----------------------------------------------------------------------------
if test -e $HOME/.iterm2_shell_integration.fish
    source $HOME/.iterm2_shell_integration.fish
end

# ----------------------------------------------------------------------------
# 通知当前目录（用于终端模拟器）
# ----------------------------------------------------------------------------
function fish_prompt --description 'Write out the prompt'
    # 通知终端当前目录
    if set -q ITERM_SESSION_ID
        printf '\e]1337;CurrentDir=%s\a' (pwd)
    end
    
    # 默认 prompt
    set -l last_status $status
    set -l prompt_status
    
    if test $last_status -ne 0
        set prompt_status (set_color red)'['$last_status']'(set_color normal)' '
    end
    
    # 用户名@主机名
    echo -n (set_color cyan)(whoami)(set_color normal)'@'(set_color yellow)(hostname)(set_color normal)':'
    
    # 当前目录
    echo -n (set_color green)(prompt_pwd)(set_color normal)
    
    # Git 状态（如果在 git 仓库中）
    if set -l git_dir (git rev-parse --git-dir 2>/dev/null)
        set -l branch (git branch --show-current 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)
        if test -n "$branch"
            echo -n ' '(set_color magagenta)'('$branch')'(set_color normal)
        end
    end
    
    # 提示符
    echo -n $prompt_status'$ '
end

# ----------------------------------------------------------------------------
# 登录 shell 设置
# ----------------------------------------------------------------------------
if status is-login
    # 登录时执行的命令可以放在这里
end

# ----------------------------------------------------------------------------
# 交互式 shell 设置
# ----------------------------------------------------------------------------
if status is-interactive
    # 启用 vi 模式（可选，取消注释以启用）
    # fish_vi_key_bindings
    
    # 或使用 emacs 模式（默认）
    fish_default_key_bindings
end