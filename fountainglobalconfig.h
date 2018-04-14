#ifndef FOUNTAINGLOBALCONFIG_H
#define FOUNTAINGLOBALCONFIG_H

#endif // FOUNTAINGLOBALCONFIG_H
#define fountainSerialDebug (1)




#include <QCoreApplication>
#include <QHash>

QByteArray &operator<<(QByteArray &l, quint8 r);

QByteArray &operator<<(QByteArray &l, quint16 r);

QByteArray &operator<<(QByteArray &l, quint32 r);

enum fountainBitBang
{
    fountain1 = 0b0000000000000001,
    fountain2 = 0b0000000000000010,
    fountain3 = 0b0000000000000100,
    fountain4 = 0b0000000000001000,
    fountain5 = 0b0000000000010000,
    fountain6 = 0b0000000000100000,
    fountain7 = 0b0000000001000000,
    fountain8 = 0b0000000010000000,
    fountain9 = 0b0000000100000000,

    group_FO1 = 0b0000100000000000,
    group_FO2 = 0b0001000000000000,
    group_FO3 = 0b0001100000000000,
    group_FO4 = 0b0100000000000000,
    group_FO5 = 0b0010100000000000,
    group_FO6 = 0b0011000000000000,
    group_FO7 = 0b0011100000000000,
    group_FO8 = 0b0111100000000000,

    group_sync= 0b1000000000000000


};

const QHash<int, quint16> intToFountainBitbang{
    {0, fountain1},
    {1, fountain2},
    {2, fountain3},
    {3, fountain4},
    {4, fountain5},
    {5, fountain6},
    {6, fountain7},
    {7, fountain8},
    {8, fountain9}
};


const QHash<int, quint16> intToFountainGroupIDBitBang{
    {0, group_FO1},
    {1, group_FO2},
    {2, group_FO3},
    {3, group_FO4},
    {4, group_FO5},
    {5, group_FO6},
    {6, group_FO7},
    {7, group_FO8}
};
