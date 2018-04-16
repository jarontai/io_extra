# io_extra
Extra io utilities for [dartlang](http://dartlang.org/). Copy, Move, etc.

More features are on the way. Check the [dev](https://github.com/jarontai/io_extra/tree/develop) branch to see the newest commits.

### Important
- All links are skipped.
- All non-exists target folders would be created.
- All exists targets (file or folder) would be overwritten.

### Usage

    import 'dart:async';
    import 'package:path/path.dart' as path;
    import 'package:io_extra/io_extra.dart' as extra;

    main() async {
      // File -> File
      extra.copySync('README.md', path.join('targetFolder', 'target.md'));

      // File -> Folder
      await extra.copy('README.md', path.join('basePath', 'targetFolder'));

      // Folder -> Folder
      extra.copySync('sourceFolder', path.join('basePath', 'not_exists_folder'));
    }
