#ifndef FOUNTAINSERIAL_H
#define FOUNTAINSERIAL_H

#include <QDebug>
#include <QMap>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>

#include "fountainglobalconfig.h"
#include "fileio.h"


class fountainSerial : public QObject
{
    Q_OBJECT

    static constexpr quint8 m_startFlag = 0xFD;
    static constexpr quint8 m_endFlag = 0xFE;
    static constexpr quint8 m_escFlag  = 0x7F;
    static constexpr quint8 m_fountainNumber = 9;
    static constexpr quint8 m_dummyProgramNo = 0;
    static constexpr quint8 m_playProgram = 0x01;
    static constexpr quint8 m_playSpeed = 0x02;
    static constexpr quint8 m_fountainSetting = 0x03;

    QByteArray m_ProgramData;
    quint16 m_GroupIDandEnable;
    quint8 m_DataLength;
    QMap<quint8, QByteArray> m_serialPackage;
    bool m_GroupSyncing;

    QByteArray byteStuffing(const quint8 &data);
    void resetGroupIdandEnable();

    void setEnableFountainInGroup(const QJsonObject &data);
    void setGroupID(const quint16 &id);
    void setProgramData(QJsonObject data);
    QByteArray generateSerializedByteArray();

public:
    fountainSerial( QObject * parent = nullptr);

    Q_INVOKABLE  QByteArray serializedProgram(const QString &programName);
    Q_INVOKABLE bool getGroupSync();
    Q_INVOKABLE void setGroupSync(const bool &input);
    Q_INVOKABLE  QByteArray serializeSpeed(const int &programNo, const int &speed);

signals:
    void out(QHash<int, QVariant>);
};

#endif // FOUNTAINSERIAL_H
