#include "fakeEvent.h"

FakeEvent *FakeEvent::instance()
{
    static FakeEvent* s_self = nullptr;
    if (!s_self) {
        s_self = new FakeEvent;
    }
    return s_self;
}

FakeEvent::FakeEvent(QObject *parent)
    : QObject(parent)
{
}

void FakeEvent::messageCaller(const QString &caller)
{
    emit callerReceived(caller);
}

#include "moc_fakeEvent.cpp"