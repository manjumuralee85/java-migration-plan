# Java 8 to 11 Migration Workflow

A comprehensive automation workflow to migrate Spring PetClinic (or any Spring Boot application) from Java 8 to Java 11 using OpenRewrite and automated testing.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Components](#components)
- [Usage Options](#usage-options)
- [Workflow Steps](#workflow-steps)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

## 🎯 Overview

This migration workflow automates the process of upgrading your Java 8 Spring Boot application to Java 11. It includes:

- ✅ Automated Java version updates
- ✅ OpenRewrite migration recipes
- ✅ Automatic build failure detection and fixes
- ✅ Test execution and validation
- ✅ Pull Request creation
- ✅ GitHub Actions integration

## 📦 Prerequisites

Before running the migration, ensure you have:

1. **Java 11 or higher** installed
   ```bash
   # Check Java version
   java -version
   ```

2. **Maven 3.6+** installed
   ```bash
   # Check Maven version
   mvn -version
   ```

3. **Git** installed and configured
   ```bash
   # Check Git version
   git --version
   
   # Configure Git (if not already done)
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

4. **GitHub CLI (optional but recommended)** for PR creation
   ```bash
   # Install GitHub CLI
   # macOS
   brew install gh
   
   # Linux
   sudo apt install gh
   
   # Windows
   winget install GitHub.cli
   
   # Authenticate
   gh auth login
   ```

5. **Spring PetClinic** repository cloned locally
   ```bash
   git clone https://github.com/spring-projects/spring-petclinic.git
   cd spring-petclinic
   ```

## 🚀 Quick Start

### Option 1: Using Shell Script (Recommended for Unix/Linux/macOS)

```bash
# 1. Copy the migration script to your project
cp migrate-java.sh /Users/A-9740/Services/spring-petclinic/

# 2. Make it executable
chmod +x /Users/A-9740/Services/spring-petclinic/migrate-java.sh

# 3. Run the migration
cd /Users/A-9740/Services/spring-petclinic
./migrate-java.sh
```

### Option 2: Using Python Script (Cross-platform)

```bash
# 1. Copy the Python script to your project
cp migrate-java.py /Users/A-9740/Services/spring-petclinic/

# 2. Make it executable (Unix/Linux/macOS)
chmod +x /Users/A-9740/Services/spring-petclinic/migrate-java.py

# 3. Run the migration
cd /Users/A-9740/Services/spring-petclinic
python3 migrate-java.py

# Or on Windows
python migrate-java.py
```

### Option 3: Using GitHub Actions

```bash
# 1. Copy the workflow file
mkdir -p /Users/A-9740/Services/spring-petclinic/.github/workflows
cp .github/workflows/java-migration.yml /Users/A-9740/Services/spring-petclinic/.github/workflows/

# 2. Commit and push the workflow
cd /Users/A-9740/Services/spring-petclinic
git add .github/workflows/java-migration.yml
git commit -m "Add Java migration workflow"
git push origin main

# 3. Trigger the workflow manually
# Go to GitHub → Actions → Java 8 to 11 Migration Workflow → Run workflow
```

## 🧩 Components

### 1. Shell Script (`migrate-java.sh`)

**What it does:**
- Checks prerequisites (Java, Maven, Git)
- Creates backup branch
- Creates migration branch
- Updates Java version in pom.xml
- Applies OpenRewrite migration recipes
- Builds the project
- Fixes build failures automatically
- Runs tests
- Commits changes
- Pushes branch and creates PR

**When to use:**
- Running migration locally
- Quick one-time migration
- Manual control over each step

### 2. Python Script (`migrate-java.py`)

**What it does:**
Same as shell script but with:
- Better error handling
- Colored output
- Cross-platform compatibility
- More detailed logging

**When to use:**
- Windows environments
- When you prefer Python
- Need better error messages

### 3. GitHub Actions Workflow (`java-migration.yml`)

**What it does:**
- Validates environment
- Performs migration
- Builds and tests
- Runs code quality checks
- Creates PR automatically
- Provides detailed summary

**When to use:**
- CI/CD integration
- Automated migrations
- Team collaboration
- Regular migration runs

## 📖 Usage Options

### Running Locally with Shell Script

```bash
# Basic usage
./migrate-java.sh

# The script will:
# 1. Check prerequisites
# 2. Create backup branch: backup-before-migration-YYYYMMDD-HHMMSS
# 3. Create migration branch: feature/java-11-migration-YYYYMMDD-HHMMSS
# 4. Update pom.xml
# 5. Apply OpenRewrite
# 6. Build and test
# 7. Create PR
```

### Running Locally with Python Script

```bash
# Basic usage
python3 migrate-java.py

# With custom project path (edit the script)
# Change PROJECT_PATH = "/your/custom/path"
```

### Running via GitHub Actions

#### Trigger Manually:

1. Go to your repository on GitHub
2. Click "Actions" tab
3. Select "Java 8 to 11 Migration Workflow"
4. Click "Run workflow"
5. Select options:
   - Target Java version (11 or 17)
   - Apply fixes automatically (true/false)
   - Create PR automatically (true/false)
6. Click "Run workflow"

#### Trigger Automatically:

The workflow automatically runs on:
- Push to branches matching `feature/java-*-migration-*`
- Pull requests to `main` or `master` that modify `pom.xml` or Java files

## 🔄 Workflow Steps Explained

### Step 1: Prerequisites Check
```
✓ Checks Java installation
✓ Checks Maven installation
✓ Checks Git installation
✓ Verifies project directory
```

### Step 2: Backup Creation
```
✓ Creates backup branch
✓ Ensures safe rollback option
```

### Step 3: Branch Creation
```
✓ Checks out base branch (main/master)
✓ Pulls latest changes
✓ Creates new migration branch
```

### Step 4: Java Version Update
```
✓ Updates <java.version> in pom.xml
✓ Updates <maven.compiler.source>
✓ Updates <maven.compiler.target>
```

### Step 5: OpenRewrite Migration
```
✓ Applies Java 8 to 11 migration recipes
✓ Updates deprecated APIs
✓ Fixes compatibility issues
✓ Modernizes code patterns
```

### Step 6: Build Project
```
✓ Runs mvn clean install
✓ Compiles Java code
✓ Packages application
```

### Step 7: Fix Build Issues (if needed)
```
✓ Re-runs OpenRewrite with aggressive fixes
✓ Updates dependencies
✓ Retries build
```

### Step 8: Run Tests
```
✓ Executes all tests
✓ Validates functionality
✓ Ensures no regressions
```

### Step 9: Commit Changes
```
✓ Stages all changes
✓ Creates detailed commit message
✓ Commits to migration branch
```

### Step 10: Create Pull Request
```
✓ Pushes branch to origin
✓ Creates PR with description
✓ Adds labels and checklist
```

## 🛠️ What OpenRewrite Does

OpenRewrite is a powerful refactoring tool that automatically:

### Code Migrations:
- Updates deprecated APIs to modern equivalents
- Migrates `java.util.Date` to `java.time` APIs
- Updates javax to jakarta namespace (for Java 11+)
- Fixes diamond operator usage
- Updates try-with-resources patterns

### Dependency Updates:
- Updates Spring Boot dependencies
- Updates library versions to Java 11 compatible
- Removes deprecated dependencies

### Code Style:
- Modernizes code patterns
- Fixes code smells
- Applies best practices

## 🔧 Troubleshooting

### Issue: "Command not found: mvn"

**Solution:**
```bash
# Install Maven
# macOS
brew install maven

# Linux
sudo apt install maven

# Windows
# Download from https://maven.apache.org/download.cgi
```

### Issue: "Build failed after migration"

**Solution:**
```bash
# 1. Review build errors
mvn clean compile

# 2. Manually fix specific errors
# Edit the problematic files

# 3. Re-run migration fixes
mvn org.openrewrite.maven:rewrite-maven-plugin:run \
  -Drewrite.activeRecipes=org.openrewrite.java.migrate.Java8toJava11

# 4. Update dependencies
mvn versions:use-latest-releases
```

### Issue: "Tests failing after migration"

**Solution:**
```bash
# 1. Run tests with verbose output
mvn test -X

# 2. Check for Java 11 specific issues
# - Module system conflicts
# - Removed APIs (like sun.misc.Unsafe)
# - Changed behavior in standard libraries

# 3. Update test dependencies
# Update JUnit, Mockito, etc. to Java 11 compatible versions
```

### Issue: "Cannot push to GitHub"

**Solution:**
```bash
# 1. Check Git credentials
git config --list

# 2. Re-authenticate
gh auth login

# 3. Check remote URL
git remote -v

# 4. Try pushing with explicit credentials
git push origin <branch-name>
```

### Issue: "OpenRewrite plugin not found"

**Solution:**
Add OpenRewrite plugin to your `pom.xml`:

```xml
<build>
    <plugins>
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
    </plugins>
</build>
```

## ❓ FAQ

### Q: Can I migrate directly from Java 8 to Java 17?

**A:** Yes! Just change the target version in the scripts:
- Shell: Edit `JAVA_VERSION="17"` in the script
- Python: Edit script to use version 17
- GitHub Actions: Select "17" when running workflow

### Q: Will this work with Gradle projects?

**A:** The current scripts are Maven-specific. For Gradle:
1. Use OpenRewrite Gradle plugin
2. Update `build.gradle` instead of `pom.xml`
3. Use `./gradlew` instead of `mvn` commands

### Q: What if I have custom dependencies?

**A:** The workflow handles most cases, but you may need to:
1. Manually update proprietary dependencies
2. Check vendor documentation for Java 11 compatibility
3. Update dependency versions in pom.xml

### Q: Can I run this on a private repository?

**A:** Yes! Ensure:
1. GitHub Actions is enabled
2. Workflow permissions are set correctly
3. Branch protection rules allow automated PRs

### Q: How do I rollback if something goes wrong?

**A:**
```bash
# Option 1: Use backup branch
git checkout backup-before-migration-YYYYMMDD-HHMMSS

# Option 2: Hard reset
git reset --hard origin/main

# Option 3: Revert commit
git revert <commit-hash>
```

### Q: Does this handle Spring Boot version upgrade?

**A:** The workflow updates Spring Boot dependencies, but for major version upgrades:
1. Check Spring Boot migration guides
2. Update parent version in pom.xml manually
3. Test thoroughly

### Q: What about database migrations?

**A:** This workflow handles code migration. For database:
1. Review Flyway/Liquibase scripts
2. Test with Java 11
3. Update JDBC drivers if needed

## 📝 Best Practices

1. **Test in Development First**
   - Run migration on a development branch
   - Test thoroughly before production

2. **Review Changes Carefully**
   - Check all modified files
   - Verify no unintended changes

3. **Update Dependencies**
   - Ensure all dependencies support Java 11
   - Check for security vulnerabilities

4. **Run Integration Tests**
   - Test all critical paths
   - Verify external integrations

5. **Document Changes**
   - Update README with new Java version
   - Document any breaking changes

## 🤝 Support

If you encounter issues:

1. Check the [Troubleshooting](#troubleshooting) section
2. Review [OpenRewrite documentation](https://docs.openrewrite.org/)
3. Check [Spring Boot migration guide](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.0-Migration-Guide)

## 📄 License

This migration workflow is provided as-is for educational and development purposes.

---

**Happy Migrating! 🚀**

For questions or issues, please check the documentation or reach out to your development team.
