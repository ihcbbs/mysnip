function generate-completions --description "Generate all shell completions"
    echo "🔧 生成补全文件..."
    echo ""
    
    # 创建补全目录
    mkdir -p ~/.config/fish/completions
    
    # Docker 补全
    if type -q docker
        echo "📦 Docker..."
        docker completion fish > ~/.config/fish/completions/docker.fish 2>/dev/null
        and echo "   ✓ 成功" || echo "   ✗ 失败"
    else
        echo "📦 Docker - 未安装"
    end
    
    # rclone 补全
    if type -q rclone
        echo "📦 rclone..."
        rclone completion fish > ~/.config/fish/completions/rclone.fish 2>/dev/null
        and echo "   ✓ 成功" || echo "   ✗ 失败"
    else
        echo "📦 rclone - 未安装"
    end
    
    # restic 补全
    if type -q restic
        echo "📦 restic..."
        restic generate --fish-completion ~/.config/fish/completions/restic.fish 2>/dev/null
        and echo "   ✓ 成功" || echo "   ✗ 失败"
    else
        echo "📦 restic - 未安装"
    end
    
    # tmux 补全（Fish 内置，检查是否存在）
    if type -q tmux
        echo "📦 tmux - Fish 内置支持"
    end
    
    echo ""
    echo "✅ 完成！已生成的补全文件:"
    ls ~/.config/fish/completions/*.fish 2>/dev/null | xargs -n1 basename
    
    echo ""
    echo "请运行 'exec fish' 重新加载 shell"
end