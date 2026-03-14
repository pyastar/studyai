#!/bin/bash
# OpenClaw 商业化博客 - 初始化脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=========================================="
echo "🚀 OpenClaw 商业化博客 - 初始化向导"
echo "=========================================="
echo ""

# 1. 创建必要目录
echo "📁 创建目录结构..."
mkdir -p "$PROJECT_DIR/content/drafts"
mkdir -p "$PROJECT_DIR/content/published"
mkdir -p "$PROJECT_DIR/content/templates"
mkdir -p "$PROJECT_DIR/output"
mkdir -p "$PROJECT_DIR/logs"
mkdir -p "$PROJECT_DIR/backup"
echo "✅ 目录创建完成"
echo ""

# 2. 检查配置文件
echo "📋 检查配置文件..."
if [ -f "$PROJECT_DIR/config.json" ]; then
    echo "✅ 配置文件已存在"
    echo ""
    echo "⚠️  请编辑 config.json 填写以下信息:"
    echo "   - blog.author (你的姓名)"
    echo "   - blog.email (你的邮箱)"
    echo "   - publish.github.repo (GitHub 仓库)"
    echo "   - publish.github.token (GitHub Token)"
    echo "   - publish.csdn.username (CSDN 用户名)"
    echo ""
else
    echo "❌ 配置文件不存在"
    echo "   请确保 config.json 在项目根目录"
    exit 1
fi

