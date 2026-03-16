# 自动备份方案

## 📋 方案概述

**目标**: 自动备份所有配置和重要文件到 GitHub，支持版本追踪和快速恢复

**备份内容**:
- ✅ 配置文件 (config.json)
- ✅ 脚本文件 (scripts/*.sh)
- ✅ 文档文件 (README, 指南等)
- ✅ 文章内容 (posts/, content/)
- ✅ 运行日志 (最近 7 天)

---

## 🚀 快速使用

### 手动备份

```bash
cd /home/admin/.openclaw/workspace/openclaw-monetization-blog
./scripts/backup-to-github.sh
```

### 自动备份（推荐）

已配置定时任务：
- **每次配置变更后**自动备份
- **每天 23:00** 自动备份
- **推送前**自动备份

---

## ⚙️ 配置说明

### 1. 配置监控文件

编辑 `scripts/backup-to-github.sh`，修改 `CONFIG_ITEMS` 数组：

```bash
CONFIG_ITEMS=(
    "config.json"          # 主配置
    ".git/config"          # Git 配置
    "scripts/*.sh"         # 所有脚本
    # 添加其他需要备份的文件
)
```

### 2. 配置备份频率

编辑 crontab：

```bash
crontab -e
```

添加：

```cron
# 每天 23:00 自动备份
0 23 * * * /home/admin/.openclaw/workspace/openclaw-monetization-blog/scripts/backup-to-github.sh >> /home/admin/.openclaw/workspace/openclaw-monetization-blog/logs/backup.log 2>&1

# 配置变更时备份（由配置监控脚本触发）
# 见 scripts/watch-config.sh
```

---

## 📁 备份目录结构

```
backup/
└── auto/
    ├── 2026-03-16/
    │   ├── config-20260316-230000.tar.gz    # 配置备份
    │   ├── docs-20260316-230000.tar.gz      # 文档备份
    │   ├── posts-20260316-230000.tar.gz     # 文章备份
    │   ├── logs-20260316-230000.tar.gz      # 日志备份
    │   ├── BACKUP-MANIFEST-20260316-230000.json  # 备份清单
    │   └── notification-20260316-230000.txt      # 通知内容
    ├── 2026-03-15/
    └── 2026-03-14/
```

---

## 🔍 查看备份历史

### 查看本地备份

```bash
# 查看所有备份
ls -lt backup/auto/

# 查看特定日期备份
ls -l backup/auto/2026-03-16/

# 查看备份清单
cat backup/auto/2026-03-16/BACKUP-MANIFEST-*.json
```

### 查看 GitHub 备份

访问：https://github.com/pyastar/studyai/tree/main/backup/auto

```bash
# 拉取最新备份
git pull origin master

# 查看备份提交历史
git log --oneline backup/auto/ | head -20
```

---

## 🔧 恢复备份

### 恢复配置文件

```bash
# 1. 找到要恢复的备份
ls -lt backup/auto/

# 2. 解压配置备份
cd backup/auto/2026-03-16/
tar -xzf config-20260316-230000.tar.gz

# 3. 恢复文件
cp config.json ../../
cp scripts/*.sh ../../scripts/

# 4. 验证
cat ../../config.json
```

### 恢复文章

```bash
# 解压文章备份
tar -xzf posts-20260316-230000.tar.gz

# 恢复文章
cp posts/*.md ../../posts/
cp content/drafts/*.md ../../content/drafts/
cp content/published/*.md ../../content/published/
```

### 使用 Git 恢复

```bash
# 查看备份相关的提交
git log --grep="自动备份" --oneline

# 恢复到特定备份点
git checkout <commit-hash> -- backup/auto/2026-03-16/

# 从备份点恢复文件
git show <commit-hash>:backup/auto/2026-03-16/config.json > config.json
```

---

## 📊 配置变更追踪

### 自动检测配置变更

创建配置监控脚本 `scripts/watch-config.sh`：

```bash
#!/bin/bash
# 监控配置文件变更，自动触发备份

CONFIG_FILE="config.json"
LAST_BACKUP_FILE=".last-backup"

# 计算配置文件哈希
CURRENT_HASH=$(md5sum $CONFIG_FILE | cut -d' ' -f1)

# 读取上次备份的哈希
if [ -f $LAST_BACKUP_FILE ]; then
    LAST_HASH=$(cat $LAST_BACKUP_FILE)
else
    LAST_HASH=""
fi

# 如果配置变更，触发备份
if [ "$CURRENT_HASH" != "$LAST_HASH" ]; then
    echo "⚠️  配置文件已变更，触发自动备份..."
    ./scripts/backup-to-github.sh
    echo $CURRENT_HASH > $LAST_BACKUP_FILE
fi
```

### 集成到 Git 钩子

创建 `.git/hooks/pre-push`：

```bash
#!/bin/bash
# 推送前自动备份

echo "🔄 推送前自动备份..."
./scripts/backup-to-github.sh
```

---

## 🔔 通知机制

### 钉钉通知

备份完成后自动发送钉钉消息：

```bash
# 在 backup-to-github.sh 末尾添加

# 发送钉钉通知
DINGTALK_WEBHOOK="https://oapi.dingtalk.com/robot/send?access_token=YOUR_TOKEN"

curl "$DINGTALK_WEBHOOK" \
  -H 'Content-Type: application/json' \
  -d "{
    \"msgtype\": \"text\",
    \"text\": {
        \"content\": \"✅ OpenClaw 博客自动备份完成\\n时间：$TIMESTAMP\\n位置：backup/$DATE/\"
    }
  }"
```

### 邮件通知

```bash
# 发送邮件通知
echo "备份完成：$TIMESTAMP" | mail -s "OpenClaw 备份通知" your-email@example.com
```

---

## 📈 备份策略

### 保留策略

- **最近 7 天**: 每天备份
- **最近 30 天**: 每周备份（保留周日）
- **最近 1 年**: 每月备份（保留 1 号）
- **永久**: 重大变更前备份

### 存储位置

| 位置 | 用途 | 保留期 |
|------|------|--------|
| 本地 backup/ | 快速恢复 | 30 天 |
| GitHub | 版本追踪 | 永久 |
| 云盘（可选） | 灾难恢复 | 永久 |

---

## 🛡️ 安全建议

### 1. 敏感信息处理

**不要备份**：
- ❌ API Keys
- ❌ 密码
- ❌ Token
- ❌ 数据库连接字符串

**解决方案**：
```bash
# 使用环境变量
export OPENCLAW_API_KEY="xxx"

# 或使用单独的 secrets 文件（不提交到 Git）
echo "API_KEY=xxx" > .env
echo ".env" >> .gitignore
```

### 2. Git 忽略配置

编辑 `.gitignore`：

```gitignore
# 不备份敏感文件
.env
*.key
*.pem
secrets.json
local-config.json

# 不备份大文件
*.log
backup/auto/*/logs-*.tar.gz
```

---

## 📝 最佳实践

### 1. 备份前检查清单

- [ ] 配置文件已更新
- [ ] 文章内容已保存
- [ ] 本地 Git 已提交
- [ ] 网络正常

### 2. 定期验证备份

```bash
# 每月验证一次备份可恢复性
./scripts/verify-backup.sh
```

### 3. 备份测试

```bash
# 测试备份脚本
./scripts/backup-to-github.sh --dry-run

# 测试恢复流程
./scripts/restore-test.sh
```

---

## 🔧 故障排除

### 问题 1: 备份失败

```bash
# 检查日志
tail -f logs/backup-*.log

# 检查磁盘空间
df -h

# 检查 Git 状态
git status
```

### 问题 2: 推送失败

```bash
# 检查网络连接
ping github.com

# 检查 Git 配置
git remote -v

# 手动推送
git push origin master
```

### 问题 3: 备份文件过大

```bash
# 查看备份大小
du -sh backup/auto/*

# 清理旧备份
find backup/auto -mtime +30 -delete

# 排除大文件
tar --exclude='*.log' -czf backup.tar.gz ...
```

---

## 📞 获取帮助

### 查看备份状态

```bash
# 最新备份
ls -lt backup/auto/ | head -5

# 备份统计
du -sh backup/auto/

# 备份历史
git log --oneline -- backup/auto/ | head -20
```

### 快速命令

```bash
# 立即备份
alias backup='./scripts/backup-to-github.sh'

# 查看备份
alias backup-list='ls -lt backup/auto/'

# 恢复最新
alias backup-restore='cd backup/auto && ls -t | head -1 | xargs tar -xzf'
```

---

**最后更新**: 2026-03-16  
**状态**: ✅ 已配置自动备份
