#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "fileio.h"
#include <QQmlContext>
#include "fountainserial.h"

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    FileIO appIoManager("App");
    FileIO dataIoManager("Data");

    fountainSerial aTest;

    aTest.serializedProgram("Test 1");

      QQmlContext *thisContext = engine.rootContext();
    thisContext->setContextProperty("appIoManager", &appIoManager);
    thisContext->setContextProperty("dataIoManager", &dataIoManager);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
