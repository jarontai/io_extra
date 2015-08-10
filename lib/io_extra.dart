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

Future<FileSystemEntity> copy(String source, String target, [bool recursive = false]) {
  // TODO
}

FileSystemEntity copySync(String source, String target, [bool recursive = false]) {
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
      File sourceFile;
      Directory sourceDir;
      sourceRootDir.listSync().forEach((FileSystemEntity entity) {
        if (entity is File) {
          sourceFile = entity as File;
          relPath =  path.relative(sourceFile.path, from: sourceRootDir.path);
          sourceFile.copySync(path.join(targetRootDir.path, relPath));
        } else if (entity is Directory) {
          sourceDir = entity as Directory;
          relPath = path.relative(sourceDir.path, from: sourceRootDir.path);
          new Directory(path.join(targetRootDir.path, relPath)).createSync();
        }
      });
      return targetRootDir;
    }
  }
  return null;
}
