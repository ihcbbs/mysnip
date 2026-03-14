# =============================================================================
# Fish User Key Bindings
# Using Fish native cursor movement, no zsh-style bindings
# =============================================================================

function fish_user_key_bindings
    # Fish uses default emacs-style keybindings:
    # Ctrl+A - beginning of line
    # Ctrl+E - end of line
    # Ctrl+B - backward one character
    # Ctrl+F - forward one character
    # Alt+B   - backward one word
    # Alt+F   - forward one word
    # Ctrl+K  - delete to end of line
    # Ctrl+U  - delete to beginning of line
    # Ctrl+W  - delete previous word
    
    # Optional: Add custom abbreviations (more fish-like than aliases)
    # abbr --add ll ls -lh
    # abbr --add la ls -lAh
    
    # FZF key bindings (if using jethrokuan/fzf)
    if functions -q fzf_key_bindings
        fzf_key_bindings
    end
end