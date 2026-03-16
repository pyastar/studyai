#!/bin/bash
# 查看备份状态

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$PROJECT_DIR/backup/auto"

echo "=========================================="
echo "📦 OpenClaw 博客备份状态"
echo "=========================================="
echo ""

# 最新备份
echo "📅 最新备份:"
ls -lt "$BACKUP_DIR" | head -3 | tail -2
echo ""

# 备份统计
echo "📊 备份统计:"
echo "  总备份数：$(find "$BACKUP_DIR" -type d | wc -l) 个"
echo "  总大小：$(du -sh "$BACKUP_DIR" 2>/dev/null | cut -f1)"
echo ""

# 最近备份详情
LATEST_DATE=$(ls -t "$BACKUP_DIR" | head -1)
if [ -n "$LATEST_DATE" ]; then
    echo "📁 最新备份详情 ($LATEST_DATE):"
    ls -lh "$BACKUP_DIR/$LATEST_DATE"/*.tar.gz 2>/dev/null | awk '{print "  " $9 " - " $5}'
    echo ""
    
    # 备份清单
    if [ -f "$BACKUP_DIR/$LATEST_DATE/BACKUP-MANIFEST-"*".json" ]; then
        echo "📋 备份清单:"
        cat "$BACKUP_DIR/$LATEST_DATE/BACKUP-MANIFEST-"*".json" | grep -E '"backup_time"|"git_commit"' | sed 's/^/  /'
    fi
fi

echo ""
echo "🔗 GitHub 仓库:"
echo "  https://github.com/pyastar/studyai/tree/main/backup/auto"
echo ""

# Git 状态
echo "📤 Git 同步状态:"
cd "$PROJECT_DIR"
if git status --porcelain | grep -q "backup/"; then
    echo "  ⚠️  有未推送的备份"
else
    echo "  ✅ 备份已同步到 GitHub"
fi

echo ""
echo "=========================================="
