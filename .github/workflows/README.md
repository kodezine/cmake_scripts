# GitHub Actions Workflows

This directory contains GitHub Actions workflows for the cmake_scripts repository.

## Workflows

### 🔍 Pre-commit Checks (`pre-commit.yml`)

Comprehensive quality assurance workflow

**Triggers:**

- Push to main, develop, support-*, feature-*, hotfix-* branches
- Pull requests to main, develop branches

**Jobs:**

1. **pre-commit**: Runs all pre-commit hooks defined in `.pre-commit-config.yaml`
   - Trailing whitespace removal
   - End-of-file fixing
   - YAML validation
   - JSON formatting
   - Clang-format for C/C++ code
   - Action linting
   - Python formatting (black, flake8, isort)

2. **cmake-lint**: Validates CMake files for syntax and formatting
3. **markdown-lint**: Checks Markdown files for consistency
4. **yaml-lint**: Validates YAML files for proper structure
5. **security-scan**: Scans for security vulnerabilities using Trivy
6. **check-status**: Aggregates results and determines overall pass/fail

### ⚡ Quick Pre-commit (`quick-pre-commit.yml`)

Fast, lightweight pre-commit validation

**Triggers:**

- Push to any branch
- Pull request events (opened, synchronize, reopened)

**Features:**

- Runs on changed files only for feature branches
- Full file scan for main branch
- Optimized caching for faster execution
- 10-minute timeout for quick feedback

## Workflow Features

### 🚀 Performance Optimizations

- **Caching**: Pre-commit hooks and Python dependencies cached
- **Concurrency**: Workflows cancelled if newer commits pushed
- **Selective Running**: Changed files only on feature branches
- **Timeouts**: Prevents workflows from hanging indefinitely

### 🔒 Security

- **Trivy scanning**: Comprehensive vulnerability detection
- **SARIF upload**: Security results integrated with GitHub Security tab
- **Dependency scanning**: Monitors for known security issues

### 📊 Quality Checks

- **Multi-language support**: C/C++, Python, CMake, Markdown, YAML
- **Formatting enforcement**: Consistent code style across repository
- **Syntax validation**: Catches errors before merge
- **Best practices**: Follows community standards for each language

## Status Badges

Add these badges to your README.md:

```markdown
![Pre-commit Checks](https://github.com/kodezine/cmake_scripts/workflows/Pre-commit%20Checks/badge.svg)
![Quick Pre-commit](https://github.com/kodezine/cmake_scripts/workflows/Quick%20Pre-commit/badge.svg)
```

## Local Development

### Setup Pre-commit Locally

```bash
# Install pre-commit
pip install pre-commit

# Install hooks
pre-commit install

# Run on all files
pre-commit run --all-files

# Run on staged files only
pre-commit run
```

### Testing Workflows Locally

```bash
# Install act for local workflow testing
# https://github.com/nektos/act

# Test the quick pre-commit workflow
act push -W .github/workflows/quick-pre-commit.yml

# Test specific job
act -j pre-commit
```

## Troubleshooting

### Common Issues

#### Pre-commit Hook Failures

```bash
# Fix formatting issues automatically
pre-commit run --all-files

# Skip hooks temporarily (not recommended)
git commit --no-verify
```

#### Workflow Permissions

Ensure the repository has the following permissions enabled:

- Actions: Read and write
- Contents: Read
- Security events: Write (for Trivy SARIF upload)

#### Cache Issues

If workflows are slow or failing due to cache:

1. Clear caches in repository Settings → Actions → Caches
2. Re-run failed workflows

### Performance Tips

- Keep commits small for faster changed-file detection
- Use `[skip ci]` in commit messages to skip workflows when needed
- Consider running `pre-commit run --all-files` locally before pushing

## Contributing

When adding new workflows:

1. Follow the existing naming convention
2. Include appropriate triggers and concurrency controls
3. Add caching for dependencies
4. Include timeout limits
5. Update this README with workflow documentation
6. Test locally with `act` before pushing

## Workflow Dependencies

### Required Actions

- `actions/checkout@v4`: Repository checkout
- `actions/setup-python@v4`: Python environment setup
- `actions/setup-node@v4`: Node.js environment setup
- `actions/cache@v3`: Dependency caching
- `aquasecurity/trivy-action@master`: Security scanning
- `github/codeql-action/upload-sarif@v2`: Security results upload

### Required Tools

- pre-commit
- cmake-format
- markdownlint-cli
- yamllint
- trivy

All tools are automatically installed during workflow execution.
