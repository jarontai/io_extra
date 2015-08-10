library io_extra;

import 'dart:io';
import 'dart:async';

import 'package:path/path.dart' as path;

// Check the target is a folder or not
bool _checkFolder(String target) {
  String ext = path.extension(target);
  int index = target.indexOf('.');
  if (ext == '' && index < 0) {
    return true;
  }
  return false;
}

// Check the target is a file or not
bool _checkFile(String target) => (path.extension(target) != '') ? true : false;

/// Copy the source to target. Recursively.
///
/// Support:
///     File -> File
///     File -> Folder
///     Folder -> Folder
///
Future<FileSystemEntity> copy(String source, String target) async {
  FileSystemEntityType sourceType = await FileSystemEntity.type(source);
  if (sourceType == FileSystemEntityType.NOT_FOUND || sourceType == FileSystemEntityType.LINK) {
    return null;
  }

  FileSystemEntityType targetType = await FileSystemEntity.type(target);
  if (sourceType == FileSystemEntityType.FILE) {
    String sourceFileName = path.basename(source);
    if (targetType == FileSystemEntityType.FILE) {  // File to file
      return new File(source).copy(target);
    } else if (targetType == FileSystemEntityType.DIRECTORY) {  // File to folder
      target = path.join(target, sourceFileName);
      return new File(source).copy(target);
    } else if (targetType == FileSystemEntityType.NOT_FOUND) {  // Target not exists
      if (_checkFolder(target)) { // Target is a folder
        await new Directory(target).create(recursive: true);
        return new File(source).copy(path.join(target, sourceFileName));
      } else if (_checkFile(target)) { // Target is a file
        await new Directory(path.dirname(target)).create(recursive: true);
        return new File(source).copy(target);
      }
    }
  }  else if (sourceType == FileSystemEntityType.DIRECTORY) {  // Folder to folder
    if (targetType == FileSystemEntityType.FILE) {
      return null;
    }
    if (_checkFolder(target)) {
      Directory targetRootDir = new Directory(path.join(target, path.basename(source)));
      await targetRootDir.create(recursive: true);

      Directory sourceRootDir = new Directory(source);
      String relPath;
      await for (FileSystemEntity entity in sourceRootDir.list()) {
        if (entity is File) {
          relPath =  path.relative(entity.path, from: sourceRootDir.path);
          await entity.copy(path.join(targetRootDir.path, relPath));
        } else if (entity is Directory) {
          relPath = path.relative(entity.path, from: sourceRootDir.path);
          await new Directory(path.join(targetRootDir.path, relPath)).create();
        }
      }
      return targetRootDir;
    }
  }
  return null;
}

/// Copy the source to target. Recursively, synchronously.
///
/// Support:
///     File -> File
///     File -> Folder
///     Folder -> Folder
///
FileSystemEntity copySync(String source, String target) {
  FileSystemEntityType sourceType = FileSystemEntity.typeSync(source);
  if (sourceType == FileSystemEntityType.NOT_FOUND || sourceType == FileSystemEntityType.LINK) {
    return null;
  }

  FileSystemEntityType targetType = FileSystemEntity.typeSync(target);
  if (sourceType == FileSystemEntityType.FILE) {
    String sourceFileName = path.basename(source);
    if (targetType == FileSystemEntityType.FILE) {  // File to file
      return new File(source).copySync(target);
    } else if (targetType == FileSystemEntityType.DIRECTORY) {  // File to folder
      target = path.join(target, sourceFileName);
      return new File(source).copySync(target);
    } else if (targetType == FileSystemEntityType.NOT_FOUND) {  // Target not exists
      if (_checkFolder(target)) { // Target is a folder
        new Directory(target).createSync(recursive: true);
        return new File(source).copySync(path.join(target, sourceFileName));
      } else if (_checkFile(target)) { // Target is a file
        new Directory(path.dirname(target)).createSync(recursive: true);
        return new File(source).copySync(target);
      }
    }
  }  else if (sourceType == FileSystemEntityType.DIRECTORY) {  // Folder to folder
    if (targetType == FileSystemEntityType.FILE) {
      return null;
    }
    if (_checkFolder(target)) {
      Directory targetRootDir = new Directory(path.join(target, path.basename(source)));
      targetRootDir.createSync(recursive: true);

      Directory sourceRootDir = new Directory(source);
      String relPath;
      sourceRootDir.listSync().forEach((FileSystemEntity entity) {
        if (entity is File) {
          relPath =  path.relative(entity.path, from: sourceRootDir.path);
          entity.copySync(path.join(targetRootDir.path, relPath));
        } else if (entity is Directory) {
          relPath = path.relative(entity.path, from: sourceRootDir.path);
          new Directory(path.join(targetRootDir.path, relPath)).createSync();
        }
      });
      return targetRootDir;
    }
  }
  return null;
}
