# Step-by-Step Setup Guide for Java Migration Workflow

This guide walks you through setting up the Java 8 to 11 migration workflow for Spring PetClinic, explained for beginners.

## 📚 Understanding the Components

### What is Spring PetClinic?
Spring PetClinic is a sample Spring Boot application that demonstrates best practices. You're going to migrate it from Java 8 to Java 11.

### What is OpenRewrite?
OpenRewrite is an automated refactoring tool that:
- Updates your code automatically
- Fixes deprecated APIs
- Modernizes code patterns
- Updates dependencies

### What is GitHub Actions?
GitHub Actions is a CI/CD platform that:
- Runs automated workflows
- Tests your code
- Creates pull requests
- Saves you time

## 🎯 Step 1: Prepare Your Environment

### Install Required Tools

#### 1.1 Install Java 11

**macOS:**
```bash
# Using Homebrew
brew install openjdk@11

# Add to PATH
echo 'export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Linux:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install openjdk-11-jdk

# CentOS/RHEL
sudo yum install java-11-openjdk-devel
```

**Windows:**
1. Download from [AdoptOpenJDK](https://adoptopenjdk.net/)
2. Run installer
3. Add to PATH in Environment Variables

**Verify Installation:**
```bash
java -version
# Should show: openjdk version "11.x.x"
```

#### 1.2 Install Maven

**macOS:**
```bash
brew install maven
```

**Linux:**
```bash
sudo apt install maven
```

**Windows:**
1. Download from [Maven website](https://maven.apache.org/download.cgi)
2. Extract to C:\Program Files\Maven
3. Add to PATH

**Verify Installation:**
```bash
mvn -version
# Should show: Apache Maven 3.x.x
```

#### 1.3 Install Git

**macOS:**
```bash
# Git comes with Xcode Command Line Tools
xcode-select --install

# Or use Homebrew
brew install git
```

**Linux:**
```bash
sudo apt install git
```

**Windows:**
Download from [Git website](https://git-scm.com/download/win)

**Configure Git:**
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

#### 1.4 Install GitHub CLI (Optional)

**macOS:**
```bash
brew install gh
```

**Linux:**
```bash
# Ubuntu/Debian
sudo apt install gh

# Or using snap
sudo snap install gh
```

**Windows:**
```bash
winget install GitHub.cli
```

**Authenticate:**
```bash
gh auth login
# Follow the prompts
```

## 🎯 Step 2: Get Spring PetClinic

### 2.1 Clone the Repository

```bash
# Navigate to where you want the project
cd /Users/A-9740/Services

# Clone Spring PetClinic
git clone https://github.com/spring-projects/spring-petclinic.git

# Navigate into the project
cd spring-petclinic
```

### 2.2 Verify the Project Structure

```bash
# List files
ls -la

# You should see:
# - pom.xml (Maven configuration)
# - src/ (source code)
# - .git/ (Git repository)
```

### 2.3 Check Current Java Version

```bash
# Open pom.xml
cat pom.xml | grep "java.version"

# Should show something like:
# <java.version>1.8</java.version>
```

## 🎯 Step 3: Set Up Migration Scripts

### 3.1 Copy Migration Files

**Option A: Manual Copy**

1. Download the migration workflow files
2. Copy `migrate-java.sh` to your project root:
   ```bash
   cp /path/to/migrate-java.sh /Users/A-9740/Services/spring-petclinic/
   ```

3. Copy `migrate-java.py` to your project root:
   ```bash
   cp /path/to/migrate-java.py /Users/A-9740/Services/spring-petclinic/
   ```

**Option B: Create Files Manually**

Create the files in your project directory and copy the content from the provided scripts.

### 3.2 Make Scripts Executable

```bash
# Navigate to project
cd /Users/A-9740/Services/spring-petclinic

# Make shell script executable
chmod +x migrate-java.sh

# Make Python script executable
chmod +x migrate-java.py
```

### 3.3 Verify Scripts

```bash
# Check if scripts exist
ls -la migrate-java.*

# Should show:
# -rwxr-xr-x  migrate-java.sh
# -rwxr-xr-x  migrate-java.py
```

## 🎯 Step 4: Add OpenRewrite Plugin to pom.xml

### 4.1 Open pom.xml

```bash
# Using nano (simple editor)
nano pom.xml

# Or use your favorite editor
# vim pom.xml
# code pom.xml (VS Code)
```

### 4.2 Find the <build><plugins> Section

Look for:
```xml
<build>
    <plugins>
        <!-- existing plugins -->
    </plugins>
</build>
```

### 4.3 Add OpenRewrite Plugin

Add this inside the `<plugins>` section:

```xml
<plugin>
    <groupId>org.openrewrite.maven</groupId>
    <artifactId>rewrite-maven-plugin</artifactId>
    <version>5.40.0</version>
    <configuration>
        <activeRecipes>
            <recipe>org.openrewrite.java.migrate.Java8toJava11</recipe>
        </activeRecipes>
    </configuration>
    <dependencies>
        <dependency>
            <groupId>org.openrewrite.recipe</groupId>
            <artifactId>rewrite-migrate-java</artifactId>
            <version>2.26.1</version>
        </dependency>
    </dependencies>
</plugin>
```

### 4.4 Save and Verify

```bash
# Save the file (Ctrl+X if using nano, then Y, then Enter)

# Verify Maven can read it
mvn validate

# Should complete without errors
```

## 🎯 Step 5: Run Your First Migration (Local)

### 5.1 Using Shell Script

```bash
# Ensure you're in the project directory
cd /Users/A-9740/Services/spring-petclinic

# Run the migration script
./migrate-java.sh
```

**What happens:**
1. ✓ Checks prerequisites
2. ✓ Creates backup branch
3. ✓ Creates migration branch
4. ✓ Updates Java version
5. ✓ Applies OpenRewrite
6. ✓ Builds project
7. ✓ Runs tests
8. ✓ Commits changes
9. ✓ Creates PR

### 5.2 Using Python Script

```bash
# Ensure you're in the project directory
cd /Users/A-9740/Services/spring-petclinic

# Run the migration script
python3 migrate-java.py
```

### 5.3 Monitor Progress

You'll see colored output showing:
- 🔵 INFO messages (what's happening)
- 🟢 SUCCESS messages (what completed)
- 🟡 WARNING messages (non-critical issues)
- 🔴 ERROR messages (problems)

### 5.4 Review Results

After completion:
```bash
# Check created branches
git branch

# You should see:
# - backup-before-migration-YYYYMMDD-HHMMSS
# - feature/java-11-migration-YYYYMMDD-HHMMSS

# View changes
git diff main
```

## 🎯 Step 6: Set Up GitHub Actions (Optional)

### 6.1 Create Workflow Directory

```bash
# Create .github/workflows directory
mkdir -p /Users/A-9740/Services/spring-petclinic/.github/workflows
```

### 6.2 Copy Workflow File

```bash
# Copy the GitHub Actions workflow
cp .github/workflows/java-migration.yml \
   /Users/A-9740/Services/spring-petclinic/.github/workflows/
```

### 6.3 Commit and Push Workflow

```bash
cd /Users/A-9740/Services/spring-petclinic

# Add workflow file
git add .github/workflows/java-migration.yml

# Commit
git commit -m "Add Java migration GitHub Actions workflow"

# Push to GitHub
git push origin main
```

### 6.4 Verify Workflow on GitHub

1. Go to your repository on GitHub
2. Click "Actions" tab
3. You should see "Java 8 to 11 Migration Workflow"

### 6.5 Run Workflow Manually

1. Click on the workflow
2. Click "Run workflow" button
3. Select options:
   - Target Java version: 11
   - Apply fixes: true
   - Create PR: true
4. Click "Run workflow"
5. Watch the progress in real-time

## 🎯 Step 7: Understanding Each Script Component

### Shell Script Breakdown

```bash
# Color definitions for output
RED='\033[0;31m'    # For errors
GREEN='\033[0;32m'  # For success
YELLOW='\033[1;33m' # For warnings
BLUE='\033[0;34m'   # For info

# Configuration
PROJECT_PATH="/Users/A-9740/Services/spring-petclinic"  # Where your project is
BRANCH_NAME="feature/java-11-migration-..."              # Migration branch name

# Helper functions
log_info()    # Prints info messages in blue
log_success() # Prints success messages in green
log_warning() # Prints warning messages in yellow
log_error()   # Prints error messages in red

# Main functions
check_prerequisites()      # Verifies tools are installed
backup_project()          # Creates backup branch
create_migration_branch() # Creates new branch for migration
update_java_version()     # Updates pom.xml
apply_openrewrite_migration() # Runs OpenRewrite
build_project()          # Compiles code
run_tests()              # Executes tests
fix_build_issues()       # Applies fixes if build fails
commit_changes()         # Commits changes to Git
push_and_create_pr()     # Pushes and creates PR
```

### Python Script Breakdown

```python
# Imports
import subprocess  # For running shell commands
import logging    # For logging messages
import sys        # For system operations
from datetime import datetime  # For timestamps

# Configuration
PROJECT_PATH = "/Users/A-9740/Services/spring-petclinic"
BASE_BRANCH = "main"
BRANCH_NAME = f"feature/java-11-migration-{datetime.now()}"

# Helper functions
run_command()         # Executes shell commands
check_command_exists() # Checks if tool is installed
print_colored()       # Prints colored messages

# Main functions (same as shell script)
check_prerequisites()
backup_project()
# ... etc
```

### GitHub Actions Workflow Breakdown

```yaml
# Trigger conditions
on:
  workflow_dispatch:  # Manual trigger
  push:              # Automatic on push
  pull_request:      # Automatic on PR

# Jobs (run in sequence)
jobs:
  validate:         # Check environment
  migrate:          # Perform migration
  build-and-test:   # Build and test
  code-quality:     # Run quality checks
  create-pr:        # Create pull request
  notify:           # Send notifications
```

## 🎯 Step 8: Testing Your Setup

### 8.1 Dry Run Test

```bash
# Create a test branch
git checkout -b test-migration

# Run migration
./migrate-java.sh

# Check results
git status
git diff

# Clean up
git checkout main
git branch -D test-migration
```

### 8.2 Verify Build

```bash
# After migration, verify build works
mvn clean install

# Should complete successfully
```

### 8.3 Verify Tests

```bash
# Run all tests
mvn test

# Should show:
# Tests run: X, Failures: 0, Errors: 0
```

## 🎯 Step 9: Common Scenarios

### Scenario 1: First Time Migration

```bash
# 1. Ensure clean working directory
git status

# 2. Run migration
./migrate-java.sh

# 3. Review PR on GitHub
# 4. Get team approval
# 5. Merge PR
```

### Scenario 2: Migration Failed

```bash
# 1. Check error logs
cat migration.log

# 2. Fix issues manually
# Edit problematic files

# 3. Re-run specific steps
mvn org.openrewrite.maven:rewrite-maven-plugin:run

# 4. Test build
mvn clean install

# 5. Continue migration
```

### Scenario 3: Need to Rollback

```bash
# Option 1: Use backup branch
git checkout backup-before-migration-YYYYMMDD-HHMMSS

# Option 2: Hard reset
git reset --hard origin/main

# Option 3: Delete migration branch
git branch -D feature/java-11-migration-YYYYMMDD-HHMMSS
```

## 🎯 Step 10: Next Steps After Migration

### 10.1 Code Review Checklist

- [ ] All Java 8 code updated
- [ ] No deprecated API usage
- [ ] All tests passing
- [ ] Dependencies updated
- [ ] Documentation updated

### 10.2 Testing Checklist

- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Performance testing done
- [ ] Security scanning complete
- [ ] Manual testing complete

### 10.3 Deployment Checklist

- [ ] Update deployment scripts
- [ ] Update Docker images
- [ ] Update CI/CD pipelines
- [ ] Update documentation
- [ ] Notify team members

## 📚 Additional Resources

### Learning Resources
- [Java 11 Features](https://openjdk.java.net/projects/jdk/11/)
- [OpenRewrite Documentation](https://docs.openrewrite.org/)
- [Spring Boot Migration Guide](https://github.com/spring-projects/spring-boot/wiki)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

### Troubleshooting Resources
- [Stack Overflow - Java 11 Migration](https://stackoverflow.com/questions/tagged/java-11+migration)
- [OpenRewrite Slack Community](https://join.slack.com/t/rewriteoss/shared_invite/)
- [Spring Boot GitHub Issues](https://github.com/spring-projects/spring-boot/issues)

## 🎓 Understanding Key Concepts

### What is a Pull Request (PR)?
A PR is a request to merge code changes into the main branch. It allows:
- Code review by team members
- Discussion of changes
- Automated testing
- Approval workflow

### What is a Branch?
A branch is a separate version of your code where you can:
- Work on features independently
- Test changes safely
- Merge back when ready

### What is OpenRewrite Recipe?
A recipe is a set of instructions that tells OpenRewrite:
- What code to find
- How to transform it
- What to replace it with

### What is Maven?
Maven is a build tool that:
- Compiles your code
- Manages dependencies
- Runs tests
- Packages applications

## ✅ Success Criteria

You know the migration is successful when:

1. ✅ All builds pass
2. ✅ All tests pass
3. ✅ No deprecated warnings
4. ✅ Code review approved
5. ✅ PR merged
6. ✅ Application runs correctly

## 🎉 Congratulations!

You've successfully set up and understand the Java migration workflow!

For questions or issues, refer to:
- README.md (overview)
- Troubleshooting section
- Team documentation
- Community resources

---

**Happy Coding! 🚀**
