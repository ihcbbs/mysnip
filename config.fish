# =============================================================================
# Fish Shell Configuration
# Converted from zsh config
# =============================================================================

# -----------------------------------------------------------------------------
# PATH Settings
# -----------------------------------------------------------------------------
set -gx PATH /sbin /bin /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin $PATH

# -----------------------------------------------------------------------------
# Environment Variables
# -----------------------------------------------------------------------------
set -gx EDITOR nano
set -gx BAT_THEME ansi-light
set -gx LC_CTYPE en_US.UTF-8

# -----------------------------------------------------------------------------
# Fisher Plugin Manager Initialization
# Note: Fisher 4.x should NOT be included in fish_plugins to avoid circular install
# Install Fisher first if not present:
# curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
# -----------------------------------------------------------------------------
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    if not test -f $XDG_CONFIG_HOME/fish/functions/fisher.fish
        echo "Installing Fisher..."
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
    end
end

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
alias lk 'k --no-vcs'

# -----------------------------------------------------------------------------
# Docker Completion
# Generate dynamically using docker completion command
# Note: NOT using halostatue/fish-docker as per user request
# -----------------------------------------------------------------------------
function __ensure_docker_completion --on-event fish_prompt
    if type -q docker
        set -l completion_file ~/.config/fish/completions/docker.fish
        if not test -f $completion_file
            echo "Generating Docker completion..."
            mkdir -p ~/.config/fish/completions
            docker completion fish > $completion_file 2>/dev/null
        end
    end
    functions -e __ensure_docker_completion
end

# -----------------------------------------------------------------------------
# Rclone Completion
# Generate dynamically using rclone completion command
# -----------------------------------------------------------------------------
function __ensure_rclone_completion --on-event fish_prompt
    if type -q rclone
        set -l completion_file ~/.config/fish/completions/rclone.fish
        if not test -f $completion_file
            echo "Generating Rclone completion..."
            mkdir -p ~/.config/fish/completions
            rclone completion fish > $completion_file 2>/dev/null
        end
    end
    functions -e __ensure_rclone_completion
end

# -----------------------------------------------------------------------------
# Restic Completion
# Generate dynamically using restic generate command
# -----------------------------------------------------------------------------
function __ensure_restic_completion --on-event fish_prompt
    if type -q restic
        set -l completion_file ~/.config/fish/completions/restic.fish
        if not test -f $completion_file
            echo "Generating Restic completion..."
            mkdir -p ~/.config/fish/completions
            restic generate --fish-completion $completion_file 2>/dev/null
        end
    end
    functions -e __ensure_restic_completion
end

# -----------------------------------------------------------------------------
# Tmux Completion
# Note: Fish 4.0+ has built-in tmux completion
# For older versions, we create a basic completion
# -----------------------------------------------------------------------------
function __ensure_tmux_completion --on-event fish_prompt
    if type -q tmux
        set -l completion_file ~/.config/fish/completions/tmux.fish
        if not test -f $completion_file
            # Check if fish version is less than 4.0
            set -l fish_version (string split . $FISH_VERSION)
            if test "$fish_version[1]" -lt 4
                echo "Generating Tmux completion..."
                mkdir -p ~/.config/fish/completions
                # Basic tmux completion for older fish versions
                begin
                    echo "complete -c tmux -f"
                    echo ""
                    echo "# Session management"
                    echo "complete -c tmux -n '__fish_use_subcommand' -a new-session -d 'Create a new session'"
                    echo "complete -c tmux -n '__fish_use_subcommand' -a new -d 'Create a new session (short)'"
                    echo "complete -c tmux -n '__fish_use_subcommand' -a attach-session -d 'Attach to existing session'"
                    echo "complete -c tmux -n '__fish_use_subcommand' -a attach -d 'Attach to existing session (short)'"
                    echo "complete -c tmux -n '__fish_use_subcommand' -a a -d 'Attach to existing session (shortest)'"
                    echo "complete -c tmux -n '__fish_use_subcommand' -a list-sessions -d 'List sessions'"
                    echo "complete -c tmux -n '__fish_use_subcommand' -a ls -d 'List sessions (short)'"
                    echo "complete -c tmux -n '__fish_use_subcommand' -a kill-session -d 'Kill session'"
                    echo "complete -c tmux -n '__fish_use_subcommand' -a switch-client -d 'Switch client'"
                    echo "complete -c tmux -n '__fish_use_subcommand' -a detach-client -d 'Detach client'"
                    echo "complete -c tmux -n '__fish_use_subcommand' -a detach -d 'Detach client (short)'"
                    echo ""
                    echo "# Window management"
                    echo "complete -c tmux -n '__fish_use_subcommand' -a new-window -d 'Create a new window'"
                    echo "complete -c tmux -n '__fish_use_subcommand' -a split-window -d 'Split window'"
                    echo ""
                    echo "# Common options"
                    echo "complete -c tmux -s s -l target-session -d 'Target session'"
                    echo "complete -c tmux -s t -l target -d 'Target'"
                    echo "complete -c tmux -s d -l detached -d 'Start detached'"
                    echo "complete -c tmux -s v -l verbose -d 'Verbose output'"
                    echo "complete -c tmux -s h -l help -d 'Help'"
                    echo ""
                    echo "# Session names completion"
                    echo "function __fish_tmux_sessions"
                    echo "    tmux list-sessions -F '#S' 2>/dev/null"
                    echo "end"
                    echo "complete -c tmux -n '__fish_seen_subcommand_from attach-session attach a switch-client' -a '(__fish_tmux_sessions)' -d 'Session'"
                    echo "complete -c tmux -n '__fish_seen_subcommand_from kill-session' -a '(__fish_tmux_sessions)' -d 'Session'"
                    echo "complete -c tmux -n '__fish_seen_subcommand_from has-session' -a '(__fish_tmux_sessions)' -d 'Session'"
                end > $completion_file
            end
        end
    end
    functions -e __ensure_tmux_completion
end

# -----------------------------------------------------------------------------
# NVM (Node Version Manager) - Optional
# Uncomment if you need Node.js version management
# -----------------------------------------------------------------------------
# set -gx nvm_default_version lts
# set -gx nvm_default_packages npm yarn

# -----------------------------------------------------------------------------
# iTerm2 Integration (macOS only)
# Uncomment if using iTerm2
# -----------------------------------------------------------------------------
# source ~/.iterm2_shell_integration.fish

# =============================================================================
# End of Configuration
# =============================================================================