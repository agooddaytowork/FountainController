#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QDirIterator>
#include <QDir>
#include <QDebug>

class FileIO : public QObject
{

    Q_OBJECT

    QString m_subFolderName;

    void searchForFilesInFolder();

    Q_PROPERTY(QStringList nameList READ nameList WRITE setNameList NOTIFY nameListChanged)

    QStringList fileNameList;

    bool fileNameExist(const QString &name);
public:


    explicit FileIO( QObject * parent = nullptr);
    explicit FileIO(const QString &folderPath, QObject *parent = nullptr);
    Q_INVOKABLE QString read(const QString &fileName);
    Q_INVOKABLE bool write(const QString &fileName, const QString &serialJson);
    Q_INVOKABLE int getNameListCount();
    Q_INVOKABLE QString getNameFromNameList(const int &index);
    QStringList nameList() const
    {
        return fileNameList;
    }

    void setNameList(QStringList const &list);
public slots:

    void setSubFolderPath(const QString &path);

signals:
    void error(QString);
    void nameListChanged(QStringList);
};

#endif // FILEIO_H
