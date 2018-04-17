#include "tcppackager.h"

tcpPackager::tcpPackager()
{

}

QString tcpPackager::m_clientId = tcpPackager::generateClientId();
QString tcpPackager::generateClientId()
{

    static QString id =  QCryptographicHash::hash("clientId" + QByteArray::number(QDateTime::currentMSecsSinceEpoch()),QCryptographicHash::Sha256);


    return id;

}


QByteArray tcpPackager::playProgram(const QString &programName, const QByteArray &Program)
{
    QJsonObject thePackage;

    qint64 theTimeStamp = QDateTime::currentMSecsSinceEpoch();
    QByteArray time;
    time.append(QString::number(theTimeStamp));
    thePackage.insert("ClientId", m_clientId);
    thePackage.insert("ClientType", m_clientType);
    thePackage.insert("UUID", (QString) QCryptographicHash::hash(theSecretKey + time, QCryptographicHash::Sha256));
    thePackage.insert("TimeStamp",QString::number(theTimeStamp) );
    thePackage.insert("Command", "playProgram");
    thePackage.insert("ProgramName", programName);
    thePackage.insert("ProgramData", (QString) Program.toHex());

    QJsonDocument aDocument(thePackage);
    return aDocument.toJson();
}

QByteArray tcpPackager::playSpeed(const QByteArray &data)
{
    QJsonObject thePackage;

    qint64 theTimeStamp = QDateTime::currentMSecsSinceEpoch();
    QByteArray time;
    time.append(QString::number(theTimeStamp));
    thePackage.insert("ClientId", m_clientId);
    thePackage.insert("ClientType", m_clientType);
    thePackage.insert("UUID", (QString) QCryptographicHash::hash(theSecretKey + time, QCryptographicHash::Sha256));
    thePackage.insert("TimeStamp",QString::number(theTimeStamp) );
    thePackage.insert("Command", "playSpeed");
    thePackage.insert("Speed", (QString) data.toHex());

    QJsonDocument aDocument(thePackage);
    return aDocument.toJson();
}


bool tcpPackager::isPackageValid(const QByteArray &input)
{
    QJsonObject thePackage = packageToJson(input);

    if(!thePackage.isEmpty())
    {
        QByteArray time;
        time.append(thePackage["TimeStamp"].toString());
        QString UUID = QCryptographicHash::hash(theSecretKey + time, QCryptographicHash::Sha256);

        if (UUID == thePackage["UUID"].toString())
        {
            return true;
        }
    }
    return false;
}

QJsonObject tcpPackager::packageToJson(const QByteArray &input)
{
    QJsonDocument aDocument(QJsonDocument::fromJson(input));
    return aDocument.object();
}


QByteArray tcpPackager::isFountainOnline()
{
    QJsonObject thePackage;

    qint64 theTimeStamp = QDateTime::currentMSecsSinceEpoch();
    QByteArray time;
    time.append(QString::number(theTimeStamp));
    thePackage.insert("ClientId", m_clientId);
    thePackage.insert("ClientType", m_clientType);
    thePackage.insert("UUID", (QString) QCryptographicHash::hash(theSecretKey + time, QCryptographicHash::Sha256));
    thePackage.insert("TimeStamp",QString::number(theTimeStamp) );
    thePackage.insert("Command", "isFountainOnline");

    QJsonDocument aDocument(thePackage);
    return aDocument.toJson();
}

QByteArray tcpPackager::fountainResponse(const QByteArray &response)
{
    QJsonObject thePackage;

    qint64 theTimeStamp = QDateTime::currentMSecsSinceEpoch();
    QByteArray time;
    time.append(QString::number(theTimeStamp));

    thePackage.insert("UUID", (QString) QCryptographicHash::hash(theSecretKey + time, QCryptographicHash::Sha256));
    thePackage.insert("TimeStamp",QString::number(theTimeStamp) );
    thePackage.insert("Command", "fountainResponse");
    thePackage.insert("Data", (QString) response.toHex());
    QJsonDocument aDocument(thePackage);
    return aDocument.toJson();
}

QByteArray tcpPackager::fountainStatus(const bool &status)
{
    QJsonObject thePackage;

    qint64 theTimeStamp = QDateTime::currentMSecsSinceEpoch();
    QByteArray time;
    time.append(QString::number(theTimeStamp));
    thePackage.insert("UUID", (QString) QCryptographicHash::hash(theSecretKey + time, QCryptographicHash::Sha256));
    thePackage.insert("TimeStamp",QString::number(theTimeStamp) );
    thePackage.insert("Command", "fountainStatus");
    thePackage.insert("Data", status);
    QJsonDocument aDocument(thePackage);
    return aDocument.toJson();
}


