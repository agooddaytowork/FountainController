#include "fountainserial.h"

QByteArray &operator<<(QByteArray &l, quint8 r)
{
    l.append(r);
    return l;
}

QByteArray &operator<<(QByteArray &l, quint16 r)
{
    return l<<quint8(r>>8)<<quint8(r);
}

QByteArray &operator<<(QByteArray &l, quint32 r)
{
    return l<<quint16(r>>16)<<quint16(r);
}


fountainSerial::fountainSerial(QObject *parent): QObject(parent), m_GroupIDandEnable(0), m_GroupSyncing(false)
{
    m_ProgramData.clear();
    m_serialPackage.clear();

}

QByteArray fountainSerial::serializedProgram(const QString &programName)
{
    FileIO dataIoManager("Data");

    QByteArray aData;

    aData.append(dataIoManager.read("Data"));

    QJsonDocument aJsonDocument(QJsonDocument::fromJson(aData));
    //    aJsonDocument.fromJson(aData);

    QJsonArray programArray = aJsonDocument.array();


    foreach (const QJsonValue &theProgram, programArray) {

        if(theProgram.toObject()["programName"].toString() == programName)
        {

            for(int i = 0; i < theProgram.toObject()["groups"].toArray().count(); i++)
            {
                m_GroupSyncing = true;

                if(theProgram.toObject()["groups"].toArray().at(i)["fountainGroupEnable"].toBool() == true)
                {

                    resetGroupIdandEnable();
                    setGroupID(intToFountainGroupIDBitBang.value(i));
                    setEnableFountainInGroup(theProgram.toObject()["groups"].toArray().at(i).toObject());
                    setProgramData(theProgram.toObject()["groups"].toArray().at(i).toObject());

                }
                else
                {
                    resetGroupIdandEnable();
                    setGroupID(intToFountainGroupIDBitBang.value(i));

                    m_ProgramData.clear();
                    for(int ii =0; ii < m_fountainNumber; ii++)
                    {
                        m_ProgramData.append(m_dummyProgramNo);
                    }
                }
                m_serialPackage.insert(i, generateSerializedByteArray());

            }

            QByteArray test;

            test << m_startFlag;
            foreach (QByteArray member, m_serialPackage) {

                test.append(member);
            }

            test << m_endFlag;


#if fountainSerialDebug
            qDebug() << "Message length: " + test.length();
            qDebug() << test;
#endif

            return test;
        }

    }

    return QByteArray();
}

QByteArray fountainSerial::generateSerializedByteArray()
{
    QByteArray output;

    if(!m_GroupSyncing) output.append(m_startFlag);
    output<<m_GroupIDandEnable;

    output.append(m_ProgramData);
    if(!m_GroupSyncing) output.append(m_endFlag);


    return output;
}

void fountainSerial::setProgramData( QJsonObject data)
{
    int i = 0;

    m_ProgramData.clear();

    foreach (QJsonValue theFountain, data["fountains"].toArray()) {

        m_ProgramData.append(byteStuffing(theFountain.toObject()["fountainProgram"].toInt()));

        i++;
    }
    while(i < m_fountainNumber)
    {
        m_ProgramData.append(m_dummyProgramNo);
        i++;
    }
}

void fountainSerial::setGroupID(const quint16 &id)
{
    if(m_GroupSyncing)
    {
        m_GroupIDandEnable = m_GroupIDandEnable | fountainBitBang::group_sync;
    }
    else
    {
        m_GroupIDandEnable = m_GroupIDandEnable & ~fountainBitBang::group_sync;
    }

    m_GroupIDandEnable = m_GroupIDandEnable | id;
}

void fountainSerial::setEnableFountainInGroup(const QJsonObject &data)
{
    int i = 0;

    foreach (QJsonValue theFountain, data["fountains"].toArray()) {


        if(theFountain.toObject()["fountainEnable"].toBool() == true)
        {
            m_GroupIDandEnable = m_GroupIDandEnable | intToFountainBitbang.value(i);
        }
        else
        {
            m_GroupIDandEnable = m_GroupIDandEnable & ~(intToFountainBitbang.value(i));
        }
        i++;

    }

    while(i < m_fountainNumber)
    {
        m_GroupIDandEnable = m_GroupIDandEnable & ~(intToFountainBitbang.value(i));
        i++;
    }

}

bool fountainSerial::getGroupSync()
{
    return m_GroupSyncing;
}

void fountainSerial::setGroupSync(const bool &input)
{

    if(m_GroupSyncing != input)
    {
        m_GroupSyncing = input;
    }



}

QByteArray fountainSerial::byteStuffing(const quint8 &data)
{
    QByteArray data1;
    if((data == m_startFlag)| (data == m_endFlag) | (data == m_escFlag))
    {
        data1.append(m_escFlag);

    }
    data1.append(data);

    return data1;
}

void fountainSerial::resetGroupIdandEnable()
{
    m_GroupIDandEnable = 0;

}

