#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "fileio.h"
#include <QQmlContext>
#include "fountainserial.h"
#include "fountainclient.h"
#include <QStandardPaths>

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN) || defined(Q_OS_ANDROID)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    app.setOrganizationName("Tam Duong");
    app.setOrganizationDomain("tamduongs.com");
    app.setApplicationName("Fountain Controller");
    QQmlApplicationEngine engine;

    FileIO appIoManager("App");
    FileIO dataIoManager("Data");

//    qDebug()<< QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);

    fountainSerial fountainProgramSerializer;
    fountainClient aClient;

      QQmlContext *thisContext = engine.rootContext();
    thisContext->setContextProperty("appIoManager", &appIoManager);
    thisContext->setContextProperty("dataIoManager", &dataIoManager);
    thisContext->setContextProperty("fountainProgramSerializer", &fountainProgramSerializer);
    thisContext->setContextProperty("theTcpClient", &aClient);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
