# OpenClaw 商业化博客 - 快速开始指南

## 🎯 5 分钟快速上手

### 1️⃣ 项目已初始化

项目结构已创建完成：

```
openclaw-monetization-blog/
├── README.md              # 项目说明
├── PROJECT-PLAN.md        # 详细方案
├── config.json            # 配置文件 ⚠️ 需要填写
├── scripts/               # 自动化脚本
│   ├── init.sh           # 初始化脚本 ✅
│   ├── collect.sh        # 内容采集
│   ├── generate.sh       # 文章生成
│   ├── publish-github.sh # GitHub 发布
│   ├── publish-csdn.sh   # CSDN 发布
│   └── daily-task.sh     # 每日任务
├── content/
│   ├── drafts/           # 草稿箱
│   ├── published/        # 已发布
│   └── templates/        # 模板
└── logs/                 # 日志
```

### 2️⃣ 配置必要信息

编辑 `config.json`，填写以下关键信息：

```bash
# 打开配置文件
nano config.json
```

**必填项**:

```json
{
  "blog": {
    "author": "杨勇",           // 你的姓名
    "email": "your@email.com"   // 你的邮箱
  },
  "publish": {
    "github": {
      "repo": "yourusername/openclaw-monetization",  // GitHub 仓库
      "token": "ghp_xxxxx"       // GitHub Token（可选）
    },
    "csdn": {
      "username": "your-csdn-name"  // CSDN 用户名
    }
  }
}
```

### 3️⃣ 测试运行

```bash
# 进入项目目录
cd ~/.openclaw/workspace/openclaw-monetization-blog

# 测试内容采集
./scripts/collect.sh

# 测试文章生成
./scripts/generate.sh

# 查看生成的文章
ls -la content/drafts/
cat content/drafts/*.md
```

### 4️⃣ 设置 GitHub 仓库（可选）

```bash
# 在 GitHub 上创建新仓库
# 然后初始化本地 Git

cd ~/.openclaw/workspace/openclaw-monetization-blog
git init
git remote add origin https://github.com/YOUR_USERNAME/openclaw-monetization.git
git add .
git commit -m "Initial commit"
git push -u origin main
```

### 5️⃣ 设置定时任务

```bash
# 编辑 crontab
crontab -e

# 添加每日任务（每天早上 9 点自动执行）
0 9 * * * /home/admin/.openclaw/workspace/openclaw-monetization-blog/scripts/daily-task.sh >> logs/cron.log 2>&1

# 保存退出
```

### 6️⃣ 查看示例文章

查看自动创建的欢迎文章：

```bash
cat content/drafts/2026-03-14-welcome.md
```

---

## 📋 完整配置说明

### GitHub Token 获取

1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token"
3. 勾选权限：`repo`（完整控制）
4. 生成后复制 Token
5. 粘贴到 `config.json` 的 `publish.github.token`

### CSDN 配置

CSDN 使用浏览器自动化发布，需要：

1. 首次手动登录 CSDN
2. 保存浏览器 Cookie（自动）
3. 后续可自动发布

---

## 🎯 日常使用流程

### 手动发布一篇文章

```bash
# 1. 生成文章（选择类型）
./scripts/generate.sh daily          # 日报
./scripts/generate.sh weekly         # 周报
./scripts/generate.sh topic "主题名"  # 指定主题

# 2. 编辑文章（可选）
nano content/drafts/YYYY-MM-DD-*.md

# 3. 发布到 GitHub
./scripts/publish-github.sh content/drafts/YYYY-MM-DD-*.md

# 4. 发布到 CSDN
./scripts/publish-csdn.sh content/drafts/YYYY-MM-DD-*.md
```

### 查看日志

```bash
# 查看今日日志
tail -f logs/daily-task-$(date +%Y%m%d).log

# 查看所有日志
ls -la logs/
```

---

## 📊 内容规划

### 主题分类

| 类型 | 说明 | 频率 | 模板 |
|------|------|------|------|
| 案例研究 | 成功变现案例 | 每周 2 篇 | case-study.md |
| 教程指南 | 实操教学 | 每周 2 篇 | tutorial.md |
| 工具推荐 | 工具评测 | 每周 1 篇 | - |
| 盈利模式 | 变现方式解析 | 每周 2 篇 | - |
| 行业趋势 | 市场动态 | 每周 1 篇 | - |

### 发布节奏

- **每日 9:00** - 自动化日报（500-1000 字）
- **周一 10:00** - 深度周报（2000+ 字）
- **每月 1 号** - 月度总结报告

---

## 🛠️ 故障排除

### 问题 1: 采集不到内容

```bash
# 检查网络
ping github.com

# 检查脚本
./scripts/collect.sh 2>&1 | tail -20
```

### 问题 2: 文章生成失败

```bash
# 检查配置文件
cat config.json | grep author

# 手动运行生成
./scripts/generate.sh daily 2>&1 | tail -20
```

### 问题 3: 发布失败

```bash
# 检查 GitHub 连接
git remote -v

# 检查发布日志
cat logs/publish-github-*.log
```

### 问题 4: 定时任务不执行

```bash
# 检查 cron 状态
crontab -l

# 检查 cron 服务
systemctl status cron

# 查看 cron 日志
grep CRON /var/log/syslog | tail -20
```

---

## 💡 进阶技巧

### 自定义内容模板

在 `content/templates/` 下创建新模板：

```bash
cp content/templates/tutorial.md content/templates/my-template.md
# 编辑模板内容
nano content/templates/my-template.md
```

### 添加新的数据源

编辑 `collect.sh`，添加新的采集逻辑：

```bash
# 在 collect.sh 中添加
collect_custom() {
    log "🔍 采集自定义数据源..."
    # 你的采集逻辑
}
```

### 集成更多发布平台

参考 `publish-github.sh` 和 `publish-csdn.sh`，创建新的发布脚本。

---

## 📞 获取帮助

### 文档

- `README.md` - 项目总览
- `PROJECT-PLAN.md` - 详细方案
- `QUICKSTART.md` - 本文件

### 日志

- `logs/collect-*.log` - 采集日志
- `logs/generate-*.log` - 生成日志
- `logs/publish-*.log` - 发布日志
- `logs/daily-task-*.log` - 每日任务日志

### 联系

- Email: your-email@example.com
- GitHub Issues: [仓库 Issues](https://github.com/yourusername/openclaw-monetization/issues)

---

## 🎉 开始创作

现在你已经准备好了！

```bash
# 运行第一次每日任务
./scripts/daily-task.sh

# 查看生成的内容
ls -la content/drafts/
ls -la output/

# 祝你创作愉快！
```

---

**下一步**: 编辑 `config.json` 填写你的信息，然后运行 `./scripts/daily-task.sh` 开始！🚀
