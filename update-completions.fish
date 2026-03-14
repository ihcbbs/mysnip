# ~/.config/fish/functions/update-completions.fish
# 更新所有命令补全的函数

function update-completions --description "Update all completions"
    set -l completion_dir $__fish_config_dir/completions
    mkdir -p $completion_dir
    
    echo "Updating completions..."
    
    # Docker
    if command -q docker
        echo "  Docker..."
        docker completion fish > $completion_dir/docker.fish 2>/dev/null
    end
    
    # Rclone
    if command -q rclone
        echo "  Rclone..."
        rclone genautocomplete fish $completion_dir/rclone.fish 2>/dev/null
    end
    
    # Restic
    if command -q restic
        echo "  Restic..."
        restic generate --fish-completion $completion_dir/restic.fish 2>/dev/null
    end


    echo "Completions updated!"
end