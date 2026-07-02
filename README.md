# Mxwifi 🔍

Herramienta de gestión WiFi para Linux con menú interactivo.

## Características
- 🔍 Escaneo de redes WiFi (SSID, señal, canal, seguridad)
- 📡 Listado de dispositivos de red
- 📂 Gestión de perfiles WiFi guardados (listar y eliminar)
- 🔗 Conexión a redes guardadas
- ⚙️ Configuración de nuevas redes
- 📶 Creación de hotspots/puntos de acceso
- 🚀 Interfaz con banner y 9 opciones (8 funciones + salida)

## Requisitos
- Linux con `nmcli`, `iwlist`, `iwconfig`, `ip`
- Permisos de superusuario para algunas funciones

## Instalación
```bash
git clone https://github.com/Falconmx1/Mxwifi.git
cd Mxwifi
chmod +x install.sh mxwifi.sh
sudo ./install.sh

Uso
sudo ./mxwifi.sh
