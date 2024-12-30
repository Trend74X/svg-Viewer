import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Cache{

  Future<void> saveCacheData(String data) async {
    Directory cacheDir = await getTemporaryDirectory();
    File cacheFile = File('${cacheDir.path}/cache.txt');
    await cacheFile.writeAsString(data);
  }

  Future<String> readCacheData() async {
    Directory cacheDir = await getTemporaryDirectory();
    File cacheFile = File('${cacheDir.path}/cache.txt');
    if (await cacheFile.exists()) {
      return await cacheFile.readAsString();
    } else {
      return ''; // Return empty string if cache file doesn't exist
    }
  }

}