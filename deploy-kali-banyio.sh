#!/bin/bash

#############
# VARIABLES #
#############

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

################
# APLICACIONES #
################

# Instalar aplicaciones
apt install bloodhound bloodhound.py mitm6 seclists flameshot golang dmenu xsel xdotool git libxfixes-dev -y
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
  if [[ ! -f "$PROTON_DEB" ]]; then
    wget -q https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb -O "$PROTON_DEB"
  else
    echo -e "${YELLOW}[-] Paquete de ProtonVPN ya descargado.${RESET}"
  fi
  dpkg -i "$PROTON_DEB" && apt update
  apt install proton-vpn-gnome-desktop -y
else
  echo -e "${YELLOW}[!] ProtonVPN ya está instalado, omitiendo instalación.${RESET}"
fi

# Instalar VSCodium
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

echo 'deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list

sudo apt update && sudo apt install codium

# Instalar kerbrute
echo -e "${GREEN}[+] Instalando kerbrute...${RESET}"
KERBRUTE_DIR="/opt/kerbrute"
if [ ! -d "$KERBRUTE_DIR" ]; then
    git clone https://github.com/ropnop/kerbrute.git "$KERBRUTE_DIR"
else
    echo -e "${YELLOW}[-] El repositorio de kerbrute ya está clonado en $KERBRUTE_DIR${RESET}"
fi
cd "$KERBRUTE_DIR"
go build -o kerbrute
if [ -f "./kerbrute" ]; then
    sudo mv kerbrute /usr/local/bin/
    echo -e "${GREEN}[+] kerbrute compilado y movido a /usr/local/bin/${RESET}"
else
    echo -e "${RED}[!] Fallo al compilar kerbrute${RESET}"
fi

# Instalar pyGPOAbuse
echo -e "${GREEN}[+] Instalando pyGPOAbuse...${RESET}"
pyGPOAbuse_DIR="/opt/pyGPOAbuse"
if [ ! -d "$pyGPOAbuse_DIR" ]; then
    git clone https://github.com/Hackndo/pyGPOAbuse.git "$pyGPOAbuse_DIR"
else
    echo -e "${YELLOW}[-] El repositorio de pyGPOAbuse ya está clonado en $pyGPOAbuse_DIR${RESET}"
fi
cd "$pyGPOAbuse_DIR"
pip install -r requirements.txt --break-system-packages
sudo cp pygpoabuse.py /usr/local/bin/pygpoabuse
echo -e "${GREEN}[+] pyGPOAbuse compilado y movido a /usr/local/bin/${RESET}"

# Instalar targetedKerberoast
echo -e "${GREEN}[+] Instalando targetedKerberoast...${RESET}"
targetedKerberoast_DIR="/opt/targetedKerberoast"
if [ ! -d "$targetedKerberoast_DIR" ]; then
    git clone https://github.com/ShutdownRepo/targetedKerberoast.git "$targetedKerberoast_DIR"
else
    echo -e "${YELLOW}[-] El repositorio de targetedKerberoast ya está clonado en $targetedKerberoast_DIR${RESET}"
fi
cd "$targetedKerberoast_DIR"
pip install -r requirements.txt --break-system-packages
sudo cp targetedKerberoast.py /usr/local/bin/targetedKerberoast
echo -e "${GREEN}[+] targetedKerberoast compilado y movido a /usr/local/bin/${RESET}"

# Instalar AutoNMAP
echo -e "${GREEN}[+] Instalando AutoNMAP...${RESET}"
AUTONMAP_DIR="/opt/AutoNMAP"
git clone https://github.com/BanYio/AutoNMAP.git "$AUTONMAP_DIR"
cd "$AUTONMAP_DIR"
chmod +x autonmap.sh
sudo cp autonmap.sh /usr/local/bin/autonmap
echo -e "${GREEN}[+] AutoNMAP instalado y movido a /usr/local/bin/${RESET}"

