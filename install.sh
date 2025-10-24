#!/bin/bash

# Chiltrix Home Assistant Installer
# Version 1.0.0

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"
}

# Check if running on Home Assistant OS
check_environment() {
    if [ ! -d "/config" ]; then
        print_error "Home Assistant config directory not found at /config"
        print_info "Are you running this from Home Assistant? You may need to adjust the CONFIG_DIR variable."
        read -p "Enter your Home Assistant config directory path [/config]: " CONFIG_DIR
        CONFIG_DIR=${CONFIG_DIR:-/config}
        
        if [ ! -d "$CONFIG_DIR" ]; then
            print_error "Directory $CONFIG_DIR does not exist. Exiting."
            exit 1
        fi
    else
        CONFIG_DIR="/config"
    fi
}

# Welcome screen
show_welcome() {
    clear
    print_header "Chiltrix Heat Pump - Home Assistant Installer"
    echo "This installer will set up Modbus integration, sensors, and dashboards"
    echo "for your Chiltrix heat pump (CX34, CX35, CX50-2, etc.)"
    echo ""
    echo "What this installer does:"
    echo "  • Creates backup of existing files"
    echo "  • Installs Modbus configuration"
    echo "  • Installs COP and cost tracking sensors"
    echo "  • Installs beautiful dashboards"
    echo "  • Configures scripts and automations"
    echo ""
    read -p "Press Enter to continue or Ctrl+C to cancel..."
}

# Collect user configuration
collect_config() {
    print_header "Configuration Setup"
    
    # Modbus Connection
    echo -e "${BLUE}Modbus Connection Settings:${NC}"
    read -p "Enter your Chiltrix IP address [192.168.1.100]: " CHILTRIX_IP
    CHILTRIX_IP=${CHILTRIX_IP:-192.168.1.100}
    
    read -p "Enter Modbus port [502]: " MODBUS_PORT
    MODBUS_PORT=${MODBUS_PORT:-502}
    
    read -p "Enter slave ID [1]: " SLAVE_ID
    SLAVE_ID=${SLAVE_ID:-1}
    
    # Cost Settings
    echo -e "\n${BLUE}Electricity Cost Settings (for cost tracking):${NC}"
    read -p "Enter your electricity rate ($/kWh) [0.15]: " ELECTRIC_RATE
    ELECTRIC_RATE=${ELECTRIC_RATE:-0.15}
    
    # Time of Use (optional)
    read -p "Do you have time-of-use (TOU) electricity rates? [y/N]: " HAS_TOU
    HAS_TOU=${HAS_TOU:-n}
    
    if [[ "$HAS_TOU" =~ ^[Yy]$ ]]; then
        read -p "Enter peak rate ($/kWh) [0.25]: " PEAK_RATE
        PEAK_RATE=${PEAK_RATE:-0.25}
        
        read -p "Enter off-peak rate ($/kWh) [0.10]: " OFFPEAK_RATE
        OFFPEAK_RATE=${OFFPEAK_RATE:-0.10}
        
        read -p "Enter peak hours start (24h format, e.g., 14 for 2pm) [14]: " PEAK_START
        PEAK_START=${PEAK_START:-14}
        
        read -p "Enter peak hours end (24h format, e.g., 20 for 8pm) [20]: " PEAK_END
        PEAK_END=${PEAK_END:-20}
    fi
    
    # Dashboard preference
    echo -e "\n${BLUE}Dashboard Selection:${NC}"
    echo "1) Premium Dashboard (Modern, gradients, analytics) - Recommended"
    echo "2) Controller Replica (Looks like physical controller)"
    echo "3) Both (Premium as main, Controller as alternate)"
    read -p "Select dashboard option [3]: " DASHBOARD_OPTION
    DASHBOARD_OPTION=${DASHBOARD_OPTION:-3}
    
    # Confirm settings
    echo -e "\n${YELLOW}Please confirm your settings:${NC}"
    echo "  IP Address: $CHILTRIX_IP"
    echo "  Port: $MODBUS_PORT"
    echo "  Slave ID: $SLAVE_ID"
    echo "  Electric Rate: \$$ELECTRIC_RATE/kWh"
    if [[ "$HAS_TOU" =~ ^[Yy]$ ]]; then
        echo "  TOU Peak Rate: \$$PEAK_RATE/kWh (${PEAK_START}:00-${PEAK_END}:00)"
        echo "  TOU Off-Peak Rate: \$$OFFPEAK_RATE/kWh"
    fi
    echo ""
    read -p "Is this correct? [Y/n]: " CONFIRM
    CONFIRM=${CONFIRM:-y}
    
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        print_warning "Setup cancelled. Please run the installer again."
        exit 0
    fi
}

