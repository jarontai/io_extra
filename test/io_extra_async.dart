import 'dart:io';
import 'dart:async';

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

  test('Testing copy: file to file (target not exists)', () async {
    File targeFile = await copy(sourceFile.path, path.join(rootFolder.path, 'target.md'));
    String sourceStr = sourceFile.readAsStringSync();
    expect(sourceStr, equals(targeFile.readAsStringSync()));
  });

  test('Testing copy: file to file (target exists)', () async {
    File targeFile = await copy(sourceFile.path, sourceFile2.path);
    String sourceStr = sourceFile.readAsStringSync();
    expect(sourceStr, equals(targeFile.readAsStringSync()));
  });

  test('Testing copy: file to folder', () async {
    File targeFile = await copy(sourceFile.path, targetFolder.path);
    String sourceStr = sourceFile.readAsStringSync();
    expect(sourceStr, equals(targeFile.readAsStringSync()));
  });

  test('Testing copy: file to file (target folder not exists)', () async {
    File targeFile = await copy(sourceFile.path, path.join(rootFolder.path, 'not_exists_folder1', 'not_exists_folder2', 'target.md'));
    String sourceStr = sourceFile.readAsStringSync();
    expect(sourceStr, equals(targeFile.readAsStringSync()));
  });

  test('Testing copy: file to folder (target folder not exists)', () async {
    File targeFile = await copy(sourceFile.path, path.join(rootFolder.path, 'not_exists_folder1', 'not_exists_folder2', 'not_exists_folder3'));
    String sourceStr = sourceFile.readAsStringSync();
    expect(sourceStr, equals(targeFile.readAsStringSync()));
  });

  test('Testing copy: folder to folder', () async {
    Directory copiedFolder = await copy(targetFolder2.path, targetFolder.path);
    List copiedList = copiedFolder.listSync();
    expect(copiedList.length, equals(targetFolder2.listSync().length));
    expect(path.basename(copiedFolder.path), equals(path.basename(targetFolder2.path)));
  });

  test('Testing copy: folder to folder (target folder not exists)', () async {
    Directory copiedFolder = await copy(targetFolder2.path, path.join(targetFolder.path, 'not_exists_folder1', 'not_exists_folder2'));
    List copiedList = copiedFolder.listSync();
    expect(copiedList.length, equals(targetFolder2.listSync().length));
    expect(path.basename(copiedFolder.path), equals(path.basename(targetFolder2.path)));
  });
}
