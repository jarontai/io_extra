import 'dart:io';

import 'package:test/test.dart';
import 'package:io_extra/io_extra.dart';
import 'package:path/path.dart' as path;

void main() {
  var rootFolder = new Directory('playground');
  File sourceFile, targetFile;
  Directory targetFolder, sourceFolder;

  bootstrap() {
    if (rootFolder.existsSync()) {
      rootFolder.deleteSync(recursive: true);
    }
    rootFolder.createSync();

    sourceFile = new File('README.md').copySync(path.join(rootFolder.path, 'source1.md'));
    targetFolder = new Directory(path.join(rootFolder.path, 'target'))..createSync();
    sourceFolder = new Directory(path.join(rootFolder.path, 'source'))..createSync();
    var sourceFolder2 = new Directory(path.join(sourceFolder.path, 'in_source'))..createSync();
    var readme = new File('README.md');
    targetFile = readme.copySync(path.join(sourceFolder.path, 'target.md'));
    readme.copy(path.join(sourceFolder2.path, 'target2.md'));
  }

  setUp(bootstrap);

  test('Testing copy: file to file (target not exists)', () async {
    File targeFile = await copy(sourceFile.path, path.join(rootFolder.path, 'target.md'));
    String sourceStr = sourceFile.readAsStringSync();
    expect(sourceStr, equals(targeFile.readAsStringSync()));
  });

  test('Testing copy: file to file (target exists)', () async {
    File targeFile = await copy(sourceFile.path, targetFile.path);
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
    Directory copiedFolder = await copy(sourceFolder.path, targetFolder.path);
    List copiedList = copiedFolder.listSync(recursive: true, followLinks: false);
    expect(copiedList.length, equals(sourceFolder.listSync(recursive: true, followLinks: false).length));
    expect(path.basename(copiedFolder.path), equals(path.basename(sourceFolder.path)));
  });

  test('Testing copy: folder to folder (target folder not exists)', () async {
    Directory copiedFolder = await copy(sourceFolder.path, path.join(targetFolder.path, 'not_exists_folder1', 'not_exists_folder2'));
    List copiedList = copiedFolder.listSync(recursive: true, followLinks: false);
    expect(copiedList.length, equals(sourceFolder.listSync(recursive: true, followLinks: false).length));
    expect(path.basename(copiedFolder.path), equals(path.basename(sourceFolder.path)));
  });
}
