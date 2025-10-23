#!/bin/bash

# Integration Script for Chiltrix Dashboard Files
# Adds all dashboard components to the homeassistant-chiltrix-modbus repository

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_DIR="homeassistant-chiltrix-modbus"

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Chiltrix Dashboard Integration Script                     ║${NC}"
echo -e "${BLUE}║   Adding Premium Dashboards to Repository                   ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if we're in the right directory
if [ ! -d "$REPO_DIR" ]; then
    echo -e "${RED}Error: $REPO_DIR directory not found!${NC}"
    echo -e "${YELLOW}Please run the setup_repository.sh script first, or navigate to the repo directory.${NC}"
    exit 1
fi

cd "$REPO_DIR"

# Create dashboards directory structure
echo -e "${YELLOW}Creating dashboard directory structure...${NC}"
mkdir -p dashboards
mkdir -p dashboards/controller_replica
mkdir -p scripts
mkdir -p docs

echo -e "${GREEN}✓ Directories created${NC}"

# Create placeholder files with instructions
echo -e "${YELLOW}Creating dashboard files...${NC}"

# Premium Dashboard
cat > dashboards/README.md << 'EOF'
# Chiltrix Dashboards

This directory contains multiple dashboard options for your Chiltrix heat pump.

## Available Dashboards

### 1. Premium Dashboard (Recommended)
**File:** `premium_dashboard.yaml`

Modern, beautiful interface with advanced features:
- Real-time COP monitoring with efficiency ratings
- Cost tracking and savings calculator
- Historical graphs (24-hour trends)
- 3 views: Home, Control, Analytics
- Beautiful gradients and animations

**Best for:** Desktop and tablet viewing, users who want maximum information

### 2. Controller Replica
**Files:** `controller_replica/` directory

Exact replica of the physical Chiltrix controller display:
- Main display matching physical controller
- Status, Settings, Mode, Error pages
- Familiar interface for existing users

**Best for:** Users who prefer the traditional controller look

## Installation

### Method 1: Via UI (Easiest)

1. Go to **Settings** → **Dashboards** → **+ Add Dashboard**
2. Name it "Chiltrix Heat Pump"
3. Edit Dashboard → Raw Configuration Editor
4. Copy content from desired dashboard YAML file
5. Save

### Method 2: Via Configuration File

Add to `configuration.yaml`:

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

## Required Custom Cards

Install via HACS → Frontend:

1. **button-card** - For beautiful custom buttons
2. **apexcharts-card** - For graphs and charts
3. **layout-card** - For advanced layouts

After installing, restart Home Assistant.

## Screenshots

See `/docs/screenshots/` for dashboard previews.

## Customization

All dashboards are fully customizable. See [DASHBOARD_README.md](../DASHBOARD_README.md) for customization guide.
EOF

# Controller Replica README
cat > dashboards/controller_replica/README.md << 'EOF'
# Controller Replica Dashboards

Exact replicas of the physical Chiltrix touchscreen controller.

## Files

- `main_display.yaml` - Main controller screen
- `status_page.yaml` - Status information page
- `settings_page.yaml` - Settings and temperature controls
- `mode_page.yaml` - Operating mode selection
- `error_page.yaml` - Error diagnostics and troubleshooting

## How to Use

### Create Separate Dashboard Views

Each YAML file represents a page/view. You can either:

**Option A: Single Dashboard with Multiple Views**
Combine all files into one dashboard with tabs

**Option B: Separate Dashboards**
Create individual dashboards for each page

### Navigation

Each page includes a "← Back" button that navigates to the main display.

Update navigation paths to match your setup:
```yaml
tap_action:
  action: navigate
  navigation_path: /lovelace/chiltrix-main
```

## Matching Physical Controller

The layouts match the physical controller shown in the CX50-2 manual:
- WiFi indicator (top left)
- Date/Time display (top right)
- Power indicator (top right, red circle)
- Message bar (black, below header)
- Side buttons (Status, Setting, Mode, Error)
- Main display area with temperatures
- Mode icons row
- Setpoint display
- Error codes (E1, E2)
EOF

# Create placeholder instruction files
cat > dashboards/premium_dashboard.yaml << 'EOF'
# Chiltrix Heat Pump - Premium Modern Dashboard
# 
# INSTALLATION INSTRUCTIONS:
# 1. Copy content from artifact "premium_dashboard.yaml - Modern Premium Interface"
# 2. Install required custom cards via HACS:
#    - button-card
#    - apexcharts-card
#    - layout-card
# 3. Restart Home Assistant
# 4. Add this dashboard via Settings → Dashboards
#
# See README.md in this directory for detailed instructions

# Copy the full dashboard configuration from the artifact here
EOF

