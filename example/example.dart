import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:io_extra/io_extra.dart' as extra;

main() async {
  // File -> File
  extra.copySync('README.md', path.join('playground', 'targetFolder', 'target.md'));

  // File -> Folder
  await extra.copy('README.md', path.join('playground', 'basePath', 'targetFolder'));

  // Folder -> Folder
  extra.copySync('sourceFolder', path.join('playground', 'basePath', 'not_exists_folder'));
}
