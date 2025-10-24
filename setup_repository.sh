#!/bin/bash

# Chiltrix Repository Setup Script
# Run this on your local machine to add all the new files to your repository

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Chiltrix Repository Setup - Add Professional Files   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if in repository
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠ Not in a git repository!${NC}"
    echo ""
    echo "Please navigate to your repository first:"
    echo "  cd /path/to/homeassistant-chiltrix-modbus"
    echo ""
    echo "Or clone it if you haven't:"
    echo "  git clone https://github.com/jasipsw/homeassistant-chiltrix-modbus.git"
    echo "  cd homeassistant-chiltrix-modbus"
    exit 1
fi

# Verify it's the correct repository
REPO_URL=$(git config --get remote.origin.url)
if [[ ! "$REPO_URL" =~ "jasipsw/homeassistant-chiltrix-modbus" ]]; then
    echo -e "${YELLOW}⚠ Warning: This doesn't appear to be the Chiltrix repository${NC}"
    echo "Current repository: $REPO_URL"
    read -p "Continue anyway? [y/N]: " CONTINUE
    if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

echo -e "${GREEN}✓ Repository found!${NC}"
echo ""

# Create directory structure
echo -e "${BLUE}Creating directory structure...${NC}"
mkdir -p .github/workflows
mkdir -p .github/ISSUE_TEMPLATE
mkdir -p dashboards/community
mkdir -p examples/automations
mkdir -p examples/configurations
mkdir -p images
echo -e "${GREEN}✓ Directories created${NC}"
echo ""

# Download files
echo -e "${BLUE}Downloading files...${NC}"
echo "Please make sure you have all the files from Claude in a folder"
echo "Enter the path to the folder containing the files:"
read -p "Path: " FILES_PATH

if [ ! -d "$FILES_PATH" ]; then
    echo -e "${YELLOW}⚠ Directory not found: $FILES_PATH${NC}"
    exit 1
fi

# Copy root files
echo -e "${BLUE}Copying root files...${NC}"
[ -f "$FILES_PATH/install.sh" ] && cp "$FILES_PATH/install.sh" . && chmod +x install.sh && echo "  ✓ install.sh"
[ -f "$FILES_PATH/.gitignore" ] && cp "$FILES_PATH/.gitignore" . && echo "  ✓ .gitignore"
[ -f "$FILES_PATH/README_NEW.md" ] && cp "$FILES_PATH/README_NEW.md" README.md && echo "  ✓ README.md (updated)"
[ -f "$FILES_PATH/QUICK_START.md" ] && cp "$FILES_PATH/QUICK_START.md" . && echo "  ✓ QUICK_START.md"
[ -f "$FILES_PATH/CHANGELOG.md" ] && cp "$FILES_PATH/CHANGELOG.md" . && echo "  ✓ CHANGELOG.md"
[ -f "$FILES_PATH/CONTRIBUTING.md" ] && cp "$FILES_PATH/CONTRIBUTING.md" . && echo "  ✓ CONTRIBUTING.md"
[ -f "$FILES_PATH/REPOSITORY_STRUCTURE.md" ] && cp "$FILES_PATH/REPOSITORY_STRUCTURE.md" . && echo "  ✓ REPOSITORY_STRUCTURE.md"

# Copy GitHub files
echo -e "${BLUE}Copying GitHub templates...${NC}"
[ -f "$FILES_PATH/release.yml" ] && cp "$FILES_PATH/release.yml" .github/workflows/ && echo "  ✓ .github/workflows/release.yml"
[ -f "$FILES_PATH/bug_report.md" ] && cp "$FILES_PATH/bug_report.md" .github/ISSUE_TEMPLATE/ && echo "  ✓ .github/ISSUE_TEMPLATE/bug_report.md"
[ -f "$FILES_PATH/feature_request.md" ] && cp "$FILES_PATH/feature_request.md" .github/ISSUE_TEMPLATE/ && echo "  ✓ .github/ISSUE_TEMPLATE/feature_request.md"
[ -f "$FILES_PATH/pull_request_template.md" ] && cp "$FILES_PATH/pull_request_template.md" .github/PULL_REQUEST_TEMPLATE.md && echo "  ✓ .github/PULL_REQUEST_TEMPLATE.md"

echo -e "${GREEN}✓ All files copied!${NC}"
echo ""

# Git status
echo -e "${BLUE}Current changes:${NC}"
git status --short
echo ""

# Commit and push
read -p "Ready to commit and push? [Y/n]: " DO_COMMIT
DO_COMMIT=${DO_COMMIT:-y}

if [[ "$DO_COMMIT" =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Adding files to git...${NC}"
    git add .
    
    echo -e "${BLUE}Committing changes...${NC}"
    git commit -m "Add automated installer and comprehensive documentation

- Add install.sh for one-command installation with interactive setup
- Update README with professional documentation and examples
- Add quick start guide for 5-minute setup
- Add contribution guidelines and code of conduct
- Add GitHub issue and PR templates for consistency
- Add automated release workflow via GitHub Actions
- Add changelog for version tracking
- Add .gitignore for security
- Reorganize repository structure

This makes installation significantly easier for users (5 minutes vs 30-60 minutes)."
    
    echo -e "${BLUE}Pushing to GitHub...${NC}"
    git push origin main
    
    echo -e "${GREEN}✓ Changes pushed!${NC}"
    echo ""
    
    # Create release
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${BLUE}  Creating First Release (v1.0.0)     ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""
    read -p "Create release v1.0.0 now? [Y/n]: " DO_RELEASE
    DO_RELEASE=${DO_RELEASE:-y}
    
    if [[ "$DO_RELEASE" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Creating tag...${NC}"
        git tag -a v1.0.0 -m "Release v1.0.0 - Initial release with automated installer

Features:
- Complete Modbus configuration for Chiltrix heat pumps
- Real-time COP calculations and cost tracking
- Beautiful premium and controller replica dashboards
- 50+ sensors for comprehensive monitoring
- Automated installation script
- Pre-built automation scripts
- Voice control integration support
- Mobile-responsive design"
        
        echo -e "${BLUE}Pushing tag...${NC}"
        git push origin v1.0.0
        
        echo -e "${GREEN}✓ Release created!${NC}"
        echo ""
        echo -e "${GREEN}GitHub Actions will now automatically:${NC}"
        echo "  • Package your files into a ZIP"
        echo "  • Create the release on GitHub"
        echo "  • Attach the ZIP file"
        echo ""
        echo "Check: https://github.com/jasipsw/homeassistant-chiltrix-modbus/releases"
        echo ""
        echo "⏳ This takes 2-3 minutes. Check the Actions tab if needed."
    fi
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              🎉 Setup Complete! 🎉                     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Next steps:"
echo "  1. Go to your repository on GitHub"
echo "  2. Update the About section with description and topics"
echo "  3. Check that the release was created (in ~3 minutes)"
echo "  4. Share your project!"
echo ""
echo "Repository: https://github.com/jasipsw/homeassistant-chiltrix-modbus"
echo ""
