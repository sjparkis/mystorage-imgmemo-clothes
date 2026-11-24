import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/storage_location.dart';

class StorageCard extends StatelessWidget {
  final StorageLocation storage;
  final VoidCallback onTap;

  const StorageCard({super.key, required this.storage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: storage.photoUrl != null
                ? Image.network(
                    storage.photoUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(height: 10),
          Text(
            storage.name.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: const Color(0xFF2C2416),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            'COLLECTION',
            style: GoogleFonts.inter(
              fontSize: 10,
              color: const Color(0xFF9B8E7E),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFEDE7DD),
      child: const Center(
        child: Icon(Icons.inventory_2_outlined,
            size: 32, color: Color(0xFFBBAA95)),
      ),
    );
  }
}
