#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "pressuredata.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    // load pressure data

    engine.rootContext()->setContextProperty("pressureData", new PressureData());

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
