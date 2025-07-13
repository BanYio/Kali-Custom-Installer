#!/bin/bash

# Colores para el output
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

REAL_USER=$(logname)
QTERM_CONF="/home/$REAL_USER/.config/qterminal.org/qterminal.ini"

echo -e "${GREEN}[+] Cambiando esquema de colores de QTerminal a Tango...${RESET}"

# Reemplazar colorScheme=Kali-Dark por colorScheme=Tango
sed -i 's/^colorScheme=Kali-Dark/colorScheme=Tango/' "$QTERM_CONF"
echo -e "${GREEN}[+] Esquema de colores cambiado a Tango.${RESET}"

# Cambiar el valor de KeyboardCursorShape de 0 a 2
sed -i 's/^KeyboardCursorShape=[0-9]\+/KeyboardCursorShape=2/' "$QTERM_CONF"
echo -e "${GREEN}[+] Forma del cursor del teclado cambiada.${RESET}"

# Cambiar la transparencia de la terminal
sed -i 's/^ApplicationTransparency=[0-9]\+/ApplicationTransparency=0/' "$QTERM_CONF"
echo -e "${GREEN}[+] Transparencial de la terminal cambiada.${RESET}"

# Cambiar la fuente de la terminal
sed -i 's/^fontFamily=[^[:space:]]\+/fontFamily=Fira Code Retina/' "$QTERM_CONF"
echo -e "${GREEN}[+] Fuente y tamaño cambiada.${RESET}"



# Atajo de teclado para abrir clipmenu con CTRL+SHIFT+a
xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Control><Shift>a" -n -t string -s "clipmenu"

# Añadir atajo de teclado para abrir APPS con CTRL+SPACE
xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Primary>space" -n -t string -s "xfce4-appfinder"
echo -e "${GREEN}[+] Añadidos los atajos de teclado${RESET}"



# Añadir servicio de clipmenu para el usuario
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now clipmenud.service
echo -e "${GREEN}[+] Creado el servicio de usuario clipmenud${RESET}"
