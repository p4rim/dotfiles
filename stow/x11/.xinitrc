#!/bin/sh

# Publish the X display and authorization to D-Bus/systemd user services,
# including the GCR keyring password dialog.
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for script in /etc/X11/xinit/xinitrc.d/*.sh; do
        if [ -r "$script" ]; then
            . "$script"
        fi
    done
    unset script
fi

exec dwm
