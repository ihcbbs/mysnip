# ============================================================
# Fish Shell Configuration
# 精简优化版 - 修复版
# ============================================================

# ------------------------------------------------------------
# PATH 设置
# ------------------------------------------------------------
set -gx PATH /sbin /bin /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin $PATH

# ------------------------------------------------------------
# 环境变量
# ------------------------------------------------------------
set -gx EDITOR nano
set -gx BAT_THEME "ansi-light"
set -gx LC_CTYPE en_US.UTF-8

# ------------------------------------------------------------
# 别名设置
# ------------------------------------------------------------
type -q k; and alias lk 'k --no-vcs'

# ------------------------------------------------------------
# Fisher 插件路径（Fisher 会自动检测）
# ------------------------------------------------------------
set -g fisher_path ~/.config/fish/fisher

# 将 Fisher 安装的插件加入函数路径
if test -d $fisher_path/functions
    set -gx fish_function_path $fisher_path/functions $fish_function_path
end

if test -d $fisher_path/completions
    set -gx fish_complete_path $fisher_path/completions $fish_complete_path
end

# 加载 Fisher 插件的 conf.d
for file in $fisher_path/conf.d/*.fish
    source $file
end

# ------------------------------------------------------------
# 补全生成（仅首次运行）
# ------------------------------------------------------------
# Docker
if type -q docker
    set -l comp_file ~/.config/fish/completions/docker.fish
    test -f $comp_file; or docker completion fish > $comp_file 2>/dev/null
end

# rclone
if type -q rclone
    set -l comp_file ~/.config/fish/completions/rclone.fish
    test -f $comp_file; or rclone completion fish > $comp_file 2>/dev/null
end

# restic
if type -q restic
    set -l comp_file ~/.config/fish/completions/restic.fish
    test -f $comp_file; or restic generate --fish-completion $comp_file 2>/dev/null
end