# Create backup
create_backup() {
    print_header "Creating Backup"
    
    BACKUP_DIR="$CONFIG_DIR/chiltrix_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup existing files if they exist
    [ -f "$CONFIG_DIR/modbus.yaml" ] && cp "$CONFIG_DIR/modbus.yaml" "$BACKUP_DIR/" && print_success "Backed up modbus.yaml"
    [ -f "$CONFIG_DIR/cop_sensors.yaml" ] && cp "$CONFIG_DIR/cop_sensors.yaml" "$BACKUP_DIR/" && print_success "Backed up cop_sensors.yaml"
    [ -f "$CONFIG_DIR/cost_sensors.yaml" ] && cp "$CONFIG_DIR/cost_sensors.yaml" "$BACKUP_DIR/" && print_success "Backed up cost_sensors.yaml"
    [ -f "$CONFIG_DIR/scripts.yaml" ] && cp "$CONFIG_DIR/scripts.yaml" "$BACKUP_DIR/" && print_success "Backed up scripts.yaml"
    
    print_success "Backup created at: $BACKUP_DIR"
}

# Create directories
create_directories() {
    print_header "Creating Directories"
    
    mkdir -p "$CONFIG_DIR/dashboards"
    mkdir -p "$CONFIG_DIR/packages/chiltrix"
    
    print_success "Created required directories"
}

# Install configuration files
install_configs() {
    print_header "Installing Configuration Files"
    
    # Copy and customize modbus.yaml
    sed -e "s/192.168.1.100/$CHILTRIX_IP/g" \
        -e "s/port: 502/port: $MODBUS_PORT/g" \
        -e "s/slave: 1/slave: $SLAVE_ID/g" \
        "modbus.yaml" > "$CONFIG_DIR/modbus.yaml"
    print_success "Installed modbus.yaml"
    
    # Copy sensor files
    cp "cop_sensors.yaml" "$CONFIG_DIR/cop_sensors.yaml"
    print_success "Installed cop_sensors.yaml"
    
    # Customize and copy cost sensors
    sed -e "s/0.15/$ELECTRIC_RATE/g" \
        "cost_sensors.yaml" > "$CONFIG_DIR/cost_sensors.yaml"
    print_success "Installed cost_sensors.yaml"
    
    # Copy helper files
    cp "fluid_helpers.yaml" "$CONFIG_DIR/fluid_helpers.yaml"
    print_success "Installed fluid_helpers.yaml"
    
    cp "cost_helpers.yaml" "$CONFIG_DIR/cost_helpers.yaml"
    print_success "Installed cost_helpers.yaml"
    
    # Handle TOU configuration if enabled
    if [[ "$HAS_TOU" =~ ^[Yy]$ ]]; then
        # Create/update TOU sensor
        cat >> "$CONFIG_DIR/cost_helpers.yaml" << EOF

# Time of Use Rate Configuration
- sensor:
  - name: "Chiltrix Current Rate"
    unique_id: cx_current_rate
    unit_of_measurement: "USD/kWh"
    state: >
      {% set h = now().hour %}
      {% if $PEAK_START <= h < $PEAK_END %}
        $PEAK_RATE
      {% else %}
        $OFFPEAK_RATE
      {% endif %}
  
  - name: "Chiltrix Current Time Period"
    unique_id: cx_time_period
    state: >
      {% set h = now().hour %}
      {% if $PEAK_START <= h < $PEAK_END %}
        Peak
      {% else %}
        Off-Peak
      {% endif %}
EOF
        print_success "Installed TOU configuration"
    fi
}

