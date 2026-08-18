# CI/CD

Automated testing, building, and releasing for RecyrCLI via GitHub Actions.

## Workflows

### CI (`.github/workflows/ci.yml`)

Runs on every push to `main` and every pull request. Skips for doc-only changes.

| Job | Runner | Swift | What it does |
|-----|--------|-------|-------------|
| **Linux** | `ubuntu-latest` (Docker) | 6.2, 6.1 | Build + test + coverage |
| **macOS** | `macos-latest` | 6.2.4 | Build + test + coverage → Codecov |

- Draft PRs are skipped.
- `.build` directory is cached per OS and Swift version.
- Linux uses native Docker images (`swift:X-noble`) instead of `setup-swift`.
- Concurrency group cancels in-progress runs on the same ref.

### Build and Release (`.github/workflows/build.yml`)

Runs on version tags (`v*`) and manual dispatch only.

```
validate-build → build-macOS → release
```

| Job | Runner | What it does |
|-----|--------|-------------|
| **validate-build** | `macos-latest` | `swift build -c release` (gate) |
| **build-macOS** | `macos-latest` | Build binary → upload artifact |
| **release** | `ubuntu-latest` | Download artifact → create GitHub Release |

- `release` job only runs on tag pushes.
- Release notes are auto-generated from commits.

## Release process

```bash
git tag v1.0.0
git push origin v1.0.0
```

This triggers the build workflow, which builds the macOS binary and creates a GitHub Release with the binary attached.

## Caching

Both workflows cache the `.build` directory. Cache keys are based on:

- OS (`macos-latest` / `ubuntu-latest`)
- Swift version
- `Package.resolved` hash

If the cache is stale (dependencies changed), it restores the partial cache and re-fetches missing packages.

## Security

- All actions are SHA-pinned (not tag-pinned) to prevent supply chain attacks.
- Workflow-level `permissions: contents: read` follows least-privilege principle.
- Only the `release` job elevates to `contents: write`.

## Dependabot (`.github/dependabot.yml`)

Weekly checks for:

- GitHub Actions version updates
- Swift package dependency updates
