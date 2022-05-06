#pragma once
#include <QObject>
#include <QPointer>

// Create a QT QObject based singleton class to handle the fake event
class FakeEvent : public QObject
{
    Q_OBJECT
public:
// Create a singleton instance of the class
    static FakeEvent* instance();

public Q_SLOTS:
    void messageCaller(const QString &caller);

Q_SIGNALS:
    void callerReceived(const QString &sender);

private:
    explicit FakeEvent(QObject *parent = nullptr);
    static FakeEvent* m_instance;
};