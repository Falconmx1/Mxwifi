# Mxwifi 🔍

Herramienta de gestión WiFi para Linux con menú interactivo.

## Características
- 🔍 Escaneo de redes WiFi (SSID, señal, canal, seguridad, MAC)
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

Menú de Opciones
═══════════════════════════════════════
          M X W I F I  v1.0
═══════════════════════════════════════
[1]  Escanear redes WiFi
[2]  Listar dispositivos de red
[3]  Ver perfiles WiFi guardados
[4]  Eliminar perfil WiFi
[5]  Conectarse a red guardada
[6]  Configurar nueva red
[7]  Crear hotspot/punto de acceso
[8]  Apagar hotspot
[9]  Salir
═══════════════════════════════════════

Ejecución
Siempre ejecuta con permisos de superusuario:
sudo mxwifi
