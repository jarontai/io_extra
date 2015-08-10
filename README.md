# io_extra
Extra io utilities for [dartlang](http://dartlang.org/). Copy, Move, etc.

Work in progress. Check the [dev](https://github.com/jarontai/io_extra/tree/develop) branch to see the newest commits.

### How To Use
#### Important: All links are skipped. All non-exists target folders would be created. All exist targets would be overwritten.

    import 'package:io_extra/io_extra.dart';
    import 'package:path/path.dart' as path;

    main() {
      // File <-> File
      copySync('README.md', path.join('targetFolder', 'target.md'));

      // File <-> Folder
      copySync('README.md', path.join('targetFolder'));

      // Folder <-> Folder
      copySync('sourceFolder', path.join('yourBasePath', 'not_exists_target_folder'));
    }
