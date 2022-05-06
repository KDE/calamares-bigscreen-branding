/*
 * Copyright 2021 Aditya Mehra <aix.m@outlook.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include "fakeqeventplugin.h"
#include "emulatedmouse.h"
#include "fakeEvent.h"
#include <QQmlContext>
#include <QQmlEngine>

// Create a static instance of fakeEvent that can register itself with QML as a singleton
static QObject *fakeEventSingletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(scriptEngine);

    //singleton managed internally, qml should never delete it
    engine->setObjectOwnership(FakeEvent::instance(), QQmlEngine::CppOwnership);
    return FakeEvent::instance();
}

void FakeQEventPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<EmulatedMouse>(uri, 1, 0, "EmulatedMouse");
    qmlRegisterSingletonType<FakeEvent>(uri, 1, 0, "FakeEvent", fakeEventSingletonProvider);
}

#include "moc_fakeqeventplugin.cpp"
