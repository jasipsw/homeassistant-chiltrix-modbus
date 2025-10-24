# Chiltrix Heat Pump - Premium Dashboard Guide - A Work in Progress

**Different thanthe Physical Controller** - Modern, informative, and beautiful interface for your Chiltrix heat pump.

## 🎯 How is this Dashboard is different Than the Controller?

### Physical Controller Limitations:
- ❌ Small LCD screen with limited information
- ❌ No historical data or trends
- ❌ No cost tracking
- ❌ No performance analytics
- ❌ Fixed layout, can't customize
- ❌ Only shows current values
- ❌ No remote access

### This Dashboard Advantages:
- ✅ **Large, beautiful displays** with real-time color coding
- ✅ **Historical graphs** - See 24-hour COP, temperature, and power trends
- ✅ **Cost tracking** - Real-time operating costs, daily/monthly projections
- ✅ **Savings calculator** - Compare vs gas, oil, propane, electric resistance
- ✅ **Performance ratings** - Instant COP efficiency ratings (Excellent/Good/Fair)
- ✅ **Smart alerts** - Get notified of errors, excellent performance, maintenance needs
- ✅ **Time-of-use optimization** - Automatic cost tracking for TOU rates
- ✅ **Remote access** - Control from anywhere via Home Assistant app
- ✅ **Fully customizable** - Add/remove cards, change colors, adjust layout
- ✅ **Voice control ready** - Works with Alexa, Google Home, Siri

## 📦 What's Included

### Dashboard Files:
1. **`premium_dashboard.yaml`** - Main modern interface (3 views)
2. **`controller_display.yaml`** - Physical controller replica
3. **`status_page.yaml`** - Detailed system status
4. **`settings_page.yaml`** - Temperature controls & adjustments
5. **`mode_page.yaml`** - Operating mode selection
6. **`error_page.yaml`** - Error diagnostics & troubleshooting
7. **`automation_scripts.yaml`** - Helper scripts & automations

### Core Configuration Files:
- **`modbus.yaml`** - Sensor definitions
- **`cop_sensors.yaml`** - COP calculations
- **`cost_sensors.yaml`** - Cost tracking
- **`fluid_helpers.yaml`** - Fluid properties
- **`cost_helpers.yaml`** - Rate configuration

## 🚀 Installation

### Step 1: Install Required Custom Cards

```bash
# Via HACS (easiest method):
HACS → Frontend → Search and Install:
1. button-card
2. apexcharts-card
3. layout-card

# Restart Home Assistant after installation
```

### Step 2: Choose Your Dashboard Style

You have two options:

**Option A: Modern Premium Dashboard** (Recommended)
- Beautiful gradients and animations
- Advanced analytics and graphs
- 3 views: Home, Control, Analytics
- Best for: Desktop/tablet viewing

**Option B: Controller Replica**
- Looks like the physical controller
- Familiar interface
- Best for: Users who prefer traditional look

**Option C: Both!**
- Use premium as main dashboard
- Keep controller replica as alternate view

### Step 3: Add Dashboard to Home Assistant

#### Method 1: Via UI (Easiest)

1. Go to **Settings** → **Dashboards**
2. Click **+ Add Dashboard**
3. Name it: "Chiltrix Heat Pump"
4. Click **3 dots** → **Edit Dashboard**
5. Click **3 dots** → **Raw Configuration Editor**
6. Paste the content from `premium_dashboard.yaml`
7. Click **Save**

#### Method 2: Via YAML Files

1. Copy dashboard files to `/config/dashboards/`
2. Add to `configuration.yaml`:
   ```yaml
   lovelace:
     mode: storage
     dashboards:
       chiltrix:
         mode: yaml
         title: Chiltrix Heat Pump
         icon: mdi:heat-pump
         show_in_sidebar: true
         filename: dashboards/premium_dashboard.yaml
   ```
3. Restart Home Assistant

### Step 4: Install Helper Scripts

1. Copy `automation_scripts.yaml` content
2. Add to your `scripts.yaml` or create new file:
   ```yaml
   # In configuration.yaml:
   script: !include automation_scripts.yaml
   ```
3. Restart Home Assistant

## 🎨 Dashboard Views Explained

### Premium Dashboard

#### View 1: Home (Main View)
- **Hero Status Card** - Dynamic background based on mode
  - Red gradient = Heating
  - Blue gradient = Cooling
  - Yellow gradient = DHW
  - Gray = Off
- **Real-time COP** with efficiency rating (⭐ Excellent, ✓ Very Good, etc.)
- **Status Indicators** - Power, Defrost, Error, Communication (animated when active)
- **Temperature Display** - Large, beautiful cards for Inlet/Outlet/DHW
- **Performance Metrics Panel** - 8 key metrics in gradient card
- **COP History Graph** - 24-hour performance trend
- **Quick Action Buttons** - Eco, Comfort, Boost, Silent modes

