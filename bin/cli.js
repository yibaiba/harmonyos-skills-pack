#!/usr/bin/env node

/**
 * harmonyos-skills-pack CLI
 *
 * 从 GitHub 下载最新 skills 并安装到当前项目的
 * .claude/skills、.github/skills、.codex/skills 目录。
 *
 * 用法:
 *   npx harmonyos-skills-pack            # 安装到当前目录
 *   npx harmonyos-skills-pack --help     # 查看帮助
 *   npx harmonyos-skills-pack --target . # 指定目标目录
 *   npx harmonyos-skills-pack --claude-only  # 仅安装 .claude/skills
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

// ── 配置 ──────────────────────────────────────────────
const REPO = 'yibaiba/harmonyos-skills-pack';
const BRANCH = 'main';
const SKILLS = ['harmonyos-ark', 'universal-product-quality'];
const ARCHIVE_URL = `https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz`;
// 国内镜像（ghproxy.net 加速 GitHub 下载）
const MIRROR_URL = `https://ghproxy.net/https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz`;

// ── 颜色输出 ──────────────────────────────────────────
const color = {
  green: (s) => `\x1b[32m${s}\x1b[0m`,
  yellow: (s) => `\x1b[33m${s}\x1b[0m`,
  red: (s) => `\x1b[31m${s}\x1b[0m`,
  cyan: (s) => `\x1b[36m${s}\x1b[0m`,
  bold: (s) => `\x1b[1m${s}\x1b[0m`,
};

// ── 参数解析 ──────────────────────────────────────────
const args = process.argv.slice(2);

if (args.includes('--help') || args.includes('-h')) {
  console.log(`
${color.bold('harmonyos-skills-pack')} — 鸿蒙 Ark AI Agent Skills 一键安装

${color.cyan('用法:')}
  npx harmonyos-skills-pack              安装到当前目录
  npx harmonyos-skills-pack --target .   指定目标目录
  npx harmonyos-skills-pack --force      强制覆盖已有文件
  npx harmonyos-skills-pack --mirror     使用国内镜像加速下载
  npx harmonyos-skills-pack --claude-only    仅 .claude/skills
  npx harmonyos-skills-pack --copilot-only   仅 .github/skills
  npx harmonyos-skills-pack --codex-only     仅 .codex/skills
  npx harmonyos-skills-pack uninstall    移除已安装的 skills

${color.cyan('安装目标:')}
  .claude/skills/harmonyos-ark/
  .claude/skills/universal-product-quality/
  .github/skills/harmonyos-ark/
  .github/skills/universal-product-quality/
  .codex/skills/harmonyos-ark/
  .codex/skills/universal-product-quality/

${color.cyan('Skills 内容:')}
  harmonyos-ark           84 个文档，覆盖 ArkTS/ArkUI/Stage/路由/状态/网络/Kit
  universal-product-quality  12 个文档，覆盖产品质量检查/深色模式/多端适配
`);
  process.exit(0);
}

const targetIdx = args.indexOf('--target');
const targetDir = targetIdx !== -1 ? path.resolve(args[targetIdx + 1] || '.') : process.cwd();
const force = args.includes('--force');
const claudeOnly = args.includes('--claude-only');
const copilotOnly = args.includes('--copilot-only');
const codexOnly = args.includes('--codex-only');
const useMirror = args.includes('--mirror') || args.includes('--cn');
const isUninstall = args.includes('uninstall');

// 默认全部安装
const installTargets = [];
if (claudeOnly) {
  installTargets.push('.claude/skills');
} else if (copilotOnly) {
  installTargets.push('.github/skills');
} else if (codexOnly) {
  installTargets.push('.codex/skills');
} else {
  installTargets.push('.claude/skills', '.github/skills', '.codex/skills');
}

// ── 卸载 ─────────────────────────────────────────────
if (isUninstall) {
  console.log(color.yellow('🗑  正在卸载 skills...'));
  let removed = 0;
  for (const t of installTargets) {
    for (const skill of SKILLS) {
      const skillPath = path.join(targetDir, t, skill);
      if (fs.existsSync(skillPath)) {
        fs.rmSync(skillPath, { recursive: true, force: true });
        console.log(`  ${color.red('✗')} ${skillPath}`);
        removed++;
      }
    }
  }
  console.log(removed > 0
    ? color.green(`\n✅ 已移除 ${removed} 个 skill 目录`)
    : color.yellow('\n⚠️  未找到已安装的 skills'));
  process.exit(0);
}

// ── 安装 ─────────────────────────────────────────────
console.log(`
${color.bold('🚀 harmonyos-skills-pack')}
${color.cyan(useMirror ? '从国内镜像下载最新 skills...' : '从 GitHub 下载最新 skills...')}
`);

// 创建临时目录
const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'hm-skills-'));

try {
  // 下载并解压（镜像优先，失败自动回退 GitHub）
  const urls = useMirror ? [MIRROR_URL, ARCHIVE_URL] : [ARCHIVE_URL, MIRROR_URL];

  let downloaded = false;
  for (let i = 0; i < urls.length; i++) {
    const url = urls[i];
    const label = url.includes('ghproxy') ? '国内镜像' : 'GitHub';
    console.log(`  📥 ${i > 0 ? '回退到 ' : ''}下载 (${label})`);
    try {
      execSync(`curl -sL --connect-timeout 10 "${url}" | tar -xz -C "${tmpDir}"`, {
        stdio: ['pipe', 'pipe', 'pipe'],
        timeout: 60000,
      });
      downloaded = true;
      break;
    } catch (e) {
      if (i < urls.length - 1) {
        console.log(`  ${color.yellow('⚠')} ${label} 下载失败，尝试备用源...`);
      }
    }
  }

  if (!downloaded) {
    console.error(color.red('\n❌ 下载失败。请检查网络连接。'));
    console.error(color.yellow('   可尝试: git clone https://github.com/' + REPO + '.git'));
    process.exit(1);
  }

  // 找到解压后的目录
  const extracted = fs.readdirSync(tmpDir).find((d) =>
    d.startsWith('harmonyos-skills-pack')
  );
  if (!extracted) {
    console.error(color.red('❌ 解压失败，未找到预期目录'));
    process.exit(1);
  }
  const sourceRoot = path.join(tmpDir, extracted);

  // 复制 skills
  let installed = 0;
  for (const target of installTargets) {
    for (const skill of SKILLS) {
      const src = path.join(sourceRoot, 'skills', skill);
      const dst = path.join(targetDir, target, skill);

      if (!fs.existsSync(src)) {
        console.log(`  ${color.yellow('⚠')} 源文件不存在: skills/${skill}`);
        continue;
      }

      if (fs.existsSync(dst)) {
        if (force) {
          fs.rmSync(dst, { recursive: true, force: true });
        } else {
          console.log(`  ${color.yellow('⏭')} 已存在，跳过: ${dst} (用 --force 覆盖)`);
          continue;
        }
      }

      // 递归复制
      fs.mkdirSync(path.dirname(dst), { recursive: true });
      copyDirSync(src, dst);
      console.log(`  ${color.green('✓')} ${dst}`);
      installed++;
    }
  }

  // 复制 AGENTS.md 和 CLAUDE.md 到项目根目录（如果不存在）
  for (const f of ['AGENTS.md', 'CLAUDE.md']) {
    const src = path.join(sourceRoot, f);
    const dst = path.join(targetDir, f);
    if (fs.existsSync(src) && (!fs.existsSync(dst) || force)) {
      fs.copyFileSync(src, dst);
      console.log(`  ${color.green('✓')} ${f}`);
    }
  }

  // 完成
  console.log(`
${color.green(color.bold(`✅ 安装完成！${installed} 个 skill 目录已就位。`))}

${color.cyan('下一步:')}
  1. 打开 AI 编程工具（Claude/Copilot/Codex）
  2. 开始提问鸿蒙开发问题，Agent 会自动读取 skills
  3. 示例: "帮我实现一个带登录的鸿蒙应用"

${color.cyan('更多信息:')}
  GitHub: https://github.com/${REPO}
  文档:   npx harmonyos-skills-pack --help
`);

} finally {
  // 清理临时目录
  fs.rmSync(tmpDir, { recursive: true, force: true });
}

// ── 工具函数 ─────────────────────────────────────────
function copyDirSync(src, dst) {
  fs.mkdirSync(dst, { recursive: true });
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    const srcPath = path.join(src, entry.name);
    const dstPath = path.join(dst, entry.name);
    if (entry.isDirectory()) {
      copyDirSync(srcPath, dstPath);
    } else {
      fs.copyFileSync(srcPath, dstPath);
    }
  }
}