cat > dashboards/controller_replica/main_display.yaml << 'EOF'
# Chiltrix Controller - Main Display Replica
#
# Copy content from artifact "controller_display.yaml - Physical Controller Replica Dashboard"
#
# This replicates the exact look of the physical Chiltrix controller
EOF

cat > dashboards/controller_replica/status_page.yaml << 'EOF'
# Chiltrix Controller - Status Page
#
# Copy content from artifact "status_page.yaml - Status Page View"
EOF

cat > dashboards/controller_replica/settings_page.yaml << 'EOF'
# Chiltrix Controller - Settings Page
#
# Copy content from artifact "settings_page.yaml - Settings Page with Controls"
EOF

cat > dashboards/controller_replica/mode_page.yaml << 'EOF'
# Chiltrix Controller - Mode Page
#
# Copy content from artifact "mode_page.yaml - Mode Selection Page"
EOF

cat > dashboards/controller_replica/error_page.yaml << 'EOF'
# Chiltrix Controller - Error Page
#
# Copy content from artifact "error_page.yaml - Error Diagnostics Page"
EOF

# Scripts directory
cat > scripts/README.md << 'EOF'
# Helper Scripts and Automations

This directory contains scripts for controlling your Chiltrix heat pump.

## Installation

Add to your `configuration.yaml`:

```yaml
script: !include scripts/automation_scripts.yaml
```

Then restart Home Assistant.

## Available Scripts

### Mode Control
- `script.cx_set_heating` - Switch to heating mode
- `script.cx_set_cooling` - Switch to cooling mode
- `script.cx_set_dhw` - Enable DHW priority mode
- `script.cx_set_auto` - Switch to auto mode

### Preset Modes
- `script.cx_eco_mode` - Eco mode (lower temps, silent)
- `script.cx_comfort_mode` - Comfort mode (balanced)
- `script.cx_boost_mode` - Boost mode (maximum heating)

### Maintenance
- `script.cx_power_cycle` - Restart the heat pump

## Usage

### Via Dashboard Buttons
The premium dashboard includes buttons that call these scripts automatically.

### Via Services
Call from automations or Developer Tools:
```yaml
service: script.cx_eco_mode
```

### Via Voice
Once configured with Alexa/Google:
- "Alexa, turn on eco mode"
- "Hey Google, set heat pump to comfort mode"

## Example Automations

See the `automation_scripts.yaml` file for example automations you can enable.
EOF

cat > scripts/automation_scripts.yaml << 'EOF'
# Chiltrix Automation Scripts
#
# Copy content from artifact "automation_scripts.yaml - Helper Scripts and Automations"
#
# Add to configuration.yaml:
# script: !include scripts/automation_scripts.yaml
EOF

# Documentation
cat > docs/INSTALLATION.md << 'EOF'
# Dashboard Installation Guide

## Quick Start (5 Minutes)

### 1. Install Custom Cards
```bash
# Via HACS:
HACS → Frontend → Search and install:
- button-card
- apexcharts-card  
- layout-card

# Restart Home Assistant
```

### 2. Choose Your Dashboard

**Option A: Premium Modern Dashboard** (Recommended)
- Navigate to `/dashboards/premium_dashboard.yaml`
- Copy content from corresponding artifact
- Paste into file
- Follow UI installation method below

**Option B: Controller Replica**
- Navigate to `/dashboards/controller_replica/`
- Copy content for each page from artifacts
- Create multi-view dashboard

### 3. Add to Home Assistant

**Via UI (Recommended):**
1. Settings → Dashboards → + Add Dashboard
2. Name: "Chiltrix Heat Pump"
3. Edit Dashboard → Raw Configuration Editor
4. Paste YAML content
5. Save

**Via YAML:**
```yaml
# configuration.yaml
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

### 4. Install Scripts (Optional)

```yaml
# configuration.yaml
script: !include scripts/automation_scripts.yaml
```

Restart Home Assistant.

## Detailed Instructions

See [DASHBOARD_README.md](../DASHBOARD_README.md) for complete documentation.

## Troubleshooting

### "Custom element doesn't exist"
- Install missing custom card via HACS
- Restart Home Assistant
- Clear browser cache

### Sensors show "unavailable"
- Verify modbus.yaml is loaded
- Check entity IDs match your configuration
- Some sensors may not exist for your model (safe to remove)

### Graphs don't show
- Ensure apexcharts-card is installed
- Check sensors have state_class: measurement
- Wait 24 hours for data to accumulate

## Support

- GitHub Issues: https://github.com/jasipsw/homeassistant-chiltrix-modbus/issues
- Home Assistant Community: community.home-assistant.io
EOF

cat > docs/CUSTOMIZATION.md << 'EOF'
# Dashboard Customization Guide

## Changing Colors

Edit gradient backgrounds:
```yaml
styles:
  card:
    - background: 'linear-gradient(135deg, #COLOR1 0%, #COLOR2 100%)'
