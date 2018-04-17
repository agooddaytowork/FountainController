#include "fountainclient.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QTextCodec>
#include "tcppackager.h"


fountainClient::fountainClient(QObject *parent): QObject(parent), tcpSocket(new QTcpSocket(this)), m_Connected(false), m_IsFountainOnline(false), m_CurrentControllingId("")
{
    in.setDevice(tcpSocket);
    in.setVersion(QDataStream::Qt_5_8);


    QObject::connect(tcpSocket, SIGNAL(readyRead()), this, SLOT(readyReadHandler()));
    QObject::connect(tcpSocket,&QTcpSocket::connected,[=](){
        setIsSVOnline(true);
        qDebug() << "connected";

        if(!m_IsFountainOnline)
        {
            QByteArray block;

            QDataStream out(&block, QIODevice::WriteOnly);
            out.setVersion(QDataStream::Qt_5_8);
            // check for fountain Online Status

            out << tcpPackager::requestToAddNewClient();
            qDebug() << tcpSocket->write(block);

            out <<tcpPackager::AskWhoIsControlling();
            qDebug() << tcpSocket->write(block);

        }

    });

    QObject::connect(tcpSocket,&QTcpSocket::disconnected, [=](){
        setIsSVOnline(false);
    });

    //    QObject::connect(tcpSocket,&QTcpSocket::error, [=](){
    //       setIsSVOnline(false);
    //    });

    QObject::connect(tcpSocket,&QTcpSocket::aboutToClose,[=](){

        QByteArray block;

        QDataStream out(&block, QIODevice::WriteOnly);
        out.setVersion(QDataStream::Qt_5_8);

        out << tcpPackager::aboutToDisconnect();

        tcpSocket->write(block);
    });

}

void fountainClient::connect(const QString &ip, const quint16 &port)
{

    tcpSocket->connectToHost(ip, port);
}

void fountainClient::connect()
{
    tcpSocket->connectToHost(m_ip, m_port);
}

void fountainClient::readyReadHandler()
{

    in.startTransaction();
    QByteArray result;
    in >> result;

    if(tcpPackager::isPackageValid(result))
    {
        QJsonObject svReply = tcpPackager::packageToJson(result);

        QString theCommand = svReply["Command"].toString();

        if(theCommand == "fountainCurrentPlayingProgram")
        {

        }
        else if (theCommand == "fountainStatus") {

            setIsFountainOnline(svReply["Data"].toBool());
        }
        else if(theCommand == "fountainResponse")
        {

        }
        else if(theCommand == "Disconnecting")
        {

        }
        else if(theCommand == "whoIsControlling")
        {
            m_CurrentControllingId = svReply["ClientId"].toString();
            if(svReply["ClientId"].toString() == tcpPackager::m_clientId)
            {
                // this device is not in control
                // popUp dialog to user
                // yeah, can control shit!
                // do nothing at the moment ha!
#if fountainClientDebug
                qDebug() << "whoIsControlling - yeah, you have permission baby";
#endif
                QByteArray block;

                QDataStream out(&block, QIODevice::WriteOnly);
                out.setVersion(QDataStream::Qt_5_8);
                out << tcpPackager::isFountainOnline();
                qDebug() << tcpSocket->write(block);

            }
            else
            {
                emit needToReQuestPermission();
#if fountainClientDebug
                qDebug() << "whoIsControlling - don't have permission ha -> request di";
#endif
            }

        }

    }

    qDebug()<< "Reply from SV: " + result;

}

void fountainClient::sendProgram( const QString &programName,const QByteArray &program)
{


    QByteArray block;

    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_5_8);

    out << tcpPackager::playProgram(programName,program);

    tcpSocket->write(block);


}

void fountainClient::sendSpeed(const QByteArray &data)
{
    QByteArray block;

    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_5_8);

    out << tcpPackager::playSpeed(data);

    tcpSocket->write(block);
}

void fountainClient::setHostName(const QString &hostName)
{
    m_ip = hostName;
}

void fountainClient::setPort(const quint16 &port)
{

    m_port = port;
}

bool fountainClient::isSVOnline() const
{
    return m_Connected;
}

void fountainClient::setIsSVOnline(bool input)
{
    if(m_Connected != input)
    {
        m_Connected = input;
        emit isSVOnlineChanged(input);
    }

    if(!m_Connected)
    {
        setIsFountainOnline(false);
    }
}

void fountainClient::disconnect()
{
    tcpSocket->close();
}

void fountainClient::requestPermission()
{
    QByteArray block;

    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_5_8);

    out << tcpPackager::requestToGetPermission();

    tcpSocket->write(block);
}

bool fountainClient::isFountainOnline() const
{
    return m_IsFountainOnline;
}

void fountainClient::setIsFountainOnline(bool input)
{
    if(m_IsFountainOnline != input)
    {
        m_IsFountainOnline = input;
        emit isFountainOnlineChanged(input);
    }
}
