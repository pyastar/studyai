#!/bin/bash
# 推送到 GitHub 脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "=========================================="
echo "📤 推送到 GitHub: pyastar/studyai"
echo "=========================================="
echo ""

# 配置 Git 用户信息
git config user.email "pyastar@users.noreply.github.com"
git config user.name "杨勇"

# 添加远程仓库（如果不存在）
if ! git remote -v | grep -q origin; then
    git remote add origin https://github.com/pyastar/studyai.git
    echo "✅ 添加远程仓库"
fi

# 复制文章到 posts 目录
mkdir -p posts
cp content/drafts/*.md posts/ 2>/dev/null || true
echo "✅ 复制文章到 posts 目录"

# 添加文件
git add posts/
echo "✅ 添加文件"

# 提交
git commit -m "📝 发布 OpenClaw 商业化文章 - $(date +%Y-%m-%d)" || echo "ℹ️  没有新改动"

# 推送
echo ""
echo "🚀 开始推送到 GitHub..."
echo "⚠️  可能需要输入 GitHub 用户名和密码（或 Token）"
echo ""

git push -u origin master

echo ""
echo "=========================================="
echo "✅ 推送完成！"
echo "=========================================="
echo ""
echo "📖 查看文章:"
echo "https://github.com/pyastar/studyai/tree/main/posts"
echo ""
