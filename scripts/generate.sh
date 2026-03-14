#!/bin/bash
# OpenClaw 商业化博客 - 文章生成脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_DIR/config.json"
OUTPUT_DIR="$PROJECT_DIR/output"
CONTENT_DIR="$PROJECT_DIR/content/drafts"
LOG_DIR="$PROJECT_DIR/logs"

# 创建目录
mkdir -p "$CONTENT_DIR" "$LOG_DIR"

LOG_FILE="$LOG_DIR/generate-$(date +%Y%m%d).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 读取配置
read_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        log "❌ 配置文件不存在：$CONFIG_FILE"
        exit 1
    fi
}

# 生成日报文章
generate_daily() {
    log "📝 生成每日文章..."
    
    local date_str=$(date +%Y-%m-%d)
    local title="OpenClaw 商业化日报 - $date_str"
    local filename="$CONTENT_DIR/${date_str}-daily.md"
    
    # 查找今日采集的汇总文件
    local summary_file="$OUTPUT_DIR/daily-summary-${date_str//-/}.md"
    
    cat > "$filename" << 'EOF'
# OpenClaw 商业化日报 - {{DATE}}

> 每天一个 AI 自动化盈利方案

---

## 📰 今日热点

[此处填入今日采集的热点内容]

---

## 💡 变现案例

### 案例名称
[案例详细描述]

**核心要点**:
- 要点 1
- 要点 2
- 要点 3

**收益分析**:
- 投入成本：XXX
- 预期收益：XXX
- 回本周期：XXX

---

## 🛠️ 工具推荐

### 工具名称
[工具介绍和使用方法]

**适用场景**: [说明]

**获取方式**: [链接]

---

## 📊 数据洞察

[今日行业数据或趋势分析]

---

## 🎯 明日预告

[下期内容预告]

---

**标签**: #OpenClaw #AI 自动化 #变现 #副业

**作者**: {{AUTHOR}}  
**日期**: {{DATE}}
EOF

    # 替换变量
    sed -i "s/{{DATE}}/$date_str/g" "$filename"
    sed -i "s/{{AUTHOR}}/$(grep -o '"author"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)/g" "$filename"
    
    log "✅ 日报生成完成：$filename"
    echo "$filename"
}

# 生成周报文章
generate_weekly() {
    log "📊 生成每周深度文章..."
    
    local date_str=$(date +%Y-%m-%d)
    local week_num=$(date +%V)
    local filename="$CONTENT_DIR/${date_str}-weekly-week${week_num}.md"
    
    cat > "$filename" << 'EOF'
# OpenClaw 商业化周报 - 第{{WEEK}}周

> 每周深度分析 | AI 自动化变现趋势

---

## 📈 本周概览

[本周重要事件和趋势总结]

---

## 🔥 热门话题

### 话题一
[详细内容]

### 话题二
[详细内容]

### 话题三
[详细内容]

---

## 💰 变现模式深度解析

### 模式名称
[模式详细介绍]

**优势**:
- 优势 1
- 优势 2

**实施步骤**:
1. 步骤一
2. 步骤二
3. 步骤三

**注意事项**:
- 注意 1
- 注意 2

---

## 📚 精选资源

- [资源 1](链接)
- [资源 2](链接)
- [资源 3](链接)

---

## 🎓 学习路线

[本周推荐的学习路径]

---

## 💬 读者问答

**Q**: [常见问题]  
**A**: [详细解答]

---

## 📅 下周预告

[下周内容计划]

---

**标签**: #OpenClaw #周报 #AI 自动化 #变现模式 #深度分析

**作者**: {{AUTHOR}}  
**日期**: {{DATE}}  
**期数**: 第{{WEEK}}周
EOF

    # 替换变量
    sed -i "s/{{WEEK}}/$week_num/g" "$filename"
    sed -i "s/{{DATE}}/$date_str/g" "$filename"
    sed -i "s/{{AUTHOR}}/$(grep -o '"author"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)/g" "$filename"
    
    log "✅ 周报生成完成：$filename"
    echo "$filename"
}

# 生成指定主题文章
generate_topic() {
    local topic="$1"
    log "📝 生成主题文章：$topic"
    
    local date_str=$(date +%Y-%m-%d)
    local filename="$CONTENT_DIR/${date_str}-${topic// /-}.md"
    
    cat > "$filename" << EOF
# $topic - 深度指南

> 专业教程 | 实操步骤

---

## 什么是 $topic

[概念介绍]

---

## 为什么重要

[重要性说明]

---

## 如何实施

### 第一步
[详细说明]

### 第二步
[详细说明]

### 第三步
[详细说明]

---

## 常见问题

**Q**: 问题 1  
**A**: 解答 1

**Q**: 问题 2  
**A**: 解答 2

---

## 总结

[内容总结]

---

**标签**: #OpenClaw #教程 #${topic// /#}

**作者**: $(grep -o '"author"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)  
**日期**: $date_str
EOF

    log "✅ 主题文章生成完成：$filename"
    echo "$filename"
}

# 主函数
main() {
    log "=========================================="
    log "✍️ 开始文章生成"
    log "=========================================="
    
    read_config
    
    local mode="${1:-daily}"
    
    case "$mode" in
        daily)
            generate_daily
            ;;
        weekly)
            generate_weekly
            ;;
        topic)
            if [ -z "$2" ]; then
                log "❌ 需要指定主题"
                echo "用法：$0 topic \"主题名称\""
                exit 1
            fi
            generate_topic "$2"
            ;;
        *)
            log "❌ 未知模式：$mode"
            echo "用法：$0 {daily|weekly|topic}"
            exit 1
            ;;
    esac
    
    log "=========================================="
    log "✅ 生成完成"
    log "=========================================="
}

main "$@"
