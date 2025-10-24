# ⚡ Quick Start Guide

**Get up and running in 5 minutes!**

## 🎯 Prerequisites Checklist
- [ ] Home Assistant 2024.1+ installed
- [ ] Know your Chiltrix IP address
- [ ] Can access Home Assistant terminal/SSH
- [ ] Have internet connection (for HACS installs)

---

## 🚀 Installation (Choose One Method)

### Option A: One-Command Install 🔥

```bash
cd /config && \
wget https://github.com/jasipsw/homeassistant-chiltrix-modbus/archive/refs/heads/main.zip && \
unzip main.zip && \
cd homeassistant-chiltrix-modbus-main && \
chmod +x install.sh && \
./install.sh
```

**That's it!** The installer will walk you through everything.

---

### Option B: Manual Install (Copy/Paste These Commands)

```bash
# 1. Download files
cd /config
wget https://github.com/jasipsw/homeassistant-chiltrix-modbus/archive/refs/heads/main.zip
unzip main.zip
cd homeassistant-chiltrix-modbus-main

# 2. Copy config files
cp modbus.yaml ../
cp cop_sensors.yaml ../
cp cost_sensors.yaml ../
cp fluid_helpers.yaml ../
cp cost_helpers.yaml ../
cp automation_scripts.yaml ../scripts.yaml

# 3. Copy dashboards
mkdir -p ../dashboards
cp premium_dashboard.yaml ../dashboards/
cp controller_display.yaml ../dashboards/

# 4. Done! Now edit modbus.yaml with your IP
```

**Edit your IP:** Change `192.168.1.100` in `/config/modbus.yaml` to your heat pump's IP

---

## 📝 Add to configuration.yaml

Open `/config/configuration.yaml` and add:

```yaml
modbus: !include modbus.yaml
sensor: !include cop_sensors.yaml
script: !include scripts.yaml

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

---

## 🎨 Install HACS Cards

1. Go to **HACS → Frontend**
2. Click **Explore & Download Repositories**
3. Search and install each:
   - `button-card`
   - `apexcharts-card`
   - `layout-card`

---

## 🔄 Restart Home Assistant

**Settings → System → Restart**

Wait 2-3 minutes...

---

## ✅ Verify It's Working

1. Go to **Developer Tools → States**
2. Search for `sensor.cx_`
3. You should see 20+ sensors!

**If sensors show "unavailable":**
- Check Settings → System → Logs for errors
- Verify your IP address is correct
- Make sure Modbus is enabled on your heat pump

---

## 🎉 Access Your Dashboard

Look in the sidebar for **Chiltrix Heat Pump** 🎯

---

## 🆘 Quick Troubleshooting

### "Can't find sensors"
- Did you restart Home Assistant?
- Is the IP address correct in modbus.yaml?
- Check logs: Settings → System → Logs

### "Dashboard looks broken"
- Install the 3 HACS cards listed above
- Clear browser cache (Ctrl+Shift+R)
- Restart Home Assistant again

### "Modbus timeout errors"
In `modbus.yaml`, increase timeout:
```yaml
timeout: 10  # Was 5, now 10
delay: 2     # Add this line
```

---

## 🎓 Next Steps

- [ ] Customize electricity rates in `cost_helpers.yaml`
- [ ] Set up automations (see README)
- [ ] Configure voice control
- [ ] Add mobile app widgets
- [ ] Explore dashboard customization

---

## 📚 Need More Help?

- Full documentation: [README.md](README.md)
- Report issues: [GitHub Issues](https://github.com/jasipsw/homeassistant-chiltrix-modbus/issues)
- Ask questions: [Discussions](https://github.com/jasipsw/homeassistant-chiltrix-modbus/discussions)

---

**That's it! You should be up and running. Enjoy your smart heat pump! 🎉**
