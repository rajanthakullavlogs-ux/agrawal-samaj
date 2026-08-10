import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../shared/widgets/widgets.dart';

class _PhotoArchiveItem {
  final String id;
  final String title;
  final String category;
  final String url;
  final String date;

  const _PhotoArchiveItem({
    required this.id,
    required this.title,
    required this.category,
    required this.url,
    required this.date,
  });
}

class AllPhotosScreen extends StatefulWidget {
  const AllPhotosScreen({super.key});

  @override
  State<AllPhotosScreen> createState() => _AllPhotosScreenState();
}

class _AllPhotosScreenState extends State<AllPhotosScreen> {
  String _selectedCategory = 'All';

  static const List<_PhotoArchiveItem> _photos = [
    _PhotoArchiveItem(
      id: 'ph-1',
      title: 'Business Summit Keynote Audience',
      category: 'Business',
      url: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80',
      date: 'Nov 15, 2026',
    ),
    _PhotoArchiveItem(
      id: 'ph-2',
      title: 'Nepali Traditional Harmonium Performance',
      category: 'Cultural',
      url: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80',
      date: 'Oct 24, 2026',
    ),
    _PhotoArchiveItem(
      id: 'ph-3',
      title: 'Youth Tree Plantation Drive',
      category: 'Social Service',
      url: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=800&q=80',
      date: 'Sep 10, 2026',
    ),
    _PhotoArchiveItem(
      id: 'ph-4',
      title: 'Teej Festival Temple Dance Group',
      category: 'Cultural',
      url: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=800&q=80',
      date: 'Aug 18, 2026',
    ),
    _PhotoArchiveItem(
      id: 'ph-5',
      title: 'Mega Blood Donation Drive Volunteers',
      category: 'Health',
      url: 'https://images.unsplash.com/photo-1615461066841-6116e61058f4?auto=format&fit=crop&w=800&q=80',
      date: 'Jul 22, 2026',
    ),
    _PhotoArchiveItem(
      id: 'ph-6',
      title: 'Youth Leadership Mentorship Session',
      category: 'Youth',
      url: 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?auto=format&fit=crop&w=800&q=80',
      date: 'Jun 14, 2026',
    ),
    _PhotoArchiveItem(
      id: 'ph-7',
      title: 'Women Empowerment Financial Workshop',
      category: 'Social Service',
      url: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=800&q=80',
      date: 'May 08, 2026',
    ),
    _PhotoArchiveItem(
      id: 'ph-8',
      title: 'Trade Networking Meet Attendees',
      category: 'Business',
      url: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=800&q=80',
      date: 'Apr 02, 2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredPhotos = _photos.where((p) {
      if (_selectedCategory == 'All') return true;
      return p.category == _selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Deep Burgundy Header Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF6B0E1B),
                    Color(0xFF3F050C),
                  ],
                ),
              ),
              padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(AppConstants.gallery);
                          }
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0x33FFFFFF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppConstants.profile),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0x33FFFFFF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'All Photo Highlights',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Browse high-resolution event captures and community highlights',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area inside Top Rounded Container
            Transform.translate(
              offset: const Offset(0, -14),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF9F7F5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Unified Section Header: Title + Count + Category Action Dropdown Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Photo Highlights',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E1615),
                                letterSpacing: -0.4,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Category Popup Menu Filter Button
                          PopupMenuButton<String>(
                            initialValue: _selectedCategory,
                            onSelected: (cat) => setState(() => _selectedCategory = cat),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            color: Colors.white,
                            elevation: 6,
                            itemBuilder: (context) => ['All', 'Business', 'Cultural', 'Social Service', 'Youth', 'Health'].map((cat) {
                              final isSel = cat == _selectedCategory;
                              return PopupMenuItem<String>(
                                value: cat,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.collections_outlined,
                                      size: 14,
                                      color: isSel ? const Color(0xFF700D15) : const Color(0xFF666666),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      cat == 'All' ? 'All Categories' : cat,
                                      style: TextStyle(
                                        fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                                        color: isSel ? const Color(0xFF700D15) : const Color(0xFF1E1615),
                                        fontSize: 13,
                                      ),
                                    ),
                                    if (isSel) ...[
                                      const Spacer(),
                                      const Icon(Icons.check_rounded, size: 16, color: Color(0xFF700D15)),
                                    ],
                                  ],
                                ),
                              );
                            }).toList(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF500913),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF500913).withValues(alpha: 0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.filter_alt_rounded, size: 13, color: Colors.white),
                                  const SizedBox(width: 6),
                                  Text(
                                    _selectedCategory == 'All' ? 'All Categories' : _selectedCategory,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 2-Column Photo Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredPhotos.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.88,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, i) {
                          final photo = filteredPhotos[i];
                          return GestureDetector(
                            onTap: () => _showZoomableLightbox(context, photo),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFF0E8E6)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: photo.url,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    // Top-Left Category Badge
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xDD6B0E1B),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          photo.category,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Bottom Title Overlay Gradient
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 8),
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Color(0xEE000000),
                                            ],
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              photo.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w800,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              photo.date,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 3),
    );
  }

  void _showZoomableLightbox(BuildContext context, _PhotoArchiveItem photo) {
    showDialog(
      context: context,
      builder: (dialogCtx) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      photo.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(dialogCtx),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 450),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: photo.url,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Color(0xFF700D15)),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '${photo.category} • ${photo.date}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