# 3. 检查脚本权限
echo "🔧 设置脚本权限..."
chmod +x "$SCRIPT_DIR"/*.sh
echo "✅ 脚本权限设置完成"
echo ""

# 4. 初始化 Git 仓库（可选）
echo "📦 是否初始化 Git 仓库？(y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    cd "$PROJECT_DIR"
    
    if [ ! -d ".git" ]; then
        git init
        echo "✅ Git 仓库初始化完成"
        
        echo ""
        echo "📝 输入你的 GitHub 仓库地址 (例如：https://github.com/yourusername/openclaw-monetization.git):"
        read -r repo_url
        
        if [ -n "$repo_url" ]; then
            git remote add origin "$repo_url"
            echo "✅ 远程仓库添加完成"
        fi
    else
        echo "ℹ️  Git 仓库已存在"
    fi
else
    echo "⏭️  跳过 Git 初始化"
fi
echo ""

# 5. 创建示例文章
echo "📝 创建示例文章..."

cat > "$PROJECT_DIR/content/drafts/$(date +%Y-%m-%d)-welcome.md" << 'EOF'
# OpenClaw 商业化变现指南 - 开篇

> 开启你的 AI 自动化盈利之旅

---

## 👋 欢迎来到 OpenClaw 商业化变现指南

这是一个专注于分享 OpenClaw 商业化变现方案的博客。

每天，我会为你带来：

- 📰 最新的 OpenClaw 商业化动态
- 💡 实用的变现案例和技巧
- 🛠️ 好用的自动化工具推荐
- 📊 深入的盈利模式分析

---

## 🎯 为什么关注 OpenClaw 商业化？

### AI 自动化是大势所趋

2026 年，AI 助手已经成为企业和个人的标配。但是：

- ❌ 大多数人只用它来聊天
- ❌ 不知道如何用 AI 赚钱
- ❌ 缺乏系统的变现方法

### OpenClaw 的价值

OpenClaw 是一个开源的 AI 自动化平台，它可以帮助你：

- ✅ 连接各种 AI 模型
- ✅ 自动化日常任务
- ✅ 创建智能工作流
- ✅ 实现被动收入

---

## 💰 常见的 OpenClaw 变现模式

### 1. 自动化服务

帮助企业或个人搭建自动化工作流，收取服务费。

**收益**: ¥5,000 - ¥50,000/项目

### 2. 技能开发

开发实用的 OpenClaw 技能，出售或订阅制收费。

**收益**: ¥1,000 - ¥20,000/月

### 3. 培训教学

开设 OpenClaw 培训课程，教学赚钱。

**收益**: ¥3,000 - ¥30,000/期

### 4. 内容创作

通过博客、视频等内容引流，实现多种变现。

**收益**: ¥2,000 - ¥50,000/月

### 5. 咨询服务

为企业提供 AI 自动化转型咨询。

**收益**: ¥10,000 - ¥100,000/项目

---

## 📅 更新计划

### 每日更新

- 早 9 点：商业化日报
- 包含最新案例、工具推荐、行业动态

### 每周深度

- 周一：周报 + 深度分析
- 包含变现模式详解、实操教程

### 每月汇总

- 月末：月度报告
- 包含趋势分析、收益总结

---

## 🎓 如何开始？

### 第一步：关注本博客

- GitHub: [你的仓库链接]
- CSDN: [你的 CSDN 主页]
- 公众号：[你的公众号]

### 第二步：学习基础知识

推荐阅读：

1. [OpenClaw 入门教程](链接)
2. [AI 自动化基础](链接)
3. [变现模式详解](链接)

### 第三步：动手实践

- 安装 OpenClaw
- 配置你的第一个自动化
- 开始尝试变现

### 第四步：持续优化

- 学习进阶技巧
- 优化你的自动化流程
- 扩展收入来源

---

## 💬 互动方式

### 提问交流

- 在 GitHub Issues 提问
- 加入读者交流群
- 邮件联系

### 投稿合作

如果你有好的案例或经验，欢迎投稿！

- 邮箱：your-email@example.com
- 微信：your-wechat

---

## 🎁 读者福利

关注本博客，你将获得：

1. **免费资源包**
   - OpenClaw 配置模板
   - 变现案例合集
   - 工具推荐清单

2. **专属社群**
   - 与志同道合者交流
   - 获取一手资讯
   - 合作机会

3. **持续更新**
   - 每日最新内容
   - 深度分析报告
   - 实战教程

---

## 🚀 开始你的变现之旅

从今天开始，每天花 10 分钟阅读本博客，一个月后你将：

- ✅ 掌握多种 OpenClaw 变现方法
- ✅ 拥有自己的自动化收入系统
- ✅ 实现时间和财务自由

**立即行动，开启你的 AI 自动化盈利之路！**

---

**标签**: #OpenClaw #AI 自动化 #变现 #副业 #被动收入 #开篇

**作者**: 杨勇  
**日期**: 2026-03-14  
**版本**: v1.0

---

## 📞 联系方式

- 📧 Email: your-email@example.com
- 💬 微信：your-wechat
- 🌐 网站：your-website.com
- 📱 公众号：你的公众号

**期待与你一起成长！** 🎉
EOF

echo "✅ 示例文章创建完成"
echo ""

# 6. 显示下一步指引
echo "=========================================="
echo "✅ 初始化完成！"
echo "=========================================="
echo ""
echo "📋 下一步:"
echo ""
echo "1. 编辑配置文件:"
echo "   nano $PROJECT_DIR/config.json"
echo ""
echo "2. 填写以下信息:"
echo "   - blog.author (你的姓名)"
echo "   - blog.email (你的邮箱)"
echo "   - publish.github.repo (GitHub 仓库)"
echo "   - publish.github.token (GitHub Token)"
echo "   - publish.csdn.username (CSDN 用户名)"
echo ""
echo "3. 测试运行:"
echo "   cd $PROJECT_DIR"
echo "   ./scripts/collect.sh"
echo "   ./scripts/generate.sh"
echo ""
echo "4. 设置定时任务:"
echo "   crontab -e"
echo "   添加：0 9 * * * $PROJECT_DIR/scripts/daily-task.sh >> logs/cron.log 2>&1"
echo ""
echo "5. 查看示例文章:"
echo "   cat $PROJECT_DIR/content/drafts/$(date +%Y-%m-%d)-welcome.md"
echo ""
echo "=========================================="
echo "🎉 祝你使用愉快！"
echo "=========================================="
