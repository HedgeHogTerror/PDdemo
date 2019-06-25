#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#ifdef __arm__
#include <pigpio.h>
#endif

#include "pressuredata.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    // load pressure data
#ifdef __arm__

        if (gpioInitialise() < 0)

           {
              fprintf(stderr, "wiring initialisation failed\n");
              return 1;
           }
        else
        {
            fprintf(stderr, "wiring initialisation passed\n");
            engine.rootContext()->setContextProperty("pressureData", new PressureData());

        }
#endif
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
