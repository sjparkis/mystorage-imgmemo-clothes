import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/repositories/storage_repository.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});
  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final _repo = StorageRepository();
  final _controller = MobileScannerController();
  bool _scanned = false;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_scanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;
    _scanned = true;

    final storage = await _repo.fetchByQrCode(barcode!.rawValue!);
    if (!mounted) return;
    if (storage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('등록되지 않은 QR입니다')),
      );
      setState(() => _scanned = false);
    } else {
      context.pushReplacement('/storage/${storage.id}');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR 스캔'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: MobileScanner(controller: _controller, onDetect: _onDetect),
    );
  }
}
