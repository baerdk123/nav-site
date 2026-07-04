#!/bin/bash
# ==========================================
# 导航站一键部署脚本
# 在能连外网的电脑上运行即可
# ==========================================
set -e

echo "================================"
echo "  导航站 - 一键部署"
echo "================================"

# --- 设置你的 GitHub 信息 ---
GITHUB_USER="baerdk123"
REPO_NAME="nav-site"
echo ""
echo "请输入你的 GitHub Personal Access Token（以 ghp_ 开头）："
read -s GITHUB_TOKEN
echo ""

if [ -z "$GITHUB_TOKEN" ]; then
  echo "❌ Token 不能为空"
  exit 1
fi

# --- 1. 下载代码 ---
echo "📦 下载代码..."
curl -sL "https://github.com/$GITHUB_USER/$REPO_NAME/archive/refs/heads/main.tar.gz" -o /tmp/nav-site.tar.gz 2>/dev/null || true

if [ -f /tmp/nav-site.tar.gz ] && [ -s /tmp/nav-site.tar.gz ]; then
  # 仓库已存在，下载
  tar -xzf /tmp/nav-site.tar.gz -C /tmp
  cd "/tmp/$REPO_NAME-main"
  echo "✅ 代码下载成功"
else
  echo "⚠️  仓库不存在，将在推送时自动创建"
  echo "   请先到 https://github.com/new 创建仓库 $REPO_NAME（不要初始化任何文件）"
  echo "   然后重新运行此脚本"
  exit 1
fi

# --- 2. 配置远程仓库 ---
echo "🔗 配置远程仓库..."
git remote set-url origin "https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/$REPO_NAME.git"

# --- 3. 推送 ---
echo "📤 推送到 GitHub..."
git push -u origin main 2>&1 | head -20
echo "✅ 代码已推送"

# --- 4. 打开 Cloudflare Pages ---
echo ""
echo "================================"
echo "🎉 推送成功！"
echo ""
echo "接下来请手动完成："
echo ""
echo "1. 打开 https://dash.cloudflare.com/"
echo "2. 左侧 → Workers & Pages → Create application → Pages → Connect to Git"
echo "3. 授权 GitHub，选择 $GITHUB_USER/$REPO_NAME"
echo "4. Build command: chmod +x build.sh && ./build.sh"
echo "5. Output directory: /"
echo "6. 展开 Environment variables，添加："
echo "   GITHUB_REPO  = $GITHUB_USER/$REPO_NAME"
echo "   GITHUB_TOKEN = $GITHUB_TOKEN"
echo "7. Save and Deploy"
echo ""
echo "部署完成后："
echo "  前台: https://$REPO_NAME.pages.dev"
echo "  后台: https://$REPO_NAME.pages.dev/admin"
echo "================================"
