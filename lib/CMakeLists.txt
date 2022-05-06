set(fakeqevent_SRCS fakeqeventplugin.cpp emulatedmouse.cpp fakeEvent.cpp)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(fakeqeventplugin SHARED ${fakeqevent_SRCS} ${RESOURCES})

target_link_libraries(fakeqeventplugin
    Qt5::Core
    Qt5::Quick
    Qt5::Qml
    Qt5::Test
)

########### install files ###############
install(TARGETS fakeqeventplugin DESTINATION ${KDE_INSTALL_QMLDIR}/Libfakeqevents)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/Libfakeqevents)
install(FILES plugins.qmltypes DESTINATION ${KDE_INSTALL_QMLDIR}/Libfakeqevents)
