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

## License

Please refer to LICENSE file.
