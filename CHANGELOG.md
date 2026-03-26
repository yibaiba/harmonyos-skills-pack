# Changelog

All notable changes to this skills pack are documented in this file.

## [0.1.0] - 2026-03-26

### Added
- Initial release of reusable skills pack with two skills:
  - harmonyos-ark
  - universal-product-quality
- Standard skill directories with full content:
  - .claude/skills/harmonyos-ark
  - .claude/skills/universal-product-quality
  - .github/skills/harmonyos-ark
  - .github/skills/universal-product-quality
- Installer and uninstaller scripts:
  - scripts/install-skills.sh
  - scripts/uninstall-skills.sh
- Sync script to keep standard directories aligned with canonical source:
  - scripts/sync-skills.sh
- Machine-readable metadata:
  - llms.txt
  - SKILLS_MANIFEST.json
- Root publishing documentation:
  - README.md
  - AGENTS.md
  - CLAUDE.md
- Starter-kit standalone/offline path:
  - skills/harmonyos-ark/starter-kit/modules/offline-no-login.md
- Starter-kit optional auth-upgrade path:
  - skills/harmonyos-ark/starter-kit/modules/optional-login-upgrade.md

### Changed
- Updated harmonyos-ark route docs for starter-kit asset completeness and numbering consistency.
- Clarified source-of-truth and install flow for clone-based distribution.
- Updated starter-kit routing table and prompts to include offline/no-login and guest-to-auth upgrade paths.
- Updated Day 2 execution guidance to support both account-login and standalone offline branches.
- Updated app-type checklist (Type A tools) to explicitly recommend offline-no-login module.

[0.1.0]: RELEASE_NOTES_0.1.0.md
