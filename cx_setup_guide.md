# Chiltrix Heat Pump Modbus Setup Guide

**Compatible Models:** CX34, CX35, CX50-2, and other Chiltrix heat pumps

## Step 1: Backup Your Configuration
Before making changes, backup your current configuration:
```bash
cp /config/configuration.yaml /config/configuration.yaml.backup
```

## Step 2: Create the modbus.yaml File

1. Create a new file: `/config/modbus.yaml`
2. Copy the entire contents from the `modbus.yaml` artifact
3. **IMPORTANT**: Change line 13 to your Waveshare device IP:
   ```yaml
   host: 192.168.1.100  # CHANGE THIS to your actual IP
   ```

## Step 3: Include modbus.yaml in configuration.yaml

Add this line to your `/config/configuration.yaml`:

```yaml
# Modbus Configuration
modbus: !include modbus.yaml
```

**If you already have a `modbus:` section**, you need to merge the configurations:

```yaml
modbus:
  # Your existing modbus devices
  - name: existing_device
    type: tcp
    host: 192.168.1.50
    port: 502
    # ... rest of config
  
  # Add the Chiltrix configuration
  - name: chiltrix_cx
    type: tcp
    host: 192.168.1.100  # Your Waveshare IP
    port: 502
    # ... (copy the rest from modbus.yaml)
```

## Step 4: Validate Configuration

Before restarting, validate your configuration:

1. Go to **Developer Tools** → **YAML**
2. Click **Check Configuration**
3. Fix any errors shown

## Step 5: Restart Home Assistant

```bash
Settings → System → Restart
```

Or via SSH:
```bash
ha core restart
```

## Step 6: Verify Entities Were Created

After restart:

1. Go to **Settings** → **Devices & Services** → **Integrations**
2. Look for "Modbus" integration
3. Click on it to see all entities
4. Filter by "CX" to see your heat pump entities

Or check **Developer Tools** → **States** and search for "cx"

## Troubleshooting

### No Entities Appear

**Check the logs:**
```
Settings → System → Logs
```

Look for errors containing "modbus" or "cx"

**Common issues:**

1. **Wrong IP address** - Verify Waveshare device IP
2. **Port blocked** - Check firewall allows port 502
3. **Wrong slave ID** - Try changing `slave: 1` to `slave: 0` or `slave: 2`
4. **Wrong register addresses** - Your firmware may use different addresses

### Entity Shows "Unavailable"

This means the register address doesn't exist on your device. You have two options:

**Option A: Comment out unavailable entities**
```yaml
# - name: "CX Flow Rate"
#   unique_id: cx_flow_rate
#   address: 257
#   ...
```

**Option B: Find correct addresses**
Use a Modbus scanner tool to find the correct register addresses for your specific firmware version.

### Values Look Wrong

**Adjust the scale:**
If temperatures show as 230 instead of 23.0, the scale factor is wrong:
```yaml
scale: 0.1  # Divides value by 10
scale: 0.01 # Divides value by 100
scale: 1    # No scaling
```

**Change data type:**
```yaml
data_type: int16   # Signed 16-bit (-32768 to 32767)
data_type: uint16  # Unsigned 16-bit (0 to 65535)
data_type: int32   # Signed 32-bit
data_type: uint32  # Unsigned 32-bit
```

## Model-Specific Notes

### CX34 / CX35
These models may use slightly different register addresses. Common differences:
- Some models use registers starting at 0x00 instead of 0xCA
- DHW functionality may not be available on all models
- Check your specific model documentation

### CX50-2
The configuration is based primarily on CX50-2 register maps.
Most addresses should work as-is.

### Other Models
If you have a different Chiltrix model:
1. Start with this configuration
2. Comment out unavailable entities
3. Use a Modbus scanner to find correct addresses
4. Update the register addresses in modbus.yaml

## Testing Individual Registers

To test if a specific register works, use Developer Tools:

1. Go to **Developer Tools** → **Services**
2. Call service: `modbus.write_register`
3. Fill in:
   ```yaml
   hub: chiltrix_cx
   address: 209
   value: 22
   slave: 1
   ```

Or to read:
```yaml
service: modbus.read_holding_registers
data:
  hub: chiltrix_cx
  address: 209
  count: 1
  slave: 1
```

## Creating a Dashboard

Add to your Lovelace dashboard (`ui-lovelace.yaml` or via UI):

```yaml
type: entities
title: Chiltrix Heat Pump
entities:
  - entity: sensor.cx_water_inlet_temperature
  - entity: sensor.cx_water_outlet_temperature
  - entity: sensor.cx_ambient_temperature
  - entity: sensor.cx_operating_state
  - entity: sensor.cx_current_power
  - entity: switch.cx_power
  - entity: switch.cx_silent_mode_control
```

## Template Sensors for Better Status Display

Add these to your `configuration.yaml` to make the operating state more readable:

```yaml
template:
  - sensor:
      - name: "CX Operating State Text"
        unique_id: cx_operating_state_text
        state: >
          {% set state = states('sensor.cx_operating_state') | int(0) %}
          {% set states_map = {
            0: 'Off',
            1: 'Heating',
            2: 'Cooling',
            3: 'Auto',
            4: 'DHW',
            5: 'Defrost',
            6: 'Error'
          } %}
          {{ states_map.get(state, 'Unknown') }}
        icon: >
          {% set state = states('sensor.cx_operating_state') | int(0) %}
          {% if state == 1 %}
            mdi:fire
          {% elif state == 2 %}
            mdi:snowflake
          {% elif state == 4 %}
            mdi:water-boiler
          {% elif state == 5 %}
            mdi:snowflake-melt
          {% elif state == 6 %}
            mdi:alert-circle
          {% else %}
            mdi:heat-pump
          {% endif %}
```

## Advanced: Finding Your Register Addresses

If entities are unavailable, you need to find the correct register addresses for your specific firmware version.

**Tools you can use:**
- QModMaster (GUI)
- mbpoll (command line)
- modpoll (command line)
- The Python scanner script (if provided)

**Example with mbpoll:**
```bash
# Install mbpoll
sudo apt-get install mbpoll

# Scan registers 200-220
mbpoll -a 1 -r 200 -c 20 -t 3 192.168.1.100
```

## Support

If you continue having issues:
1. Check Home Assistant logs
2. Verify RS485 wiring (A to A+, B to B-)
3. Confirm Waveshare device is accessible (ping the IP)
4. Try a different Modbus tool to verify device responds
5. Check Chiltrix documentation for your specific model and firmware version
6. Compare with the gonzojive/heatpump GitHub project for CX34 references
