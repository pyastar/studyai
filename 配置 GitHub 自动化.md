# 配置 GitHub 自动发布

## ✅ 当前状态

**已完成**:
- ✅ 文章已生成并准备好
- ✅ Git 仓库已初始化
- ✅ 远程仓库已配置
- ✅ 文章已提交到本地仓库

**待完成**:
- ⏳ 配置 GitHub Token 实现自动推送

---

## 🔑 为什么需要 Token？

GitHub 从 2021 年开始不再支持密码推送，必须使用 **Personal Access Token**。

---

## 📝 5 分钟配置 Token

### 第 1 步：创建 Token

1. **打开 GitHub Token 页面**:
   ```
   https://github.com/settings/tokens
   ```

2. **点击 "Generate new token"** → 选择 "Generate new token (classic)"

3. **填写信息**:
   - **Note**: `OpenClaw Blog Auto Push`
   - **Expiration**: `No expiration` (或选择 1 年)
   - **Select scopes**: 勾选 `repo` (完整控制私有仓库)

4. **点击 "Generate token"**

5. **复制 Token** (重要！只显示一次)
   ```
   ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```

### 第 2 步：配置到 Git

**方式 A: 临时使用（本次推送）**
```bash
cd /home/admin/.openclaw/workspace/openclaw-monetization-blog

# 使用 Token 推送
git remote set-url origin https://YOUR_TOKEN@github.com/pyastar/studyai.git
git push -u origin master
```

**方式 B: 永久配置（推荐）**
```bash
cd /home/admin/.openclaw/workspace/openclaw-monetization-blog

# 保存 Token 到 Git 配置
git config --global credential.helper store

# 推送一次（会提示输入用户名和密码）
git push -u origin master

# 输入:
# Username: pyastar
# Password: 粘贴你的 Token（不是 GitHub 密码！）

# 之后会自动保存，无需再次输入
```

**方式 C: 使用 Git Credential Manager（最简单）**
```bash
# 如果使用 Windows/Mac，Git 会自动弹出登录窗口
# 直接登录 GitHub 即可
git push -u origin master
```

---

## 🚀 一键配置脚本

创建一个配置脚本：

```bash
cat > /home/admin/.openclaw/workspace/openclaw-monetization-blog/setup-github-token.sh << 'EOF'
#!/bin/bash
# 配置 GitHub Token

echo "=========================================="
echo "🔑 配置 GitHub Token"
echo "=========================================="
echo ""
echo "请输入你的 GitHub Token:"
echo "(获取地址：https://github.com/settings/tokens)"
echo ""
read -s -p "Token: " GITHUB_TOKEN
echo ""

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ Token 不能为空"
    exit 1
fi

# 配置仓库 URL
cd /home/admin/.openclaw/workspace/openclaw-monetization-blog
git remote set-url origin https://${GITHUB_TOKEN}@github.com/pyastar/studyai.git

echo ""
echo "✅ Token 配置完成！"
echo ""
echo "现在推送文章到 GitHub..."
git push -u origin master

echo ""
echo "=========================================="
echo "✅ 配置完成！"
echo "=========================================="
echo ""
echo "📖 查看文章:"
echo "https://github.com/pyastar/studyai/tree/main/posts"
EOF

chmod +x /home/admin/.openclaw/workspace/openclaw-monetization-blog/setup-github-token.sh
```

运行脚本：
```bash
./setup-github-token.sh
```

---

## ✅ 验证配置

推送成功后，访问：
```
https://github.com/pyastar/studyai/tree/main/posts
```

应该能看到文章文件。

---

## 📅 自动发布配置

配置好 Token 后，设置每天自动发布：

```bash
crontab -e

# 添加以下内容（每天早上 9 点自动发布）
0 9 * * * cd /home/admin/.openclaw/workspace/openclaw-monetization-blog && ./scripts/auto-run.sh >> logs/auto-run.log 2>&1
```

---

## 🔒 安全提示

1. **Token 保密**: 不要分享或上传到公开仓库
2. **定期更新**: 建议每年更新一次 Token
3. **权限最小化**: 只给必要的权限（repo 足够）
4. **撤销权限**: 如果泄露，立即在 GitHub 撤销 Token

---

## 🆘 常见问题

### Q: Token 被盗用了怎么办？

**A**: 立即撤销：
1. 访问 https://github.com/settings/tokens
2. 找到对应的 Token
3. 点击 "Delete"

### Q: 推送失败 "Authentication failed"？

**A**: Token 可能过期或错误
- 重新生成 Token
- 更新配置：`git remote set-url origin https://NEW_TOKEN@github.com/...`

### Q: 找不到 "Generate new token" 按钮？

**A**: 确保已登录 GitHub，访问正确的 URL

---

## 📞 需要帮助？

配置过程中遇到问题，告诉我具体错误信息！

---

**配置完成后，系统将每天自动发布文章到 GitHub！** 🚀
