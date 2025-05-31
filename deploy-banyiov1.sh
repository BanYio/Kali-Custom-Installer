#!/bin/bash

# Colores para el output
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

echo -e "${YELLOW}[*] Iniciando script de configuración de entorno Kali...${RESET}"

# Real user
REAL_USER=$(logname)
USER_ZSHRC="/home/$REAL_USER/.zshrc"

# Ruta al archivo de configuración de QTerminal
QTERM_CONF="/home/$REAL_USER/.config/qterminal.org/qterminal.ini"

# Ruta de la imagen de fondo
WALLPAPER_PATH="/home/$REAL_USER/Pictures/wallpaper.PNG"

# Verificar si se ejecuta como root
if [[ "$EUID" -ne 0 ]]; then
  echo -e "${RED}[!] Este script debe ejecutarse como root. Usa sudo.${RESET}"
  exit 1
fi

# Función para verificar si un paquete está instalado
check_installed() {
  if dpkg -s "$1" &>/dev/null; then
    echo -e "${YELLOW}[-] $1 ya está instalado.${RESET}"
    return 0  # Paquete ya instalado
  else
    return 1  # Paquete no instalado
  fi
}

# Actualizar el sistema
# echo -e "${GREEN}[+] Actualizando el sistema...${RESET}"
# apt update && apt full-upgrade -y
# apt autoremove -y

# Instalar aplicaciones
apt install bloodhound bloodhound.py mitm6 seclists flameshot golang ntpdate codium -y
sudo -u "$REAL_USER" pip install certipy-ad --break-system-packages

# Instalar Obsidian
if ! check_installed obsidian; then
  echo -e "${GREEN}[+] Instalando Obsidian...${RESET}"
  OBSIDIAN_DEB="/tmp/obsidian.deb"
  wget -q https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.10/obsidian_1.8.10_amd64.deb -O "$OBSIDIAN_DEB"
  dpkg -i "$OBSIDIAN_DEB" || apt -f install -y
  rm "$OBSIDIAN_DEB"
else
  echo -e "${YELLOW}[!] Obsidian ya está instalado, omitiendo instalación.${RESET}"
fi

# Instalar Google Chrome
if ! check_installed google-chrome-stable; then
  echo -e "${GREEN}[+] Instalando Google Chrome...${RESET}"
  CHROME_DEB="/tmp/google-chrome.deb"
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O "$CHROME_DEB"
  dpkg -i "$CHROME_DEB" || apt -f install -y
  rm "$CHROME_DEB"
else
  echo -e "${YELLOW}[!] Google Chrome ya está instalado, omitiendo instalación.${RESET}"
fi

# Instalar ProtonVPN GUI oficial
if ! check_installed proton-vpn-gnome-desktop; then
  echo -e "${GREEN}[+] Instalando ProtonVPN (GUI oficial)...${RESET}"

  PROTON_DEB="/tmp/protonvpn-stable-release_1.0.8_all.deb"

  # Descargar el paquete del repositorio de ProtonVPN
  if [[ ! -f "$PROTON_DEB" ]]; then
    wget -q https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb -O "$PROTON_DEB"
  else
    echo -e "${YELLOW}[-] Paquete de ProtonVPN ya descargado.${RESET}"
  fi

  # Instalar el repositorio y actualizar
  dpkg -i "$PROTON_DEB" && apt update
  apt install proton-vpn-gnome-desktop -y
else
  echo -e "${YELLOW}[!] ProtonVPN ya está instalado, omitiendo instalación.${RESET}"
fi

echo -e "${GREEN}[+] Instalando Oh My Zsh para usuario $REAL_USER...${RESET}"

if [ ! -d "/home/$REAL_USER/.oh-my-zsh" ]; then
  sudo -u "$REAL_USER" -H bash -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
else
  echo -e "${YELLOW}[-] Oh My Zsh ya está instalado para $REAL_USER. Omitiendo.${RESET}"
fi

#
#TERMINAL
#

# Instalar Oh My Zsh si no está ya instalado
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo -e "${GREEN}[+] Instalando Oh My Zsh...${RESET}"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo -e "${YELLOW}[-] Oh My Zsh ya está instalado. Omitiendo instalación.${RESET}"
fi

# Añadiendo los plugins a la ZSH
echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$USER_ZSHRC"
echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> /root/.zshrc
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$USER_ZSHRC"
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /root/.zshrc

echo -e "${GREEN}[+] Cambiando esquema de colores de QTerminal a Tango...${RESET}"

