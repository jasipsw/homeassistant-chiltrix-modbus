# Energy Tracking Setup Guide

This guide explains how to set up minute-by-minute energy tracking for your Chiltrix heat pump system, allowing you to compare actual performance against design specifications (Manual J calculations and HERS reports).

## Overview

The energy tracking system provides:
- **Minute-by-minute** thermal and electrical energy consumption
- **Hourly, daily, monthly, and yearly** aggregations
- **Bar graph visualizations** showing energy use patterns
- **COP (efficiency) tracking** over time
- **Comparison tools** for actual vs. design performance

## Installation Steps

### 1. Add Energy Integration Sensors

Edit your `configuration.yaml` and add:

```yaml
sensor: !include cx_energy_sensors.yaml
```

Or if you already have a `sensor:` section, merge the contents of `cx_energy_sensors.yaml` into it.

**What this does:**
- Creates `sensor.cx_thermal_energy_output` (accumulated thermal energy in kWh)
- Creates `sensor.cx_electrical_energy_input` (accumulated electrical energy in kWh)
- Uses Riemann sum integration to convert instantaneous power (kW) to energy (kWh)

### 2. Add Utility Meters

Edit your `configuration.yaml` and add:

```yaml
utility_meter: !include cx_energy_utility_meters.yaml
```

Or if you already have a `utility_meter:` section, merge the contents.

**What this does:**
- Creates hourly meters that reset at the top of each hour
- Creates daily meters that reset at midnight
- Creates monthly meters that reset on the 1st of each month
- Creates yearly meters that reset on January 1st
- Tracks energy by operating mode (heating, cooling, DHW, idle)

### 3. Add Energy Dashboard

Copy the dashboard configuration:

1. Go to Home Assistant
2. Navigate to **Settings → Dashboards**
3. Create new dashboard or edit existing
4. Click **"Take Control"** (if using UI mode)
5. Click **"Raw Configuration Editor"**
6. Paste contents of `cx_energy_dashboard.yaml`
7. Save

Alternatively, add to your `ui-lovelace.yaml`:
```yaml
views:
  - !include cx_energy_dashboard.yaml
```

### 4. Install ApexCharts Card (via HACS)

The dashboard uses ApexCharts for visualizations:

1. Open **HACS** (Home Assistant Community Store)
2. Click **"Frontend"**
3. Click **"+ Explore & Download Repositories"**
4. Search for **"ApexCharts Card"**
5. Click **"Download"**
6. Restart Home Assistant

### 5. Restart Home Assistant

After making all configuration changes:

1. Go to **Settings → System → Restart**
2. Wait for restart to complete
3. Verify sensors are available:
   - `sensor.cx_thermal_energy_output`
   - `sensor.cx_electrical_energy_input`
   - `sensor.cx_thermal_energy_hourly_heating`
   - etc.

## Understanding the Calculations

### From Power to Energy

Your thermal power sensor shows **instantaneous power** in kW (e.g., 25 kW).

To convert to **energy** (kWh), we integrate over time:
- **25 kW running for 1 minute** = 25 × (1/60) = **0.417 kWh**
- **25 kW running for 1 hour** = 25 × 1 = **25 kWh**
- **25 kW running for 1 day** = 25 × 24 = **600 kWh** (if constant)

The integration sensor automatically performs this calculation continuously.

### Bar Graph Visualization

**Minute-by-minute bars** (2-hour view):
- Each bar = energy consumed in 1 minute
- Calculated using `group_by: delta` over 1-minute intervals
- Useful for seeing cycling patterns and short-term behavior

**Hourly bars** (24-hour view):
- Each bar = total energy consumed in that hour
- Shows daily heating patterns
- Compare against time-of-use electricity rates

**Daily bars** (7-day view):
- Each bar = total energy consumed that day
- Shows weekly trends and weather impact

**Monthly bars** (12-month view):
- Each bar = total energy consumed that month
- Shows seasonal heating/cooling patterns

## Comparing to Design Specifications

### Manual J Calculation

Your HVAC technician created a Manual J load calculation during system design.

**To compare:**

1. Get your **Design Heating Load** from Manual J report (in BTU/hr)
2. Convert to kW: `Design Load (kW) = BTU/hr ÷ 3412`
   - Example: 85,000 BTU/hr ÷ 3412 = 24.9 kW

3. Compare to your **Peak Thermal Power**:
   - Look at the maximum thermal power in the hourly charts
   - This should occur on the coldest days
   - Ideally, actual peak should be close to design load

4. **Interpretation:**
   - **Actual < Design:** Great! Your home is performing better than expected
   - **Actual = Design:** Perfect! System sized correctly
   - **Actual > Design:** Investigate potential issues (air leaks, insulation, etc.)

### HERS Report

Your HERS (Home Energy Rating System) report from construction includes annual energy estimates.

**To compare:**

1. Find **"Estimated Annual Heating Energy"** in your HERS report (kWh/year)
2. Compare to your yearly thermal energy sensor:
   - `sensor.cx_thermal_energy_yearly_heating`

3. Calculate percentage difference:
   ```
   Difference = (Actual - HERS) / HERS × 100%
   ```

4. **Interpretation:**
   - Within ±20% = Normal (weather variation, occupancy differences)
   - More than 20% higher = Investigate efficiency issues
   - Lower than expected = Excellent performance!

### Creating Comparison Helpers

To display design values on the dashboard:

