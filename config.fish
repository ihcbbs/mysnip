# ============================================================
# Fish Shell Configuration
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
# 别名
# ------------------------------------------------------------
type -q k; and alias lk 'k --no-vcs'

# ------------------------------------------------------------
# Fisher 插件路径
# ------------------------------------------------------------
set -g fisher_path ~/.config/fish/fisher

if test -d $fisher_path/functions
    set -gx fish_function_path $fisher_path/functions $fish_function_path
end

if test -d $fisher_path/completions
    set -gx fish_complete_path $fisher_path/completions $fish_complete_path
end

for file in $fisher_path/conf.d/*.fish
    source $file
end