# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-23

### Added
- 🎉 Initial release
- Automated installation script (`install.sh`)
- Complete Modbus configuration for Chiltrix heat pumps
- Real-time COP (Coefficient of Performance) calculations
- Cost tracking with time-of-use (TOU) rate support
- Premium dashboard with modern UI
- Controller replica dashboard
- 50+ sensors for comprehensive monitoring
- Pre-built automation scripts
- Voice control integration support
- Mobile-responsive design
- Error detection and diagnostics
- Savings calculator comparing multiple fuel types

### Features
- **Modbus Support**: TCP, RTU over TCP, and Serial/RS485
- **Temperature Sensors**: Inlet, outlet, ambient, DHW, suction, discharge
- **Performance Metrics**: Real-time COP, power consumption, flow rate
- **Financial Tracking**: Cost per hour, daily/monthly projections
- **Dashboards**: 
  - Premium (modern gradients, analytics, graphs)
  - Controller replica (familiar physical interface)
  - Status, settings, mode, and error pages
- **Automation**: Eco mode, comfort mode, boost mode, silent mode
- **Integrations**: Alexa, Google Home, Siri support

### Documentation
- Comprehensive README with installation guide
- Quick start guide
- Troubleshooting section
- Customization examples
- API reference for sensors

### Compatible Models
- CX34 ✅
- CX35 ✅
- CX50-2 ✅
- Other Chiltrix models with Modbus support

---

## [Unreleased]

### Planned
- [ ] MQTT support for remote monitoring
- [ ] Advanced predictive maintenance alerts
- [ ] Integration with weather forecasts for optimization
- [ ] Energy comparison graphs (heat pump vs alternatives)
- [ ] Backup/restore configuration utility
- [ ] Docker container for testing
- [ ] Additional dashboard themes
- [ ] Mobile app dashboard layouts
- [ ] Multi-unit support (multiple heat pumps)
- [ ] Historical COP trend analysis

---

## Version History

### How to Read Versions
- **Major (X.0.0)**: Breaking changes, major rewrites
- **Minor (0.X.0)**: New features, no breaking changes
- **Patch (0.0.X)**: Bug fixes, minor improvements

---

## Upgrade Instructions

### From Manual Installation to Automated
1. Backup your existing configuration
2. Run the new `install.sh` script
3. Merge any custom modifications
4. Restart Home Assistant

### General Upgrade Process
1. Download latest release
2. Review CHANGELOG for breaking changes
3. Backup `/config/` directory
4. Run `install.sh` or manually copy updated files
5. Check for deprecated sensors/entities
6. Update automations if needed
7. Clear browser cache
8. Restart Home Assistant

---

## Known Issues

### v1.0.0
- TOU rate switching may have 1-minute delay (template sensor polling)
- ApexCharts may show gaps if scan_interval is too long
- Dashboard cards require specific HACS versions:
  - button-card >= 3.4.0
  - apexcharts-card >= 2.0.0
  - layout-card >= 2.4.0

---

## Support

For issues, feature requests, or questions:
- 🐛 [Report a Bug](https://github.com/jasipsw/homeassistant-chiltrix-modbus/issues/new?template=bug_report.md)
- 💡 [Request a Feature](https://github.com/jasipsw/homeassistant-chiltrix-modbus/issues/new?template=feature_request.md)
- 💬 [Ask a Question](https://github.com/jasipsw/homeassistant-chiltrix-modbus/discussions)

---

## Contributors

Thank you to all contributors! ❤️

- [@jasipsw](https://github.com/jasipsw) - Creator & Maintainer

Special thanks to:
- [gonzojive/heatpump](https://github.com/gonzojive/heatpump) - Original Modbus research
- [sodabrew/chilctl](https://github.com/sodabrew/chilctl) - CLI tools
- Home Assistant Community

---

[Unreleased]: https://github.com/jasipsw/homeassistant-chiltrix-modbus/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/jasipsw/homeassistant-chiltrix-modbus/releases/tag/v1.0.0
