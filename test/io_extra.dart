import 'dart:io';

import 'package:test/test.dart';
import 'package:io_extra/io_extra.dart';
import 'package:path/path.dart' as path;

void main() {
  var rootFolder = new Directory(path.join(Platform.packageRoot, 'playground'));
  File sourceFile, sourceFile2;
  Directory targetFolder, targetFolder2;

  bootstrap() {
    if (rootFolder.existsSync()) {
      rootFolder.deleteSync(recursive: true);
    }
    rootFolder.createSync();

    sourceFile = new File(path.join(Platform.packageRoot, 'README.md')).copySync(path.join(rootFolder.path, 'source1.md'));
    targetFolder = new Directory(path.join(rootFolder.path, 'target'))..createSync();
    targetFolder2 = new Directory(path.join(rootFolder.path, 'target2'))..createSync();
    sourceFile2 = new File(path.join(Platform.packageRoot, 'README.md')).copySync(path.join(targetFolder2.path, 'source2.md'));
  }

  setUp(bootstrap);

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

  test('Testing copySync: folder to folder', () {
    Directory copiedFolder = copySync(targetFolder2.path, targetFolder.path);
    expect(copiedFolder.listSync().length, equals(targetFolder2.listSync().length));
    expect(path.basename(copiedFolder.path), equals(path.basename(targetFolder2.path)));
  });

  test('Testing copySync: folder to folder (target folder not exists)', () {
    Directory copiedFolder = copySync(targetFolder2.path, path.join(targetFolder.path, 'not_exists_folder1', 'not_exists_folder2'));
    expect(copiedFolder.listSync().length, equals(targetFolder2.listSync().length));
    expect(path.basename(copiedFolder.path), equals(path.basename(targetFolder2.path)));
  });
}
