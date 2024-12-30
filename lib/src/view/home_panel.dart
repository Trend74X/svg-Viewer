import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:svg_viewer/src/widgets/folder_view_widget.dart';

class HomePanelView extends StatefulWidget {
  const HomePanelView({super.key});

  @override
  State<HomePanelView> createState() => _HomePanelViewState();
}

class _HomePanelViewState extends State<HomePanelView> {
  List<String> drives = [];
  List<String> directoryStack = [];
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    getRootDirectories();
  }

  Future<void> getRootDirectories() async {
    try {
      for (var i = 'c'.codeUnitAt(0); i <= 'z'.codeUnitAt(0); i++) {
        var letter = String.fromCharCode(i);
        bool driveExists = await checkDriveExists(letter);
        if (driveExists) drives.add(letter.toUpperCase());
      }
      Future.delayed(const Duration(seconds: 1), () {
        setState(() { });
      });
    } catch (e) {
      debugPrint('Error while getting root directories: $e');
    }
  }

  Future<bool> checkDriveExists(String driveLetter) async {
    try {
      String drivePath = '$driveLetter:/';
      Directory driveDirectory = Directory(drivePath);
      return await driveDirectory.exists();
    } catch (e) {
      return false;
    }
  }

  Future<void> listFiles(String path, [fromBack]) async {
    try {
      Directory directory = Directory(path);
      List<FileSystemEntity> directoryContents = directory.listSync();
            
      files.clear();
      for(var item in directoryContents) {
        String path = item.path.replaceAll('\\', '/');
        if(path.split('/').last[0] != '.' && path.split('/').last.contains('.BIN') == false) {
          files.add(item);
        }
      }
      setState(() {
        if(fromBack == null) {
          if(directoryStack.isEmpty) {
            directoryStack.add(path);
          } else if(directoryStack.isNotEmpty) {
            if(directoryStack.last != path) directoryStack.add(path);  
          }
        }
      });

    } catch (e) {
      debugPrint('Error while listing files: $e');
    }
  }

  void goBack() {
    if (directoryStack.length > 1) {
      // Pop the current directory from the stack
      directoryStack.removeLast();
      // List files in the parent directory
      listFiles(directoryStack.last, true);
    } else {
      directoryStack.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          child: SizedBox(
            height: 130.0,
            child: ListView.builder(
              itemCount: drives.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String driveLetter = drives[index];
                return GestureDetector(
                  onTap: () => listFiles('$driveLetter:/'),
                  child: FolderViewWidget(folderName: driveLetter, driveLetter: true)
                );
              },
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => goBack(),
                  child: Visibility(
                    visible: files.isNotEmpty,
                    child: Container(
                      color: Colors.white,
                      child: const Icon(FluentIcons.back),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(directoryStack.isNotEmpty ? directoryStack.last : '' )
              ],
            ),
          )
        ),
        Expanded(
          flex: 6,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Material(
              child: files.isEmpty
                ? const Center(
                  child: Text('Click on a drive to view files.'),
                )
                : SingleChildScrollView(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: files.map((file) {
                      return GestureDetector(
                        onDoubleTap: () => onFileTap(file),
                        child: FolderViewWidget(folderName: file.path, driveLetter: false)
                      );
                    }).toList(),
                  ),
                )
            ),
          ),
        ),
      ],
    );
  }

  void onFileTap(FileSystemEntity file) {
    if (FileSystemEntity.isDirectorySync(file.path)) {
      listFiles(file.path);
    } else {
      debugPrint(file.path);
    }
  }
}