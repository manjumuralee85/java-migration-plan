# OpenRewrite Recipe Files Guide

## 📋 Overview

This package includes **two OpenRewrite recipe files** for migrating Spring PetClinic from Java 8 to Java 11:

1. **rewrite.yml** - Basic migration recipe
2. **spring-petclinic-recipe.yml** - Comprehensive PetClinic-specific recipe (RECOMMENDED)

## 📁 Where to Place Recipe Files

### Option 1: Project Root (Recommended for Single Project)
```
/Users/A-9740/Services/spring-petclinic/
├── pom.xml
├── src/
├── rewrite.yml                          ← Place here
└── spring-petclinic-recipe.yml          ← Or place here
```

### Option 2: .mvn Directory (Maven Standard)
```
/Users/A-9740/Services/spring-petclinic/
├── .mvn/
│   └── rewrite.yml                      ← Place here
├── pom.xml
└── src/
```

### Option 3: src/main/resources/META-INF/rewrite
```
/Users/A-9740/Services/spring-petclinic/
├── pom.xml
└── src/
    └── main/
        └── resources/
            └── META-INF/
                └── rewrite/
                    └── spring-petclinic-recipe.yml  ← Place here
```

## 🎯 Recommended Setup

**For Spring PetClinic, use Option 1 (project root):**

```bash
# Copy the comprehensive recipe to your project
cp spring-petclinic-recipe.yml /Users/A-9740/Services/spring-petclinic/rewrite.yml
```

## 🔧 How to Use the Recipe Files

### Method 1: With Updated pom.xml (Automatic)

Add this to your `pom.xml`:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.openrewrite.maven</groupId>
            <artifactId>rewrite-maven-plugin</artifactId>
            <version>5.40.0</version>
            <configuration>
                <!-- This tells OpenRewrite to use your custom recipe -->
                <activeRecipes>
                    <recipe>com.petclinic.SpringPetClinicJava11Upgrade</recipe>
                </activeRecipes>
                <!-- Points to your recipe file -->
                <configLocation>${project.basedir}/rewrite.yml</configLocation>
            </configuration>
            <dependencies>
                <dependency>
                    <groupId>org.openrewrite.recipe</groupId>
                    <artifactId>rewrite-migrate-java</artifactId>
                    <version>2.26.1</version>
                </dependency>
                <dependency>
                    <groupId>org.openrewrite.recipe</groupId>
                    <artifactId>rewrite-spring</artifactId>
                    <version>5.21.0</version>
                </dependency>
                <dependency>
                    <groupId>org.openrewrite.recipe</groupId>
                    <artifactId>rewrite-testing-frameworks</artifactId>
                    <version>2.19.0</version>
                </dependency>
            </dependencies>
        </plugin>
    </plugins>
</build>
```

Then run:
```bash
mvn rewrite:run
```

### Method 2: Command Line (No pom.xml Changes)

```bash
# Using the comprehensive recipe
mvn org.openrewrite.maven:rewrite-maven-plugin:5.40.0:run \
  -Drewrite.recipeArtifactCoordinates=org.openrewrite.recipe:rewrite-migrate-java:2.26.1,org.openrewrite.recipe:rewrite-spring:5.21.0,org.openrewrite.recipe:rewrite-testing-frameworks:2.19.0 \
  -Drewrite.configLocation=rewrite.yml \
  -Drewrite.activeRecipes=com.petclinic.SpringPetClinicJava11Upgrade
```

### Method 3: Using Migration Scripts (Easiest)

Our migration scripts already handle this! Just ensure the recipe file is in place:

```bash
# 1. Copy recipe file
cp spring-petclinic-recipe.yml /Users/A-9740/Services/spring-petclinic/rewrite.yml

# 2. Run migration script (it will use the recipe automatically)
./migrate-java.sh
```

## 📚 Recipe File Breakdown

### rewrite.yml (Basic Recipe)
```yaml
name: com.petclinic.Java8To11Migration
description: Basic Java 8 to 11 migration with dependency upgrades

Includes:
- Core Java 8 to 11 migration
- Spring Boot upgrade
- Common dependency updates
- JUnit 4 to 5 migration
- Basic code cleanup
```

### spring-petclinic-recipe.yml (Comprehensive - RECOMMENDED)
```yaml
name: com.petclinic.SpringPetClinicJava11Upgrade
description: Complete Spring PetClinic migration

Includes 12 phases:
1. Core Java Migration
2. Missing Java 11 Dependencies (JAXB, JAX-WS)
3. Spring Boot Upgrade to 2.7.x
4. Spring Boot Starters Update
5. Database Dependencies (H2, MySQL, PostgreSQL)
6. Testing Frameworks (JUnit 5, Mockito 5)
7. WebJars (Bootstrap, jQuery)
8. Maven Plugins Update
9. Validation & Hibernate
10. Code Cleanup & Modernization
11. Security Updates
12. Property File Updates
```

## 🎨 Customizing the Recipe

### Add Custom Dependencies

Edit `spring-petclinic-recipe.yml` and add:

```yaml
- org.openrewrite.maven.UpgradeDependencyVersion:
    groupId: com.example
    artifactId: your-dependency
    newVersion: 2.0.0
