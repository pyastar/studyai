#!/bin/bash
# OpenClaw 商业化博客 - 每日定时任务脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_DIR/config.json"
LOG_DIR="$PROJECT_DIR/logs"
CONTENT_DIR="$PROJECT_DIR/content"

mkdir -p "$LOG_DIR" "$CONTENT_DIR/drafts" "$CONTENT_DIR/published"

LOG_FILE="$LOG_DIR/daily-task-$(date +%Y%m%d).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 检查配置
check_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        log "❌ 配置文件不存在：$CONFIG_FILE"
        exit 1
    fi
    log "✅ 配置文件检查通过"
}

# 步骤 1: 采集内容
step_collect() {
    log "=========================================="
    log "📥 步骤 1: 采集内容"
    log "=========================================="
    
    if [ -x "$SCRIPT_DIR/collect.sh" ]; then
        bash "$SCRIPT_DIR/collect.sh" all
        log "✅ 内容采集完成"
    else
        log "⚠️  采集脚本不存在，跳过"
    fi
}

# 步骤 2: 生成文章
step_generate() {
    log "=========================================="
    log "✍️  步骤 2: 生成文章"
    log "=========================================="
    
    # 判断是周几，周一生成周报
    local day_of_week=$(date +%u)
    
    if [ "$day_of_week" = "1" ]; then
        log "今天是周一，生成周报..."
        bash "$SCRIPT_DIR/generate.sh" weekly
    else
        log "生成日报..."
        bash "$SCRIPT_DIR/generate.sh" daily
    fi
    
    log "✅ 文章生成完成"
}

# 步骤 3: 发布到 GitHub
step_publish_github() {
    log "=========================================="
    log "📤 步骤 3: 发布到 GitHub"
    log "=========================================="
    
    # 查找最新的草稿
    local latest_draft=$(ls -t "$CONTENT_DIR/drafts/"*.md 2>/dev/null | head -1)
    
    if [ -n "$latest_draft" ] && [ -f "$latest_draft" ]; then
        log "找到最新草稿：$latest_draft"
        
        if [ -x "$SCRIPT_DIR/publish-github.sh" ]; then
            bash "$SCRIPT_DIR/publish-github.sh" "$latest_draft"
            
            # 发布成功后移动到已发布目录
            mv "$latest_draft" "$CONTENT_DIR/published/"
            log "✅ 文章已移动到已发布目录"
        else
            log "⚠️  发布脚本不存在，跳过"
        fi
    else
        log "⚠️  没有找到草稿文件，跳过发布"
    fi
}

# 步骤 4: 发布到 CSDN
step_publish_csdn() {
    log "=========================================="
    log "📤 步骤 4: 发布到 CSDN"
    log "=========================================="
    
    # 查找最新的已发布文章
    local latest_published=$(ls -t "$CONTENT_DIR/published/"*.md 2>/dev/null | head -1)
    
    if [ -n "$latest_published" ] && [ -f "$latest_published" ]; then
        log "找到最新已发布文章：$latest_published"
        
        if [ -x "$SCRIPT_DIR/publish-csdn.sh" ]; then
            bash "$SCRIPT_DIR/publish-csdn.sh" "$latest_published"
            log "✅ CSDN 发布完成"
        else
            log "⚠️  CSDN 发布脚本不存在，跳过"
        fi
    else
        log "⚠️  没有找到已发布文件，跳过"
    fi
}

# 步骤 5: 清理和备份
step_cleanup() {
    log "=========================================="
    log "🧹 步骤 5: 清理和备份"
    log "=========================================="
    
    # 清理 7 天前的日志
    find "$LOG_DIR" -name "*.log" -mtime +7 -delete 2>/dev/null || true
    log "✅ 清理旧日志完成"
    
    # 备份今日内容
    local backup_dir="$PROJECT_DIR/backup/$(date +%Y%m)"
    mkdir -p "$backup_dir"
    cp -r "$CONTENT_DIR/published/"*.md "$backup_dir/" 2>/dev/null || true
    log "✅ 内容备份完成"
}

# 发送通知
send_notification() {
    local status="$1"
    local message="$2"
    
    log "📬 发送通知：$message"
    
    # 这里可以集成钉钉、微信等通知
    # 示例：调用钉钉机器人
    # curl -X POST "https://oapi.dingtalk.com/robot/send?access_token=YOUR_TOKEN" \
    #   -H "Content-Type: application/json" \
    #   -d "{\"msgtype\":\"text\",\"text\":{\"content\":\"$message\"}}"
    
    log "✅ 通知发送完成"
}

# 主函数
main() {
    log "=========================================="
    log "🌅 开始每日任务 - $(date +%Y-%m-%d)"
    log "=========================================="
    
    local start_time=$(date +%s)
    
    # 检查配置
    check_config
    
    # 执行各步骤
    step_collect
    step_generate
    step_publish_github
    step_publish_csdn
    step_cleanup
    
    # 计算执行时间
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    log "=========================================="
    log "✅ 每日任务完成"
    log "=========================================="
    log "📊 执行时间：${duration}秒"
    log "=========================================="
    
    # 发送成功通知
    send_notification "success" "✅ OpenClaw 商业化博客每日任务完成，耗时${duration}秒"
}

# 错误处理
trap 'log "❌ 任务执行失败"; send_notification "error" "❌ OpenClaw 商业化博客每日任务执行失败"' ERR

main "$@"
