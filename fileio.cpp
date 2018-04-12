#include "fileio.h"

FileIO::FileIO(QObject *parent): QObject(parent)
{

}

FileIO::FileIO(const QString &folderPath, QObject *parent): QObject(parent), m_subFolderName(folderPath)
{
    fileNameList.clear();
    searchForFilesInFolder();
}

void FileIO::searchForFilesInFolder()
{
    // check if Folder Json exists

    fileNameList.clear();

#ifdef Q_OS_ANDROID
m_thePath = QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).value(0);
#endif

#ifdef Q_OS_WIN || Q_OS_IOS
      m_thePath = QStandardPaths::standardLocations(QStandardPaths::DocumentsLocation).value(0);
#endif




    qDebug()<< m_thePath+"/Json";
    if(!QDir(m_thePath+"/Json").exists())
    {
        QDir().mkdir(m_thePath+"/Json");
    }

    if(!QDir(m_thePath+"/Json/" + m_subFolderName).exists()) QDir().mkdir(m_thePath+"/Json/"+m_subFolderName);

    // scan for .txt files

    QDirIterator it(m_thePath+"/Json/" + m_subFolderName, QStringList() << "*.txt", QDir::Files, QDirIterator::NoIteratorFlags);
    while (it.hasNext())
    {
        it.next();
        QString fileName = it.fileName().remove(QRegExp("[.txt]"));
        fileNameList.append(fileName);
    }

    emit nameListChanged(fileNameList);

}


QString FileIO::read(const QString &fileName)
{
    if (m_subFolderName.isEmpty()){
        emit error("source is empty");
        return QString();
    }

    QFile file(m_thePath+"/Json/"+ m_subFolderName +"/" + fileName +".txt");
    QString fileContent;
    if ( file.open(QIODevice::ReadOnly) ) {
        QString line;
        QTextStream t( &file );
        do {
            line = t.readLine();
            fileContent += line;
        } while (!line.isNull());

        file.close();
    } else {
        emit error("Unable to open the file");
        return QString();
    }
    return fileContent;
}

bool FileIO::write(const QString &fileName, const QString &serialJson)
{

        if (m_subFolderName.isNull())
            return false;

    QFile file(m_thePath+ "/Json/" + m_subFolderName +"/" + fileName +".txt");
    if (!file.open(QFile::WriteOnly | QFile::Truncate))
        return false;

    QTextStream out(&file);
    out << serialJson;

    file.close();

    if(!fileNameExist(fileName))
    {
        fileNameList.append(fileName);
        emit nameListChanged(fileNameList);
    }
    return true;
}


void FileIO::setSubFolderPath(const QString &path)
{
    m_subFolderName = path;
}

bool FileIO::fileNameExist(const QString &name)
{
    foreach (QString m_name, fileNameList) {

        if(m_name == name) return true;

    }

    return false;
}

void FileIO::setNameList(const QStringList &list)
{

}

int FileIO::getNameListCount()
{
    return fileNameList.count();
}

QString FileIO::getNameFromNameList(const int &index)
{
    return fileNameList.at(index);
}

