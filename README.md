# Kali Custom Installer

Kali Custom Installer es un script en Bash diseñado para desplegar de forma rápida y automatizada un entorno personalizado de Kali Linux, pensado para profesionales de ciberseguridad, pentesters y entusiastas que desean tener su entorno listo para trabajar sin perder tiempo configurando desde cero.

![image](https://github.com/user-attachments/assets/531a0182-0ae0-416c-9750-956f22497de3)

Este script configura y optimiza el sistema con herramientas esenciales, personalización de terminal, mejoras visuales y utilidades prácticas para el día a día en auditorías y laboratorios.

### I3-install


## Características principales
- Instalación automática de herramientas como:
kerbrute, pygpoabuse, bloodHound, entre otras.
- Navegadores y utilidades como Google Chrome, ProtonVPN y Obsidian.
- Terminal personalizada con Oh My Zsh, alias útiles y tema visual.
- Configuración de panel, entorno gráfico y otras personalizaciones para mayor productividad.
Ideal para montar entornos rápidos en máquinas virtuales o equipos recién formateados.

## Aplicaciones y herramientas
- bloodhound
- bloodhound.py
- bloodyad
- certipy-ad
- kerbrute
- pyGPOAbuse
- targetedKerberoast
- Obsidian
- Google-Chrome
- Proton-VPN
- VSCodium
- clipmenu
- OhMyZsh
- mitm6
- seclists
- flameshot
- golang
- dmenu
- xsel
- xdotool
- libxfixes-dev
- AutoNMAP

Además se añaden 2 atajos de teclado; para abrir APPS con **CTRL+SPACE** y abrir clipmenu con **CTRL+SHIFT+A**

## Requisitos
- Distribución Kali Linux (recomendado: versión actualizada).
- Permisos de superusuario.
- Conexión a Internet durante la instalación.

# Instalación
A continuación se detallan los pasos para ejecutar el script y desplegar el entorno personalizado en tu Kali Linux. El proceso es completamente automatizado, pero asegúrate de revisar y comprender lo que se instalará antes de ejecutarlo. Se recomienda hacerlo sobre una instalación limpia o en un entorno controlado.

- Primero actualizamos el sistema

```bash
sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove -y
```
- Una vez hemos actualizado el sistema, podemos instalar y ejecutar el script para personalizar nuestro entorno.
```bash
git clone https://github.com/BanYio/Kali-Custom-Installer.git
cd Kali-Custom-Installer.git
chmod +x *.sh
sudo ./deploy-kali-banyio.sh
```
- Durante la ejecución del script, en el momento de instalar *ohmyzsh*, tendremos que salir de esta nueva terminal que nos aparece en 2 ocasiones, ya que se instala tanto para el usuario que está ejecutando el script como para root.
```bash
exit
exit
```
![image](https://github.com/user-attachments/assets/29c50f70-671f-49a0-818c-47eae3212bd4)

Una vez ejecutado el script nos pedirá la opción de reinciar el equipo para que todos los cambios se apliquen correctamente, este paso no es obligatorio, pero si **recomendable**.

# Personalización

Despúes de reiniciar el equipo, podemos ejecutar el script para la personalización de la terminal y los atajos de teclado.

```bash
./change-terminal-and-shortcuts.sh
```

Es necesario reiniciar la terminal para que se apliquen los cambios.

Ahora podemos añadir el panel personalizado y el fondo de pantalla. Para ello vamos a la barra del panel, click derecho, panel, Panel Preferences.

![image](https://github.com/user-attachments/assets/0305d0ea-cf37-4207-81fd-9ae2fd3c793b)

Ahora le damos a BackUp & Restore, e importamos el panel del repositorio

![image](https://github.com/user-attachments/assets/676dddba-9405-436a-b66a-66707c2a847f)

Una vez hemos añadido el panel personalizado, lo seleccionamos y le damos a aplicar, nos aparecerá un error, le damos a **REMOVE** y funciona perfectamente.

![image](https://github.com/user-attachments/assets/5663d9c0-5fb6-4251-ae84-66673b59f6af)

Ahora ya tenemos el entorno personalizado con herramientas que pueden ser bastante útiles en nuestro día a día como pentesters.

