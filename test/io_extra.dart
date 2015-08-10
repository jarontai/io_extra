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

  test('Testing copySync: file to file', () {
    File targeFile = copySync(sourceFile.path, path.join(rootFolder.path, 'target.md'));
    expect(sourceFile.readAsStringSync(), equals(targeFile.readAsStringSync()));
  });

  test('Testing copySync: file to folder', () {
    File targeFile = copySync(sourceFile.path, targetFolder.path);
    expect(sourceFile.readAsStringSync(), equals(targeFile.readAsStringSync()));
  });

  test('Testing copySync(target folder does not exists): file to file', () {
    File targeFile = copySync(sourceFile.path, path.join(rootFolder.path, 'not_exists1', 'not_exists2', 'target.md'));
    expect(sourceFile.readAsStringSync(), equals(targeFile.readAsStringSync()));
  });

  test('Testing copySync(target folder does not exists): file to folder', () {
    File targeFile = copySync(sourceFile.path, path.join(rootFolder.path, 'not_exists1', 'not_exists2', 'not_exists3'));
    expect(sourceFile.readAsStringSync(), equals(targeFile.readAsStringSync()));
  });

  // test('Testing copySync: folder to folder', () {
  //   File targeFile = copySync(sourceFile.path, targetFolder.path);
  //   expect(sourceFile.readAsStringSync(), equals(targeFile.readAsStringSync()));
  // });
  //
  // test('Testing copySync(target folder does not exists): folder to folder', () {
  //   File targeFile = copySync(sourceFile.path, path.join(rootFolder.path, 'target.md'));
  //   expect(sourceFile.readAsStringSync(), equals(targeFile.readAsStringSync()));
  // });
}
