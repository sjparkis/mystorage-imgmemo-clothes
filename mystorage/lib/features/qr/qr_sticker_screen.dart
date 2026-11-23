import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../data/models/storage_location.dart';

class QrStickerScreen extends StatefulWidget {
  final StorageLocation storage;
  const QrStickerScreen({super.key, required this.storage});

  @override
  State<QrStickerScreen> createState() => _QrStickerScreenState();
}

class _QrStickerScreenState extends State<QrStickerScreen> {
  Future<void> _print(BuildContext context) async {
    try {
      final doc = pw.Document();
      doc.addPage(
        pw.Page(
          build: (ctx) => pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: widget.storage.qrCode,
                  width: 200,
                  height: 200,
                ),
                pw.SizedBox(height: 12),
                pw.Text(
                  widget.storage.name,
                  style: const pw.TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      );
      await Printing.layoutPdf(onLayout: (_) => doc.save());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('출력 중 오류가 발생했습니다')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR 스티커'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _print(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(data: widget.storage.qrCode, size: 240),
            const SizedBox(height: 16),
            Text(
              widget.storage.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.print),
              label: const Text('스티커 출력'),
              onPressed: () => _print(context),
            ),
          ],
        ),
      ),
    );
  }
}
