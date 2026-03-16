#!/bin/bash
# OpenClaw 博客 - 自动备份到 GitHub 脚本
# 功能：备份配置文件、重要文档，自动提交到 GitHub

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$PROJECT_DIR/backup/auto"
LOG_DIR="$PROJECT_DIR/logs"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
DATE=$(date +%Y-%m-%d)

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_DIR/backup-$TIMESTAMP.log"
}

# 创建备份目录
mkdir -p "$BACKUP_DIR/$DATE"

log "=========================================="
log "🔄 开始自动备份到 GitHub"
log "=========================================="

# 1. 备份配置文件
log "📁 备份配置文件..."

# 配置目录
CONFIG_ITEMS=(
    "config.json"
    ".git/config"
    "scripts/*.sh"
)

# 创建配置备份包
CONFIG_BACKUP="$BACKUP_DIR/$DATE/config-$TIMESTAMP.tar.gz"
tar -czf "$CONFIG_BACKUP" \
    config.json \
    scripts/*.sh \
    2>/dev/null || log "⚠️ 部分文件备份失败"

log "✅ 配置备份完成：$CONFIG_BACKUP"

# 2. 备份重要文档
log "📄 备份重要文档..."

DOC_BACKUP="$BACKUP_DIR/$DATE/docs-$TIMESTAMP.tar.gz"
tar -czf "$DOC_BACKUP" \
    README.md \
    QUICKSTART.md \
    PROJECT-PLAN.md \
    SETUP-COMPLETE.md \
    全自动运行说明.md \
    发布到 GitHub 指南.md \
    配置 GitHub 自动化.md \
    2>/dev/null || log "⚠️ 部分文档备份失败"

log "✅ 文档备份完成：$DOC_BACKUP"

# 3. 备份文章内容
log "📝 备份文章内容..."

POSTS_BACKUP="$BACKUP_DIR/$DATE/posts-$TIMESTAMP.tar.gz"
tar -czf "$POSTS_BACKUP" \
    posts/*.md \
    content/drafts/*.md \
    content/published/*.md \
    2>/dev/null || log "⚠️ 部分文章备份失败"

log "✅ 文章备份完成：$POSTS_BACKUP"

# 4. 备份日志（最近 7 天）
log "📊 备份最近日志..."

LOG_BACKUP="$BACKUP_DIR/$DATE/logs-$TIMESTAMP.tar.gz"
find "$LOG_DIR" -name "*.log" -mtime -7 -exec tar -czf "$LOG_BACKUP" {} + 2>/dev/null || log "⚠️ 日志备份失败"

log "✅ 日志备份完成：$LOG_BACKUP"

# 5. 生成备份清单
log "📋 生成备份清单..."

cat > "$BACKUP_DIR/$DATE/BACKUP-MANIFEST-$TIMESTAMP.json" << EOF
{
  "backup_time": "$TIMESTAMP",
  "date": "$DATE",
  "project": "openclaw-monetization-blog",
  "files": {
    "config": "$(basename $CONFIG_BACKUP)",
    "docs": "$(basename $DOC_BACKUP)",
    "posts": "$(basename $POSTS_BACKUP)",
    "logs": "$(basename $LOG_BACKUP)"
  },
  "git_commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')",
  "git_branch": "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')",
  "system_info": {
    "hostname": "$(hostname)",
    "user": "$(whoami)",
    "date": "$(date '+%Y-%m-%d %H:%M:%S %Z')"
  }
}
EOF

log "✅ 备份清单生成完成"

# 6. 清理旧备份（保留最近 30 天）
log "🧹 清理 30 天前的旧备份..."

find "$BACKUP_DIR" -type d -mtime +30 -exec rm -rf {} + 2>/dev/null || true

log "✅ 清理完成"

# 7. 提交到 Git
log "📤 提交备份到 Git..."

cd "$PROJECT_DIR"

# 添加备份文件
git add backup/$DATE/ 2>/dev/null || true

# 检查是否有变更
if git diff --cached --quiet; then
    log "ℹ️  没有新备份需要提交"
else
    # 提交
    git commit -m "💾 自动备份 - $TIMESTAMP" || log "⚠️ 提交失败"
    
    # 推送
    log "🚀 推送到 GitHub..."
    git push origin master 2>&1 | tee -a "$LOG_DIR/backup-$TIMESTAMP.log" || log "⚠️ 推送失败（可能是网络问题）"
    
    log "✅ 备份已推送到 GitHub"
fi

# 8. 发送通知
log "📬 发送备份通知..."

NOTIFICATION_MSG="✅ 自动备份完成

📅 时间：$DATE $TIMESTAMP
📁 备份位置：backup/$DATE/
📦 备份文件:
  - config-$TIMESTAMP.tar.gz
  - docs-$TIMESTAMP.tar.gz
  - posts-$TIMESTAMP.tar.gz
  - logs-$TIMESTAMP.tar.gz

🔗 GitHub: https://github.com/pyastar/studyai/tree/main/backup/$DATE"

# 保存到通知文件
echo "$NOTIFICATION_MSG" > "$BACKUP_DIR/$DATE/notification-$TIMESTAMP.txt"

log "✅ 通知已生成"

log "=========================================="
log "✅ 备份完成！"
log "=========================================="
log ""
log "📂 备份位置：$BACKUP_DIR/$DATE/"
log "🔗 GitHub: https://github.com/pyastar/studyai/tree/main/backup/$DATE"
log ""

# 返回备份清单
cat "$BACKUP_DIR/$DATE/BACKUP-MANIFEST-$TIMESTAMP.json"
