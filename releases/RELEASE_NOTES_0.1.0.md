# Release Notes 0.1.0

Release Date: 2026-03-26

## Highlights
- First publishable version of the clone-installable skills pack.
- Full skill content is available in standard directories for both Claude and Copilot.
- Added install/uninstall/sync scripts for lifecycle management.
- Added standalone offline/no-login design path for HarmonyOS starter-kit.
- Added optional login-upgrade design path (guest mode to account sync migration).

## Included Skills
- harmonyos-ark
- universal-product-quality

## Starter Kit Additions
- New module: skills/harmonyos-ark/starter-kit/modules/offline-no-login.md
	- Direct-to-home startup flow without login gate
	- First-launch guide pattern and local persistence strategy
- New module: skills/harmonyos-ark/starter-kit/modules/optional-login-upgrade.md
	- Guest-to-auth upgrade flow
	- Local-to-cloud migration strategy and conflict resolution suggestions
- Updated router: skills/harmonyos-ark/starter-kit/SKILL.md
	- Added routing entries and quick prompts for both new paths
- Updated execution guidance: skills/harmonyos-ark/starter-kit/pipeline/execution-order.md
	- Day 2 now supports two branches: account-login path and offline no-login path
- Updated app-type checklist: skills/harmonyos-ark/starter-kit/pipeline/app-type-checklist.md
	- Type A (tool apps) now explicitly recommends offline-no-login module

## Install
```bash
./scripts/install-skills.sh --claude
./scripts/install-skills.sh --copilot-workspace /path/to/your/workspace
```

## Maintenance
```bash
./scripts/sync-skills.sh
```

## Compatibility
- Claude skills path: ~/.claude/skills
- Copilot workspace path: <workspace>/.github/skills
