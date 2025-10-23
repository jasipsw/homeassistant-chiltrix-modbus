# Chiltrix Heat Pump - Home Assistant Modbus Integration

A comprehensive Home Assistant configuration for monitoring and controlling Chiltrix heat pumps via Modbus TCP.

## 🔥 Compatible Models

- **CX34** Series
- **CX35** Series  
- **CX50-2** Series
- Other Chiltrix heat pump models

## ✨ Features

### Core Monitoring
- ✅ **Complete temperature monitoring** - inlet, outlet, ambient, coil, discharge, suction
- ✅ **Real-time performance metrics** - power, flow rate, speeds, pressure
- ✅ **Operating state tracking** - heating, cooling, DHW, defrost, error codes
- ✅ **Diagnostic data** - runtime hours, compressor starts, defrost cycles

### Advanced Analytics
- 📊 **COP (Coefficient of Performance) calculations**
  - Real-time COP monitoring
  - Mode-specific COP (heating, cooling, DHW)
  - DHW priority tracking
  - Historical averages
  
- 💰 **Cost tracking and analysis**
  - Real-time operating costs
  - Time-of-use (TOU) rate support
  - Fuel cost comparisons (gas, oil, propane, electric resistance)
  - Savings calculations
  - Daily, monthly, and annual cost projections

### Fluid Configuration
- 🌡️ **Configurable fluid properties**
  - Default: Environol 1000
  - Water
  - Glycol mixtures (30%, 50%)
  - Custom fluid support

## 📦 What's Included

```
homeassistant-chiltrix-modbus/
├── modbus.yaml              # Main Modbus configuration (sensors, switches, climate)
├── cop_sensors.yaml         # COP calculation templates
├── cost_sensors.yaml        # Cost calculation templates
├── fluid_helpers.yaml       # Fluid property configuration helpers
├── cost_helpers.yaml        # Energy cost configuration helpers
├── customize.yaml           # Entity customizations (names, icons)
├── cop_dashboard.yaml       # COP monitoring dashboard
├── cost_dashboard.yaml      # Cost tracking dashboard (incomplete - see artifacts)
├── SETUP_GUIDE.md          # Detailed installation instructions
├── COP_SETUP_GUIDE.md      # COP configuration guide
└── README.md               # This file
```

## 🚀 Quick Start

### Prerequisites
- Home Assistant (2023.1 or newer)
- Waveshare RS485 to Modbus TCP device (or similar)
- RS485 connection to your Chiltrix heat pump
- Network connection to Waveshare device

### Installation

1. **Clone this repository:**
   ```bash
   cd /config
   git clone https://github.com/jasipsw/homeassistant-chiltrix-modbus.git
   ```

2. **Copy files to your Home Assistant config:**
   ```bash
   cp homeassistant-chiltrix-modbus/*.yaml /config/
   ```

3. **Edit `modbus.yaml`** and change the IP address (line 13):
   ```yaml
   host: 192.168.1.100  # Change to your Waveshare device IP
   ```

4. **Add to `configuration.yaml`:**
   ```yaml
   # Modbus Configuration
   modbus: !include modbus.yaml
   
   # COP and Cost Sensors
   template: !include cop_sensors.yaml
   template: !include cost_sensors.yaml
   
   # Fluid and Cost Configuration
   input_number: !include fluid_helpers.yaml
   input_number: !include cost_helpers.yaml
   
   # Entity Customization
   homeassistant:
     customize: !include customize.yaml
   ```

5. **Check configuration:**
   ```
   Developer Tools → YAML → Check Configuration
   ```

6. **Restart Home Assistant:**
   ```
   Settings → System → Restart
   ```

7. **Verify entities created:**
   ```
   Developer Tools → States → Search "cx"
   ```

### Basic Configuration

After restart, configure your system:

1. **Set your fluid type** (if not using Environol 1000):
   - Go to Settings → Devices & Services → Helpers
   - Adjust "Chiltrix Fluid Specific Heat Capacity" and "Chiltrix Fluid Density"

2. **Set your electricity rate**:
   - Find "Electricity Rate (Flat)" helper
   - Enter your rate in $/kWh

3. **Configure Time-of-Use rates** (optional):
   - Set peak, mid-peak, and off-peak rates
   - Configure time schedules

## 📊 Dashboard

Add pre-built dashboard cards to your Lovelace interface:

### COP Dashboard
```yaml
# Copy content from cop_dashboard.yaml
```

### Cost Dashboard  
```yaml
# Copy content from cost_dashboard.yaml
```

## 📖 Documentation

- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed installation and troubleshooting
- **[COP_SETUP_GUIDE.md](COP_SETUP_GUIDE.md)** - COP calculation configuration and FAQ

## 🔧 Troubleshooting

### No Entities Appear
1. Check Home Assistant logs for Modbus errors
2. Verify Waveshare device IP address is correct
3. Confirm RS485 wiring (A to A, B to B)
4. Try different slave ID (0, 1, or 2)

### Entities Show "Unavailable"
- Register addresses may differ for your model/firmware
- Comment out unavailable entities in modbus.yaml
- Use Modbus scanner tool to find correct addresses

### COP Shows "Unavailable"
1. Verify flow rate sensor is working
2. Check temperature sensors
3. Confirm heat pump is running (power > 100W)
4. Review fluid property settings

## 🌍 Typical Register Addresses

These addresses work for most Chiltrix models but may vary:

| Register | Address (Hex) | Address (Dec) | Description |
|----------|---------------|---------------|-------------|
| Water Inlet Temp | 0xCA | 202 | Inlet temperature |
| Water Outlet Temp | 0xCB | 203 | Outlet temperature |
| Operating State | 0xF3 | 243 | Current mode |
| Current Power | 0x100 | 256 | Power consumption |
| Flow Rate | 0x101 | 257 | Water flow rate |

See `modbus.yaml` for complete register map.

## 💡 Example Values

### COP (Coefficient of Performance)
- Heating (mild): 3.5 - 5.0 (Excellent)
- Heating (cold): 2.5 - 3.5 (Good)
- Cooling: 3.0 - 5.0 (Good-Excellent)
- DHW: 2.5 - 4.0 (Good)

### Operating Costs (at $0.12/kWh, COP=3.5)
- Cost per hour: ~$0.30 - $0.60
- Cost per kWh thermal: ~$0.034
- Daily cost: ~$2.40 - $4.80
- Monthly cost: ~$72 - $144

## 🤝 Contributing

Contributions are welcome! If you have:
- Register address corrections for specific models
- Improvements to calculations
- Bug fixes
- Additional features

Please open an issue or pull request.

## 📜 License

MIT License - See [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This integration is not officially supported by Chiltrix. Use at your own risk. Always refer to official Chiltrix documentation for your specific model.

## 🙏 Credits

- Register definitions inspired by [gonzojive/heatpump](https://github.com/gonzojive/heatpump) (CX34 project)
- Based on Chiltrix CX34/CX35/CX50-2 Modbus implementations
- Uses pymodbus library for Modbus TCP communication

## 📞 Support

- 📫 Open an issue on GitHub
- 📖 Check the documentation files
- 🔍 Search existing issues for solutions

---

**Made with ❤️ for the Home Assistant and Chiltrix communities**
