import 'dart:io';

Future<bool> isFileType(String path) async {
  FileSystemEntity fileSystemEntity = File(path);
  if (await fileSystemEntity.exists()) {
    if (fileSystemEntity is File) {
      return true;
    } else if (fileSystemEntity is Directory) {
      return false;
    } else {
      return false;
    }
  } else {
    return false;
  }
}