#!/bin/bash

##############################################################################
# Java Migration Workflow Installer
# This script installs the migration workflow into your Spring PetClinic project
##############################################################################

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          Java Migration Workflow Installer                    ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Default project path
DEFAULT_PROJECT_PATH="/Users/A-9740/Services/spring-petclinic"

# Ask for project path
echo -e "${BLUE}Enter the path to your Spring PetClinic project:${NC}"
echo -e "${YELLOW}(Press Enter for default: $DEFAULT_PROJECT_PATH)${NC}"
read -r PROJECT_PATH

# Use default if empty
if [ -z "$PROJECT_PATH" ]; then
    PROJECT_PATH="$DEFAULT_PROJECT_PATH"
fi

# Verify project exists
if [ ! -d "$PROJECT_PATH" ]; then
    echo -e "${RED}Error: Directory not found: $PROJECT_PATH${NC}"
    exit 1
fi

# Verify it's a Maven project
if [ ! -f "$PROJECT_PATH/pom.xml" ]; then
    echo -e "${RED}Error: pom.xml not found. Is this a Maven project?${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Project found: $PROJECT_PATH${NC}"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}Installing migration workflow...${NC}"
echo ""

# Copy shell script
echo -e "${BLUE}1. Installing migrate-java.sh...${NC}"
cp "$SCRIPT_DIR/migrate-java.sh" "$PROJECT_PATH/"
chmod +x "$PROJECT_PATH/migrate-java.sh"
echo -e "${GREEN}   ✓ Shell script installed${NC}"

# Copy Python script
echo -e "${BLUE}2. Installing migrate-java.py...${NC}"
cp "$SCRIPT_DIR/migrate-java.py" "$PROJECT_PATH/"
chmod +x "$PROJECT_PATH/migrate-java.py"
echo -e "${GREEN}   ✓ Python script installed${NC}"

# Copy GitHub Actions workflow
echo -e "${BLUE}3. Installing GitHub Actions workflow...${NC}"
mkdir -p "$PROJECT_PATH/.github/workflows"
cp "$SCRIPT_DIR/.github/workflows/java-migration.yml" "$PROJECT_PATH/.github/workflows/"
echo -e "${GREEN}   ✓ GitHub Actions workflow installed${NC}"

# Copy documentation
echo -e "${BLUE}4. Installing documentation...${NC}"
cp "$SCRIPT_DIR/README.md" "$PROJECT_PATH/MIGRATION_README.md"
cp "$SCRIPT_DIR/SETUP_GUIDE.md" "$PROJECT_PATH/MIGRATION_SETUP_GUIDE.md"
cp "$SCRIPT_DIR/TROUBLESHOOTING.md" "$PROJECT_PATH/MIGRATION_TROUBLESHOOTING.md"
cp "$SCRIPT_DIR/QUICK_REFERENCE.md" "$PROJECT_PATH/MIGRATION_QUICK_REFERENCE.md"
cp "$SCRIPT_DIR/WORKFLOW_DIAGRAM.md" "$PROJECT_PATH/MIGRATION_WORKFLOW_DIAGRAM.md"
cp "$SCRIPT_DIR/PROJECT_SUMMARY.md" "$PROJECT_PATH/MIGRATION_PROJECT_SUMMARY.md"
echo -e "${GREEN}   ✓ Documentation installed${NC}"

# Copy OpenRewrite config
echo -e "${BLUE}5. Installing OpenRewrite plugin config...${NC}"
cp "$SCRIPT_DIR/openrewrite-plugin-config.xml" "$PROJECT_PATH/"
echo -e "${GREEN}   ✓ OpenRewrite config installed${NC}"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    Installation Complete!                     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}Migration workflow successfully installed to:${NC}"
echo -e "${YELLOW}$PROJECT_PATH${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo ""
echo "1. Add OpenRewrite plugin to your pom.xml:"
echo -e "   ${YELLOW}See: openrewrite-plugin-config.xml for configuration${NC}"
echo ""
echo "2. Run the migration:"
echo -e "   ${YELLOW}cd $PROJECT_PATH${NC}"
echo -e "   ${YELLOW}./migrate-java.sh${NC}"
echo "   or"
echo -e "   ${YELLOW}python3 migrate-java.py${NC}"
echo ""
echo "3. For GitHub Actions:"
echo -e "   ${YELLOW}git add .github/workflows/java-migration.yml${NC}"
echo -e "   ${YELLOW}git commit -m 'Add Java migration workflow'${NC}"
echo -e "   ${YELLOW}git push origin main${NC}"
echo "   Then go to GitHub → Actions → Run workflow"
echo ""
echo "4. Read the documentation:"
echo -e "   ${YELLOW}cat MIGRATION_README.md${NC}"
echo -e "   ${YELLOW}cat MIGRATION_SETUP_GUIDE.md${NC}"
echo ""
echo -e "${GREEN}Happy Migrating! 🚀${NC}"
echo ""
