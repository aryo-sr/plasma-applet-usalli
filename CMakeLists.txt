# set minimum CMake version (req'd for CMake 3.0 or later)
cmake_minimum_required(VERSION 3.16)

project(usalli)

set(KF5_MIN_VERSION "5.92.0")

# use Extra CMake Modules (ECM) for common functionality
find_package(ECM REQUIRED NO_MODULE)
# needed by find_package(KF5Plasma) below.
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR} ${CMAKE_MODULE_PATH})

# Locate plasma_install_package macro
find_package(KF5Plasma REQUIRED)
# Locate plasma_install_package macro.
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS
    Plasma
    I18n
    Notifications
)

# Add installation target ("make install")
plasma_install_package(package id.aryos.usalli)
# Copy applet icon
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/package/contents/icons/kaaba-svgrepo-com.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons)
