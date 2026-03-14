#!/bin/bash
# OpenClaw 商业化博客 - 自动发布到 GitHub

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_DIR/logs"

mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/github-publish-$(date +%Y%m%d-%H%M%S).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

cd "$PROJECT_DIR"

log "=========================================="
log "📤 开始自动发布到 GitHub"
log "=========================================="

# 配置 Git 用户信息
log "⚙️  配置 Git 用户信息..."
git config user.email "pyastar@users.noreply.github.com"
git config user.name "杨勇"

# 添加远程仓库（如果不存在）
if ! git remote -v | grep -q origin; then
    log "🔗 添加远程仓库..."
    git remote add origin https://github.com/pyastar/studyai.git
else
    log "✅ 远程仓库已存在"
fi

# 复制最新文章到 posts 目录
log "📋 复制文章到 posts 目录..."
mkdir -p posts

# 查找最新的草稿
latest_draft=$(ls -t content/drafts/*.md 2>/dev/null | head -1)

if [ -n "$latest_draft" ] && [ -f "$latest_draft" ]; then
    log "  找到文章：$latest_draft"
    cp "$latest_draft" posts/
    log "✅ 文章已复制"
else
    log "⚠️  没有找到草稿文件"
    exit 1
fi

# 添加文件
log "📝 添加文件到 Git..."
git add posts/
log "✅ 文件已添加"

# 检查是否有改动
if git diff --cached --quiet; then
    log "ℹ️  没有新改动，跳过提交"
else
    # 提交
    log "💾 提交更改..."
    git commit -m "📝 自动发布 OpenClaw 商业化文章 - $(date +%Y-%m-%d %H:%M)"
    log "✅ 提交完成"
    
    # 推送
    log "🚀 推送到 GitHub..."
    
    # 检查是否配置了 Token
    current_url=$(git remote get-url origin 2>/dev/null || echo "")
    
    if [[ "$current_url" == *"@"* ]]; then
        log "✅ 已配置 Token，自动推送..."
        git push -u origin master 2>&1 | tee -a "$LOG_FILE"
        log "✅ 推送成功！"
    else
        log "⚠️  未配置 GitHub Token，需要手动输入密码"
        log "💡 建议配置 Token: https://github.com/settings/tokens"
        log ""
        log "现在推送..."
        git push -u origin master 2>&1 | tee -a "$LOG_FILE"
    fi
fi

log ""
log "=========================================="
log "✅ 自动发布完成！"
log "=========================================="
log ""
log "📖 查看文章:"
log "https://github.com/pyastar/studyai/tree/main/posts"
log ""
log "📄 日志文件：$LOG_FILE"
log ""

# 移动草稿到已发布
if [ -n "$latest_draft" ]; then
    mkdir -p "$PROJECT_DIR/content/published"
    mv "$latest_draft" "$PROJECT_DIR/content/published/" 2>/dev/null || true
    log "✅ 文章已移动到已发布目录"
fi
