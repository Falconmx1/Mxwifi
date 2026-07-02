🔥 MXWIFI - DOMINA EL WIFI COMO UN VERDADERO HACKER 🔥
<div align="center">
https://img.shields.io/badge/%F0%9F%9A%80-MXWIFI_v1.0-00ff00?style=for-the-badge&logo=linux&logoColor=white&labelColor=000000
https://img.shields.io/badge/Shell-Bash_4.4+-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white
https://img.shields.io/badge/OS-Linux_Friendly-FCC624?style=for-the-badge&logo=linux&logoColor=black
https://img.shields.io/badge/License-MIT_%F0%9F%94%A5-blue?style=for-the-badge&logo=mit-license&logoColor=white
https://img.shields.io/badge/Status-Operational-success?style=for-the-badge

</div>

🎯 ¿QUÉ MIERDA ES MXWIFI?
Mxwifi es la herramienta más chingona y poderosa para gestionar redes WiFi en Linux. Olvídate de comandos complicados, aquí tienes un menú interactivo con 9 opciones que te harán sentir como un hacker de película.

¡Sin dependencias pedorras! Solo usamos comandos nativos de Linux como nmcli, iwlist, iwconfig y ip. Puro poder del sistema, nada de bibliotecas externas.

⚡ CARACTERÍSTICAS QUE TE VUELAN LA CABEZA

🎮 Menú Interactivo (9 Opciones)

1- 🔍 Escanear redes WiFi - iwlist, awk, sed - Te muestra SSID, señal, canal y seguridad. ¡Como un rastreador profesional!

2- 📡 Listar dispositivos -	ip link, iwconfig, nmcli - Te dice qué interfaces de red tienes y su estado actual

3- 📂 Ver perfiles guardados -	nmcli con show - Lista todas las redes WiFi que has guardado

4- 🗑️ Eliminar perfil -	nmcli con delete - Borra perfiles viejos que ya no te sirven

5- 🔗 Conectar a red guardada	- nmcli con up - Conéctate con una red que ya guardaste

6- ⚙️ Configurar nueva red - nmcli dev wifi connect -	Agrega redes nuevas, con o sin contraseña

7- 📶 Crear hotspot -	nmcli con add type wifi - Convierte tu compu en un punto de acceso WiFi

8- 🛑 Apagar hotspot - nmcli con down/delete - Apaga el punto de acceso cuando ya no lo necesites

9	🚪 Salir	exit	¡Hasta luego, perro!

📦 INSTALACIÓN RÁPIDA (3 PASOS)
# 1. Clonar el repositorio
git clone https://github.com/Falconmx1/Mxwifi.git
cd Mxwifi

# 2. Dar permisos de ejecución
chmod +x mxwifi.sh install.sh

# 3. Instalar en el sistema
sudo ./install.sh

# 🚀 ¡Listo! Ejecuta con:
sudo mxwifi

📝 Dependencias (se instalan automáticamente)
# En Debian/Ubuntu:
sudo apt install network-manager wireless-tools net-tools

# En Arch:
sudo pacman -S networkmanager wireless_tools net-tools

🔧 COMANDOS EXPLICADOS PARA QUE APRENDAS
📡 Escaneo de Redes
# Escanea todas las redes disponibles
iwlist $INTERFACE scan

# Filtra solo lo importante
grep -E "ESSID|Quality|Channel|Encryption"

📂 Gestión de Perfiles

# Lista todas las conexiones guardadas
nmcli con show

# Elimina una conexión específica
nmcli con delete <nombre>
🔗 Conexión a Redes
bash
# Conecta a red nueva (con contraseña)
nmcli dev wifi connect <SSID> password <pass>

# Conecta a red abierta (sin contraseña)
nmcli dev wifi connect <SSID>

# Activa una conexión guardada
nmcli con up <nombre>
📶 Hotspot/Punto de Acceso

# Crea punto de acceso
nmcli con add type wifi ifname wlan0 con-name Hotspot ssid <nombre>

# Configura modo AP y seguridad
nmcli con modify Hotspot wifi-sec.key-mgmt wpa-psk
nmcli con modify Hotspot wifi-sec.psk <contraseña>

# Activa el hotspot
nmcli con up Hotspot
🚨 SOLUCIÓN DE PROBLEMAS
❌ Error: "No se encontró interfaz WiFi"

# Verifica tus interfaces
iwconfig

# Activa la interfaz manualmente
sudo ip link set wlan0 up
❌ Error: "NetworkManager no está corriendo"

# Inicia el servicio
sudo systemctl start NetworkManager

# Habilita el servicio para que inicie siempre
sudo systemctl enable NetworkManager
❌ Error: "Hotspot no funciona"

# Verifica que tu tarjeta soporte modo AP
iw list | grep "AP"

# Si no, actualiza drivers o usa otra interfaz

# Reinicia NetworkManager
sudo systemctl restart NetworkManager
❌ Error: "No hay permisos"

# Mxwifi necesita permisos de root para escanear y configurar
sudo mxwifi
🎨 BONUS: PERSONALIZACIÓN
Cambiar el Banner
Edita el archivo mxwifi.sh y modifica estas líneas:


echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC} ${GREEN}          M X W I F I  v1.0${NC}          ${BLUE}║${NC}"
Cambiar Colores
Los colores disponibles:


RED='\033[0;31m'    # Rojo
GREEN='\033[0;32m'  # Verde
YELLOW='\033[1;33m' # Amarillo
BLUE='\033[0;34m'   # Azul
PURPLE='\033[0;35m' # Púrpura
CYAN='\033[0;36m'   # Cian
WHITE='\033[1;37m'  # Blanco
NC='\033[0m'        # Sin color
📸 EJEMPLO DE USO

$ sudo mxwifi

╔═══════════════════════════════════════╗
║          M X W I F I  v1.0          ║
╠═══════════════════════════════════════╣
║    Gestión WiFi para Linux           ║
║    Interfaz: wlan0                   ║
╚═══════════════════════════════════════╝

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
Selecciona una opción [1-9]: 1

[*] Escaneando redes WiFi...
[!] Esto puede tomar unos segundos

═══════════════════════════════════════════════════════════
SSID                      SEÑAL      CANAL    SEGURIDAD    
═══════════════════════════════════════════════════════════
MiRedPro                  70/100     6        Cifrada      
RedVecinos                45/100     1        Cifrada      
CafeInternet              30/100     11       Abierta      
═══════════════════════════════════════════════════════════
Presiona Enter para continuar...
🤝 CONTRIBUCIONES
¡Las contribuciones son bienvenidas! Si tienes ideas para mejorar Mxwifi:

Haz un fork del repositorio

Crea tu rama de características (git checkout -b feature/amazing)

Commit tus cambios (git commit -m 'Add some amazing feature')

Push a la rama (git push origin feature/amazing)

Abre un Pull Request

📄 LICENCIA
MIT License - ¡Haz lo que quieras con el código! Solo te pedimos que menciones el proyecto original.

🌟 AGRADECIMIENTOS
A Linux por ser el mejor sistema operativo

A NetworkManager por hacer posible todo

A la comunidad Open Source por la inspiración

A todos los que usan Mxwifi y lo hacen crecer

📞 CONTACTO
GitHub: Falconmx1

Proyecto: Mxwifi

<div align="center">
⭐ ¡SI TE GUSTA, DALE UNA ESTRELLA AL REPO! ⭐

Hecho con ❤️ y ☕ en México

</div>
