# Contributing to Buffalo Brook Gold Rush

First off, thank you for considering contributing to Buffalo Brook Gold Rush! It's people like you that make this game better for everyone.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Getting Started](#getting-started)
- [Development Guidelines](#development-guidelines)
- [Submitting Changes](#submitting-changes)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Features](#suggesting-features)

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for all. Please be respectful and constructive in all interactions.

### Our Standards

**Positive behavior includes:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards others

**Unacceptable behavior includes:**
- Trolling, insulting comments, or personal attacks
- Public or private harassment
- Publishing others' private information
- Other conduct which could be considered inappropriate

---

## How Can I Contribute?

### Reporting Bugs

Bugs are tracked as [GitHub issues](../../issues). When creating a bug report, please include:

**Required Information:**
- **Description**: Clear and concise description of the bug
- **Steps to Reproduce**: Numbered steps to reproduce the behavior
- **Expected Behavior**: What you expected to happen
- **Actual Behavior**: What actually happened
- **Screenshots**: If applicable, add screenshots
- **Environment**:
  - OS (Windows, Linux, Android)
  - Godot version
  - Game version/commit hash

**Bug Report Template:**
```markdown
## Bug Description
[Clear description of the bug]

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. Perform action '...'
4. See error

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- OS: [e.g., Windows 11]
- Godot Version: [e.g., 4.2]
- Game Version: [e.g., commit abc123]

## Screenshots
[If applicable]

## Additional Context
[Any other relevant information]
```

### Suggesting Features

Feature suggestions are also tracked as [GitHub issues](../../issues). When suggesting a feature:

**Include:**
- **Feature Description**: Clear description of the feature
- **Problem Statement**: What problem does it solve?
- **Proposed Solution**: How would you implement it?
- **Alternatives**: Other solutions you've considered
- **Additional Context**: Mockups, examples, references

**Feature Request Template:**
```markdown
## Feature Description
[Clear description of the proposed feature]

## Problem Statement
[What problem does this solve?]

## Proposed Solution
[How should this work?]

## Alternative Solutions
[What other approaches did you consider?]

## Additional Context
[Mockups, examples, or references]

## Priority
[Low/Medium/High - your opinion]
```

### Contributing Code

We love code contributions! Here's how to get started:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Make your changes**
4. **Test thoroughly**
5. **Commit with clear messages**
6. **Push to your fork**
7. **Open a Pull Request**

### Contributing Documentation

Documentation improvements are always welcome:

- Fix typos or unclear explanations
- Add missing documentation
- Improve code comments
- Create tutorials or guides
- Translate documentation

### Contributing Art/Assets

If you're an artist and want to contribute:

- Follow the [Art Design Guide](art_design_guide.md)
- Use appropriate file formats
- Provide source files when possible
- Ensure assets are properly licensed
- Include attribution information

### Contributing Audio

For sound designers and musicians:

- Follow audio quality guidelines
- Provide original compositions or properly licensed audio
- Include source files (project files)
- Document audio specifications

---

## Getting Started

### Development Setup

1. **Install Prerequisites**
   ```bash
   # Install Godot 4.0+
   # Download from: https://godotengine.org/download

   # Install Git
   # Windows: https://git-scm.com/download/win
   # Linux: sudo apt-get install git
   ```

2. **Fork and Clone**
   ```bash
   # Fork the repository on GitHub
   # Then clone your fork
   git clone https://github.com/YOUR-USERNAME/Buffalo-Brook-Gold-Rush.git
   cd Buffalo-Brook-Gold-Rush
   ```

3. **Set Up Remote**
   ```bash
   # Add upstream remote
   git remote add upstream https://github.com/x-cessive/Buffalo-Brook-Gold-Rush.git

   # Verify remotes
   git remote -v
   ```

4. **Open in Godot**
   - Launch Godot Engine
   - Import the project
   - Open `project.godot`

### Understanding the Codebase

**Key Directories:**
- `scripts/` - Game logic (start here for gameplay changes)
- `scenes/` - Scene files and scene-specific scripts
- `autoload/` - Singleton systems (economy, audio, save)
- `resources/` - Game data and assets

**Key Files:**
- `project.godot` - Project configuration
- `export_presets.cfg` - Export settings
- Design documents (`.md` files) - Game design reference

### Making Changes

1. **Create a Branch**
   ```bash
   # Always branch from main
   git checkout main
   git pull upstream main
   git checkout -b feature/your-feature-name
   ```

2. **Make Your Changes**
   - Follow coding guidelines
   - Add comments for complex logic
   - Update documentation if needed

3. **Test Your Changes**
   - Run the game and test functionality
   - Check for errors in console
   - Test edge cases
   - Verify no regressions

4. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "Add feature: brief description"
   ```

---

## Development Guidelines

### Coding Standards

#### GDScript Style Guide

**Naming Conventions:**
```gdscript
# Variables and functions: snake_case
var gold_count: int = 0
func calculate_gold_value() -> float:

# Constants: UPPER_SNAKE_CASE
const MAX_GOLD_CAPACITY: int = 1000

# Classes: PascalCase
class_name GoldPanController

# Private/internal: prefix with underscore
var _internal_state: bool = false
func _internal_calculation() -> void:
```

**Code Structure:**
```gdscript
# 1. Class definition
class_name ClassName
extends BaseClass

# 2. Documentation
## Brief description of the class/script
## Additional details if needed

# 3. Signals
signal gold_found(amount: int)
signal tool_changed(tool_name: String)

# 4. Enums
enum ToolType {
	BASIC_PAN,
	GOLD_PAN,
	PROFESSIONAL_PAN
}

# 5. Constants
const MAX_DURABILITY: float = 100.0

# 6. Exported variables
@export var tool_effectiveness: float = 1.0

# 7. Public variables
var gold_count: int = 0

# 8. Private variables
var _is_panning: bool = false

# 9. Onready variables
@onready var sprite: Sprite2D = $Sprite2D

# 10. Built-in virtual methods
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

# 11. Public methods
func start_panning() -> void:
	pass

# 12. Private methods
func _calculate_yield() -> int:
	pass
```

**Comments and Documentation:**
```gdscript
## Function documentation using double ##
## Describes what the function does
## @param param_name: Description of parameter
## @return: Description of return value
func documented_function(param_name: int) -> String:
	# Inline comments explain complex logic
	var result = param_name * 2
	return str(result)
```

**Best Practices:**
- Use type hints for all variables and functions
- Keep functions small and focused
- Avoid magic numbers (use constants)
- Handle errors gracefully
- Clean up resources in `_exit_tree()`

### Scene Organization

**Scene Structure:**
- Root node should have descriptive name
- Use logical node hierarchies
- Group related nodes under container nodes
- Use unique names (`%NodeName`) for important nodes

**Scene Naming:**
- Use snake_case for scene files
- Be descriptive: `gold_panning_minigame.tscn`
- Match script names where applicable

### Git Workflow

**Branch Naming:**
```bash
feature/add-new-tool-system
bugfix/fix-inventory-crash
hotfix/critical-save-bug
docs/update-api-documentation
refactor/cleanup-economy-code
```

**Commit Messages:**
```
# Format
<type>: <subject>

[optional body]

[optional footer]

# Types
feat: New feature
fix: Bug fix
docs: Documentation changes
style: Code style changes (formatting)
refactor: Code refactoring
test: Adding or updating tests
chore: Maintenance tasks

# Examples
feat: Add sluice box tool with 2x effectiveness

fix: Prevent inventory overflow when collecting gold
- Add max capacity check
- Display warning message when full
- Fixes #123

docs: Update tool system documentation
```

### Testing Guidelines

**Manual Testing:**
- Test your changes in the Godot editor
- Run the full game, not just individual scenes
- Test on different platforms if possible
- Verify no console errors or warnings

**Test Checklist:**
- [ ] Code runs without errors
- [ ] Feature works as intended
- [ ] No regressions in existing features
- [ ] UI is responsive and functional
- [ ] Performance is acceptable
- [ ] Documentation is updated

---

## Submitting Changes

### Pull Request Process

1. **Update Your Branch**
   ```bash
   git checkout main
   git pull upstream main
   git checkout your-feature-branch
   git rebase main
   ```

2. **Push to Your Fork**
   ```bash
   git push origin your-feature-branch
   ```

3. **Create Pull Request**
   - Go to the original repository on GitHub
   - Click "New Pull Request"
   - Select your branch
   - Fill out the PR template

### Pull Request Template

```markdown
## Description
[Describe your changes in detail]

## Motivation and Context
[Why is this change required? What problem does it solve?]

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature causing existing functionality to change)
- [ ] Documentation update

## How Has This Been Tested?
[Describe your testing process]

## Screenshots (if applicable)
[Add screenshots to demonstrate changes]

## Checklist
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings or errors
- [ ] I have tested my changes thoroughly
- [ ] Any dependent changes have been merged and published
```

### Review Process

**What to Expect:**
1. A maintainer will review your PR
2. You may receive feedback or requests for changes
3. Make requested changes and push updates
4. Once approved, your PR will be merged

**Response Time:**
- We aim to respond within 3-7 days
- Complex changes may take longer to review
- Feel free to ping if no response after a week

---

## Best Practices

### Do's

✅ **DO** write clear, descriptive commit messages
✅ **DO** test your changes thoroughly
✅ **DO** update documentation when changing functionality
✅ **DO** follow the existing code style
✅ **DO** ask questions if you're unsure
✅ **DO** be patient and respectful

### Don'ts

❌ **DON'T** commit commented-out code
❌ **DON'T** commit debugging print statements
❌ **DON'T** include unrelated changes in your PR
❌ **DON'T** commit binary files without permission
❌ **DON'T** change whitespace unnecessarily
❌ **DON'T** merge main into your feature branch (use rebase)

---

## Recognition

Contributors will be recognized in:
- The game's credits
- The README's credits section
- The project's contributors page

---

## Questions?

If you have questions about contributing:

1. Check the [Wiki](../../wiki) for detailed guides
2. Search existing [Issues](../../issues) and [Discussions](../../discussions)
3. Ask in [Discussions](../../discussions)
4. Contact the maintainers

---

## Thank You!

Your contributions make this project better for everyone. We appreciate your time and effort!

**Happy coding!** 🎮⛏️✨

---

[← Back to README](README.md)
