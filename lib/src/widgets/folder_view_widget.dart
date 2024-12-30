import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FolderViewWidget extends StatelessWidget {
  final String folderName;
  final bool driveLetter;
  const FolderViewWidget({super.key, required this.folderName, required this.driveLetter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: getFolderType(),
    );
  }

  getFolderType() {
    String path = folderName.replaceAll('/', '\\');
    return driveLetter
      ? columnFolderWidget()
      : folderName.split('/').last.split('.').last == 'svg'
        ? svgIconView(path)
        : columnFolderWidget();
  }

  getFolderName() {
    String path = folderName.replaceAll('\\', '/');
    return driveLetter == true 
      ? folderName 
      : path.split('/').last;
  }

  columnFolderWidget(){
    String path = folderName.replaceAll('\\', '/');
    return Column(
      children: [
        Icon(
          driveLetter == true
            ? FluentIcons.hard_drive
            : path.split('/').last.contains('.') != true
              ? FluentIcons.folder_horizontal
              : FluentIcons.file_code,
          size: 80.0,
        ),
        const SizedBox(height: 4.0),
        SizedBox(
          width: 80.0,
          child: Text(
            getFolderName(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 4,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  svgIconView(path) {
    debugPrint('PATH => $path');
    return Column(
      children: [
        SvgPicture.file(
          File(folderName),
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn), 
          width: 80.0,
          height: 80.0
        ),
        const SizedBox(height: 4.0),
        SizedBox(
          width: 50.0,
          child: Text(
            getFolderName(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

}