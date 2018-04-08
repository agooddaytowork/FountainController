#include "fountainclient.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QTextCodec>


fountainClient::fountainClient(QObject *parent): QObject(parent), tcpSocket(new QTcpSocket(this)), m_Connected(false)
{

    in.setDevice(tcpSocket);
    in.setVersion(QDataStream::Qt_5_8);


    QObject::connect(tcpSocket, SIGNAL(readyRead()), this, SLOT(readyReadHandler()));
    QObject::connect(tcpSocket,&QTcpSocket::connected,[=](){
        setIsSVOnline(true);
        qDebug() << "connected";

    });

    QObject::connect(tcpSocket,&QTcpSocket::disconnected, [=](){
        setIsSVOnline(false);
    });

//    QObject::connect(tcpSocket,&QTcpSocket::error, [=](){
//       setIsSVOnline(false);
//    });

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

    qDebug()<< "Reply from SV: " + result;

}

void fountainClient::sendProgram( const QString &programName,const QByteArray &program)
{

    QJsonObject theOutObject;


    theOutObject.insert("UUID" , "PC");
    theOutObject.insert("ProgramName", programName);
    //   theOutObject.insert("ProgramData", QTextCodec::codecForMib(106)->toUnicode(program));
    theOutObject.insert("ProgramData", (QString) program.toHex());



    QByteArray block;

    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_5_8);

    out << QJsonDocument(theOutObject).toJson();

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
}

void fountainClient::disconnect()
{
     tcpSocket->close();
}
