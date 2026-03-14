#!/bin/bash
# 配置 GitHub Token 并推送文章

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"

cd "$PROJECT_DIR"

echo "=========================================="
echo "🔑 配置 GitHub Token 并推送"
echo "=========================================="
echo ""
echo "📝 获取 Token 步骤:"
echo "1. 访问：https://github.com/settings/tokens"
echo "2. 点击 'Generate new token (classic)'"
echo "3. Note 填写：OpenClaw Blog"
echo "4. 勾选 'repo' 权限"
echo "5. 点击 'Generate token'"
echo "6. 复制 Token (ghp_xxxxx)"
echo ""
echo "⚠️  Token 只显示一次，请妥善保管！"
echo ""
read -p "按回车键继续..."
echo ""

echo "请输入你的 GitHub Token:"
read -s -p "Token: " GITHUB_TOKEN
echo ""
echo ""

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ Token 不能为空"
    exit 1
fi

echo "✅ Token 已接收"
echo ""

# 配置 Git 用户信息
echo "⚙️  配置 Git 用户信息..."
git config user.email "pyastar@users.noreply.github.com"
git config user.name "杨勇"

# 配置远程仓库 URL（带 Token）
echo "🔗 配置远程仓库..."
git remote set-url origin https://${GITHUB_TOKEN}@github.com/pyastar/studyai.git

# 检查文章
echo "📄 检查文章..."
if [ ! -f "posts/2026-03-14-improved-article.md" ]; then
    echo "❌ 文章不存在"
    exit 1
fi
echo "✅ 文章已准备好"

# 推送到 GitHub
echo ""
echo "🚀 开始推送到 GitHub..."
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
echo "💡 提示:"
echo "Token 已保存到 Git 配置，下次推送无需再次输入"
echo ""
echo "📅 设置自动发布:"
echo "crontab -e"
echo "添加：0 9 * * * $PROJECT_DIR/scripts/auto-run.sh >> logs/auto-run.log 2>&1"
echo ""
