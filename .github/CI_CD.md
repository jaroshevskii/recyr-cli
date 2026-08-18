# CI/CD

Automated testing, building, and releasing via GitHub Actions.

## Workflows

### CI

Runs on push to `main` and on pull requests. Skips for doc-only changes and draft PRs.

- **Format** — lint Swift files with `swift-format`
- **Linux** — build + test + coverage
- **macOS** — build + test + coverage → Codecov

Dependencies are cached. Concurrency groups cancel in-progress runs on the same ref.

### Build and Release

Runs on version tags (`v*`) and manual dispatch.

```
validate build → build macOS binary → create GitHub Release
```

Release notes are auto-generated from commits.

## Release

```bash
git tag v1.0.0
git push origin v1.0.0
```

This builds the macOS binary and creates a GitHub Release with the binary attached.

## Formatting

Uses `swift-format` with default settings (same as TCA).

```bash
./scripts/format.sh           # format in-place
./scripts/format.sh --lint    # check only (CI uses this)
```

## Security

- Actions are SHA-pinned to prevent supply chain attacks.
- Least-privilege permissions by default, elevated only where needed.

## Dependabot

Weekly checks for GitHub Actions and Swift package dependency updates.
