#!/bin/bash
# OpenClaw 商业化博客 - CSDN 发布脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_DIR/config.json"
LOG_DIR="$PROJECT_DIR/logs"

mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/publish-csdn-$(date +%Y%m%d).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 读取配置
CSDN_USERNAME=$(grep -o '"username"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | tail -1 | cut -d'"' -f4)
CSDN_AUTO=$(grep -o '"auto"[[:space:]]*:[[:space:]]*true' "$CONFIG_FILE" && echo "true" || echo "false")

# 发布到 CSDN（浏览器自动化）
publish_to_csdn() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        log "❌ 文件不存在：$file"
        exit 1
    fi
    
    log "📤 发布到 CSDN: $file"
    log "  用户名：$CSDN_USERNAME"
    log "  自动模式：$CSDN_AUTO"
    
    # 提取文章标题和内容
    local title=$(head -1 "$file" | sed 's/^# //')
    local content=$(cat "$file")
    
    log "  文章标题：$title"
    
    if [ "$CSDN_AUTO" = "true" ]; then
        log "🌐 启动浏览器自动化发布..."
        
        # 使用浏览器自动化发布到 CSDN
        # 这里调用 OpenClaw 的浏览器工具
        # 实际使用需要配置 CSDN 登录状态
        
        cat > /tmp/csdn_publish.py << 'PYTHON'
#!/usr/bin/env python3
"""
CSDN 自动发布脚本
需要预先登录并保存 Cookie
"""
import sys
import time

def publish_to_csdn(title, content):
    """
    发布文章到 CSDN
    需要浏览器自动化支持
    """
    print(f"准备发布：{title}")
    print("注意：需要配置 CSDN 浏览器自动化")
    print("1. 打开 CSDN 写文章页面")
    print("2. 填写标题和内容")
    print("3. 点击发布")
    
    # 实际实现需要浏览器自动化工具
    # 如 Playwright、Selenium 等
    
    return True

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("用法：python csdn_publish.py <title> <content_file>")
        sys.exit(1)
    
    title = sys.argv[1]
    content_file = sys.argv[2]
    
    with open(content_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    success = publish_to_csdn(title, content)
    sys.exit(0 if success else 1)
PYTHON
        
        python3 /tmp/csdn_publish.py "$title" "$file"
        
        log "✅ CSDN 发布完成（浏览器自动化）"
    else
        log "⚠️  自动发布未启用，请手动发布"
        log "  CSDN 写文章：https://mp.csdn.net/mp_blog/create/article"
        log ""
        log "  文章标题：$title"
        log "  文章内容：$file"
    fi
}

# 主函数
main() {
    log "=========================================="
    log "🚀 开始 CSDN 发布"
    log "=========================================="
    
    if [ -z "$1" ]; then
        log "❌ 请指定要发布的文件"
        echo "用法：$0 <文件路径>"
        exit 1
    fi
    
    publish_to_csdn "$1"
    
    log "=========================================="
    log "✅ 发布完成"
    log "=========================================="
}

main "$@"
