#!/bin/sh

export XDG_CURRENT_DESKTOP=i3
export XDG_SESSION_DESKTOP=i3
export XDG_SESSION_TYPE=x11

# Load Arch's X11 session initialization scripts.
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for script in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ -x "$script" ] && . "$script"
    done
    unset script
fi

exec i3
