#!/bin/bash
# 每日新闻采集与部署脚本
# 执行时间：每日7:00

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$PROJECT_DIR/deploy.log"

echo "===== 开始执行新闻采集与部署任务 =====" | tee -a "$LOG_FILE"
echo "执行时间: $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"

# 进入项目目录
cd "$PROJECT_DIR"

# 检查必要文件是否存在
if [ ! -f "data/news.json" ]; then
    echo "错误: news.json 文件不存在" | tee -a "$LOG_FILE"
    exit 1
fi

if [ ! -f "index.html" ]; then
    echo "错误: index.html 文件不存在" | tee -a "$LOG_FILE"
    exit 1
fi

# Git操作
echo "开始Git提交..." | tee -a "$LOG_FILE"

# 配置Git（如果未配置）
if [ -z "$(git config user.email 2>/dev/null)" ]; then
    git config user.email "dailynews@copaw.com"
    git config user.name "DailyNews Bot"
fi

# 添加文件
git add data/news.json index.html

# 检查是否有变更
if git diff --cached --quiet; then
    echo "没有文件变更，跳过提交" | tee -a "$LOG_FILE"
else
    # 提交变更
    COMMIT_MSG="📰 更新每日新闻 - $(date '+%Y年%m月%d日')"
    git commit -m "$COMMIT_MSG" | tee -a "$LOG_FILE"
    
    # 推送到远程仓库
    git push origin main | tee -a "$LOG_FILE"
    echo "Git推送成功" | tee -a "$LOG_FILE"
fi

echo "===== 任务执行完成 =====" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"