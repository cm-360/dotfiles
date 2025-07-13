{
  # https://wiki.archlinux.org/title/Keyboard_input#Identifying_scancodes
  # https://wiki.archlinux.org/title/Map_scancodes_to_keycodes#Using_udev

  # AT Translated Set 2 keyboard
  # /dev/input/event0
  services.udev.extraHwdb = ''
    evdev:input:b0011v0001p0001eAB83*
     KEYBOARD_KEY_92=previoussong
     KEYBOARD_KEY_93=playpause
     KEYBOARD_KEY_94=nextsong
     KEYBOARD_KEY_95=esc
  '';
}