# Comprobar si el archivo existe
if [ -f "$QTERM_CONF" ]; then
    # Reemplazar colorScheme=Kali-Dark por colorScheme=Tango
    sed -i 's/^colorScheme=Kali-Dark/colorScheme=Tango/' "$QTERM_CONF"
    echo -e "${GREEN}[+] Esquema de colores cambiado a Tango.${RESET}"

    # Cambiar el valor de KeyboardCursorShape de 0 a 2
    sed -i 's/^KeyboardCursorShape=[0-9]\+/KeyboardCursorShape=2/' "$QTERM_CONF"
    echo -e "${GREEN}[+] Forma del cursor del teclado cambiada.${RESET}"

    # Cambiar el la transparencia de la terminal
    sed -i 's/^ApplicationTransparency=[0-9]\+/ApplicationTransparency=0/' "$QTERM_CONF"
    echo -e "${GREEN}[+] Transparencial de la terminal cambiada.${RESET}"

    # Cambiar el la fuente de la terminal
    sed -i 's/^fontFamily=[^[:space:]]\+/fontFamily=Fira Code SemiBold/' "$QTERM_CONF"
    echo -e "${GREEN}[+] Fuente y tamaño cambiada.${RESET}"
else
    echo -e "${YELLOW}[-] El archivo de configuración de QTerminal no se encontró en $QTERM_CONF${RESET}"
fi

# Cambiar el tema robbyrussell.zsh-theme solo para root
echo -e "${GREEN}[+] Personalizando tema robbyrussell para el usuario root...${RESET}"

cat > /root/.oh-my-zsh/themes/robbyrussell.zsh-theme << 'EOF'
PROMPT="%(?:%{$fg_bold[red]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[red]%}%c%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[green]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%})"
EOF


####Cambiar fondo de pantalla#####
cp wallpaper.PNG /home/banyio/Pictures/

#echo -e "${GREEN}[+] Estableciendo fondo de pantalla...${RESET}"

#Cambiar el fondo de escritorio
#xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -s /home/"$REAL_USER"/Pictures/wallpaper.PNG

#Poner la imagen centrada
#xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/image-style -s 1

#Quitar iconos del Escritorio
#xfconf-query -c xfce4-desktop -p /desktop-icons/style -s 0

# Configuracion de la barra.
cp xfce-panel-genmon-iplocal.sh /usr/share/kali-themes/
chmod +x /usr/share/kali-themes/xfce-panel-genmon-iplocal.sh

echo -e "${GREEN}[+] Restaurando panel XFCE para $REAL_USER...${RESET}"
echo -e "${GREEN}[+] Restaurando panel XFCE desde el archivo exportado...${RESET}"

# Ruta al archivo del panel exportado
PANEL_ARCHIVE="./banyio-panel.tar.bz2"

# Directorio de configuración de XFCE
REAL_USER_HOME=$(eval echo "~$REAL_USER")
XFCE_CONFIG_DIR="$REAL_USER_HOME/.config/xfce4"

# Verifica si el archivo existe
if [ -f "$PANEL_ARCHIVE" ]; then
    # Crear el directorio necesario para el panel si no existe
    sudo -u "$REAL_USER" mkdir -p "$XFCE_CONFIG_DIR/panel"

    # Extraer el archivo en la ubicación correcta
    sudo -u "$REAL_USER" tar -xjf "$PANEL_ARCHIVE" -C "$XFCE_CONFIG_DIR/panel/"

    echo -e "${GREEN}[+] Panel restaurado correctamente.${RESET}"
else
    echo -e "${RED}[-] No se encontró el archivo del panel: $PANEL_ARCHIVE${RESET}"
fi

# Verifica que el archivo exista
if [ -f "$PANEL_ARCHIVE" ]; then
    # Extraer los ficheros dentro del directorio correspondiente
    sudo -u "$REAL_USER" tar -xjf "$PANEL_ARCHIVE" -C "$REAL_USER_HOME/.config/xfce4/panel/"
    echo -e "${GREEN}[+] Panel XFCE restaurado correctamente.${RESET}"

else
    echo -e "${RED}[-] No se encontró el archivo del panel: $PANEL_ARCHIVE${RESET}"
fi

# Instalar kerbrute
echo -e "${GREEN}[+] Instalando kerbrute...${RESET}"
KERBRUTE_DIR="/opt/kerbrute"

# Verificar si ya está clonado
if [ ! -d "$KERBRUTE_DIR" ]; then
    git clone https://github.com/ropnop/kerbrute.git "$KERBRUTE_DIR"
else
    echo -e "${YELLOW}[-] El repositorio de kerbrute ya está clonado en $KERBRUTE_DIR${RESET}"
fi

# Entrar al directorio y compilar
cd "$KERBRUTE_DIR" || { echo -e "${RED}[!] No se pudo acceder al directorio kerbrute${RESET}"; exit 1; }

# Compilar y mover el binario
go build -o kerbrute
if [ -f "./kerbrute" ]; then
    sudo mv kerbrute /usr/local/bin/
    echo -e "${GREEN}[+] kerbrute compilado y movido a /usr/local/bin/${RESET}"
else
    echo -e "${RED}[!] Fallo al compilar kerbrute${RESET}"
fi

#Descomprimir rockyou
gunzip /usr/share/wordlists/rockyou.txt.gz

#Arreglar la base de datos para bloodhound
sudo -u postgres psql -c "ALTER DATABASE template1 REFRESH COLLATION VERSION;"
sudo -u postgres psql -c "ALTER DATABASE postgres REFRESH COLLATION VERSION;"


