#include "fountainserial.h"

fountainSerial::fountainSerial(QObject *parent): QObject(parent), m_GroupIDandEnable(0), m_GroupSyncing(false)
{
    m_ProgramData.clear();
    m_serialPackage.clear();

}

QByteArray fountainSerial::serializedProgram(const QString &programName)
{
    FileIO dataIoManager("Data");

    QJsonDocument aJsonDocument;

    aJsonDocument.fromJson(dataIoManager.read("Data").toUtf8());

    QJsonArray programArray = aJsonDocument.array();


    foreach (const QJsonValue &theProgram, programArray) {

        if(theProgram.toObject()["programName"].toString() == programName)
        {

            for(int i = 0; i < theProgram.toObject()["groups"].toArray().count(); i++)
            {

                if(theProgram.toObject()["groups"].toArray().at(i)["fountainGroupEnable"].toBool() == true)
                {
                    m_GroupSyncing = true;
                    resetGroupIdandEnable();
                    setGroupID(intToFountainGroupIDBitBang.value(i));
                    setEnableFountainInGroup(theFountainGroup.toObject());
                    setProgramData(theFountainGroup.toObject());
                    m_serialPackage.insert(i, generateSerializedByteArray());
                }

            }

        }

    }

    return QByteArray();
}

QByteArray fountainSerial::generateSerializedByteArray()
{
    QByteArray output;

    if(!m_GroupSyncing) output.append(m_startFlag);
    output.append(m_GroupIDandEnable);
    output.append(m_ProgramData);
    if(!m_GroupSyncing) output.append(m_endFlag);


    return output;
}

void fountainSerial::setProgramData(const QJsonObject &data)
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

