#!/bin/bash
# Cloudflare Pages 构建脚本
set -e
echo "🚀 开始构建导航站..."

# 如果设置了 GITHUB_REPO，替换 config.yml 中的仓库名
if [ -n "$GITHUB_REPO" ]; then
  sed -i '' "s|your-username/nav-site|$GITHUB_REPO|g" admin/config.yml 2>/dev/null || \
  sed -i "s|your-username/nav-site|$GITHUB_REPO|g" admin/config.yml
  echo "✅ GITHUB_REPO 已注入: $GITHUB_REPO"
fi

# 如果设置了 GITHUB_TOKEN，替换占位符
if [ -n "$GITHUB_TOKEN" ]; then
  # token 可能包含特殊字符，用 awk 处理
  escaped_token=$(echo "$GITHUB_TOKEN" | sed 's/[\/&]/\\&/g')
  sed -i '' "s/GITHUB_TOKEN_PLACEHOLDER/$escaped_token/g" admin/config.yml 2>/dev/null || \
  sed -i "s/GITHUB_TOKEN_PLACEHOLDER/$escaped_token/g" admin/config.yml
  echo "✅ GITHUB_TOKEN 已注入"
else
  echo "⚠️  未设置 GITHUB_TOKEN——后台无法写入 GitHub"
fi

# 如果设置了 SITE_DOMAIN，替换域名占位符
if [ -n "$CF_PAGES_URL" ]; then
  domain=$(echo "$CF_PAGES_URL" | sed 's|https://||' | sed 's|/||')
  sed -i '' "s|你的域名.pages.dev|$domain|g" admin/config.yml 2>/dev/null || \
  sed -i "s|你的域名.pages.dev|$domain|g" admin/config.yml 2>/dev/null || true
fi

echo "✅ 构建完成"