QByteArray tcpPackager::fountainCurrentPlayingProgram(const QString &program)
{
    QJsonObject thePackage;

    qint64 theTimeStamp = QDateTime::currentMSecsSinceEpoch();
    QByteArray time;
    time.append(QString::number(theTimeStamp));
    thePackage.insert("UUID", (QString) QCryptographicHash::hash(theSecretKey + time, QCryptographicHash::Sha256));
    thePackage.insert("TimeStamp",QString::number(theTimeStamp) );
    thePackage.insert("Command", "fountainCurrentPlayingProgram");
    thePackage.insert("Data", program);
    QJsonDocument aDocument(thePackage);
    return aDocument.toJson();
}

QByteArray tcpPackager::AnswerWhoIsControlling(const QString &clientId, const int &clientType)
{
    QJsonObject thePackage;

    qint64 theTimeStamp = QDateTime::currentMSecsSinceEpoch();
    QByteArray time;
    time.append(QString::number(theTimeStamp));
    thePackage.insert("UUID", (QString) QCryptographicHash::hash(theSecretKey + time, QCryptographicHash::Sha256));
    thePackage.insert("TimeStamp",QString::number(theTimeStamp) );
    thePackage.insert("Command", "whoIsControlling");
    thePackage.insert("clientId", clientId);
    thePackage.insert("clientType", clientType);
    QJsonDocument aDocument(thePackage);
    return aDocument.toJson();
}

QByteArray tcpPackager::AskWhoIsControlling()
{
    QJsonObject thePackage;
    qint64 theTimeStamp = QDateTime::currentMSecsSinceEpoch();
    QByteArray time;
    time.append(QString::number(theTimeStamp));
    thePackage.insert("ClientId", m_clientId);
    thePackage.insert("ClientType", m_clientType);
    thePackage.insert("UUID", (QString) QCryptographicHash::hash(theSecretKey + time, QCryptographicHash::Sha256));
    thePackage.insert("TimeStamp",QString::number(theTimeStamp) );
    thePackage.insert("Command", "whoIsControlling");

    QJsonDocument aDocument(thePackage);
    return aDocument.toJson();
}

QByteArray tcpPackager::requestToAddNewClient()
{
    QJsonObject thePackage;
    qint64 theTimeStamp = QDateTime::currentMSecsSinceEpoch();
    QByteArray time;
    time.append(QString::number(theTimeStamp));
    thePackage.insert("ClientId", m_clientId);
    thePackage.insert("ClientType", m_clientType);
    thePackage.insert("UUID", (QString) QCryptographicHash::hash(theSecretKey + time, QCryptographicHash::Sha256));
    thePackage.insert("TimeStamp",QString::number(theTimeStamp) );
    thePackage.insert("Command", "addNewClient");

    QJsonDocument aDocument(thePackage);
    return aDocument.toJson();

}

QByteArray tcpPackager::requestToGetPermission()
{
    QJsonObject thePackage;
    qint64 theTimeStamp = QDateTime::currentMSecsSinceEpoch();
    QByteArray time;
    time.append(QString::number(theTimeStamp));
    thePackage.insert("ClientId", m_clientId);
    thePackage.insert("ClientType", m_clientType);
    thePackage.insert("UUID", (QString) QCryptographicHash::hash(theSecretKey + time, QCryptographicHash::Sha256));
    thePackage.insert("TimeStamp",QString::number(theTimeStamp) );
    thePackage.insert("Command", "getControlPermission");

    QJsonDocument aDocument(thePackage);
    return aDocument.toJson();
}

QByteArray tcpPackager::aboutToDisconnect()
{
    QJsonObject thePackage;
    qint64 theTimeStamp = QDateTime::currentMSecsSinceEpoch();
    QByteArray time;
    time.append(QString::number(theTimeStamp));
    thePackage.insert("ClientId", m_clientId);
    thePackage.insert("ClientType", m_clientType);
    thePackage.insert("UUID", (QString) QCryptographicHash::hash(theSecretKey + time, QCryptographicHash::Sha256));
    thePackage.insert("TimeStamp",QString::number(theTimeStamp) );
    thePackage.insert("Command", "Disconnecting");

    QJsonDocument aDocument(thePackage);
    return aDocument.toJson();
}