1. Go to **Settings → Devices & Services → Helpers**
2. Click **"+ Create Helper"** → **"Number"**

Create these helpers:

**Design Heating Load:**
- Name: `Design Heating Load`
- Entity ID: `input_number.design_heating_load`
- Min: 0, Max: 100, Step: 0.1
- Unit: kW
- Set value to your Manual J design load in kW

**HERS Annual Heating:**
- Name: `HERS Annual Heating Estimate`
- Entity ID: `input_number.hers_annual_heating`
- Min: 0, Max: 50000, Step: 1
- Unit: kWh
- Set value to your HERS report annual heating estimate

3. Update the markdown card in the dashboard with your actual values
4. Uncomment the "Load Comparison Chart" section in `cx_energy_dashboard.yaml`

## Example Calculations for 3,500 sq ft House

### Typical Design Loads

**Rule of Thumb:** 30-50 BTU/hr per sq ft

For 3,500 sq ft:
- **Well Insulated:** 3,500 × 30 = 105,000 BTU/hr = **30.8 kW**
- **Average:** 3,500 × 40 = 140,000 BTU/hr = **41.0 kW**
- **Poorly Insulated:** 3,500 × 50 = 175,000 BTU/hr = **51.3 kW**

Your current 25 kW reading suggests either:
- Excellent insulation
- Mild weather conditions
- Efficient system operation

### Annual Energy Estimates

Assuming an average heating season (4 months at 50% capacity):
- Design Load: 30 kW
- Operating Hours: 4 months × 30 days × 24 hours × 50% = 1,440 hours
- **Annual Thermal Energy:** 30 kW × 1,440 hours = **43,200 kWh**

With COP of 3.0:
- **Annual Electrical Energy:** 43,200 ÷ 3.0 = **14,400 kWh**

Compare these estimates to your actual measurements!

## Monitoring and Analysis

### Daily Checks

1. **Check COP:** Should be 2.5-4.5 for heating mode
   - Low COP = investigate system performance
   - Track COP vs outdoor temperature

2. **Review Hourly Bars:** Identify peak demand times
   - Schedule high-demand activities during off-peak hours
   - Optimize thermostat setpoints

### Weekly Analysis

1. **Compare Daily Totals:**
   - Correlate with outdoor temperatures
   - Identify unusual spikes or patterns

2. **Review Operating Modes:**
   - How much energy for heating vs DHW?
   - Is DHW priority impacting heating efficiency?

### Monthly Review

1. **Compare to Previous Months:**
   - Seasonal trends
   - Year-over-year comparison

2. **Compare to Design Specs:**
   - Are you within expected range?
   - Calculate percentage difference

3. **Cost Analysis:**
   - Use `cx_cost_sensors.yaml` to track operating costs
   - Compare to alternative heating sources

## Troubleshooting

### Sensors Show "Unknown" or "Unavailable"

**Check:**
1. All required sensors exist:
   - `sensor.cx_thermal_power_output`
   - `sensor.cx_current_power`
   - `sensor.cx_flow_rate`
   - `sensor.cx_water_temperature_delta`

2. Fluid properties configured:
   - `input_number.cx_fluid_density` (default: 1025 kg/m³)
   - `input_number.cx_fluid_specific_heat` (default: 3.95 kJ/(kg·°C))

3. Integration sensors have `state_class: measurement`

### Energy Values Seem Wrong

**Verify:**
1. Power sensor units:
   - Thermal power should be in **kW**
   - Electrical power should be in **W** (converted to kW in integration)

2. Integration sensor configuration:
   - `unit_prefix: k` (for kWh)
   - `unit_time: h` (for hours)
   - `method: left` (Riemann sum method)

3. Fluid properties are correct for your system:
   - Water: 1000 kg/m³, 4.186 kJ/(kg·°C)
   - Environol 1000: 1025 kg/m³, 3.95 kJ/(kg·°C)

### Graphs Not Showing

**Check:**
1. ApexCharts card installed via HACS
2. Browser cache cleared (Ctrl+Shift+R)
3. Entity IDs match in dashboard configuration
4. History component enabled in Home Assistant

## Advanced: Degree Day Analysis

For even more detailed analysis, consider correlating energy use with heating degree days (HDD):

1. Add a weather integration to track outdoor temperature
2. Calculate daily HDD: `HDD = (65°F - Average Outdoor Temp)`
3. Compare daily energy use vs HDD
4. Calculate your home's "UA value" (heat loss coefficient)

## Files Created

- **cx_energy_sensors.yaml** - Integration sensors (power → energy)
- **cx_energy_utility_meters.yaml** - Hourly/daily/monthly/yearly meters
- **cx_energy_dashboard.yaml** - Bar graph visualizations
- **ENERGY_TRACKING_SETUP.md** - This guide

## Support

For issues or questions:
1. Check sensor states in Developer Tools → States
2. Review Home Assistant logs for errors
3. Verify all configuration files are properly included
4. Ensure Environol 1000 fluid properties are correctly set (970 kg/m³ should be 1025 kg/m³)

## Next Steps

1. ✅ Install and configure all sensors
2. ✅ Set up dashboard and verify visualizations
3. ✅ Gather Manual J and HERS data
4. ✅ Create comparison helpers with design values
5. ✅ Monitor for 1-2 weeks to establish baseline
6. ✅ Compare actual vs design specifications
7. ✅ Optimize system operation based on findings

Enjoy your detailed energy monitoring! 📊🔥
