# Desktop Management
Linux desktop management and related notes
==============================================================================
I prefer XFCE **overall**, but I really like some features of GNOME better for
*desktop* UX. 
<https://wiki.archlinux.org/index.php/xfce>
## XFCE

`startxfce4` OR `echo "exec startxfce4" >> ~/.xinitrc` and then use `startx`
or `xinit` as usual.

##### Config
Launch: `xfce4-settings-editor`
or use: `xconf-query` for command-line

copy `/etc/xdg/xfce4/xinitrc` to `~/.config/xfce4/` and edit for user control.

`/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml`

`cp /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml \
~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml`

`<value type="string" value="xfwm4"/>`
to
`<value type="string" value="window_manager_executable"/>`

*Or using command-line:*
`window_manager --replace`

##### Misc (Troubleshooting)
`/etc/X11/Xwrapper.config` `needs_root_rights = no` (or 'yes')
`exec startx -- -keeptty -nolisten tcp > ~/.xorg.log 2>&1`
