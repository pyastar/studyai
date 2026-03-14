# 发布文章到 GitHub 指南

## ✅ 文章已准备好

**文章位置**: `/home/admin/.openclaw/workspace/openclaw-monetization-blog/posts/2026-03-14-improved-article.md`

**目标仓库**: `https://github.com/pyastar/studyai`

---

## 📤 发布方式

### 方式 1: 使用推送脚本（推荐）

```bash
cd /home/admin/.openclaw/workspace/openclaw-monetization-blog
./scripts/push-to-github.sh
```

**执行后会提示**:
- 输入 GitHub 用户名
- 输入密码或 Token

**Token 获取**: https://github.com/settings/tokens

---

### 方式 2: 手动推送

```bash
# 1. 进入项目目录
cd /home/admin/.openclaw/workspace/openclaw-monetization-blog

# 2. 配置 Git 用户信息
git config user.email "pyastar@users.noreply.github.com"
git config user.name "杨勇"

# 3. 添加远程仓库
git remote add origin https://github.com/pyastar/studyai.git

# 4. 复制文章到 posts 目录
mkdir -p posts
cp content/drafts/2026-03-14-improved-article.md posts/

# 5. 添加并提交
git add posts/
git commit -m "📝 发布 OpenClaw 商业化文章 - 电商客服自动化案例"

# 6. 推送到 GitHub
git push -u origin master
```

---

### 方式 3: GitHub 网页上传（最简单）

1. **打开仓库**: https://github.com/pyastar/studyai

2. **创建 posts 目录**:
   - 点击 "Add file" → "Create new file"
   - 文件名输入：`posts/2026-03-14-improved-article.md`

3. **复制文章内容**:
   ```bash
   cat /home/admin/.openclaw/workspace/openclaw-monetization-blog/content/drafts/2026-03-14-improved-article.md
   ```

4. **粘贴并提交**:
   - 粘贴文章内容
   - 填写提交信息
   - 点击 "Commit new file"

---

## 🔑 GitHub Token 配置（可选）

如果要自动化推送，建议配置 Token：

**1. 创建 Token**:
- 访问：https://github.com/settings/tokens
- 点击 "Generate new token (classic)"
- 勾选权限：`repo`
- 生成并复制 Token

**2. 使用 Token 推送**:
```bash
git remote set-url origin https://YOUR_TOKEN@github.com/pyastar/studyai.git
git push -u origin master
```

---

## 📊 发布后效果

文章发布后，访问链接：
```
https://github.com/pyastar/studyai/blob/main/posts/2026-03-14-improved-article.md
```

---

## 🎯 自动发布配置

如果要每天自动发布，在 crontab 中添加：

```bash
crontab -e

# 添加以下内容（每天早上 9 点）
0 9 * * * cd /home/admin/.openclaw/workspace/openclaw-monetization-blog && ./scripts/push-to-github.sh >> logs/github-push.log 2>&1
```

**注意**: 需要配置 GitHub Token 才能自动推送

---

## 📞 遇到问题？

### 问题 1: 认证失败

**解决**: 使用 Token 代替密码
```bash
git remote set-url origin https://YOUR_TOKEN@github.com/pyastar/studyai.git
```

### 问题 2: 权限不足

**解决**: 确认你是仓库所有者或有写入权限

### 问题 3: 推送被拒绝

**解决**: 先拉取最新代码
```bash
git pull origin master
git push -u origin master
```

---

## ✅ 快速验证

发布成功后，检查：

1. **GitHub 仓库**: https://github.com/pyastar/studyai/tree/main/posts
2. **文章内容**: 打开文章链接查看
3. **README 更新**: 可选添加文章列表

---

**开始发布吧！** 🚀
