# Quick Reference - Java Migration Workflow

One-page cheat sheet for Java 8 to 11 migration.

## 🚀 Quick Start Commands

```bash
# 1. Clone project
git clone https://github.com/spring-projects/spring-petclinic.git
cd spring-petclinic

# 2. Run migration (choose one)
./migrate-java.sh        # Shell script
python3 migrate-java.py  # Python script

# 3. Review and merge PR
gh pr view
gh pr merge
```

## 📝 Common Commands

### Prerequisites Check
```bash
java -version              # Should show 11.x.x
mvn -version              # Should show 3.6+
git --version             # Any recent version
gh --version              # Optional, for PR creation
```

### Manual Migration Steps
```bash
# 1. Update pom.xml
sed -i 's/<java.version>1.8/<java.version>11/g' pom.xml

# 2. Run OpenRewrite
mvn org.openrewrite.maven:rewrite-maven-plugin:run \
  -Drewrite.activeRecipes=org.openrewrite.java.migrate.Java8toJava11

# 3. Build
mvn clean install

# 4. Test
mvn test

# 5. Commit
git add .
git commit -m "Migrate to Java 11"

# 6. Push and create PR
git push origin feature/java-11-migration
gh pr create
```

## 🔧 Troubleshooting Quick Fixes

### Build Fails
```bash
# Add JAXB dependencies
# Add to pom.xml <dependencies>:
<dependency>
    <groupId>javax.xml.bind</groupId>
    <artifactId>jaxb-api</artifactId>
    <version>2.3.1</version>
</dependency>
```

### Tests Fail
```bash
# Update test dependencies
mvn versions:use-latest-releases -Dincludes=junit:*,org.mockito:*
```

### OpenRewrite Issues
```bash
# Verify recipes
mvn org.openrewrite.maven:rewrite-maven-plugin:discover

# Re-run with force
mvn clean
mvn org.openrewrite.maven:rewrite-maven-plugin:run
```

## 🎯 File Locations

```
/Users/A-9740/Services/spring-petclinic/
├── pom.xml                         # Maven config
├── src/                           # Source code
├── .github/workflows/             # GitHub Actions
│   └── java-migration.yml         # Migration workflow
├── migrate-java.sh                # Shell migration script
├── migrate-java.py                # Python migration script
└── .git/                         # Git repository
```

## 📊 pom.xml Key Updates

### Before (Java 8)
```xml
<properties>
    <java.version>1.8</java.version>
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>
</properties>
```

### After (Java 11)
```xml
<properties>
    <java.version>11</java.version>
    <maven.compiler.source>11</maven.compiler.source>
    <maven.compiler.target>11</maven.compiler.target>
</properties>
```

### Add OpenRewrite Plugin
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

## 🔄 GitHub Actions Triggers

### Manual Trigger
```yaml
on:
  workflow_dispatch:
    inputs:
      target_java_version:
        type: choice
        options: ['11', '17']
```

### Automatic Trigger
```yaml
on:
  push:
    branches:
      - 'feature/java-*-migration-*'
  pull_request:
    branches:
      - main
    paths:
      - 'pom.xml'
      - '**/*.java'
```

## 🐛 Debug Commands

```bash
# Verbose Maven
mvn clean install -X

# Show dependency tree
mvn dependency:tree

# Check for updates
mvn versions:display-dependency-updates

# Validate pom.xml
mvn validate

# Check effective POM
mvn help:effective-pom

# List all Maven goals
mvn help:describe -Dplugin=org.openrewrite.maven:rewrite-maven-plugin

# Show available recipes
mvn org.openrewrite.maven:rewrite-maven-plugin:discover
```

## 📋 Pre-Flight Checklist

```bash
# Run these before migration
[ ] Commit all changes
[ ] Update local main: git pull origin main
[ ] Verify Java 11: java -version
[ ] Test current build: mvn clean install
[ ] Create backup: git branch backup-$(date +%Y%m%d)
```

## ✅ Post-Migration Checklist

```bash
# Verify migration success
[ ] Build passes: mvn clean install
[ ] Tests pass: mvn test
[ ] No Java 8 references: grep -r "1\.8" pom.xml
[ ] Dependencies updated: mvn versions:display-dependency-updates
[ ] PR created: gh pr view
[ ] CI passing: gh pr checks
```

## 🎨 Color Codes (for scripts)

```bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Usage
echo -e "${GREEN}Success!${NC}"
```

## 🔑 Environment Variables

```bash
# Set Java home
export JAVA_HOME=/path/to/java-11

# Set Maven options
export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512m"

# Add to PATH
export PATH=$JAVA_HOME/bin:$PATH
```

## 📦 Maven Useful Commands

```bash
# Skip tests
mvn install -DskipTests

# Run specific test
mvn test -Dtest=ClassName

# Clean
mvn clean

# Update plugins
mvn versions:display-plugin-updates

# Force update
mvn -U clean install

# Offline mode
mvn -o install
```

## 🌐 GitHub CLI Commands

```bash
# Login
gh auth login

# Create PR
gh pr create --title "Title" --body "Body"

# List PRs
gh pr list

# View PR
gh pr view 123

# Merge PR
gh pr merge 123 --squash

# Check PR status
gh pr checks
```

## 📱 Git Commands

```bash
# Create branch
git checkout -b feature/migration

# Stage changes
git add .

# Commit
git commit -m "Message"

# Push
git push origin branch-name

# View changes
git diff

# View status
git status

# Rollback
git reset --hard HEAD~1

# Stash changes
git stash
git stash pop
```

## 🎯 OpenRewrite Recipes

```bash
# Java 8 to 11
org.openrewrite.java.migrate.Java8toJava11

# Upgrade to Java 11
org.openrewrite.java.migrate.UpgradeToJava11

# Add JAXB
org.openrewrite.java.migrate.javax.AddJaxbDependencies

# Java Version
org.openrewrite.java.migrate.JavaVersion11
```

## 💡 Tips & Tricks

### Speed Up Maven
```bash
# Use parallel builds
mvn -T 4 clean install

# Use daemon
mvnd clean install
```

### Check Java in use
```bash
# macOS
/usr/libexec/java_home -V

# Linux
update-alternatives --list java

# All platforms
mvn -version
```

### Quick Test
```bash
# Compile only
mvn compile

# Run single class
mvn exec:java -Dexec.mainClass="com.example.Main"
```

## 🆘 Emergency Commands

### Rollback Everything
```bash
git reset --hard origin/main
git clean -fdx
```

### Kill Maven Process
```bash
# Find process
ps aux | grep maven

# Kill it
kill -9 <PID>
```

### Clear Maven Cache
```bash
rm -rf ~/.m2/repository
mvn dependency:purge-local-repository
```

## 📚 Quick Links

- Maven Central: https://search.maven.org/
- OpenRewrite Docs: https://docs.openrewrite.org/
- Spring Boot Guide: https://spring.io/guides
- Java 11 Release Notes: https://openjdk.java.net/projects/jdk/11/
- GitHub Actions: https://docs.github.com/en/actions

## 🎓 Remember

1. **Always backup before migrating**
2. **Test in development first**
3. **Read error messages carefully**
4. **Update one thing at a time**
5. **Keep CI green**
6. **Document changes**

---

**Quick Help:**
- Stuck? Check TROUBLESHOOTING.md
- Need details? Check README.md
- First time? Check SETUP_GUIDE.md

**Support:**
```bash
# Get help
gh issue create
gh pr comment "Need help!"

# Community
# - Stack Overflow
# - OpenRewrite Slack
# - Spring Forums
```

---

*Last Updated: 2024*
