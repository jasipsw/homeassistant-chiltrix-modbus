# Contributing to Chiltrix Home Assistant Integration

First off, thank you for considering contributing! 🎉

This project is made better by contributors like you. Whether you're fixing bugs, adding features, improving documentation, or sharing your custom dashboards, all contributions are welcome!

## 🤝 How Can I Contribute?

### 🐛 Reporting Bugs

**Before submitting a bug report:**
- Check existing [Issues](https://github.com/jasipsw/homeassistant-chiltrix-modbus/issues) to avoid duplicates
- Ensure you're using the latest version
- Verify the issue isn't with Home Assistant itself

**Good bug reports include:**
- Clear, descriptive title
- Exact steps to reproduce
- What you expected vs what happened
- Your Home Assistant version
- Your Chiltrix model (CX34, CX35, etc.)
- Relevant log excerpts
- Screenshots if applicable

**Example:**
```markdown
**Home Assistant Version:** 2024.10.0
**Chiltrix Model:** CX34
**Connection Type:** Modbus TCP

**Description:**
COP sensor shows incorrect values after 24 hours of operation.

**Steps to Reproduce:**
1. Install integration following README
2. Wait 24 hours
3. Check sensor.cx_cop value
4. Value shows -1.5 instead of expected 3.5

**Logs:**
```
[paste relevant logs here]
```

**Expected:** COP should show positive values between 2-5
**Actual:** Shows -1.5
```

### 💡 Suggesting Features

We love feature ideas! Before suggesting:
- Check [existing feature requests](https://github.com/jasipsw/homeassistant-chiltrix-modbus/labels/enhancement)
- Consider if it fits the project scope
- Think about how it benefits other users

**Good feature requests include:**
- Clear use case ("As a user, I want to...")
- Why it's valuable
- How it might work
- Mockups or examples (if applicable)

### 📝 Improving Documentation

Documentation improvements are always welcome!
- Fix typos or unclear explanations
- Add examples
- Improve installation instructions
- Translate to other languages
- Add troubleshooting tips

### 🎨 Sharing Dashboards

Created a custom dashboard? Share it!
1. Create a new file: `dashboards/community/your_dashboard_name.yaml`
2. Add screenshots
3. Document any requirements
4. Submit a pull request

### 🔧 Contributing Code

**Areas we'd love help with:**
- Support for additional Chiltrix models
- New sensor types
- Performance optimizations
- Additional automation examples
- Dashboard improvements
- Testing and validation

---

## 🚀 Getting Started

### Development Setup

1. **Fork the repository**
   ```bash
   # Click "Fork" button on GitHub
   # Then clone your fork
   git clone https://github.com/YOUR_USERNAME/homeassistant-chiltrix-modbus.git
   cd homeassistant-chiltrix-modbus
   ```

2. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/bug-description
   ```

3. **Make your changes**
   - Edit files as needed
   - Test thoroughly
   - Follow existing code style

4. **Test your changes**
   - Install in your Home Assistant test instance
   - Verify all sensors work
   - Check dashboards render correctly
   - Test across different scenarios

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add: Brief description of changes"
   ```
   
   **Commit message format:**
   - `Add:` New features
   - `Fix:` Bug fixes
   - `Update:` Updates to existing features
   - `Docs:` Documentation changes
   - `Style:` Formatting changes
   - `Refactor:` Code restructuring
   - `Test:` Adding tests

6. **Push and create pull request**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then open a PR on GitHub!

---

## 📋 Pull Request Guidelines

### Before Submitting
- [ ] Code follows existing style
- [ ] Tested in Home Assistant
- [ ] Documentation updated (if needed)
- [ ] CHANGELOG.md updated
- [ ] No breaking changes (or clearly documented)
- [ ] Commit messages are clear

### PR Description Should Include
- What changes were made
- Why these changes were needed
- How to test the changes
- Screenshots (for UI changes)
- Any breaking changes

**Example PR template:**
```markdown
## Description
Adds support for CX50-2 model with additional temperature sensors.

## Changes
- Added 2 new temperature sensors in modbus.yaml
- Updated dashboard to display new sensors
- Added CX50-2 to compatibility list

## Testing
- [x] Tested on CX50-2 hardware
- [x] Verified sensors appear in HA
- [x] Dashboard displays correctly
- [x] No errors in logs

## Screenshots
[attach screenshots]

## Breaking Changes
None
```

---

## 🎨 Code Style Guidelines

### YAML Files
- Use 2 spaces for indentation
- Include comments for complex logic
- Use descriptive entity IDs
- Follow Home Assistant naming conventions

**Example:**
```yaml
# Good
- name: "Chiltrix Water Inlet Temperature"
  unique_id: cx_water_inlet_temp
  unit_of_measurement: "°C"
  state_class: measurement
  device_class: temperature

# Avoid
- name: "temp1"
  id: t1
```

### Dashboard Files
- Group related cards
- Use consistent colors
- Add helpful tooltips
- Keep layouts mobile-friendly
- Comment card purposes

**Example:**
```yaml
# Temperature Overview Card
- type: entities
  title: Temperature Sensors
  entities:
    - sensor.cx_water_inlet_temperature
    - sensor.cx_water_outlet_temperature
```

### Scripts & Automations
- Use descriptive names
- Include mode specification
- Add helpful descriptions
- Handle edge cases

---

## 🧪 Testing

### Manual Testing Checklist
- [ ] Fresh install works
- [ ] Update from previous version works
- [ ] All sensors populate
- [ ] Dashboards render correctly
- [ ] Scripts execute successfully
- [ ] No errors in Home Assistant logs
- [ ] Works on mobile
- [ ] Works on desktop

### Test Scenarios
1. **Clean install** - Fresh Home Assistant
2. **Update** - Existing installation
3. **Multiple models** - Test on CX34, CX35, CX50-2
4. **Edge cases** - Disconnection, errors, restarts

---

## 🏗️ Project Structure

```
homeassistant-chiltrix-modbus/
├── install.sh                    # Automated installer
├── README.md                     # Main documentation
├── QUICK_START.md               # Quick start guide
├── CHANGELOG.md                 # Version history
├── CONTRIBUTING.md              # This file
├── LICENSE                      # MIT License
├── 
├── modbus.yaml                  # Modbus configuration
├── cop_sensors.yaml             # COP calculations
├── cost_sensors.yaml            # Cost tracking
├── fluid_helpers.yaml           # Fluid properties
├── cost_helpers.yaml            # Rate configuration
├── automation_scripts.yaml      # Helper scripts
├──
├── dashboards/
│   ├── premium_dashboard.yaml   # Main dashboard
│   ├── controller_display.yaml  # Controller replica
│   ├── status_page.yaml         # Status view
│   ├── settings_page.yaml       # Settings view
│   ├── mode_page.yaml           # Mode selection
│   ├── error_page.yaml          # Error diagnostics
│   └── community/               # User-contributed dashboards
│
├── examples/
│   ├── automations/             # Example automations
│   └── configurations/          # Configuration examples
│
└── images/                      # Screenshots and images
```

---

## 📚 Resources

### Helpful Documentation
- [Home Assistant Developer Docs](https://developers.home-assistant.io/)
- [Modbus Integration Docs](https://www.home-assistant.io/integrations/modbus/)
- [YAML Syntax](https://yaml.org/)
- [Chiltrix Manuals](https://chiltrix.com/support)

### Tools
- [YAML Validator](http://www.yamllint.com/)
- [Home Assistant Config Helper](https://www.home-assistant.io/docs/tools/)
- [Visual Studio Code](https://code.visualstudio.com/) with Home Assistant extension

---

## 💬 Community

### Getting Help
- 💬 [GitHub Discussions](https://github.com/jasipsw/homeassistant-chiltrix-modbus/discussions) - General questions
- 🐛 [GitHub Issues](https://github.com/jasipsw/homeassistant-chiltrix-modbus/issues) - Bug reports
- 🏠 [Home Assistant Community](https://community.home-assistant.io/) - General HA help

### Stay Connected
- ⭐ Star the repository
- 👀 Watch for updates
- 🔔 Enable notifications for discussions

---

## 🎖️ Recognition

Contributors will be:
- Listed in README.md
- Credited in CHANGELOG.md
- Thanked in release notes

Significant contributions may earn:
- Maintainer status
- Project leadership roles

---

## ❓ Questions?

Don't hesitate to ask! Options:
1. Open a [Discussion](https://github.com/jasipsw/homeassistant-chiltrix-modbus/discussions)
2. Comment on relevant Issues
3. Reach out to maintainers

---

## 📜 Code of Conduct

### Our Pledge
We pledge to make participation in this project a harassment-free experience for everyone.

### Our Standards
**Positive behavior:**
- Using welcoming language
- Being respectful of differing viewpoints
- Accepting constructive criticism
- Focusing on what's best for the community

**Unacceptable behavior:**
- Trolling or insulting comments
- Public or private harassment
- Publishing others' private information
- Other unprofessional conduct

### Enforcement
Instances of unacceptable behavior may result in:
1. Warning
2. Temporary ban
3. Permanent ban

Report issues to project maintainers.

---

## 🙏 Thank You!

Your contributions make this project better for everyone. Whether it's a bug report, feature suggestion, or code contribution - thank you! 🎉

---

**Happy Contributing! 🚀**