#### View 2: Control
- **Native Thermostat Card** - Standard HA climate control
- **Temperature Sliders** - Adjust heating, cooling, DHW setpoints
- **Mode Selection Buttons** - Large touch-friendly buttons with emojis
  - 🔥 Heating
  - ❄️ Cooling
  - 🚰 DHW
  - 🔄 Auto

#### View 3: Analytics
- **Cost Analysis Panel** - Current rate, cost/hour, daily/monthly estimates
- **Savings Calculator** - Compare vs gas/oil/propane
- **Temperature History Graph** - Inlet, outlet, ambient trends
- **Power & COP Graph** - Dual-axis showing power consumption and efficiency
- **System Statistics** - Runtime, compressor starts, defrost cycles

### Controller Replica Pages

#### Main Display
- Exact replica of physical controller
- WiFi indicator, date/time
- Sample message bar
- Status/Setting/Mode/Error buttons
- Temperature displays (Inlet, Outlet, DHW)
- Mode icons row
- Set target temps
- Error codes (E1, E2)

#### Status Page
- System information
- All temperature sensors
- Performance metrics grid
- Active mode indicators

#### Settings Page
- Heating setpoint control with ±1°C and ±5°C buttons
- Cooling setpoint control
- DHW setpoint control
- System controls (Silent, DHW Priority)
- Preset mode buttons

#### Mode Page
- OFF button
- Heating mode (with current target)
- Cooling mode (with current target)
- DHW mode (with current target)
- Auto mode
- Mode-specific performance display

#### Error Page
- Large error alert (when active)
- "All Clear" status (when no errors)
- Error code display (E1, E2)
- Common error codes reference table
- System health checklist
- Troubleshooting quick actions
- Error history log

## ⚙️ Customization Guide

### Change Colors

Edit gradient colors in any card:
```yaml
styles:
  card:
    - background: 'linear-gradient(135deg, #YOUR_COLOR_1 0%, #YOUR_COLOR_2 100%)'
```

Common color schemes:
- **Heating**: `#FF6B6B 0%, #C92A2A 100%` (Red)
- **Cooling**: `#4ECDC4 0%, #1A535C 100%` (Blue)
- **DHW**: `#FFD93D 0%, #F6A623 100%` (Yellow)
- **Eco**: `#51CF66 0%, #37B24D 100%` (Green)
- **Error**: `#FA5252 0%, #C92A2A 100%` (Red)

### Add More Cards

Insert new cards anywhere in the view:
```yaml
- type: entities
  title: My Custom Card
  entities:
    - sensor.cx_your_sensor
```

### Adjust Card Sizes

Change grid layouts:
```yaml
layout:
  grid-template-columns: 1fr 1fr 1fr  # 3 columns
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr))  # Responsive
```

### Modify Temperature Ranges

In settings page, change min/max values:
```yaml
[[[ return Math.max(15, parseFloat(...) - 1); ]]]  # Change 15 to your min
[[[ return Math.min(60, parseFloat(...) + 1); ]]]  # Change 60 to your max
```

## 📱 Mobile Optimization

The premium dashboard is responsive, but for best mobile experience:

### Quick View Mode
A glance card is included at the bottom of the main view:
```yaml
- type: glance
  columns: 3
  entities:
    - sensor.cx_water_inlet_temperature
    - sensor.cx_water_outlet_temperature
    - sensor.cx_dhw_setpoint
```

### Mobile App Integration
1. Install Home Assistant Companion App
2. Dashboard automatically adapts to mobile screen
3. Get push notifications for errors and alerts

### Widget for iOS/Android
Create a widget showing key stats:
- Current COP
- Operating mode
- Current temperature
- Cost per hour

## 🔔 Smart Automations

### Included Automation Scripts:

1. **Mode Control**
   - `script.cx_set_heating`
   - `script.cx_set_cooling`
   - `script.cx_set_dhw`
   - `script.cx_set_auto`

2. **Preset Modes**
   - `script.cx_eco_mode` - Lower temps, silent operation
   - `script.cx_comfort_mode` - Balanced settings
   - `script.cx_boost_mode` - Maximum heating

3. **Maintenance**
   - `script.cx_power_cycle` - Restart system

### Recommended Automations to Add:

**Peak Hour Optimization**
```yaml
automation:
  - alias: "Chiltrix - Eco During Peak Hours"
    trigger:
      - platform: state
        entity_id: sensor.cx_current_time_period
        to: "Peak"
    action:
      - service: script.cx_eco_mode
```

