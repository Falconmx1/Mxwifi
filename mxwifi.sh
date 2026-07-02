#!/bin/bash

# Colores para el banner
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin Color

# Función para mostrar el banner
show_banner() {
    clear
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${GREEN}          M X W I F I  v1.0${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${YELLOW}  Gestión WiFi para Linux${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
}

# Función para mostrar el menú
show_menu() {
    echo ""
    echo "[1]  Escanear redes WiFi"
    echo "[2]  Listar dispositivos de red"
    echo "[3]  Ver perfiles WiFi guardados"
    echo "[4]  Eliminar perfil WiFi"
    echo "[5]  Conectarse a red guardada"
    echo "[6]  Configurar nueva red"
    echo "[7]  Crear hotspot/punto de acceso"
    echo "[8]  Apagar hotspot"
    echo "[9]  Salir"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -n "Selecciona una opción [1-9]: "
}

# Función para escanear redes (ejemplo)
scan_wifi() {
    echo -e "${GREEN}[*] Escaneando redes WiFi...${NC}"
    sudo iwlist wlan0 scan | grep -E "ESSID|Signal|Channel|Encryption"
    read -p "Presiona Enter para continuar..."
}

# Función principal
main() {
    while true; do
        show_banner
        show_menu
        read opcion
        case $opcion in
            1) scan_wifi ;;
            2) echo "Función en desarrollo..." ; read -p "Presiona Enter..." ;;
            3) echo "Función en desarrollo..." ; read -p "Presiona Enter..." ;;
            4) echo "Función en desarrollo..." ; read -p "Presiona Enter..." ;;
            5) echo "Función en desarrollo..." ; read -p "Presiona Enter..." ;;
            6) echo "Función en desarrollo..." ; read -p "Presiona Enter..." ;;
            7) echo "Función en desarrollo..." ; read -p "Presiona Enter..." ;;
            8) echo "Función en desarrollo..." ; read -p "Presiona Enter..." ;;
            9) echo -e "${GREEN}Saliendo...${NC}" ; exit 0 ;;
            *) echo -e "${RED}Opción inválida${NC}" ; read -p "Presiona Enter..." ;;
        esac
    done
}

# Ejecutar
main
