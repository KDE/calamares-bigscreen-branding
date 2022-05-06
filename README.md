# calamares-bigscreen-branding

Bigscreen branding and customization for Plasma Bigscreen

#### Installation

  + cd calamares-bigscreen-branding
  + mkdir build
  + cd build
  + cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON
  + make
  + sudo make install

  + Calamares settings.conf in sample-settings needs to be installed manually to "/etc/calamares" for testing or is supplied by the distribution
