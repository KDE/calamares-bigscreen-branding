#include "emulatedmouse.h"
#include <QProcess>

EmulatedMouse::EmulatedMouse(QObject *parent)
    : QObject(parent)
{
}

void EmulatedMouse::moveMouseEvent(int posX, int posY)
{
    QStringList args;
    args << QStringLiteral("mousemove") << QString::number(posX) << QString::number(posY);
    QProcess::execute(QStringLiteral("xdotool"), args);
}

void EmulatedMouse::mouseClickEvent()
{
    QStringList args;
    args << QStringLiteral("click") << QStringLiteral("1");
    QProcess::execute(QStringLiteral("xdotool"), args);
}