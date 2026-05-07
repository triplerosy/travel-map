# GitHub Pages 部署脚本

Write-Host "🚀 开始配置 GitHub Pages 部署..." -ForegroundColor Cyan
Write-Host ""

# 检查 Git 是否安装
try {
    $gitVersion = git --version
    Write-Host "✅ Git 已安装：$gitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ 未检测到 Git，请先安装 Git: https://git-scm.com/" -ForegroundColor Red
    exit
}

Write-Host ""

# 检查是否已初始化 Git 仓库
if (Test-Path ".git") {
    Write-Host "✅ Git 仓库已初始化" -ForegroundColor Green
} else {
    Write-Host "📦 正在初始化 Git 仓库..." -ForegroundColor Yellow
    git init
}

Write-Host ""

# 获取远程仓库地址
if (git remote -v | Select-String "origin") {
    Write-Host "✅ 远程仓库已配置" -ForegroundColor Green
    git remote -v
} else {
    Write-Host ""
    Write-Host "📍 请输入你的 GitHub 仓库地址：" -ForegroundColor Yellow
    Write-Host "   格式：https://github.com/你的用户名/travel-map.git" -ForegroundColor Gray
    $repoUrl = Read-Host "   仓库地址"
    
    if ($repoUrl) {
        git remote add origin $repoUrl
        Write-Host "✅ 远程仓库配置成功" -ForegroundColor Green
    } else {
        Write-Host "⚠️  未输入仓库地址，跳过远程仓库配置" -ForegroundColor Yellow
        Write-Host "   你可以稍后手动执行：git remote add origin <仓库地址>" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "📝 准备提交的文件：" -ForegroundColor Cyan
git status --short

Write-Host ""
Write-Host "💾 提交更改..." -ForegroundColor Yellow
git add .
$message = Read-Host "输入提交信息 (直接回车使用默认信息)"
if ($message) {
    git commit -m $message
} else {
    git commit -m "🎉 配置 GitHub Pages 部署"
}

Write-Host ""
Write-Host "📤 推送到 GitHub..." -ForegroundColor Yellow
Write-Host "   如果是第一次推送，使用：git push -u origin main" -ForegroundColor Gray
Write-Host "   如果已推送过，使用：git push" -ForegroundColor Gray
Write-Host ""

$pushChoice = Read-Host "现在要推送吗？(y/n)"
if ($pushChoice -eq 'y' -or $pushChoice -eq 'Y') {
    # 检查分支
    $currentBranch = git rev-parse --abbrev-ref HEAD
    if ($currentBranch -ne "main") {
        Write-Host "🔄 重命名分支为 main..." -ForegroundColor Yellow
        git branch -M main
    }
    
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ 推送成功！" -ForegroundColor Green
        Write-Host ""
        Write-Host "🎉 接下来请：" -ForegroundColor Cyan
        Write-Host "   1. 访问你的 GitHub 仓库" -ForegroundColor White
        Write-Host "   2. 进入 Settings → Pages" -ForegroundColor White
        Write-Host "   3. 设置 Source 为 'main' 分支" -ForegroundColor White
        Write-Host "   4. 等待 1-2 分钟" -ForegroundColor White
        Write-Host "   5. 访问生成的网站地址" -ForegroundColor White
        Write-Host ""
        Write-Host "🌐 网站地址格式：https://你的用户名.github.io/travel-map/" -ForegroundColor Cyan
    } else {
        Write-Host ""
        Write-Host "⚠️  推送失败，请检查远程仓库配置" -ForegroundColor Yellow
    }
} else {
    Write-Host ""
    Write-Host "💡 提示：稍后可以手动执行 git push 推送" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "📖 详细部署指南请查看：DEPLOY.md" -ForegroundColor Green
Write-Host ""
