{
  # ----- References -----
  #
  # Arch Wiki:
  # - https://wiki.archlinux.org/title/Map_scancodes_to_keycodes
  # - https://wiki.archlinux.org/title/Keyboard_input#Identifying_scancodes
  # - https://wiki.archlinux.org/title/Udev#Remap_specific_device
  #
  # Keycode name lists:
  # - https://hal.freedesktop.org/quirk/quirk-keymap-list.txt
  # - https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h
  #
  # hwdb manual:
  # - https://www.man7.org/linux/man-pages/man7/hwdb.7.html
  #
  # ----- How to Remap -----
  #
  # 1. Identify device's evdev path:
  #   - Run `evtest` -> format: "/dev/input/eventX"
  #
  # 2. Identify keyboard scancodes:
  #   - Run `evtest /dev/input/eventX`
  #   - Check `MSC_SCAN` event values
  #
  # 3. Map scancodes to keycodes:
  #   - Use hwdb entries with KEYBOARD_KEY_<scancode>=<keycode>
  #
  # Optionally, identify device's modalias:
  #   - Run `cat /sys/class/input/eventX/device/modalias`
  #   - Format: "input:bXXXXvXXXXpXXXXeXXXX"

  services.udev.extraHwdb = ''
    # /dev/input/event0: AT Translated Set 2 keyboard
    # evdev:input:b0011v0001p0001eAB83*
    evdev:name:AT Translated Set 2 keyboard:*
     KEYBOARD_KEY_92=previoussong
     KEYBOARD_KEY_93=playpause
     KEYBOARD_KEY_94=nextsong
     KEYBOARD_KEY_95=esc
  '';
}
