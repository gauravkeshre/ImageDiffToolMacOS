# Git Workflow for ImageDiffTool

## Repository Setup ✅

The repository has been initialized with:
- Complete Xcode project structure
- Comprehensive .gitignore for macOS/Xcode development
- Initial commit with all project files
- Clean working directory

## Current Status

```bash
Branch: main
Commit: 50d06f0 - Initial commit: Complete Image Diff Tool for macOS
Files: 16 files committed (1,273 lines of code)
```

## Recommended Workflow

### For Feature Development

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/new-feature-name
   ```

2. **Make Changes & Commit**
   ```bash
   git add .
   git commit -m "Add: Brief description of changes"
   ```

3. **Push to Remote** (when you add a remote)
   ```bash
   git push origin feature/new-feature-name
   ```

### For Bug Fixes

1. **Create Fix Branch**
   ```bash
   git checkout -b fix/bug-description
   ```

2. **Fix & Commit**
   ```bash
   git add .
   git commit -m "Fix: Brief description of fix"
   ```

### Common Commands

- **Check Status**: `git status`
- **View History**: `git log --oneline --graph`
- **See Changes**: `git diff`
- **Switch Branches**: `git checkout branch-name`
- **Merge to Main**: `git checkout main && git merge feature-branch`

## Adding a Remote Repository

When you're ready to push to GitHub/GitLab:

```bash
# Add remote origin
git remote add origin https://github.com/username/ImageDiffTool.git

# Push initial commit
git push -u origin main
```

## Files Currently Tracked

- **Source Code**: All Swift files in ImageDiffTool/
- **Project Files**: Xcode project and workspace files
- **Assets**: App icons and asset catalogs
- **Documentation**: README.md, build scripts
- **Configuration**: .gitignore, entitlements

## Files Ignored

- Build artifacts (build/, DerivedData/)
- User-specific Xcode files (xcuserdata/)
- macOS system files (.DS_Store)
- Temporary files and caches

Your ImageDiffTool project is now ready for collaborative development! 🚀