# Install dashboards
install_dashboards() {
    print_header "Installing Dashboards"
    
    case $DASHBOARD_OPTION in
        1)
            cp "premium_dashboard.yaml" "$CONFIG_DIR/dashboards/chiltrix_dashboard.yaml"
            print_success "Installed Premium Dashboard"
            ;;
        2)
            cp "controller_display.yaml" "$CONFIG_DIR/dashboards/chiltrix_dashboard.yaml"
            print_success "Installed Controller Replica Dashboard"
            ;;
        3)
            cp "premium_dashboard.yaml" "$CONFIG_DIR/dashboards/chiltrix_premium.yaml"
            cp "controller_display.yaml" "$CONFIG_DIR/dashboards/chiltrix_controller.yaml"
            print_success "Installed both dashboards"
            ;;
    esac
    
    # Copy additional dashboard pages
    cp "status_page.yaml" "$CONFIG_DIR/dashboards/chiltrix_status.yaml" 2>/dev/null && print_success "Installed status page" || true
    cp "settings_page.yaml" "$CONFIG_DIR/dashboards/chiltrix_settings.yaml" 2>/dev/null && print_success "Installed settings page" || true
    cp "mode_page.yaml" "$CONFIG_DIR/dashboards/chiltrix_mode.yaml" 2>/dev/null && print_success "Installed mode page" || true
    cp "error_page.yaml" "$CONFIG_DIR/dashboards/chiltrix_error.yaml" 2>/dev/null && print_success "Installed error page" || true
}

# Install scripts
install_scripts() {
    print_header "Installing Scripts & Automations"
    
    if [ -f "$CONFIG_DIR/scripts.yaml" ]; then
        print_warning "scripts.yaml already exists"
        read -p "Append Chiltrix scripts to existing file? [Y/n]: " APPEND_SCRIPTS
        APPEND_SCRIPTS=${APPEND_SCRIPTS:-y}
        
        if [[ "$APPEND_SCRIPTS" =~ ^[Yy]$ ]]; then
            echo "" >> "$CONFIG_DIR/scripts.yaml"
            echo "# Chiltrix Heat Pump Scripts" >> "$CONFIG_DIR/scripts.yaml"
            cat "automation_scripts.yaml" >> "$CONFIG_DIR/scripts.yaml"
            print_success "Appended scripts to scripts.yaml"
        else
            cp "automation_scripts.yaml" "$CONFIG_DIR/chiltrix_scripts.yaml"
            print_warning "Installed as chiltrix_scripts.yaml - Add 'script: !include chiltrix_scripts.yaml' to configuration.yaml"
        fi
    else
        cp "automation_scripts.yaml" "$CONFIG_DIR/scripts.yaml"
        print_success "Installed scripts.yaml"
    fi
}

