#!/bin/bash
# QQ消息推送脚本
# 执行时间：每日8:00

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$PROJECT_DIR/notify.log"

echo "===== 开始执行QQ消息推送任务 =====" | tee -a "$LOG_FILE"
echo "执行时间: $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"

# 检查news.json是否存在
if [ ! -f "$PROJECT_DIR/data/news.json" ]; then
    echo "错误: news.json 文件不存在" | tee -a "$LOG_FILE"
    exit 1
fi

# 统计新闻数量
TOTAL_NEWS=$(cat "$PROJECT_DIR/data/news.json" | grep -o '"id":' | wc -l)
UPDATE_TIME=$(cat "$PROJECT_DIR/data/news.json" | grep '"update_time"' | cut -d'"' -f4)

# 构建推送消息
MESSAGE="📰 每日新闻早报
━━━━━━━━━━━━━━
📅 日期：$(date '+%Y年%m月%d日')
⏰ 更新时间：$UPDATE_TIME
📊 今日收录：${TOTAL_NEWS} 条热点新闻

🔥 9大分类全覆盖：
🏘️ 社会新闻  ⚽ 体育运动  🎬 影音娱乐
🔬 科学教育  💻 数码科技  🏛️ 时政军事
💰 财经动态  🚗 汽车资讯  🏠 生活资讯

👉 点击查看完整内容：
https://orangenekoo.github.io/DailyNews/

━━━━━━━━━━━━━━
💡 每天8点准时推送，祝您阅读愉快！"

echo "推送消息内容:" | tee -a "$LOG_FILE"
echo "$MESSAGE" | tee -a "$LOG_FILE"

# 这里可以调用QQ机器人API进行推送
# 由于环境限制，这里仅记录日志
echo "消息已准备就绪，等待推送到QQ频道" | tee -a "$LOG_FILE"

echo "===== 推送任务执行完成 =====" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"