```

### Remove Unwanted Recipes

Comment out recipes you don't want:

```yaml
# - org.openrewrite.java.testing.junit5.JUnit4to5Migration  # Skip JUnit migration
```

### Add New Recipes

Find more recipes at: https://docs.openrewrite.org/recipes

```yaml
- org.openrewrite.java.cleanup.YourCustomRecipe
```

## 🔍 Discover Available Recipes

See what recipes will be applied:

```bash
mvn org.openrewrite.maven:rewrite-maven-plugin:discover
```

## 🧪 Dry Run (Preview Changes)

See what will change without actually changing:

```bash
mvn org.openrewrite.maven:rewrite-maven-plugin:dryRun
```

This creates a `rewrite.patch` file showing all changes.

## ✅ Verify Recipe Syntax

```bash
# Install yamllint (optional)
pip install yamllint

# Validate syntax
yamllint rewrite.yml
```

## 📊 What Each Recipe Does

### Spring Boot Dependency Upgrades
```
spring-boot-starter-web:        2.x → 2.7.18
spring-boot-starter-data-jpa:   2.x → 2.7.18
spring-boot-starter-thymeleaf:  2.x → 2.7.18
spring-boot-starter-test:       2.x → 2.7.18
```

### Database Dependencies
```
h2:                2.x → 2.2.224
mysql-connector-j: 5.x → 8.2.0
postgresql:        42.x → 42.7.1
```

### Testing Dependencies
```
junit-jupiter:     5.x → 5.10.1
mockito-core:      1.x/2.x → 5.8.0
assertj-core:      3.x → 3.24.2
```

### Maven Plugins
```
maven-compiler-plugin:     3.x → 3.11.0
maven-surefire-plugin:     2.x → 3.2.3
spring-boot-maven-plugin:  2.x → 2.7.18
```

## 🚨 Common Issues & Solutions

### Issue 1: Recipe Not Found
```
[ERROR] Recipe 'com.petclinic.SpringPetClinicJava11Upgrade' not found
```

**Solution:**
- Ensure `rewrite.yml` is in the correct location
- Check the recipe name matches exactly
- Add `-Drewrite.configLocation=rewrite.yml`

### Issue 2: Dependencies Not Updated
```
[WARNING] Some dependencies were not updated
```

**Solution:**
- Run with `-U` flag to force updates: `mvn -U rewrite:run`
- Check if dependencies exist in Maven Central
- Update version numbers in recipe file

### Issue 3: Conflicting Versions
```
[ERROR] Dependency convergence error
```

**Solution:**
- Use `<dependencyManagement>` in pom.xml
- Run `mvn dependency:tree` to find conflicts
- Pin specific versions in recipe

## 📝 Integration with Migration Scripts

### For migrate-java.sh

The shell script automatically uses the recipe if present:

```bash
# Script looks for recipe in these locations:
# 1. ./rewrite.yml
# 2. ./.mvn/rewrite.yml
# 3. Uses default if not found
```

### For migrate-java.py

Same behavior as shell script:

```python
# Automatically detects and uses recipe file
# Falls back to command-line recipes if not found
```

### For GitHub Actions

Add this step to use custom recipe:

```yaml
- name: Copy recipe file
  run: |
    cp spring-petclinic-recipe.yml rewrite.yml

- name: Apply OpenRewrite
  run: |
    mvn rewrite:run -Drewrite.configLocation=rewrite.yml
```

## 🎯 Best Practices

1. **Start with Comprehensive Recipe**
   - Use `spring-petclinic-recipe.yml`
   - Covers all PetClinic dependencies

2. **Version Control**
   - Commit recipe file to Git
   - Track changes over time

3. **Review Before Running**
   - Use `dryRun` first
   - Review the patch file

4. **Incremental Updates**
   - Test after each phase
   - Comment out problematic recipes

5. **Keep Updated**
   - Update recipe file for new dependencies
   - Check for new OpenRewrite recipes

## 📖 Recipe File Structure

```yaml
---
type: specs.openrewrite.org/v1beta/recipe
name: com.example.MyRecipe              # Unique recipe name
displayName: My Migration Recipe        # Human-readable name
description: What this recipe does      # Description

tags:                                   # Optional tags
  - java11
  - migration

recipeList:                            # List of recipes to apply
  - org.openrewrite.java.Recipe1
  - org.openrewrite.java.Recipe2:      # Recipe with parameters
      parameter1: value1
      parameter2: value2
```

## 🔗 Resources

- **OpenRewrite Docs**: https://docs.openrewrite.org/
- **Recipe Catalog**: https://docs.openrewrite.org/recipes
- **Spring Recipes**: https://docs.openrewrite.org/recipes/java/spring
- **Maven Plugin**: https://github.com/openrewrite/rewrite-maven-plugin

## ✨ Quick Reference

```bash
# Copy recommended recipe
cp spring-petclinic-recipe.yml /path/to/project/rewrite.yml

# Discover what will change
mvn rewrite:discover

# Preview changes (dry run)
mvn rewrite:dryRun

# Apply changes
mvn rewrite:run

# Or use migration script
./migrate-java.sh
```

---

**Pro Tip:** The `spring-petclinic-recipe.yml` is specifically tailored for Spring PetClinic with all common dependencies. Use this for the best results! 🎯
