/****************************************************************************
** Meta object code from reading C++ file 'kwin_smaragd.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.5)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../../../src/kwin_smaragd.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'kwin_smaragd.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.5. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Smaragd__Decoration_t {
    QByteArrayData data[12];
    char stringdata0[148];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Smaragd__Decoration_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Smaragd__Decoration_t qt_meta_stringdata_Smaragd__Decoration = {
    {
QT_MOC_LITERAL(0, 0, 19), // "Smaragd::Decoration"
QT_MOC_LITERAL(1, 20, 12), // "updateLayout"
QT_MOC_LITERAL(2, 33, 0), // ""
QT_MOC_LITERAL(3, 34, 13), // "updateButtons"
QT_MOC_LITERAL(4, 48, 20), // "updateButtonsDelayed"
QT_MOC_LITERAL(5, 69, 15), // "onWindowChanged"
QT_MOC_LITERAL(6, 85, 3), // "WId"
QT_MOC_LITERAL(7, 89, 2), // "id"
QT_MOC_LITERAL(8, 92, 15), // "NET::Properties"
QT_MOC_LITERAL(9, 108, 10), // "properties"
QT_MOC_LITERAL(10, 119, 16), // "NET::Properties2"
QT_MOC_LITERAL(11, 136, 11) // "properties2"

    },
    "Smaragd::Decoration\0updateLayout\0\0"
    "updateButtons\0updateButtonsDelayed\0"
    "onWindowChanged\0WId\0id\0NET::Properties\0"
    "properties\0NET::Properties2\0properties2"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Smaragd__Decoration[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       4,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    0,   34,    2, 0x08 /* Private */,
       3,    0,   35,    2, 0x08 /* Private */,
       4,    0,   36,    2, 0x08 /* Private */,
       5,    3,   37,    2, 0x08 /* Private */,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 6, 0x80000000 | 8, 0x80000000 | 10,    7,    9,   11,

       0        // eod
};

void Smaragd::Decoration::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<Decoration *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->updateLayout(); break;
        case 1: _t->updateButtons(); break;
        case 2: _t->updateButtonsDelayed(); break;
        case 3: _t->onWindowChanged((*reinterpret_cast< WId(*)>(_a[1])),(*reinterpret_cast< NET::Properties(*)>(_a[2])),(*reinterpret_cast< NET::Properties2(*)>(_a[3]))); break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject Smaragd::Decoration::staticMetaObject = { {
    QMetaObject::SuperData::link<KDecoration2::Decoration::staticMetaObject>(),
    qt_meta_stringdata_Smaragd__Decoration.data,
    qt_meta_data_Smaragd__Decoration,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *Smaragd::Decoration::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Smaragd::Decoration::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_Smaragd__Decoration.stringdata0))
        return static_cast<void*>(this);
    return KDecoration2::Decoration::qt_metacast(_clname);
}

int Smaragd::Decoration::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = KDecoration2::Decoration::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 4)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 4;
    }
    return _id;
}
struct qt_meta_stringdata_Smaragd__DecorationButton_t {
    QByteArrayData data[2];
    char stringdata0[40];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Smaragd__DecorationButton_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Smaragd__DecorationButton_t qt_meta_stringdata_Smaragd__DecorationButton = {
    {
QT_MOC_LITERAL(0, 0, 25), // "Smaragd::DecorationButton"
QT_MOC_LITERAL(1, 26, 13) // "hoverProgress"

    },
    "Smaragd::DecorationButton\0hoverProgress"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Smaragd__DecorationButton[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       1,   14, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // properties: name, type, flags
       1, QMetaType::QReal, 0x00095103,

       0        // eod
};

void Smaragd::DecorationButton::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{

#ifndef QT_NO_PROPERTIES
    if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<DecorationButton *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< qreal*>(_v) = _t->hoverProgress(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = static_cast<DecorationButton *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setHoverProgress(*reinterpret_cast< qreal*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
    (void)_o;
    (void)_id;
    (void)_c;
    (void)_a;
}

QT_INIT_METAOBJECT const QMetaObject Smaragd::DecorationButton::staticMetaObject = { {
    QMetaObject::SuperData::link<KDecoration2::DecorationButton::staticMetaObject>(),
    qt_meta_stringdata_Smaragd__DecorationButton.data,
    qt_meta_data_Smaragd__DecorationButton,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *Smaragd::DecorationButton::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Smaragd::DecorationButton::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_Smaragd__DecorationButton.stringdata0))
        return static_cast<void*>(this);
    return KDecoration2::DecorationButton::qt_metacast(_clname);
}

int Smaragd::DecorationButton::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = KDecoration2::DecorationButton::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    
#ifndef QT_NO_PROPERTIES
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
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
QT_WARNING_POP
QT_END_MOC_NAMESPACE