# Instalar clipmenu
echo -e "${GREEN}[+] Instalando Clipmenu...${RESET}"
CLIPMENU_DIR="/opt/clipmenu"
git clone https://github.com/cdown/clipmenu.git "$CLIPMENU_DIR"
cd "$CLIPMENU_DIR"
make clean
make
make install
sudo make install
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now clipmenud.service
echo -e "${GREEN}[+] Clipmenu instalado y creado el servicio de usuario clipmenud${RESET}"

# Atajo de teclado para abrir clipmenu con CTRL+SHIFT+a
xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Control><Shift>a" -n -t string -s "clipmenu"

############
# TERMINAL #
############

# Instalar OhMyZsh
echo -e "${GREEN}[+] Instalando Oh My Zsh para usuario $REAL_USER...${RESET}"

if [ ! -d "/home/$REAL_USER/.oh-my-zsh" ]; then
  sudo -u "$REAL_USER" -H bash -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
else
  echo -e "${YELLOW}[-] Oh My Zsh ya está instalado para $REAL_USER. Omitiendo.${RESET}"
fi

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

    # Cambiar la fuente de la terminal
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

###################
# PERSONALIZACIÓN #
###################

# Añadir fondo de pantalla a Pictures
cp "/home/$REAL_USER/Kali-Linux-ENV/wallpaper.PNG" "/home/$REAL_USER/Pictures/"
#git clone https://github.com/owerdogan/wallpapers-for-kali.git

# Añadir plugin al panel de kali-themes
cp xfce-panel-genmon-iplocal.sh /usr/share/kali-themes/
chmod +x /usr/share/kali-themes/xfce-panel-genmon-iplocal.sh
echo -e "${GREEN}[+] Restaurando panel XFCE para $REAL_USER...${RESET}"
echo -e "${GREEN}[+] Restaurando panel XFCE desde el archivo exportado...${RESET}"

# Descomprimir rockyou
gunzip /usr/share/wordlists/rockyou.txt.gz

# Añadir atajo de teclado para abrir APPS con CTRL+SPACE
xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Primary>space" -n -t string -s "xfce4-appfinder"

#####################################
#COMPROBACIÓN DE PAQUETES INSTALADOS#
#####################################

echo -e "\n${YELLOW}[*] Verificando instalaciones...${RESET}"
check_tool() {
    if command -v "$1" &>/dev/null; then
        echo -e "${GREEN}[✓] $1 instalado correctamente.${RESET}"
    else
        echo -e "${RED}[✗] $1 no está instalado o no se encuentra en PATH.${RESET}"
    fi
}
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}[✓] Archivo encontrado: $1${RESET}"
    else
        echo -e "${RED}[✗] Archivo no encontrado: $1${RESET}"
    fi
}
# Comprobaciones de herramientas
check_tool bloodhound
check_tool mitm6
check_tool flameshot
check_tool golang
check_tool certipy-ad
check_tool obsidian
check_tool google-chrome
check_tool protonvpn
check_tool codium
check_tool kerbrute
check_tool autonmap
check_tool clipmenu
# Comprobaciones de archivos/movidos
check_file /usr/local/bin/kerbrute
check_file /usr/local/bin/pygpoabuse
check_file /usr/local/bin/targetedKerberoast
check_file /usr/local/bin/autonmap
check_file /usr/share/kali-themes/xfce-panel-genmon-iplocal.sh
echo -e "${YELLOW}[*] Verificación finalizada.${RESET}"

############
# REINICIO #
############

#Reiniciar el sistema
echo ""
read -p "¿Deseas reiniciar el sistema ahora? [s/N]: " respuesta

case "$respuesta" in
    [sS]|[sS][iI])
        echo "Reiniciando el sistema..."
        sleep 2
        sudo reboot
        ;;
    *)
        echo "Reinicio cancelado. El sistema no se reiniciará."
        ;;
esac
