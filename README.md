# io_extra
Extra io utilities for dartlang. Copy, Move, etc.

Work in progress. Check the [dev](https://github.com/jarontai/io_extra/tree/develop) branch to see the newest commits.

### How To Use
#### Please note: All links are skipped. All non-exists folders would be created.

    import 'package:io_extra/io_extra.dart';
    import 'package:path/path.dart' as path;

    main() {
      copySync('README.md', path.join(Platform.packageRoot, 'not_exists_folder1', 'target.md'));
      copySync('someFolder', path.join(Platform.packageRoot, 'not_exists_folder2'));
    }
