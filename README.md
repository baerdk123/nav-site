# 📎 我的导航站 — JAMStack 在线编辑版

纯静态导航站，可通过 `/admin` 网页后台在线编辑书签，手机/电脑都能用。

## 🏗 架构

```
GitHub 仓库
  ├── index.html        ← 导航前台（白色极简风格）
  ├── links.json        ← 书签数据库（CMS 直接编辑这个文件）
  ├── admin/
  │   ├── index.html    ← Decap CMS 后台入口
  │   └── config.yml    ← CMS 配置（关联 GitHub + Token）
  ├── _redirects        ← Cloudflare Pages 路由规则
  ├── _routes.json      ← Cloudflare Pages 高级路由
  └── build.sh          ← 构建脚本（注入 Token）
```

## 🚀 部署步骤（5分钟）

### 1️⃣ 在 GitHub 创建仓库

```bash
# 或直接在 GitHub 网页点 New repository，命名为 nav-site
```

### 2️⃣ 修改 admin/config.yml

把 `your-username/nav-site` 改为你的 GitHub 用户名/仓库名

```yaml
# 在第5行
repo: 你的GitHub用户名/nav-site
```

### 3️⃣ 创建 GitHub Personal Access Token

1. 访问 https://github.com/settings/tokens
2. 点 **Generate new token (classic)**
3. 勾选 `repo` 全部权限
4. 生成 token，复制保存（关掉就看不到了）

### 4️⃣ 推到 GitHub

```bash
cd 本项目目录
git init
git add .
git commit -m "初始化导航站"
git remote add origin https://github.com/你的用户名/nav-site.git
git push -u origin main
```

### 5️⃣ Cloudflare Pages 部署

1. 登录 [Cloudflare Pages](https://pages.cloudflare.com/)
2. **Create a project** → **Connect to Git** → 选择你的 nav-site 仓库
3. Build settings:
   - **Build command**: `chmod +x build.sh && ./build.sh`
   - **Build output directory**: `/`
4. 展开 **Environment variables (advanced)** → 添加：
   - `GITHUB_TOKEN` = 第3步生成的 token
5. 点 **Save and Deploy**

等1-2分钟部署完成，Cloudflare 会给你一个 `xxx.pages.dev` 域名。

### 6️⃣ 完成 🎉

| 页面 | 地址 |
|------|------|
| 导航前台 | `https://xxx.pages.dev/` |
| 后台管理 | `https://xxx.pages.dev/admin` |

**后台编辑**：打开 `/admin` → 会自动连接 GitHub → 看到 links.json 的内容 → 直接新增/修改/删除书签 → 点 **Publish** → 自动提交到 GitHub → 前台自动更新。

## 📱 手机端

浏览器打开 `/admin` 即可编辑，界面自适应手机，排版和桌面一致。

## 🔄 同步原理

```
在后台编辑保存
    ↓
Decap CMS 用 Token 直接写入 GitHub 仓库（更新 links.json）
    ↓
GitHub 检测到变更
    ↓
Cloudflare Pages 自动触发重新部署（约30秒）
    ↓
前台自动刷新生效
```

## ⚠️ 注意事项

- Token 只在 Cloudflare Pages 构建时使用，不会被提交到 git 历史
- 如果 Token 过期，在 Cloudflare Pages 环境变量中更新即可
- 前台首次加载会显示「加载中」，确认 links.json 存在且格式正确
