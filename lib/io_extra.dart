library io_extra;

import 'dart:io';
import 'dart:async';

import 'package:path/path.dart' as path;

Future<FileSystemEntity> copy(String source, String target, [bool recursive = true]) {

}

FileSystemEntity copySync(String source, String target, [bool recursive = true]) {
  FileSystemEntityType sourceType = FileSystemEntity.typeSync(source);
  if (sourceType == FileSystemEntityType.NOT_FOUND || sourceType == FileSystemEntityType.LINK) {
    return null;
  }

  FileSystemEntityType targetType = FileSystemEntity.typeSync(target);
  if (sourceType == FileSystemEntityType.FILE) {
    String sourceFileName = path.basename(source);
    String targetFileName = path.basename(target);
    if (targetType == FileSystemEntityType.FILE) {
      return new File(source).copySync(target);
    } else if (targetType == FileSystemEntityType.DIRECTORY) {
      target = path.join(target, sourceFileName);
      return new File(source).copySync(target);
    } else if (targetType == FileSystemEntityType.NOT_FOUND) {
      String ext = path.extension(target);
      int index = target.indexOf('.');

      // Target is a folder
      if (ext == '' && index < 0) {
        makeDirSync(target);
        return new File(source).copySync(path.join(target, sourceFileName));
      } else if (ext != '') { // Target is a file
        makeDirSync(path.dirname(target));
        return new File(source).copySync(target);
      }
    }
  }
  return null;
}

Directory makeDirSync(String folder, [bool recursive = true]) {

}

void main() {

}
