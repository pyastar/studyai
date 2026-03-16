#!/bin/bash
# 配置文件变更监控脚本
# 功能：检测配置变更，自动触发备份

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_DIR/config.json"
STATE_FILE="$PROJECT_DIR/.backup-state"
LOG_DIR="$PROJECT_DIR/logs"

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_DIR/config-watch.log"
}

# 计算配置文件哈希
current_hash=$(md5sum "$CONFIG_FILE" 2>/dev/null | cut -d' ' -f1 || echo "none")

# 读取上次备份的哈希
if [ -f "$STATE_FILE" ]; then
    last_hash=$(cat "$STATE_FILE" 2>/dev/null || echo "none")
else
    last_hash="none"
fi

log "配置检查：当前=$current_hash, 上次=$last_hash"

# 如果配置变更，触发备份
if [ "$current_hash" != "$last_hash" ]; then
    log "⚠️  配置文件已变更，触发自动备份..."
    
    # 执行备份
    cd "$PROJECT_DIR"
    ./scripts/backup-to-github.sh
    
    # 更新状态
    echo "$current_hash" > "$STATE_FILE"
    
    log "✅ 备份完成，状态已更新"
else
    log "✅ 配置无变更"
fi