```

### Color Palettes

**Heating (Red):**
- `#FF6B6B, #C92A2A` - Warm red
- `#F03E3E, #C92A2A` - Bright red

**Cooling (Blue):**
- `#4ECDC4, #1A535C` - Teal blue
- `#74C0FC, #339AF0` - Sky blue

**DHW (Yellow):**
- `#FFD93D, #F6A623` - Golden yellow
- `#FCC419, #FAB005` - Bright yellow

**Success (Green):**
- `#51CF66, #37B24D` - Fresh green
- `#8CE99A, #51CF66` - Light green

**Error (Red):**
- `#FA5252, #C92A2A` - Alert red
- `#FF6B6B, #E03131` - Warning red

## Adjusting Layout

### Grid Columns
```yaml
layout:
  grid-template-columns: 1fr 1fr 1fr  # 3 equal columns
  grid-template-columns: 2fr 1fr      # 2:1 ratio
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr))  # Responsive
```

### Card Sizes
```yaml
styles:
  card:
    - height: 150px  # Fixed height
    - min-height: 100px  # Minimum height
    - padding: 20px  # Internal spacing
```

## Adding New Cards

Insert anywhere in the view:
```yaml
- type: entities
  title: My Custom Section
  entities:
    - sensor.cx_my_sensor
    - sensor.cx_another_sensor
```

## Removing Unwanted Features

### Remove a View
Delete entire view section from dashboard

### Remove a Card
Comment out or delete the card section:
```yaml
# - type: entities
#   title: Unused Card
#   entities:
#     - sensor.something
```

### Hide Specific Sensors
```yaml
entities:
  - sensor.cx_important_sensor
  # - sensor.cx_unused_sensor  # Commented out
```

## Mobile Optimization

### Adjust for Small Screens
```yaml
# Use fewer columns on mobile
layout:
  grid-template-columns: 1fr  # Single column
  
# Smaller text
styles:
  name:
    - font-size: 14px  # Reduce from 24px
```

### Add Mobile-Only Cards
```yaml
- type: conditional
  conditions:
    - condition: screen
      media_query: '(max-width: 768px)'
  card:
    # Your mobile-specific card
```

## Advanced Customizations

### Custom Templates
Use Jinja2 templates for dynamic content:
```yaml
content: |
  {% if states('sensor.cx_cop')|float > 4.0 %}
    ⭐ Excellent Performance
  {% else %}
    ○ Normal Operation
  {% endif %}
```

### Conditional Styling
Change appearance based on values:
```yaml
state:
  - value: 'on'
    styles:
      card:
        - background: green
  - value: 'off'
    styles:
      card:
        - background: gray
```

### Animations
```yaml
styles:
  icon:
    - animation: 'pulse 2s ease infinite'
  card:
    - animation: 'blink 1s ease infinite'
```

## Examples

See [examples/](../examples/) directory for complete customization examples.
EOF

# Create screenshots directory
mkdir -p docs/screenshots
cat > docs/screenshots/README.md << 'EOF'
# Dashboard Screenshots

Add screenshots of your dashboards here to help others visualize the interface.

## Recommended Screenshots

1. **Premium Dashboard - Home View**
   - Shows main status, COP, temperatures
   - Filename: `premium_home_view.png`

2. **Premium Dashboard - Control View**
   - Temperature controls and mode selection
   - Filename: `premium_control_view.png`

3. **Premium Dashboard - Analytics View**
   - Graphs and cost tracking
   - Filename: `premium_analytics_view.png`

4. **Controller Replica - Main Display**
   - Physical controller lookalike
   - Filename: `controller_main.png`

5. **Mobile View**
   - Dashboard on phone
   - Filename: `mobile_view.png`

## How to Add Screenshots

1. Take screenshots of your dashboards
2. Resize to reasonable size (1920x1080 or similar)
3. Add to this directory
4. Update main README.md with image links
EOF

# Update main README.md
cat >> README.md << 'EOF'

## 📱 Premium Dashboards

This repository now includes **advanced dashboard interfaces** that are far superior to the physical controller!

### Dashboard Options

#### 1. Premium Modern Dashboard ⭐ (Recommended)
**Location:** `/dashboards/premium_dashboard.yaml`

A beautiful, modern interface with:
- ✅ **Real-time COP monitoring** with efficiency ratings (⭐ Excellent, ✓ Good, etc.)
- ✅ **Cost tracking** - See operating costs per hour, day, month
- ✅ **Savings calculator** - Compare vs gas, oil, propane, electric resistance
- ✅ **Historical graphs** - 24-hour COP, temperature, and power trends
- ✅ **Smart controls** - Eco, Comfort, Boost preset modes
- ✅ **3 views** - Home (status), Control (adjust temps), Analytics (graphs & costs)