# Update configuration.yaml
update_configuration_yaml() {
    print_header "Updating configuration.yaml"
    
    CONFIG_FILE="$CONFIG_DIR/configuration.yaml"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        print_error "configuration.yaml not found!"
        return
    fi
    
    # Create backup
    cp "$CONFIG_FILE" "$CONFIG_FILE.backup"
    
    # Check if includes already exist
    NEEDS_MODBUS=true
    NEEDS_SENSOR=true
    NEEDS_SCRIPT=true
    NEEDS_LOVELACE=true
    
    grep -q "modbus: !include modbus.yaml" "$CONFIG_FILE" && NEEDS_MODBUS=false
    grep -q "sensor: !include" "$CONFIG_FILE" && NEEDS_SENSOR=false
    grep -q "script: !include" "$CONFIG_FILE" && NEEDS_SCRIPT=false
    grep -q "lovelace:" "$CONFIG_FILE" && NEEDS_LOVELACE=false
    
    # Add required includes
    ADDITIONS=""
    
    if [ "$NEEDS_MODBUS" = true ]; then
        ADDITIONS="${ADDITIONS}\n# Chiltrix Modbus Configuration\nmodbus: !include modbus.yaml\n"
        print_success "Added modbus include"
    fi
    
    if [ "$NEEDS_SENSOR" = true ]; then
        ADDITIONS="${ADDITIONS}\n# Chiltrix Sensors\nsensor: !include cop_sensors.yaml\n"
        print_success "Added sensor include"
    else
        print_warning "Sensor includes already exist - manually add '!include cop_sensors.yaml'"
    fi
    
    if [ "$NEEDS_SCRIPT" = true ]; then
        ADDITIONS="${ADDITIONS}\n# Chiltrix Scripts\nscript: !include scripts.yaml\n"
        print_success "Added script include"
    else
        print_warning "Script includes already exist - verify scripts are loaded"
    fi
    
    if [ "$NEEDS_LOVELACE" = true ]; then
        ADDITIONS="${ADDITIONS}\n# Chiltrix Dashboards\nlovelace:\n  mode: storage\n  dashboards:\n    chiltrix:\n      mode: yaml\n      title: Chiltrix Heat Pump\n      icon: mdi:heat-pump\n      show_in_sidebar: true\n      filename: dashboards/chiltrix_premium.yaml\n"
        print_success "Added lovelace dashboard configuration"
    else
        print_warning "Lovelace config exists - manually add dashboard to configuration.yaml"
    fi
    
    # Append additions to configuration.yaml
    if [ -n "$ADDITIONS" ]; then
        echo -e "$ADDITIONS" >> "$CONFIG_FILE"
    fi
}

# Check for required HACS components
check_hacs_components() {
    print_header "Checking HACS Components"
    
    print_info "Required HACS Frontend Components:"
    echo "  1. button-card"
    echo "  2. apexcharts-card"
    echo "  3. layout-card"
    echo ""
    print_warning "Please install these via HACS → Frontend before using the dashboards"
    echo ""
    read -p "Press Enter to continue..."
}

# Final instructions
show_completion() {
    print_header "Installation Complete!"
    
    echo -e "${GREEN}✓ Configuration files installed${NC}"
    echo -e "${GREEN}✓ Dashboards installed${NC}"
    echo -e "${GREEN}✓ Scripts installed${NC}"
    echo ""
    
    print_info "Next Steps:"
    echo "  1. Install required HACS components:"
    echo "     • Go to HACS → Frontend"
    echo "     • Install: button-card, apexcharts-card, layout-card"
    echo ""
    echo "  2. Restart Home Assistant:"
    echo "     • Settings → System → Restart"
    echo ""
    echo "  3. Verify Modbus connection:"
    echo "     • Check Developer Tools → States"
    echo "     • Look for sensor.cx_* entities"
    echo ""
    echo "  4. Access your dashboard:"
    echo "     • Sidebar → Chiltrix Heat Pump"
    echo ""
    
    print_warning "Configuration backup saved to: $BACKUP_DIR"
    echo ""
    
    print_success "Enjoy your Chiltrix dashboard!"
    echo ""
    echo "Support: https://github.com/jasipsw/homeassistant-chiltrix-modbus"
}

# Main installation flow
main() {
    show_welcome
    check_environment
    collect_config
    create_backup
    create_directories
    install_configs
    install_dashboards
    install_scripts
    update_configuration_yaml
    check_hacs_components
    show_completion
}

# Run main function
main
