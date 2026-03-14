#!/bin/bash
# OpenClaw 商业化博客 - 全自动运行脚本（含自动发布）

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_DIR/logs"
CONTENT_DIR="$PROJECT_DIR/content"

mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/auto-run-$(date +%Y%m%d-%H%M%S).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 步骤 1: 采集内容
step_collect() {
    log "=========================================="
    log "📥 步骤 1: 采集内容"
    log "=========================================="
    
    bash "$SCRIPT_DIR/collect.sh" all
    
    log "✅ 内容采集完成"
}

# 步骤 2: 生成文章
step_generate() {
    log "=========================================="
    log "✍️  步骤 2: 生成文章"
    log "=========================================="
    
    local date_str=$(date +%Y-%m-%d)
    local summary_file="$PROJECT_DIR/output/daily-summary-${date_str//-/}.md"
    
    if [ -f "$summary_file" ]; then
        log "  读取采集内容..."
        bash "$SCRIPT_DIR/generate.sh" daily
    else
        log "  采集汇总不存在，使用模板生成..."
        bash "$SCRIPT_DIR/generate.sh" daily
    fi
    
    log "✅ 文章生成完成"
}

# 步骤 3: 自动发布到 GitHub
step_publish_github() {
    log "=========================================="
    log "📤 步骤 3: 发布到 GitHub"
    log "=========================================="
    
    # 检查是否启用自动发布
    local auto_enabled=$(grep -o '"autoPush"[[:space:]]*:[[:space:]]*true' "$PROJECT_DIR/config.json" || echo "")
    
    if [ -n "$auto_enabled" ]; then
        log "  GitHub 自动发布已启用"
        bash "$SCRIPT_DIR/auto-publish-github.sh"
    else
        log "  ℹ️  GitHub 自动发布未启用，跳过"
    fi
}

# 步骤 4: 清理和备份
step_cleanup() {
    log "=========================================="
    log "🧹 步骤 4: 清理和备份"
    log "=========================================="
    
    # 清理 7 天前的日志
    find "$LOG_DIR" -name "*.log" -mtime +7 -delete 2>/dev/null || true
    log "✅ 清理旧日志"
    
    # 备份今日内容
    local backup_dir="$PROJECT_DIR/backup/$(date +%Y%m)"
    mkdir -p "$backup_dir"
    cp -r "$CONTENT_DIR/published/"*.md "$backup_dir/" 2>/dev/null || true
    log "✅ 备份完成"
}

# 主流程
main() {
    log "=========================================="
    log "🚀 OpenClaw 商业化博客 - 全自动运行"
    log "=========================================="
    log "📅 日期：$(date +%Y-%m-%d)"
    log "⏰ 时间：$(date +%H:%M:%S)"
    log "=========================================="
    
    local start_time=$(date +%s)
    
    # 执行全流程
    step_collect
    step_generate
    step_publish_github
    step_cleanup
    
    # 计算执行时间
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    log "=========================================="
    log "✅ 全自动运行完成"
    log "=========================================="
    log "📊 执行时间：${duration}秒"
    log "=========================================="
    
    # 显示结果
    log ""
    log "📁 生成的文件:"
    ls -lh "$CONTENT_DIR/published/"*.md 2>/dev/null | tail -3
    log ""
}

# 错误处理
trap 'log "❌ 执行失败"' ERR

# 运行
main "$@"
