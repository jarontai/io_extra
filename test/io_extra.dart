import 'dart:io';

import 'package:test/test.dart';
import 'package:io_extra/io_extra.dart';
import 'package:path/path.dart' as path;

void main() {
  var rootFolder = new Directory(path.join(Platform.packageRoot, 'playground'));
  File sourceFile;
  Directory targetFolder;

  setUp(() {
    if (rootFolder.existsSync()) {
      rootFolder.deleteSync(recursive: true);
    }
    rootFolder.createSync();

    sourceFile = new File(path.join(Platform.packageRoot, 'README.md')).copySync(path.join(rootFolder.path, 'source.md'));
    targetFolder = new Directory(path.join(rootFolder.path, 'target'))..createSync();
  });

  test('Testing makeDirSync (one level folder)', () {
    Directory targetDir = makeDirSync(path.join(rootFolder.path, 'not_exists_folder1'));
    expect(targetDir.existsSync(), equals(true));
  });

  test('Testing makeDirSync (multi level folder)', () {
    Directory targetDir = makeDirSync(path.join(rootFolder.path, 'not_exists_folder1', 'not_exists_folder2', 'not_exists_folder3'));
    expect(targetDir.existsSync(), equals(true));
  });

  test('Testing copySync: file to file', () {
    File targeFile = copySync(sourceFile.path, path.join(rootFolder.path, 'target.md'));
    expect(sourceFile.readAsStringSync(), equals(targeFile.readAsStringSync()));
  });

  test('Testing copySync: file to folder', () {
    File targeFile = copySync(sourceFile.path, targetFolder.path);
    expect(sourceFile.readAsStringSync(), equals(targeFile.readAsStringSync()));
  });

  test('Testing copySync: file to file (target folder not exists)', () {
    File targeFile = copySync(sourceFile.path, path.join(rootFolder.path, 'not_exists_folder1', 'not_exists_folder2', 'target.md'));
    expect(sourceFile.readAsStringSync(), equals(targeFile.readAsStringSync()));
  });

  test('Testing copySync: file to folder (target folder not exists)', () {
    File targeFile = copySync(sourceFile.path, path.join(rootFolder.path, 'not_exists_folder1', 'not_exists_folder2', 'not_exists_folder3'));
    expect(sourceFile.readAsStringSync(), equals(targeFile.readAsStringSync()));
  });

}
