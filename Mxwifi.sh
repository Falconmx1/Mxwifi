#!/bin/bash

# ============================================
# Mxwifi v1.0 - Herramienta de Gestión WiFi
# ============================================

# Colores para el banner y mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # Sin Color

# Variables globales
INTERFACE="wlan0"
HOTSPOT_SSID="Mxwifi_Hotspot"
HOTSPOT_PASS="12345678"

# ============================================
# FUNCIONES DEL SISTEMA
# ============================================

# Verificar dependencias
check_dependencies() {
    local deps=("nmcli" "iwlist" "iwconfig" "ip" "grep" "awk" "sed")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v $dep &> /dev/null; then
            missing+=($dep)
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        echo -e "${RED}[!] Faltan dependencias: ${missing[*]}${NC}"
        echo -e "${YELLOW}[*] Instala con: sudo apt install network-manager wireless-tools net-tools${NC}"
        exit 1
    fi
}

# Obtener interfaz WiFi activa
get_wifi_interface() {
    local iface=$(iwconfig 2>/dev/null | grep -E "IEEE 802.11" | awk '{print $1}')
    if [ -n "$iface" ]; then
        INTERFACE=$iface
    else
        echo -e "${RED}[!] No se encontró interfaz WiFi${NC}"
        return 1
    fi
    return 0
}

# Verificar permisos de root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${RED}[!] Ejecuta con sudo: sudo ./mxwifi.sh${NC}"
        exit 1
    fi
}

# ============================================
# FUNCIONES DEL MENÚ
# ============================================

# Mostrar banner
show_banner() {
    clear
    echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} ${GREEN}          M X W I F I  v1.0${NC}          ${BLUE}║${NC}"
    echo -e "${BLUE}╠═══════════════════════════════════════╣${NC}"
    echo -e "${BLUE}║${NC} ${YELLOW}    Gestión WiFi para Linux${NC}        ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC} ${CYAN}    Interfaz: $INTERFACE${NC}              ${BLUE}║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
}

# Mostrar menú
show_menu() {
    echo ""
    echo -e "${WHITE}[1]${NC}  ${GREEN}Escanear redes WiFi${NC}"
    echo -e "${WHITE}[2]${NC}  ${GREEN}Listar dispositivos de red${NC}"
    echo -e "${WHITE}[3]${NC}  ${GREEN}Ver perfiles WiFi guardados${NC}"
    echo -e "${WHITE}[4]${NC}  ${RED}Eliminar perfil WiFi${NC}"
    echo -e "${WHITE}[5]${NC}  ${GREEN}Conectarse a red guardada${NC}"
    echo -e "${WHITE}[6]${NC}  ${YELLOW}Configurar nueva red${NC}"
    echo -e "${WHITE}[7]${NC}  ${PURPLE}Crear hotspot/punto de acceso${NC}"
    echo -e "${WHITE}[8]${NC}  ${RED}Apagar hotspot${NC}"
    echo -e "${WHITE}[9]${NC}  ${RED}Salir${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -n -e "${YELLOW}Selecciona una opción [1-9]: ${NC}"
}

# ============================================
# OPCIÓN 1: ESCANEAR REDES WIFI
# ============================================

