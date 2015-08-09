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

  test('Testing copy file to file', () {
    File targeFile = copySync(sourceFile.path, path.join(rootFolder.path, 'target.md'));
    expect(sourceFile.readAsStringSync(), equals(targeFile.readAsStringSync()));
  });

  test('Testing copy file to folder', () {
    File targeFile = copySync(sourceFile.path, targetFolder.path);
    expect(sourceFile.readAsStringSync(), equals(targeFile.readAsStringSync()));
  });
}
