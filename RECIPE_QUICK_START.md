# 🎯 Quick Recipe Setup Guide

## What Are Recipe Files?

Recipe files tell OpenRewrite **exactly which dependencies to upgrade** and **how to modernize your code**. Think of them as upgrade instructions for your project.

## 📦 Included Recipe Files

This package includes **TWO** recipe files:

### 1. rewrite.yml (Basic)
- Core Java 8 to 11 migration
- Essential Spring Boot upgrades
- Basic dependency updates
- Good for simple projects

### 2. spring-petclinic-recipe.yml (Comprehensive - RECOMMENDED)
- Everything in basic recipe PLUS:
- All Spring Boot starters (web, data-jpa, thymeleaf, etc.)
- Database drivers (H2, MySQL, PostgreSQL)
- Testing frameworks (JUnit 5, Mockito 5, AssertJ)
- WebJars (Bootstrap, jQuery)
- Maven plugins
- Security updates
- Code modernization
- **Specifically tailored for Spring PetClinic!**

## 🚀 Super Quick Setup (30 seconds)

```bash
# Step 1: Copy the comprehensive recipe to your project
cp spring-petclinic-recipe.yml /Users/A-9740/Services/spring-petclinic/rewrite.yml

# Step 2: Run migration (it will automatically use the recipe!)
cd /Users/A-9740/Services/spring-petclinic
./migrate-java.sh
```

**That's it!** The migration script will automatically:
✅ Detect the recipe file
✅ Load all upgrade instructions
✅ Apply all dependency updates
✅ Modernize your code

## 📍 Where to Put Recipe Files

**Recommended Location (Project Root):**
```
/Users/A-9740/Services/spring-petclinic/
├── pom.xml
├── rewrite.yml                    ← Put it here!
└── src/
```

**Alternative Locations (also work):**
```
Option 2: .mvn/rewrite.yml
Option 3: spring-petclinic-recipe.yml (different name)
```

Our scripts check all these locations automatically!

## 🎯 What Gets Upgraded

### Spring Boot Starters → 2.7.18
- spring-boot-starter-web
- spring-boot-starter-data-jpa
- spring-boot-starter-thymeleaf
- spring-boot-starter-test
- spring-boot-starter-actuator
- And more...

### Database Drivers
- H2: latest Java 11 compatible version
- MySQL: 8.2.0
- PostgreSQL: 42.7.1

### Testing Frameworks
- JUnit: 4.x → 5.10.1 (Jupiter)
- Mockito: 1.x/2.x → 5.8.0
- AssertJ: → 3.24.2

### Maven Plugins
- maven-compiler-plugin: → 3.11.0
- maven-surefire-plugin: → 3.2.3
- spring-boot-maven-plugin: → 2.7.18

### WebJars
- Bootstrap: → 5.3.2
- jQuery: → 3.7.1

## 🔧 How Migration Scripts Use Recipes

### Shell Script (migrate-java.sh)
```bash
# Automatically checks for recipe files in order:
# 1. rewrite.yml
# 2. spring-petclinic-recipe.yml
# 3. .mvn/rewrite.yml
# 4. Falls back to default if none found

./migrate-java.sh  # Just run it!
```

### Python Script (migrate-java.py)
```python
# Same auto-detection as shell script
python3 migrate-java.py  # Just run it!
```

### GitHub Actions
```yaml
# Automatically uses recipe if present
# No extra configuration needed!
```

## 📖 Detailed Documentation

For complete recipe documentation, see: **RECIPE_GUIDE.md**

Topics covered:
- Customizing recipes
- Adding your own dependencies
- Recipe syntax
- Troubleshooting
- Advanced usage

## ❓ FAQ

**Q: Do I need to modify pom.xml?**
A: No! Just copy the recipe file and run the migration script.

**Q: Which recipe should I use?**
A: Use `spring-petclinic-recipe.yml` renamed to `rewrite.yml` - it's comprehensive!

**Q: Can I customize the recipe?**
A: Yes! Edit the YAML file to add/remove dependencies. See RECIPE_GUIDE.md

**Q: What if I have custom dependencies?**
A: Add them to the recipe file following the examples inside.

**Q: Will this break my project?**
A: No! The migration creates a new branch. You can always rollback.

## ✅ Verification

After copying the recipe file, verify it's detected:

```bash
cd /Users/A-9740/Services/spring-petclinic

# Check if file exists
ls -la rewrite.yml

# Should show: -rw-r--r-- rewrite.yml

# Run migration (will show "Found custom recipe file")
./migrate-java.sh
```

## 🎨 Recipe File Structure (Simple Explanation)

```yaml
name: com.petclinic.SpringPetClinicJava11Upgrade  # Recipe name

recipeList:                                        # List of upgrades
  - org.openrewrite.java.migrate.Java8toJava11    # Java migration
  
  - org.openrewrite.maven.UpgradeDependencyVersion:  # Upgrade a dependency
      groupId: com.h2database
      artifactId: h2
      newVersion: 2.2.224                          # New version number
  
  # ... more upgrades ...
```

## 🚨 Important Notes

1. **File Location Matters**: Put `rewrite.yml` in your project root
2. **Name Matters**: Must be named `rewrite.yml` or one of the alternatives
3. **YAML Syntax**: Indentation must be correct (use spaces, not tabs)
4. **Auto-Detection**: Scripts automatically find and use the recipe

## 🎉 You're Ready!

```bash
# Quick checklist:
[ ] Downloaded the migration package
[ ] Copied spring-petclinic-recipe.yml to your project as rewrite.yml
[ ] Ready to run: ./migrate-java.sh

# That's all you need! The recipe does the rest! 🚀
```

---

**Need Help?**
- Detailed guide: RECIPE_GUIDE.md
- Troubleshooting: TROUBLESHOOTING.md
- Full setup: SETUP_GUIDE.md
