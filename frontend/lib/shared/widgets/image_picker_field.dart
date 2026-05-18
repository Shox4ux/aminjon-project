// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:factory_management/app/di/injection.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/constants/app_sizes.dart';
import 'package:factory_management/core/theme/app_theme.dart';
import 'package:factory_management/l10n/app_localizations.dart';

class ImagePickerField extends StatefulWidget {
  final List<String> initialUrls;
  final void Function(List<String>) onChanged;

  const ImagePickerField({
    super.key,
    required this.initialUrls,
    required this.onChanged,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImageItem {
  String? url;
  Uint8List? bytes;
  bool uploading;
  bool failed;

  _ImageItem({this.url, this.bytes, this.uploading = false}) : failed = false;
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  late final List<_ImageItem> _items;
  final _dio = sl<Dio>();

  @override
  void initState() {
    super.initState();
    _items = widget.initialUrls
        .where((u) => u.isNotEmpty)
        .map((u) => _ImageItem(url: u))
        .toList();
  }

  void _notify() {
    final urls = _items
        .where((i) => i.url != null && !i.uploading && !i.failed)
        .map((i) => i.url!)
        .toList();
    widget.onChanged(urls);
  }

  /// Resizes to max 1920px and re-encodes as JPEG (quality 85) in the browser
  /// using the Canvas API. Falls back to original bytes on any error.
  Future<({Uint8List bytes, String name})> _compress(
      Uint8List bytes, String filename) async {
    try {
      final blob = html.Blob([bytes]);
      final objectUrl = html.Url.createObjectUrl(blob);
      final img = html.ImageElement()..src = objectUrl;
      await img.onLoad.first;
      html.Url.revokeObjectUrl(objectUrl);

      const maxDim = 1920;
      var w = img.naturalWidth;
      var h = img.naturalHeight;
      if (w == 0 || h == 0) return (bytes: bytes, name: filename);

      if (w > maxDim || h > maxDim) {
        if (w >= h) {
          h = (h * maxDim / w).round();
          w = maxDim;
        } else {
          w = (w * maxDim / h).round();
          h = maxDim;
        }
      }

      final canvas = html.CanvasElement(width: w, height: h);
      canvas.context2D.drawImageScaled(img, 0, 0, w.toDouble(), h.toDouble());
      final dataUrl = canvas.toDataUrl('image/jpeg', 0.85);
      final base64Data = dataUrl.split(',').last;
      final compressed = base64Decode(base64Data);
      final baseName = filename.contains('.')
          ? filename.substring(0, filename.lastIndexOf('.'))
          : filename;
      return (bytes: compressed, name: '$baseName.jpg');
    } catch (_) {
      return (bytes: bytes, name: filename);
    }
  }

  Future<void> _pick() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final valid = result.files.where((f) => f.bytes != null).toList();
    if (valid.isEmpty) return;

    final newItems = valid.map((f) => _ImageItem(bytes: f.bytes, uploading: true)).toList();
    setState(() => _items.addAll(newItems));

    try {
      // Compress each image client-side before uploading
      final compressed = await Future.wait(
        valid.map((f) => _compress(f.bytes!, f.name)),
      );
      final formData = FormData.fromMap({
        'files': compressed
            .map((c) => MultipartFile.fromBytes(c.bytes, filename: c.name))
            .toList(),
      });
      final response = await _dio.post('/api/v1/upload/images', data: formData);
      final urls = List<String>.from(response.data['urls']);
      setState(() {
        for (var i = 0; i < newItems.length && i < urls.length; i++) {
          newItems[i].url = urls[i];
          newItems[i].uploading = false;
        }
      });
    } catch (_) {
      setState(() {
        for (final item in newItems) {
          item.uploading = false;
          item.failed = true;
        }
      });
    }
    _notify();
  }

  void _remove(int index) {
    setState(() => _items.removeAt(index));
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.fieldImages,
          style: TextStyle(
            fontSize: AppFonts.sm,
            fontWeight: FontWeight.w500,
            color: c.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._items.asMap().entries.map(
                  (e) => _Thumbnail(item: e.value, onRemove: () => _remove(e.key)),
                ),
            _AddButton(onTap: _pick, colors: c, label: l10n.addImages),
          ],
        ),
      ],
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final _ImageItem item;
  final VoidCallback onRemove;

  const _Thumbnail({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (item.uploading) {
      content = const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else if (item.failed) {
      content = const Center(child: Icon(Icons.error_outline, color: Colors.red, size: 28));
    } else if (item.url != null) {
      content = Image.network(
        item.url!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Center(child: Icon(Icons.broken_image_outlined, size: 28)),
      );
    } else {
      content = Image.memory(item.bytes!, fit: BoxFit.cover);
    }

    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            child: content,
          ),
          if (!item.uploading)
            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.close, size: 13, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  final AppThemeColors colors;
  final String label;

  const _AddButton({required this.onTap, required this.colors, required this.label});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: colors.border, width: 1.5, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            color: colors.tableHeader,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined, size: 26, color: colors.textSecondary),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: AppFonts.xs, color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