scan_wifi() {
    echo -e "${GREEN}[*] Escaneando redes WiFi...${NC}"
    echo -e "${YELLOW}[!] Esto puede tomar unos segundos${NC}"
    
    # Activar interfaz
    ip link set $INTERFACE up 2>/dev/null
    
    # Escanear con iwlist
    local scan_result=$(sudo iwlist $INTERFACE scan 2>/dev/null)
    
    if [ -z "$scan_result" ]; then
        echo -e "${RED}[!] No se encontraron redes o error en el escaneo${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    # Procesar y mostrar resultados
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    printf "${CYAN}%-25s %-10s %-8s %-15s${NC}\n" "SSID" "SEÑAL" "CANAL" "SEGURIDAD"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    
    # Extraer información con awk y sed
    echo "$scan_result" | awk -v blue="$BLUE" -v green="$GREEN" -v yellow="$YELLOW" -v nc="$NC" '
    BEGIN { 
        ssid=""; signal=""; channel=""; encryption=""
    }
    /ESSID:/ { 
        gsub(/ESSID:/,""); 
        gsub(/"/,""); 
        ssid=$0; 
        if (ssid == "") ssid="<Red Oculta>"
    }
    /Quality=/ { 
        split($0, a, "Quality="); 
        split(a[2], b, " "); 
        split(b[1], c, "/"); 
        signal=c[1] "/" c[2]
    }
    /Channel:/ { 
        channel=$2
    }
    /Encryption key:/ { 
        encryption=($3=="on" ? "Cifrada" : "Abierta")
    }
    /ESSID:/ && ssid!="" {
        printf "%-25s %-10s %-8s %-15s\n", ssid, signal, channel, encryption
        ssid=""; signal=""; channel=""; encryption=""
    }'
    
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    read -p "Presiona Enter para continuar..."
}

# ============================================
# OPCIÓN 2: LISTAR DISPOSITIVOS DE RED
# ============================================

list_network_devices() {
    echo -e "${GREEN}[*] Listando dispositivos de red...${NC}\n"
    
    # Interfaces de red
    echo -e "${CYAN}─── Interfaces de Red ───${NC}"
    ip link show | grep -E "^[0-9]+:" | while read line; do
        local iface=$(echo $line | awk -F': ' '{print $2}')
        local state=$(echo $line | grep -q "UP" && echo "🟢 Activa" || echo "🔴 Inactiva")
        echo -e "  ${WHITE}$iface${NC} - $state"
    done
    
    # Dispositivos WiFi
    echo -e "\n${CYAN}─── Dispositivos WiFi ───${NC}"
    iwconfig 2>/dev/null | grep -E "^[a-zA-Z0-9]+" | while read line; do
        local iface=$(echo $line | awk '{print $1}')
        local mode=$(echo $line | grep -o "Mode:[^ ]*" | cut -d':' -f2)
        local freq=$(echo $line | grep -o "Frequency:[^ ]*" | cut -d':' -f2)
        local signal=$(echo $line | grep -o "Signal level=[^ ]*" | cut -d'=' -f2)
        echo -e "  ${WHITE}$iface${NC} - Modo: $mode, Frecuencia: $freq, Señal: $signal"
    done
    
    # Conexiones activas
    echo -e "\n${CYAN}─── Conexiones Activas ───${NC}"
    nmcli -t -f NAME,TYPE,DEVICE con show --active 2>/dev/null | while IFS=':' read -r name type device; do
        if [ -n "$name" ]; then
            echo -e "  ${GREEN}●${NC} $name ($type) - $device"
        fi
    done
    
    echo -e "\n${GREEN}[✓] Listado completo${NC}"
    read -p "Presiona Enter para continuar..."
}

# ============================================
# OPCIÓN 3: VER PERFILES GUARDADOS
# ============================================

view_saved_profiles() {
    echo -e "${GREEN}[*] Perfiles WiFi guardados:${NC}\n"
    
    local profiles=$(nmcli -t -f NAME,TYPE con show 2>/dev/null | grep ":wifi" | cut -d':' -f1)
    
    if [ -z "$profiles" ]; then
        echo -e "${YELLOW}[!] No hay perfiles WiFi guardados${NC}"
    else
        echo -e "${BLUE}═══════════════════════════════════════════${NC}"
        echo -e "${CYAN}Lista de redes guardadas:${NC}"
        echo -e "${BLUE}═══════════════════════════════════════════${NC}"
        
        local count=0
        echo "$profiles" | while read -r profile; do
            if [ -n "$profile" ]; then
                count=$((count+1))
                # Obtener detalles
                local ssid=$(echo "$profile" | sed 's/^[0-9]*-//')
                local uuid=$(nmcli -t -f UUID con show "$profile" 2>/dev/null | head -1)
                local device=$(nmcli -t -f DEVICE con show "$profile" 2>/dev/null | head -1)
                local autoconnect=$(nmcli -t -f autoconnect con show "$profile" 2>/dev/null | head -1)
                
                echo -e "${GREEN}[$count]${NC} ${WHITE}$ssid${NC}"
                echo -e "    UUID: $uuid"
                echo -e "    Dispositivo: $device"
                echo -e "    Auto-conexión: $autoconnect"
                echo ""
            fi
        done
    fi
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# OPCIÓN 4: ELIMINAR PERFIL
# ============================================

delete_profile() {
    echo -e "${RED}[!] Eliminar perfil WiFi${NC}\n"
    
    # Mostrar perfiles disponibles
    local profiles=($(nmcli -t -f NAME,TYPE con show 2>/dev/null | grep ":wifi" | cut -d':' -f1))
    
    if [ ${#profiles[@]} -eq 0 ]; then
        echo -e "${YELLOW}[!] No hay perfiles WiFi guardados${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    echo -e "${CYAN}Perfiles disponibles:${NC}"
    local i=1
    for profile in "${profiles[@]}"; do
        echo -e "${GREEN}[$i]${NC} $profile"
        i=$((i+1))
    done
    
    echo -n -e "\n${YELLOW}Selecciona el número del perfil a eliminar (0 para cancelar): ${NC}"
    read selection
    
    if [[ $selection =~ ^[0-9]+$ ]] && [ $selection -ge 1 ] && [ $selection -le ${#profiles[@]} ]; then
        local profile_to_delete="${profiles[$((selection-1))]}"
        echo -n -e "${RED}¿Seguro que quieres eliminar '$profile_to_delete'? (s/N): ${NC}"
        read confirm
        if [[ "$confirm" =~ ^[sS]$ ]]; then
            nmcli con delete "$profile_to_delete" 2>/dev/null
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}[✓] Perfil eliminado correctamente${NC}"
            else
                echo -e "${RED}[!] Error al eliminar el perfil${NC}"
            fi
        else
            echo -e "${YELLOW}[!] Operación cancelada${NC}"
        fi
    else
        echo -e "${YELLOW}[!] Operación cancelada${NC}"
    fi
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# OPCIÓN 5: CONECTARSE A RED GUARDADA
# ============================================

connect_to_saved() {
    echo -e "${GREEN}[*] Conectar a red guardada${NC}\n"
    
    # Mostrar perfiles disponibles
    local profiles=($(nmcli -t -f NAME,TYPE con show 2>/dev/null | grep ":wifi" | cut -d':' -f1))
    
    if [ ${#profiles[@]} -eq 0 ]; then
        echo -e "${YELLOW}[!] No hay perfiles WiFi guardados${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    echo -e "${CYAN}Perfiles disponibles:${NC}"
    local i=1
    for profile in "${profiles[@]}"; do
        local status=$(nmcli -t -f NAME,DEVICE con show --active 2>/dev/null | grep "^$profile:" > /dev/null && echo "🟢 Conectado" || echo "🔴 Desconectado")
        echo -e "${GREEN}[$i]${NC} $profile - $status"
        i=$((i+1))
    done
    
    echo -n -e "\n${YELLOW}Selecciona el número de la red a conectar (0 para cancelar): ${NC}"
    read selection
    
    if [[ $selection =~ ^[0-9]+$ ]] && [ $selection -ge 1 ] && [ $selection -le ${#profiles[@]} ]; then
        local profile_to_connect="${profiles[$((selection-1))]}"
        echo -e "${GREEN}[*] Conectando a $profile_to_connect...${NC}"
        
        nmcli con up "$profile_to_connect" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[✓] Conectado exitosamente${NC}"
            # Mostrar IP
            local ip=$(ip -4 addr show $INTERFACE | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
            [ -n "$ip" ] && echo -e "${CYAN}[i] IP asignada: $ip${NC}"
        else
            echo -e "${RED}[!] Error al conectar${NC}"
        fi
    else
        echo -e "${YELLOW}[!] Operación cancelada${NC}"
    fi
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# OPCIÓN 6: CONFIGURAR NUEVA RED
# ============================================

configure_new_network() {
    echo -e "${YELLOW}[*] Configurar nueva red WiFi${NC}\n"
    
    # Escanear redes disponibles
    echo -e "${GREEN}[*] Escaneando redes disponibles...${NC}"
    sudo iwlist $INTERFACE scan 2>/dev/null | grep "ESSID:" | sed 's/.*ESSID:"\(.*\)"/\1/' | while read -r ssid; do
        if [ -n "$ssid" ]; then
            echo -e "  ${WHITE}•${NC} $ssid"
        fi
    done
    
    echo ""
    echo -n -e "${CYAN}Nombre de la red (SSID): ${NC}"
    read ssid
    
    if [ -z "$ssid" ]; then
        echo -e "${RED}[!] SSID no puede estar vacío${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    echo -n -e "${CYAN}Contraseña (dejar vacío si es abierta): ${NC}"
    read -s password
    echo ""
    
    # Crear perfil
    echo -e "${GREEN}[*] Configurando red...${NC}"
    
    if [ -z "$password" ]; then
        # Red abierta
        nmcli dev wifi connect "$ssid" 2>/dev/null
    else
        # Red protegida
        nmcli dev wifi connect "$ssid" password "$password" 2>/dev/null
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✓] Red configurada y conectada exitosamente${NC}"
    else
        echo -e "${RED}[!] Error al configurar la red. Verifica SSID y contraseña${NC}"
    fi
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# OPCIÓN 7: CREAR HOTSPOT
# ============================================

create_hotspot() {
    echo -e "${PURPLE}[*] Crear hotspot/punto de acceso${NC}\n"
    
    # Verificar si ya hay un hotspot activo
    if nmcli con show --active 2>/dev/null | grep -q "Hotspot"; then
        echo -e "${YELLOW}[!] Ya hay un hotspot activo${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    echo -n -e "${CYAN}Nombre del hotspot (SSID) [${HOTSPOT_SSID}]: ${NC}"
    read hotspot_name
    hotspot_name=${hotspot_name:-$HOTSPOT_SSID}
    
    echo -n -e "${CYAN}Contraseña (mínimo 8 caracteres) [${HOTSPOT_PASS}]: ${NC}"
    read -s hotspot_pass
    echo ""
    hotspot_pass=${hotspot_pass:-$HOTSPOT_PASS}
    
    if [ ${#hotspot_pass} -lt 8 ]; then
        echo -e "${RED}[!] La contraseña debe tener al menos 8 caracteres${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    echo -e "${GREEN}[*] Creando hotspot...${NC}"
    
    # Crear hotspot con nmcli
    nmcli con add type wifi ifname $INTERFACE con-name Hotspot autoconnect no ssid "$hotspot_name" 2>/dev/null
    nmcli con modify Hotspot 802-11-wireless.mode ap 2>/dev/null
    nmcli con modify Hotspot 802-11-wireless.band bg 2>/dev/null
    nmcli con modify Hotspot 802-11-wireless.channel 6 2>/dev/null
    nmcli con modify Hotspot wifi-sec.key-mgmt wpa-psk 2>/dev/null
    nmcli con modify Hotspot wifi-sec.psk "$hotspot_pass" 2>/dev/null
    nmcli con modify Hotspot ipv4.method shared 2>/dev/null
    nmcli con up Hotspot 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✓] Hotspot creado exitosamente${NC}"
        echo -e "${CYAN}[i] SSID: $hotspot_name${NC}"
        echo -e "${CYAN}[i] Contraseña: $hotspot_pass${NC}"
        echo -e "${CYAN}[i] Interfaz: $INTERFACE${NC}"
        
        # Obtener IP del hotspot
        local hotspot_ip=$(ip -4 addr show $INTERFACE | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
        [ -n "$hotspot_ip" ] && echo -e "${CYAN}[i] IP del hotspot: $hotspot_ip${NC}"
    else
        echo -e "${RED}[!] Error al crear el hotspot${NC}"
        nmcli con delete Hotspot 2>/dev/null
    fi
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# OPCIÓN 8: APAGAR HOTSPOT
# ============================================

stop_hotspot() {
    echo -e "${RED}[*] Apagar hotspot${NC}\n"
    
    if ! nmcli con show --active 2>/dev/null | grep -q "Hotspot"; then
        echo -e "${YELLOW}[!] No hay hotspot activo${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    echo -n -e "${RED}¿Seguro que quieres apagar el hotspot? (s/N): ${NC}"
    read confirm
    
    if [[ "$confirm" =~ ^[sS]$ ]]; then
        nmcli con down Hotspot 2>/dev/null
        nmcli con delete Hotspot 2>/dev/null
        
        # Reiniciar NetworkManager para limpiar
        systemctl restart NetworkManager 2>/dev/null
        
        echo -e "${GREEN}[✓] Hotspot apagado correctamente${NC}"
    else
        echo -e "${YELLOW}[!] Operación cancelada${NC}"
    fi
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCIÓN PRINCIPAL
# ============================================

main() {
    # Verificar permisos y dependencias
    check_root
    check_dependencies
    get_wifi_interface
    
    # Bucle principal
    while true; do
        show_banner
        show_menu
        read opcion
        
        case $opcion in
            1) scan_wifi ;;
            2) list_network_devices ;;
            3) view_saved_profiles ;;
            4) delete_profile ;;
            5) connect_to_saved ;;
            6) configure_new_network ;;
            7) create_hotspot ;;
            8) stop_hotspot ;;
            9) 
                echo -e "${GREEN}[✓] Saliendo de Mxwifi...${NC}"
                echo -e "${CYAN}¡Hasta luego!${NC}"
                exit 0 
                ;;
            *) 
                echo -e "${RED}[!] Opción inválida. Selecciona 1-9${NC}"
                read -p "Presiona Enter para continuar..."
                ;;
        esac
    done
}

# ============================================
# EJECUTAR
# ============================================

# Capturar señales de interrupción
trap 'echo -e "\n${RED}[!] Interrupción detectada. Saliendo...${NC}"; exit 1' INT TERM

# Ejecutar programa principal
main
