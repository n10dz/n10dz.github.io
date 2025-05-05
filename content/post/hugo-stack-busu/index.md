---
title: "在Windows上使用Hugo+GitHub Pages搭建个人博客全记录"
description: "手把手教你通过Hugo静态生成器stack主题与GitHub Pages在Windows系统部署个人博客"  # 新增SEO摘要
date: 2022-02-20T15:32:00+08:00
draft: false  # 发布前改为false
categories: ["捯饬博客"]
tags: ["Hugo", "GitHub Pages", "博客搭建", "stack主题"]  # 新增Utterances标签
license: "CC-BY-SA-4.0"  # 新增知识共享协议
comments: true  # 关键字段！启用Utterances评论
cover:
    image: "https://source.unsplash.com/featured/?coding,computer"
    alt: "Windows电脑显示代码编辑器与浏览器"
    caption: "Hugo + GitHub Pages 静态博客部署流程"
    hidden: false  # 控制封面图显隐（可选）
---

本文将详细记录我在Windows环境下使用Hugo静态网站生成器和GitHub Pages搭建个人博客的全过程，包含多分支管理策略和自动化部署方案。

## 环境准备
### 1. 安装Hugo Extended
推荐使用[扩展版Hugo](https://github.com/gohugoio/hugo/releases)以获得完整的SCSS支持：
```powershell
# 验证安装（需≥0.83.0）
hugo version
```

### 2. 初始化Git仓库

```powershell
hugo new site myblog
cd myblog
git init
```

## 主题配置

### 使用Stack主题（子模块方式）

```powershell
git submodule add https://github.com/CaiJimmy/hugo-theme-stack/ themes/stack
Copy-Item themes/stack/exampleSite/config.yaml ./config.yaml -Recurse
```

关键配置项：

```yaml
baseURL: "https://n10dz.github.io/"
theme: stack
params:
  sidebar:
    enabled: true
  social:
    GitHub: "https://github.com/n10dz/n10dz.github.io"
```

## 分支策略

采用双分支管理：

- `main` 分支：存放Hugo源文件
- `gh-blog` 分支：存放生成的静态页面

```powershell
# 创建干净的分支
git checkout --orphan gh-blog
git rm -rf .
echo "# Blog Pages" > README.md
git add . && git commit -m "Init pages branch"
git checkout -b main
```

## 部署流程

### 1. 推送源码到main分支

```powershell
git remote add origin https://github.com/n10dz/n10dz.github.io.git
git add .
git commit -m "Initial commit"
git push -u origin main
```

### 2. 生成并部署静态页面

```powershell
hugo -D  # 生成到public目录

cd public
git init
git checkout -b gh-blog
git add .
git commit -m "Deploy: $(date "+%Y-%m-%d %H:%M")"
git push origin gh-blog --force
```

## 自动化部署（可选）

在`.github/workflows/deploy.yml`添加GitHub Actions：

```yaml
name: Auto Deploy
on: [push]
jobs:
  build-deploy:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v4
      with:
        submodules: true
        
    - name: Setup Hugo
      uses: peaceiris/actions-hugo@v2
      with:
        hugo-version: 'latest'
        extended: true

    - name: Build
      run: hugo --minify

    - name: Deploy
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_branch: gh-blog
```

## 注意事项

1. 必须使用Hugo Extended版本
2. 主题建议通过submodule方式引入
3. GitHub Pages的发布分支需要设置为`gh-blog`
4. 每次更新内容后需要：
   - 提交源码到main分支
   - 重新生成并提交public目录到gh-blog分支

## 成果预览

访问你的GitHub Pages地址：
[https://n10dz.github.io](https://n10dz.github.io/)

至此，你已经拥有了一个完全免费、可自定义且支持自动化部署的现代博客系统。接下来可以开始创作你的技术文章啦！