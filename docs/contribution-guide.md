---
layout: default
title: Contribution Guide
---

# Contribution Guide

## Documentation Checklists

### For New Features

```markdown
#### Documentation Checklist - New Feature
- [ ] README.md
  - [ ] Add feature to main feature list
  - [ ] Add to relevant capability section
  - [ ] Update requirements if needed
  - [ ] Update usage instructions if needed

- [ ] Feature Documentation
  - [ ] Create feature guide in docs/features/{feature-name}.md
  - [ ] Add detailed usage instructions
  - [ ] Include examples and screenshots
  - [ ] Document any configuration options
  - [ ] Add troubleshooting section

- [ ] Main Documentation (docs/index.md)
  - [ ] Add feature to appropriate section
  - [ ] Link to detailed feature guide
  - [ ] Update quick links if major feature

- [ ] Quick Start (docs/quick-start.md)
  - [ ] Add basic usage if user-facing
  - [ ] Update requirements if needed
  - [ ] Add to relevant sections

- [ ] Advanced Usage (docs/advanced-usage.md)
  - [ ] Add advanced configurations
  - [ ] Include best practices
  - [ ] Add integration examples
  - [ ] Document power user features

- [ ] FAQ (docs/faq.md)
  - [ ] Add common questions
  - [ ] Include troubleshooting
  - [ ] Add configuration help

- [ ] CHANGELOG.md
  - [ ] Add under "🚀 New Features" section
  - [ ] Include brief description
  - [ ] Note any dependencies or requirements

- [ ] release_notes.md
  - [ ] Add under appropriate section
  - [ ] Include user-facing benefits
  - [ ] Note any breaking changes
```

### Feature Documentation Template

Create a new file `docs/features/{feature-name}.md`:

```markdown
---
layout: default
title: {Feature Name}
---

# {Feature Name}

## Overview
Brief description of what the feature does and its benefits.

## Requirements
- List any specific requirements
- API keys needed
- System requirements
- Permissions required

## Basic Usage
Step-by-step guide for basic usage:
1. First step with screenshot
2. Second step with example
3. Additional steps as needed

## Configuration
Available configuration options:
| Option | Description | Default | Possible Values |
|--------|-------------|---------|-----------------|
| Option1 | What it does| Default | Valid values   |

## Advanced Usage
Detailed examples for power users:
```python
# Example code or configuration
advanced_setting = value
```

## Best Practices
- Recommended usage patterns
- Performance tips
- Security considerations

## Troubleshooting
Common issues and solutions:
1. Problem: Description
   Solution: Steps to resolve

## Examples
Real-world usage examples:
1. Basic example
2. Advanced example
3. Integration example

## Related Features
- Link to related feature 1
- Link to related feature 2

## Further Reading
- External documentation
- API references
- Related guides
```

### For Bug Fixes

```markdown
#### Documentation Checklist - Bug Fix
- [ ] CHANGELOG.md
  - [ ] Add under "🐛 Bug Fixes" section
  - [ ] Describe what was fixed
  - [ ] Note any behavior changes

- [ ] release_notes.md
  - [ ] Add under "Bug Fixes" section
  - [ ] Explain impact on users
  - [ ] Include any required user actions

- [ ] Documentation
  - [ ] Update relevant docs if fix changes behavior
  - [ ] Add to FAQ if it's a common issue
  - [ ] Update troubleshooting guides if relevant
```

### For UI Changes

```markdown
#### Documentation Checklist - UI Change
- [ ] README.md
  - [ ] Update screenshots if included
  - [ ] Update feature list if needed
  - [ ] Update usage instructions if needed

- [ ] CHANGELOG.md
  - [ ] Add under "🎨 UI Improvements" section
  - [ ] Describe visual/UX changes

- [ ] Documentation
  - [ ] Update quick-start.md with new UI flows
  - [ ] Update advanced-usage.md if needed
  - [ ] Add screenshots where helpful
```

### For Release Process

```markdown
#### Documentation Checklist - New Release
- [ ] Version Numbers
  - [ ] Update version.txt
  - [ ] Update Info.plist
  - [ ] Check all documentation references

- [ ] CHANGELOG.md
  - [ ] Generate new version section
  - [ ] Organize by change type
  - [ ] Include all changes since last release

- [ ] release_notes.md
  - [ ] Update version number
  - [ ] Include all major changes
  - [ ] Organize by category
  - [ ] Add installation instructions
  - [ ] List requirements

- [ ] Documentation
  - [ ] Update version references
  - [ ] Check all links
  - [ ] Update compatibility information
  - [ ] Review all documentation for accuracy
```

## Commit Message Guidelines

Use these prefixes for clear change tracking:

- `feat:` New features
- `fix:` Bug fixes
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc)
- `refactor:` Code changes that neither fix bugs nor add features
- `perf:` Performance improvements
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

Examples:
```bash
feat: Add speech-to-text capability
fix: Resolve permission handling in AudioRecorder
docs: Update README with new features
style: Format AudioRecorder class
refactor: Improve error handling in OpenAIService
perf: Optimize audio processing
test: Add tests for permission handling
chore: Update build script
```

## Pull Request Process

1. **Before Creating PR**
   - Complete relevant documentation checklist
   - Update all necessary documentation
   - Test all documentation links
   - Ensure consistent formatting

2. **PR Description**
   - Reference related issues
   - Complete documentation checklist
   - Explain documentation changes
   - Include screenshots for UI changes

3. **Review Process**
   - Address documentation feedback
   - Ensure all checks pass
   - Verify documentation accuracy
   - Test documentation links

## Questions?

If you're unsure about documentation requirements:
1. Check existing documentation for examples
2. Ask in the PR comments
3. Reference this guide
4. Create a draft PR for feedback 