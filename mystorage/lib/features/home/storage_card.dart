import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/storage_location.dart';

class StorageCard extends StatelessWidget {
  final StorageLocation storage;
  final int clothCount;
  final VoidCallback onTap;

  const StorageCard({super.key, required this.storage, required this.clothCount, required this.onTap});

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
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: const Color(0xFF2C2416),
            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              if (storage.locationName != null) ...[
                const Icon(Icons.place_outlined, size: 10, color: Color(0xFFBBAA95)),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    storage.locationName!,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: const Color(0xFFBBAA95),
                      letterSpacing: 0.5,
                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '·',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFFBBAA95),
                  ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                clothCount > 0 ? '$clothCount' : 'COLLECTION',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: const Color(0xFF9B8E7E),
                  letterSpacing: storage.locationName == null ? 1 : 0,
                ).copyWith(fontFamilyFallback: const ['ChosunSm']),
              ),
            ],
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
