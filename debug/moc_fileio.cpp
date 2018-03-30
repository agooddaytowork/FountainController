/****************************************************************************
** Meta object code from reading C++ file 'fileio.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.10.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../fileio.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'fileio.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.10.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_FileIO_t {
    QByteArrayData data[14];
    char stringdata0[135];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_FileIO_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_FileIO_t qt_meta_stringdata_FileIO = {
    {
QT_MOC_LITERAL(0, 0, 6), // "FileIO"
QT_MOC_LITERAL(1, 7, 5), // "error"
QT_MOC_LITERAL(2, 13, 0), // ""
QT_MOC_LITERAL(3, 14, 15), // "nameListChanged"
QT_MOC_LITERAL(4, 30, 16), // "setSubFolderPath"
QT_MOC_LITERAL(5, 47, 4), // "path"
QT_MOC_LITERAL(6, 52, 4), // "read"
QT_MOC_LITERAL(7, 57, 8), // "fileName"
QT_MOC_LITERAL(8, 66, 5), // "write"
QT_MOC_LITERAL(9, 72, 10), // "serialJson"
QT_MOC_LITERAL(10, 83, 16), // "getNameListCount"
QT_MOC_LITERAL(11, 100, 19), // "getNameFromNameList"
QT_MOC_LITERAL(12, 120, 5), // "index"
QT_MOC_LITERAL(13, 126, 8) // "nameList"

    },
    "FileIO\0error\0\0nameListChanged\0"
    "setSubFolderPath\0path\0read\0fileName\0"
    "write\0serialJson\0getNameListCount\0"
    "getNameFromNameList\0index\0nameList"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_FileIO[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       7,   14, // methods
       1,   70, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   49,    2, 0x06 /* Public */,
       3,    1,   52,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       4,    1,   55,    2, 0x0a /* Public */,

 // methods: name, argc, parameters, tag, flags
       6,    1,   58,    2, 0x02 /* Public */,
       8,    2,   61,    2, 0x02 /* Public */,
      10,    0,   66,    2, 0x02 /* Public */,
      11,    1,   67,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QString,    2,
    QMetaType::Void, QMetaType::QStringList,    2,

 // slots: parameters
    QMetaType::Void, QMetaType::QString,    5,

 // methods: parameters
    QMetaType::QString, QMetaType::QString,    7,
    QMetaType::Bool, QMetaType::QString, QMetaType::QString,    7,    9,
    QMetaType::Int,
    QMetaType::QString, QMetaType::Int,   12,

 // properties: name, type, flags
      13, QMetaType::QStringList, 0x00495103,

 // properties: notify_signal_id
       1,

       0        // eod
};

void FileIO::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        FileIO *_t = static_cast<FileIO *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->error((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 1: _t->nameListChanged((*reinterpret_cast< QStringList(*)>(_a[1]))); break;
        case 2: _t->setSubFolderPath((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 3: { QString _r = _t->read((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 4: { bool _r = _t->write((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 5: { int _r = _t->getNameListCount();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = std::move(_r); }  break;
        case 6: { QString _r = _t->getNameFromNameList((*reinterpret_cast< const int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            typedef void (FileIO::*_t)(QString );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&FileIO::error)) {
                *result = 0;
                return;
            }
        }
        {
            typedef void (FileIO::*_t)(QStringList );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&FileIO::nameListChanged)) {
                *result = 1;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        FileIO *_t = static_cast<FileIO *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QStringList*>(_v) = _t->nameList(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        FileIO *_t = static_cast<FileIO *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setNameList(*reinterpret_cast< QStringList*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

const QMetaObject FileIO::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_FileIO.data,
      qt_meta_data_FileIO,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *FileIO::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *FileIO::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_FileIO.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int FileIO::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 7)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 7)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 7;
    }
#ifndef QT_NO_PROPERTIES
   else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 1;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void FileIO::error(QString _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void FileIO::nameListChanged(QStringList _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
