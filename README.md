# Usalli

A Plasmoid for showing Islamic prayer times schedule. Work with KDE Plasma Framework >= 5.92.

## Requirements

### Kubuntu 22.04

```
sudo apt install qml-module-org-kde-kconfig qml-module-org-kde-notification
```

### Fedora 37 KDE

```
sudo dnf install kf5-kconfig kf5-knotifications kf5-ki18n
```

## Installing

Build manually with CMake. Change `<your_username>` with your Linux user name.

### Build Requirements

**Kubuntu 22.04**

```
sudo apt install cmake extra-cmake-modules gettext g++ qml-module-org-kde-kconfig qml-module-org-kde-notification libkf5config-dev libkf5i18n-dev libkf5plasma-dev libkf5notifications-dev plasma-workspace-dev
```

**Fedora 37 KDE**

```
sudo dnf install cmake extra-cmake-modules plasma-workspace-devel kf5-kconfig-devel kf5-knotifications-devel kf5-plasma-devel kf5-ki18n-devel
```

Then from project directory.

```
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/home/<your_username>/.local ..
make install
```

## Install Manually

Download this repo as ZIP, then extract it.
Then copy folder `package` to `/home/<your_username>/.local/share/plasma/plasmoids` and rename it to `id.aryos.usalli`.

Then you can add the widget to KDE Plasma.

![Screenshot](screenshot.png)

## To Do List

- [x] Adjust calculation
- [x] Time remaining
- [x] Adjust row alignment
- [x] Adjust isya show next day
- [x] Highlight next prayer
- [x] Tooltip next prayer
- [x] Add imsak time
- [x] Config location
- [x] Config show imsak
- [x] Notification popup
- [x] Custom icon
- [ ] Add dhuha time: 15+ sunrise & 15- dhuhr
- [ ] Tooltip hijri calendar
- [ ] Show hijri calendar
- [ ] Config show next prayer label rather than icon in task bar
- [ ] Config others: madhab, calculation method
- [ ] Config adjust hijri day
- [ ] Get kde geolocation data / gmaps api get lang lot search city
- [ ] Play adzan / Alarm
- [ ] Show next / previous day button
- [ ] Imsakiyah schedule
- [ ] Linux packaging

## License

Please refer to LICENSE file.