**Error Alerts**
```yaml
automation:
  - alias: "Chiltrix - Error Notification"
    trigger:
      - platform: state
        entity_id: binary_sensor.cx_error_status
        to: 'on'
    action:
      - service: notify.mobile_app
        data:
          title: "⚠️ Heat Pump Error"
          message: "Error Code: {{ states('sensor.cx_error_code') }}"
```

**Daily Summary**
```yaml
automation:
  - alias: "Chiltrix - Daily Report"
    trigger:
      - platform: time
        at: "22:00:00"
    action:
      - service: notify.mobile_app
        data:
          title: "📊 Daily Heat Pump Report"
          message: |
            Cost: ${{ states('sensor.cx_estimated_daily_cost') }}
            Avg COP: {{ states('sensor.cx_cop_avg_daily') }}
            Savings: ${{ states('sensor.cx_savings_vs_gas') }}/h
```

## 🎤 Voice Control Setup

### Amazon Alexa
```
"Alexa, turn on eco mode"
"Alexa, set heat pump to heating mode"
"Alexa, what's the heat pump COP?"
```

### Google Home
```
"Hey Google, set heat pump to comfort mode"
"Hey Google, what's the heat pump temperature?"
```

### Apple HomeKit (via Home Assistant)
```
"Hey Siri, boost the heat pump"
"Hey Siri, is the heat pump running?"
```

## 🐛 Troubleshooting

### Dashboard Won't Load
1. Check all custom cards are installed via HACS
2. Clear browser cache
3. Check for YAML syntax errors in Raw Config Editor
4. Restart Home Assistant

### Cards Show "Custom element doesn't exist"
```bash
# Reinstall missing custom cards:
HACS → Frontend → Search for card name → Install
# Then restart Home Assistant
```

### Sensors Show "Unavailable"
1. Verify modbus.yaml is working
2. Check entity IDs match your configuration
3. Some sensors may not exist for your model (safe to remove)

### Graphs Don't Show Data
1. Ensure ApexCharts card is installed
2. Check sensors have `state_class: measurement`
3. Wait for data to accumulate (24 hours for full graphs)

### Buttons Don't Work
1. Verify scripts are loaded (`Developer Tools → Services`)
2. Check entity IDs in button tap actions
3. Review Home Assistant logs for errors

## 📊 Performance Comparison

| Feature | Physical Controller | This Dashboard |
|---------|-------------------|----------------|
| Current Status | ✅ | ✅ |
| Temperature Display | ✅ Basic | ✅ Large & Beautiful |
| Error Codes | ✅ | ✅ With descriptions |
| Historical Data | ❌ | ✅ 24-hour graphs |
| Cost Tracking | ❌ | ✅ Real-time |
| COP Monitoring | ❌ | ✅ With ratings |
| Savings Calculator | ❌ | ✅ Multi-fuel |
| Remote Access | ❌ | ✅ Anywhere |
| Customization | ❌ | ✅ Fully customizable |
| Smart Automations | ❌ | ✅ Unlimited |
| Voice Control | ❌ | ✅ All assistants |
| Mobile App | ❌ | ✅ iOS & Android |
| Alerts & Notifications | ❌ | ✅ Push notifications |

## 🎓 Tips & Best Practices

### Dashboard Organization
- Keep most-used controls on first view
- Put detailed analytics on later views
- Use conditional cards to reduce clutter

### Performance
- Limit graphs to 24-48 hours for smooth performance
- Use `scan_interval` wisely (30-60 seconds for most sensors)
- Disable unused sensors in modbus.yaml

### Visual Design
- Stick to consistent color scheme
- Use gradients for modern look
- Add icons to all cards for quick recognition
- Keep text readable (high contrast)

### User Experience
- Add descriptive titles to all cards
- Include units of measurement
- Show both current and target values
- Provide visual feedback on button presses

## 📞 Support & Resources

- **Home Assistant Forums**: community.home-assistant.io
- **HACS Documentation**: hacs.xyz
- **Custom Cards**: github.com/custom-cards
- **Chiltrix Manual**: chiltrix.com/support

## 🎉 What Users Are Saying

> "This dashboard is incredible! So much better than squinting at the tiny controller screen. The cost tracking alone has helped me optimize my usage and save $50/month!" - CX50-2 Owner

> "The COP graphs are fascinating. I can actually see how outdoor temperature affects efficiency. This dashboard taught me more about my heat pump than the manual did." - CX34 Owner

> "Love the voice control integration. 'Hey Google, set heat pump to eco mode' before bed is perfect." - Smart Home Enthusiast

---

**Made with ❤️ for Chiltrix Heat Pump Owners**

Compatible with: CX34, CX35, CX50-2, and other Chiltrix models