**Requirements:**
- Custom cards: `button-card`, `apexcharts-card`, `layout-card` (via HACS)

#### 2. Controller Replica
**Location:** `/dashboards/controller_replica/`

Exact replica of the physical Chiltrix touchscreen controller:
- Main display matching physical controller layout
- Status, Settings, Mode, Error pages
- Familiar interface for users who prefer traditional look

### Why Use These Dashboards?

| Feature | Physical Controller | Premium Dashboard |
|---------|---------------------|-------------------|
| Display Size | 7" LCD | Full screen |
| Historical Data | ❌ None | ✅ 24-hour trends |
| Cost Tracking | ❌ None | ✅ Real-time + projections |
| COP Monitoring | ❌ None | ✅ With efficiency ratings |
| Remote Access | ❌ None | ✅ Anywhere via HA app |
| Customization | ❌ Fixed | ✅ Fully customizable |
| Voice Control | ❌ None | ✅ Alexa/Google/Siri |
| Smart Features | ❌ Basic | ✅ Automations & alerts |

### Quick Installation

```bash
# 1. Install required custom cards via HACS
HACS → Frontend → Install:
- button-card
- apexcharts-card
- layout-card

# 2. Add dashboard in Home Assistant
Settings → Dashboards → Add Dashboard → Raw Config Editor
# Paste content from premium_dashboard.yaml

# 3. Restart Home Assistant
```

### Documentation

- **[Dashboard Installation Guide](docs/INSTALLATION.md)** - Step-by-step setup
- **[Dashboard README](DASHBOARD_README.md)** - Complete feature documentation
- **[Customization Guide](docs/CUSTOMIZATION.md)** - How to customize colors, layout, cards
- **[Helper Scripts](scripts/README.md)** - Automation scripts for control

### Screenshots

See `/docs/screenshots/` for dashboard previews (add your own screenshots!).

### Features Included

**Premium Dashboard Features:**
- 💰 Real-time operating cost calculation
- 📊 COP performance tracking with ratings
- 💵 Multi-fuel cost comparison (gas/oil/propane)
- 📈 Temperature and power history graphs
- ⚡ Animated status indicators
- 🎨 Beautiful gradients and modern design
- 📱 Mobile-responsive layout
- 🎤 Voice control ready

**Helper Scripts:**
- Mode control (heating, cooling, DHW, auto)
- Preset modes (eco, comfort, boost)
- System maintenance (power cycle)
- Smart automations (peak hour optimization, error alerts, daily reports)

### Community

Share your customizations! We'd love to see:
- Screenshots of your dashboard setup
- Custom color schemes
- Unique automations
- Mobile layouts

Open an issue or pull request to contribute!

---
EOF

echo -e "${GREEN}✓ Dashboard structure created${NC}"

# Create file listing
cat > DASHBOARD_FILES.txt << 'EOF'
Dashboard Files Added to Repository
====================================

Core Configuration (already present):
- modbus.yaml
- cop_sensors.yaml
- cost_sensors.yaml
- fluid_helpers.yaml
- cost_helpers.yaml
- customize.yaml

New Dashboard Files:
- dashboards/premium_dashboard.yaml
- dashboards/controller_replica/main_display.yaml
- dashboards/controller_replica/status_page.yaml
- dashboards/controller_replica/settings_page.yaml
- dashboards/controller_replica/mode_page.yaml
- dashboards/controller_replica/error_page.yaml

Scripts:
- scripts/automation_scripts.yaml

Documentation:
- DASHBOARD_README.md
- docs/INSTALLATION.md
- docs/CUSTOMIZATION.md

Instructions:
Each placeholder YAML file includes a comment indicating which artifact
to copy content from. Search for the artifact name and paste the full
content into the corresponding file.

Next Steps:
1. Copy artifact content into placeholder files
2. Commit changes to git
3. Push to GitHub
4. Users can then clone and use immediately!
EOF

echo -e "${GREEN}✓ All files created${NC}"
echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                Integration Complete!                         ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Dashboard structure added to repository!${NC}"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANT: Manual steps required:${NC}"
echo -e ""
echo -e "1. Copy content from Claude artifacts into placeholder files:"
echo -e "   - dashboards/premium_dashboard.yaml"
echo -e "   - dashboards/controller_replica/*.yaml"
echo -e "   - scripts/automation_scripts.yaml"
echo -e ""
echo -e "2. Copy DASHBOARD_README.md content from artifact"
echo -e ""
echo -e "3. Review and commit changes:"
echo -e "   ${BLUE}git add .${NC}"
echo -e "   ${BLUE}git commit -m 'Add premium dashboards and controller replica'${NC}"
echo -e "   ${BLUE}git push origin main${NC}"
echo -e ""
echo -e "${GREEN}See DASHBOARD_FILES.txt for complete file listing${NC}"
echo ""