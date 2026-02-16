# Troubleshooting Guide - Java Migration Workflow

A comprehensive guide to solve common issues during Java 8 to 11 migration.

## 🔍 Table of Contents

1. [Prerequisites Issues](#prerequisites-issues)
2. [Build Failures](#build-failures)
3. [Test Failures](#test-failures)
4. [OpenRewrite Issues](#openrewrite-issues)
5. [Git/GitHub Issues](#gitgithub-issues)
6. [Dependency Issues](#dependency-issues)
7. [Runtime Issues](#runtime-issues)
8. [GitHub Actions Issues](#github-actions-issues)

---

## 1. Prerequisites Issues

### Issue 1.1: "command not found: java"

**Symptoms:**
```bash
./migrate-java.sh: line 45: java: command not found
```

**Diagnosis:**
Java is not installed or not in PATH.

**Solution:**

**macOS:**
```bash
# Install Java 11
brew install openjdk@11

# Add to PATH
echo 'export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify
java -version
```

**Linux:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install openjdk-11-jdk

# Verify
java -version
```

**Windows:**
1. Download from https://adoptium.net/
2. Install
3. Add to PATH: System Properties → Environment Variables
4. Restart terminal

---

### Issue 1.2: "command not found: mvn"

**Symptoms:**
```bash
./migrate-java.sh: line 67: mvn: command not found
```

**Diagnosis:**
Maven is not installed or not in PATH.

**Solution:**

**macOS:**
```bash
brew install maven
mvn -version
```

**Linux:**
```bash
sudo apt install maven
mvn -version
```

**Windows:**
1. Download from https://maven.apache.org/download.cgi
2. Extract to C:\Program Files\Maven
3. Add to PATH
4. Restart terminal

---

### Issue 1.3: Wrong Java Version

**Symptoms:**
```bash
java version "1.8.0_XXX"
```

**Diagnosis:**
Multiple Java versions installed, using wrong one.

**Solution:**

**macOS:**
```bash
# List installed Java versions
/usr/libexec/java_home -V

# Set Java 11 as default
export JAVA_HOME=$(/usr/libexec/java_home -v11)
echo 'export JAVA_HOME=$(/usr/libexec/java_home -v11)' >> ~/.zshrc

# Verify
java -version
```

**Linux:**
```bash
# List alternatives
sudo update-alternatives --config java

# Select Java 11 from the list

# Verify
java -version
```

**Windows:**
1. Set JAVA_HOME environment variable to Java 11 installation
2. Update PATH to use JAVA_HOME\bin
3. Restart terminal

---

## 2. Build Failures

### Issue 2.1: Compilation Errors After Migration

**Symptoms:**
```
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.8.1:compile
[ERROR] Compilation failure: package javax.xml.bind does not exist
```

**Diagnosis:**
Java 11 removed some packages that were in Java 8 (like JAXB).

**Solution:**

Add missing dependencies to pom.xml:

```xml
<dependencies>
    <!-- JAXB API -->
    <dependency>
        <groupId>javax.xml.bind</groupId>
        <artifactId>jaxb-api</artifactId>
        <version>2.3.1</version>
    </dependency>
    
    <!-- JAXB Implementation -->
    <dependency>
        <groupId>org.glassfish.jaxb</groupId>
        <artifactId>jaxb-runtime</artifactId>
        <version>2.3.1</version>
    </dependency>
    
    <!-- JAX-WS (if needed) -->
    <dependency>
        <groupId>javax.xml.ws</groupId>
        <artifactId>jaxws-api</artifactId>
        <version>2.3.1</version>
    </dependency>
</dependencies>
```

Then rebuild:
```bash
mvn clean compile
```

---

### Issue 2.2: "Unsupported class file major version 55"

**Symptoms:**
```
java.lang.IllegalArgumentException: Unsupported class file major version 55
```

**Diagnosis:**
Trying to run Java 11 bytecode with Java 8.

**Solution:**

Ensure Java 11 is being used:
```bash
# Check Java version
java -version

# Set JAVA_HOME
export JAVA_HOME=/path/to/java11

# Clean and rebuild
mvn clean install
```

---

### Issue 2.3: Maven Plugin Compatibility

**Symptoms:**
```
[ERROR] Plugin org.apache.maven.plugins:maven-compiler-plugin:3.1 is not compatible
```

**Diagnosis:**
Old Maven plugins don't support Java 11.

**Solution:**

Update plugins in pom.xml:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.11.0</version>
            <configuration>
                <source>11</source>
                <target>11</target>
            </configuration>
        </plugin>
        
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.0.0</version>
        </plugin>
    </plugins>
</build>
```

---

## 3. Test Failures

### Issue 3.1: Tests Passing Locally but Failing in CI

**Symptoms:**
```
Tests run: 50, Failures: 5, Errors: 0, Skipped: 0
```

**Diagnosis:**
Environment differences between local and CI.

**Solution:**

1. Check Java version in CI:
```yaml
# In GitHub Actions
- name: Set up JDK 11
  uses: actions/setup-java@v4
  with:
    java-version: '11'
    distribution: 'temurin'
```

2. Check for timezone issues:
```java
// Use explicit timezone in tests
ZonedDateTime.now(ZoneId.of("UTC"))
```

3. Clean before testing:
```bash
mvn clean test
```

---

### Issue 3.2: Module System Conflicts

**Symptoms:**
```
java.lang.IllegalAccessError: class X cannot access class Y
```

**Diagnosis:**
Java 9+ module system restricting access.

**Solution:**

Add JVM arguments to surefire plugin:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.0.0</version>
    <configuration>
        <argLine>
            --add-opens java.base/java.lang=ALL-UNNAMED
            --add-opens java.base/java.util=ALL-UNNAMED
        </argLine>
    </configuration>
</plugin>
```

---

### Issue 3.3: Mockito Compatibility

**Symptoms:**
```
java.lang.NoClassDefFoundError: net/bytebuddy/...
```

**Diagnosis:**
Old Mockito version not compatible with Java 11.

**Solution:**

Update Mockito version:

```xml
<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-core</artifactId>
    <version>5.7.0</version>
    <scope>test</scope>
</dependency>
```

---

## 4. OpenRewrite Issues

### Issue 4.1: OpenRewrite Plugin Not Found

**Symptoms:**
```
[ERROR] Plugin 'org.openrewrite.maven:rewrite-maven-plugin' not found
```

**Diagnosis:**
Plugin not properly added to pom.xml.

**Solution:**

Add plugin to pom.xml:

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

Then:
```bash
mvn validate
```

---

### Issue 4.2: OpenRewrite Changes Nothing

**Symptoms:**
OpenRewrite runs but makes no changes.

**Diagnosis:**
- Recipe not active
- Code already migrated
- Wrong recipe name

**Solution:**

1. Verify recipe is active:
```bash
mvn org.openrewrite.maven:rewrite-maven-plugin:discover
```

2. Run with explicit recipe:
```bash
mvn org.openrewrite.maven:rewrite-maven-plugin:run \
  -Drewrite.activeRecipes=org.openrewrite.java.migrate.Java8toJava11
```

3. Check available recipes:
```bash
mvn org.openrewrite.maven:rewrite-maven-plugin:discover
```

---

### Issue 4.3: OpenRewrite Errors

**Symptoms:**
```
[ERROR] Error during rewrite: cannot find symbol
```

**Diagnosis:**
Code doesn't compile, OpenRewrite can't parse it.

**Solution:**

1. Fix compilation errors first:
```bash
mvn clean compile
# Fix any errors
```

2. Then run OpenRewrite:
```bash
mvn org.openrewrite.maven:rewrite-maven-plugin:run
```

---

## 5. Git/GitHub Issues

### Issue 5.1: Cannot Push to GitHub

**Symptoms:**
```
remote: Permission to repository denied
fatal: unable to access 'https://github.com/...': The requested URL returned error: 403
```

**Diagnosis:**
Authentication issue.

**Solution:**

**Using HTTPS:**
```bash
# Re-authenticate with GitHub CLI
gh auth login

# Or use personal access token
git remote set-url origin https://YOUR_TOKEN@github.com/user/repo.git
```

**Using SSH:**
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Add to GitHub: Settings → SSH Keys → New SSH key
cat ~/.ssh/id_ed25519.pub

# Change remote to SSH
git remote set-url origin git@github.com:user/repo.git
```

---

### Issue 5.2: Branch Already Exists

**Symptoms:**
```
fatal: A branch named 'feature/java-11-migration-...' already exists.
```

**Diagnosis:**
Previous migration attempt left branch.

**Solution:**

Delete old branch and start fresh:
```bash
# Delete local branch
git branch -D feature/java-11-migration-20240116-120000

# Delete remote branch (if exists)
git push origin --delete feature/java-11-migration-20240116-120000

# Run migration again
./migrate-java.sh
```

---

### Issue 5.3: Merge Conflicts

**Symptoms:**
```
CONFLICT (content): Merge conflict in pom.xml
```

**Diagnosis:**
Changes conflict with main branch.

**Solution:**

```bash
# Update your branch
git checkout main
git pull origin main
git checkout feature/java-11-migration-...
git merge main

# Resolve conflicts
# Edit conflicted files
# Look for <<<<<<< HEAD markers

# Stage resolved files
git add .

# Complete merge
git commit

# Push
git push origin feature/java-11-migration-...
```

---

## 6. Dependency Issues

### Issue 6.1: Dependency Not Found

**Symptoms:**
```
[ERROR] Failed to execute goal on project: Could not resolve dependencies
[ERROR] The following artifacts could not be resolved: com.example:library:jar:1.0.0
```

**Diagnosis:**
Dependency not available for Java 11.

**Solution:**

1. Find Java 11 compatible version:
```bash
mvn versions:display-dependency-updates
```

2. Update in pom.xml:
```xml
<dependency>
    <groupId>com.example</groupId>
    <artifactId>library</artifactId>
    <version>2.0.0</version> <!-- Updated version -->
</dependency>
```

3. Check Maven Central for compatible versions:
https://search.maven.org/

---

### Issue 6.2: Transitive Dependency Conflicts

**Symptoms:**
```
[WARNING] Conflict detected: com.google.guava:guava:20.0 vs 30.0
```

**Diagnosis:**
Multiple dependencies pulling different versions.

**Solution:**

Add dependency management:

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.google.guava</groupId>
            <artifactId>guava</artifactId>
            <version>32.1.3-jre</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```

---

## 7. Runtime Issues

### Issue 7.1: NoClassDefFoundError at Runtime

**Symptoms:**
```
java.lang.NoClassDefFoundError: javax/xml/bind/JAXBException
```

**Diagnosis:**
Runtime missing classes removed in Java 11.

**Solution:**

Add runtime dependencies:

```xml
<dependencies>
    <dependency>
        <groupId>javax.xml.bind</groupId>
        <artifactId>jaxb-api</artifactId>
        <version>2.3.1</version>
    </dependency>
    <dependency>
        <groupId>org.glassfish.jaxb</groupId>
        <artifactId>jaxb-runtime</artifactId>
        <version>2.3.1</version>
        <scope>runtime</scope>
    </dependency>
</dependencies>
```

---

### Issue 7.2: Illegal Reflective Access

**Symptoms:**
```
WARNING: Illegal reflective access by ...
WARNING: Please consider reporting this to the maintainers
```

**Diagnosis:**
Library using reflection on JDK internals.

**Solution:**

Add JVM arguments:

```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <jvmArguments>
            --add-opens java.base/java.lang=ALL-UNNAMED
            --add-opens java.base/java.util=ALL-UNNAMED
        </jvmArguments>
    </configuration>
</plugin>
```

---

## 8. GitHub Actions Issues

### Issue 8.1: Workflow Not Running

**Symptoms:**
Workflow doesn't appear in Actions tab.

**Diagnosis:**
- Workflow file in wrong location
- YAML syntax error
- Branch protection

**Solution:**

1. Check file location:
```bash
ls -la .github/workflows/
# Should show: java-migration.yml
```

2. Validate YAML:
```bash
# Use online validator or
yamllint .github/workflows/java-migration.yml
```

3. Check workflow syntax:
```yaml
name: Java Migration  # Required
on: workflow_dispatch  # Required trigger
jobs:                  # Required
  migrate:            # At least one job
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
```

---

### Issue 8.2: Workflow Failing in CI

**Symptoms:**
Workflow fails in GitHub Actions but works locally.

**Diagnosis:**
Environment differences.

**Solution:**

1. Add debug logging:
```yaml
- name: Debug Environment
  run: |
    echo "Java version:"
    java -version
    echo "Maven version:"
    mvn -version
    echo "Working directory:"
    pwd
    ls -la
```

2. Check secrets:
```yaml
- name: Check Secrets
  run: |
    echo "GitHub Token length: ${#GITHUB_TOKEN}"
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

3. Use exact same Java version:
```yaml
- name: Set up JDK 11
  uses: actions/setup-java@v4
  with:
    java-version: '11.0.20'  # Exact version
    distribution: 'temurin'
```

---

### Issue 8.3: PR Not Created

**Symptoms:**
Migration completes but no PR created.

**Diagnosis:**
- GitHub token permissions
- Branch already has PR
- Script error

**Solution:**

1. Check GitHub token permissions:
   - Go to repository Settings → Actions → General
   - Workflow permissions → Read and write permissions

2. Check for existing PR:
```bash
gh pr list --head feature/java-11-migration-...
```

3. Create PR manually:
```bash
gh pr create \
  --title "Java 8 to 11 Migration" \
  --body "Migration completed" \
  --base main \
  --head feature/java-11-migration-...
```

---

## 🔧 General Debugging Tips

### Enable Debug Mode

**Shell Script:**
```bash
# Add at the top of the script
set -x  # Print commands before executing
set -e  # Exit on error
set -u  # Exit on undefined variable
```

**Python Script:**
```python
# Add logging
import logging
logging.basicConfig(level=logging.DEBUG)
```

**Maven:**
```bash
# Run with debug output
mvn clean install -X

# Or with even more detail
mvn clean install -e -X
```

---

### Collect Diagnostic Information

```bash
# Create diagnostic report
cat > diagnostic-report.txt << EOF
Date: $(date)
User: $(whoami)
Working Directory: $(pwd)

Java Version:
$(java -version 2>&1)

Maven Version:
$(mvn -version)

Git Status:
$(git status)

Git Log:
$(git log --oneline -5)

pom.xml Java Version:
$(grep "java.version" pom.xml)

Last Build Log:
$(tail -50 target/maven-status/*/compile/default-compile/inputFiles.lst 2>/dev/null || echo "No build log found")
EOF

cat diagnostic-report.txt
```

---

## 📞 Getting Help

If none of these solutions work:

1. **Check logs carefully:**
   ```bash
   # Maven logs
   cat target/maven.log
   
   # Script logs
   cat migration.log
   ```

2. **Search for specific error:**
   - Copy exact error message
   - Search on Stack Overflow
   - Check GitHub issues

3. **Community resources:**
   - [OpenRewrite Slack](https://join.slack.com/t/rewriteoss/shared_invite/)
   - [Spring Boot GitHub](https://github.com/spring-projects/spring-boot/issues)
   - [Stack Overflow](https://stackoverflow.com/questions/tagged/java-11+migration)

4. **Create minimal reproduction:**
   - Isolate the problem
   - Create small example
   - Share with community

---

## ✅ Prevention Checklist

Before starting migration:

- [ ] Backup your code
- [ ] Update all tools (Java, Maven, Git)
- [ ] Read migration guides
- [ ] Test in development first
- [ ] Have rollback plan ready
- [ ] Document any custom dependencies
- [ ] Notify team members
- [ ] Schedule adequate time

---

**Remember:** Most issues can be solved by:
1. Reading error messages carefully
2. Checking versions of tools
3. Consulting official documentation
4. Starting with clean environment

Good luck with your migration! 🚀
