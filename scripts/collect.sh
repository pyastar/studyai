#!/bin/bash
# OpenClaw 商业化博客 - 内容采集脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_DIR/config.json"
OUTPUT_DIR="$PROJECT_DIR/output"
LOG_DIR="$PROJECT_DIR/logs"

# 创建目录
mkdir -p "$OUTPUT_DIR" "$LOG_DIR"

LOG_FILE="$LOG_DIR/collect-$(date +%Y%m%d).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 读取配置
read_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        log "❌ 配置文件不存在：$CONFIG_FILE"
        exit 1
    fi
    log "📖 读取配置文件..."
}

# 采集 GitHub 动态
collect_github() {
    log " 开始采集 GitHub 动态..."
    
    local repos=("openclaw/openclaw" "openclaw/skills")
    local output_file="$OUTPUT_DIR/github-$(date +%Y%m%d).md"
    
    echo "# GitHub 动态 - $(date +%Y-%m-%d)" > "$output_file"
    echo "" >> "$output_file"
    
    for repo in "${repos[@]}"; do
        log "  采集仓库：$repo"
        
        # 使用 GitHub API（需要配置 Token）
        # 这里用示例数据，实际使用需要配置 API_KEY
        echo "## 仓库：$repo" >> "$output_file"
        echo "" >> "$output_file"
        echo "- 采集时间：$(date '+%Y-%m-%d %H:%M:%S')" >> "$output_file"
        echo "- 状态：需要配置 GitHub API Token" >> "$output_file"
        echo "" >> "$output_file"
    done
    
    log "✅ GitHub 采集完成：$output_file"
}

# 采集搜索内容
collect_search() {
    log "🔍 开始采集搜索内容..."
    
    local keywords=("AI 自动化变现" "智能助理盈利" "被动收入" "自动化营销")
    local output_file="$OUTPUT_DIR/search-$(date +%Y%m%d).md"
    
    echo "# 搜索结果 - $(date +%Y-%m-%d)" > "$output_file"
    echo "" >> "$output_file"
    
    for keyword in "${keywords[@]}"; do
        log "  搜索关键词：$keyword"
        echo "## 关键词：$keyword" >> "$output_file"
        echo "" >> "$output_file"
        echo "- 采集时间：$(date '+%Y-%m-%d %H:%M:%S')" >> "$output_file"
        echo "- 状态：需要配置搜索 API" >> "$output_file"
        echo "" >> "$output_file"
    done
    
    log "✅ 搜索采集完成：$output_file"
}

# 采集社区内容
collect_community() {
    log "💬 开始采集社区内容..."
    
    local output_file="$OUTPUT_DIR/community-$(date +%Y%m%d).md"
    
    echo "# 社区动态 - $(date +%Y-%m-%d)" > "$output_file"
    echo "" >> "$output_file"
    echo "- 采集时间：$(date '+%Y-%m-%d %H:%M:%S')" >> "$output_file"
    echo "- 状态：待实现" >> "$output_file"
    echo "" >> "$output_file"
    
    log "✅ 社区采集完成：$output_file"
}

# 生成采集汇总
generate_summary() {
    log "📋 生成采集汇总..."
    
    local summary_file="$OUTPUT_DIR/daily-summary-$(date +%Y%m%d).md"
    
    echo "# 每日采集汇总 - $(date +%Y-%m-%d)" > "$summary_file"
    echo "" >> "$summary_file"
    echo "**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')" >> "$summary_file"
    echo "" >> "$summary_file"
    
    # 合并所有采集文件
    for file in "$OUTPUT_DIR"/github-*.md "$OUTPUT_DIR"/search-*.md "$OUTPUT_DIR"/community-*.md; do
        if [ -f "$file" ] && [[ "$file" != *summary* ]]; then
            echo "" >> "$summary_file"
            cat "$file" >> "$summary_file"
        fi
    done
    
    log "✅ 汇总完成：$summary_file"
}

# 主函数
main() {
    log "=========================================="
    log "🚀 开始内容采集"
    log "=========================================="
    
    read_config
    
    local mode="${1:-all}"
    
    case "$mode" in
        github)
            collect_github
            ;;
        search)
            collect_search
            ;;
        community)
            collect_community
            ;;
        all)
            collect_github
            collect_search
            collect_community
            ;;
        *)
            log "❌ 未知模式：$mode"
            echo "用法：$0 {github|search|community|all}"
            exit 1
            ;;
    esac
    
    generate_summary
    
    log "=========================================="
    log "✅ 采集完成"
    log "=========================================="
}

main "$@"
