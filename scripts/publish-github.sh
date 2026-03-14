#!/bin/bash
# OpenClaw 商业化博客 - GitHub 发布脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_DIR/config.json"
LOG_DIR="$PROJECT_DIR/logs"

mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/publish-github-$(date +%Y%m%d).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 读取配置
GITHUB_REPO=$(grep -o '"repo"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | head -1 | cut -d'"' -f4)
GITHUB_BRANCH=$(grep -o '"branch"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
GITHUB_FOLDER=$(grep -o '"folder"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
GITHUB_TOKEN=$(grep -o '"token"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | head -1 | cut -d'"' -f4)

# 发布到 GitHub
publish_to_github() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        log "❌ 文件不存在：$file"
        exit 1
    fi
    
    log "📤 发布到 GitHub: $file"
    log "  仓库：$GITHUB_REPO"
    log "  分支：$GITHUB_BRANCH"
    log "  目录：$GITHUB_FOLDER"
    
    # 检查是否配置了 Token
    if [ -z "$GITHUB_TOKEN" ]; then
        log "⚠️  未配置 GitHub Token，使用 Git 推送方式"
        
        # 使用 Git 推送
        local temp_dir=$(mktemp -d)
        cd "$temp_dir"
        
        git init
        git remote add origin "https://github.com/$GITHUB_REPO.git"
        
        # 尝试拉取现有内容
        git pull origin "$GITHUB_BRANCH" 2>/dev/null || true
        
        # 创建目录结构
        mkdir -p "$GITHUB_FOLDER"
        
        # 复制文件
        cp "$file" "$GITHUB_FOLDER/"
        
        # 提交并推送
        git add "$GITHUB_FOLDER/"
        git commit -m "📝 发布新文章：$(basename "$file")"
        git push origin "$GITHUB_BRANCH"
        
        # 清理
        cd - > /dev/null
        rm -rf "$temp_dir"
        
        log "✅ Git 推送完成"
    else
        log "⚠️  API 推送方式待实现（需要 GitHub API）"
        log "  当前使用 Git 推送作为备选方案"
        
        # 使用 Git 推送（同上）
        local temp_dir=$(mktemp -d)
        cd "$temp_dir"
        
        git init
        git remote add origin "https://github.com/$GITHUB_REPO.git"
        git pull origin "$GITHUB_BRANCH" 2>/dev/null || true
        
        mkdir -p "$GITHUB_FOLDER"
        cp "$file" "$GITHUB_FOLDER/"
        
        git add "$GITHUB_FOLDER/"
        git commit -m "📝 发布新文章：$(basename "$file")"
        git push origin "$GITHUB_BRANCH"
        
        cd - > /dev/null
        rm -rf "$temp_dir"
        
        log "✅ 发布完成"
    fi
}

# 主函数
main() {
    log "=========================================="
    log "🚀 开始 GitHub 发布"
    log "=========================================="
    
    if [ -z "$1" ]; then
        log "❌ 请指定要发布的文件"
        echo "用法：$0 <文件路径>"
        exit 1
    fi
    
    publish_to_github "$1"
    
    log "=========================================="
    log "✅ 发布完成"
    log "=========================================="
}

main "$@"
