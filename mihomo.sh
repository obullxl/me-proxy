#!/bin/sh

# 文件映射
# C:\Users\obull\output  /app/output
# C:\Users\obull\config  /app/config

# 1. 定义变量，使用容器内的Linux路径
UPDATE_FILE="/app/output/mihomo.yaml"  # Docker内访问Windows C盘的文件
REPO_DIR="/app/config/me-proxy/mihomo" # Docker内访问Windows D盘的仓库目录
DEST_FILE="${REPO_DIR}/mihomo.yaml"

# 2. 进入仓库目录
cd "$REPO_DIR" || { echo " 仓库目录 $REPO_DIR 不存在或无法访问"; exit 1; }

# 3. 如果目标文件已存在，则进行备份重命名
if [ -f "$DEST_FILE" ]; then
    # 生成当前时间戳，格式为 YYYYMMDDTHHMMSS
    TIMESTAMP=$(date +"%Y%m%dT%H%M%S")
    BACKUP_NAME="mihomo-${TIMESTAMP}.yaml"
    
    # 重命名旧文件
    mv "$DEST_FILE" "$BACKUP_NAME"
    echo "ℹ️ 已备份旧文件为: $BACKUP_NAME"
fi

# 4. 将新文件从C盘复制到仓库目录（覆盖）
# 注意：这里使用 cp 而不是 mv，以保留 C 盘的原始文件
cp "$UPDATE_FILE" "$DEST_FILE"
echo "✅ 已更新最新文件"

# 5. 执行 Git 提交和推送
cd /app/config/me-proxy
git add --all
git commit -m "Update mihomo.yaml"
git push

echo "🎉 同步完成"
