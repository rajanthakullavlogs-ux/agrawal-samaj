import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Data model for photo items displayed in the photo viewer lightbox popup dialog.
class PhotoViewerItem {
  final String id;
  final String title;
  final String imageUrl;
  final String? category;
  final String? date;
  final String? location;
  final String description;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const PhotoViewerItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.category,
    this.date,
    this.location,
    required this.description,
    this.actionLabel,
    this.onActionTap,
  });
}

/// Displays a compact, content-fitted popup modal card wrapping the photo, event title, details & description.
void showPhotoViewerModal(BuildContext context, PhotoViewerItem item) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.70),
    builder: (dialogCtx) {
      return Dialog(
        backgroundColor: Colors.white,
        elevation: 16,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header Row: Category Badge + Date Badge + Close Button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                child: Row(
                  children: [
                    // Category Badge
                    if (item.category != null && item.category!.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF700D15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item.category!.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFFE5C158),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Date Pill
                    if (item.date != null && item.date!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5EFEA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFEADBCE)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 11, color: Color(0xFF700D15)),
                            const SizedBox(width: 4),
                            Text(
                              item.date!,
                              style: const TextStyle(
                                color: Color(0xFF500913),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const Spacer(),

                    // Close Button
                    InkWell(
                      onTap: () => Navigator.of(dialogCtx).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0EAE8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF500913),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. High Quality Image Container (Pinch to Zoom enabled)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: const Color(0xFFF5EFEA),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF700D15),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: const Color(0xFFFDEAEA),
                          child: const Center(
                            child: Icon(Icons.broken_image_rounded, size: 40, color: Color(0xFF700D15)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Content Details: Title, Location, Description & Action Button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1615),
                        height: 1.25,
                        letterSpacing: -0.2,
                      ),
                    ),

                    // Location Chip
                    if (item.location != null && item.location!.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 13, color: Color(0xFF700D15)),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              item.location!,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF700D15),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 10),
                    const Divider(height: 1, color: Color(0xFFF0E8E6)),
                    const SizedBox(height: 10),

                    // Event Description Text
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: Color(0xFF5A4540),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    // Action Button (e.g., View Event Details)
                    if (item.actionLabel != null && item.onActionTap != null) ...[
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(dialogCtx).pop();
                          item.onActionTap!();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B1222), Color(0xFF6B0E1B)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6B0E1B).withValues(alpha: 0.30),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.actionLabel!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
