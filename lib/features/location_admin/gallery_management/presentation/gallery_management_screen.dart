import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/nas_logo.dart';
import '../../shared/branch_admin_nav_bar.dart';

/// B4 — Gallery Management Screen (Location Admin)
class GalleryManagementScreen extends StatefulWidget {
  const GalleryManagementScreen({super.key});

  @override
  State<GalleryManagementScreen> createState() => _GalleryManagementScreenState();
}

class _GalleryManagementScreenState extends State<GalleryManagementScreen> {
  late List<Map<String, dynamic>> _albums;

  @override
  void initState() {
    super.initState();
    _albums = [
      {
        'title': 'Teej Festival 2026',
        'date': '15 Aug 2026',
        'category': 'CULTURAL',
        'count': 18,
        'likes': 126,
        'comments': 18,
        'views': '4.8k',
        'color': const Color(0xFF5A080D),
      },
      {
        'title': 'Women Leadership Workshop',
        'date': '05 Aug 2026',
        'category': 'MEETINGS',
        'count': 24,
        'likes': 98,
        'comments': 12,
        'views': '1.2k',
        'color': const Color(0xFFE8CAAB),
      },
      {
        'title': 'Community Cleanliness Drive',
        'date': '28 Jul 2026',
        'category': 'ACTIVITIES',
        'count': 15,
        'likes': 75,
        'comments': 10,
        'views': '6.5k',
        'color': const Color(0xFF5A080D),
      },
      {
        'title': 'Blood Donation Camp',
        'date': '12 Jul 2026',
        'category': 'EVENTS',
        'count': 10,
        'likes': 156,
        'comments': 24,
        'views': '12.4k',
        'color': const Color(0xFF5A080D),
      },
    ];
  }

  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _activeCategoryFilter = 'ALL';
  String _activeSortFilter = 'NEWEST';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredAlbums {
    var result = _albums.where((album) {
      final titleMatches = album['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final categoryMatches = _activeCategoryFilter == 'ALL' ||
          album['category'].toString().toUpperCase() == _activeCategoryFilter.toUpperCase();
      return titleMatches && categoryMatches;
    }).toList();

    if (_activeSortFilter == 'OLDEST') {
      return result.reversed.toList();
    } else if (_activeSortFilter == 'MOST_LIKED') {
      var sorted = List<Map<String, dynamic>>.from(result);
      sorted.sort((a, b) => (b['likes'] as int).compareTo(a['likes'] as int));
      return sorted;
    }
    return result;
  }

  void _addNewAlbum(Map<String, dynamic> newAlbum) {
    setState(() {
      _albums.insert(0, newAlbum);
    });
  }

  void _showGalleryFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (modalCtx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFAEAEC),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.tune_rounded, color: Color(0xFF500913), size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Gallery Filters',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    if (_activeCategoryFilter != 'ALL' || _activeSortFilter != 'NEWEST')
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _activeCategoryFilter = 'ALL';
                            _activeSortFilter = 'NEWEST';
                          });
                          setModalState(() {});
                          Navigator.pop(modalCtx);
                        },
                        child: const Text('Reset All', style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w800)),
                      ),
                  ],
                ),
                const SizedBox(height: 18),

                // Category Section
                const Text('Filter by Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    {'label': 'All Posts', 'value': 'ALL'},
                    {'label': 'Cultural', 'value': 'CULTURAL'},
                    {'label': 'Events', 'value': 'EVENTS'},
                    {'label': 'Celebrations', 'value': 'CELEBRATIONS'},
                    {'label': 'Meetings', 'value': 'MEETINGS'},
                    {'label': 'Activities', 'value': 'ACTIVITIES'},
                  ].map((item) {
                    final isSel = _activeCategoryFilter == item['value'];
                    return InkWell(
                      onTap: () {
                        setState(() => _activeCategoryFilter = item['value']!);
                        setModalState(() {});
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFF500913) : const Color(0xFFF9F6F0),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSel ? const Color(0xFF500913) : const Color(0xFFEFE8E5)),
                        ),
                        child: Text(
                          item['label']!,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isSel ? FontWeight.w900 : FontWeight.w700,
                            color: isSel ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Sort Section
                const Text('Sort By', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    {'label': 'Newest First', 'value': 'NEWEST'},
                    {'label': 'Oldest First', 'value': 'OLDEST'},
                    {'label': 'Most Liked', 'value': 'MOST_LIKED'},
                  ].map((item) {
                    final isSel = _activeSortFilter == item['value'];
                    return InkWell(
                      onTap: () {
                        setState(() => _activeSortFilter = item['value']!);
                        setModalState(() {});
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFFC4901E) : const Color(0xFFF9F6F0),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSel ? const Color(0xFFC4901E) : const Color(0xFFEFE8E5)),
                        ),
                        child: Text(
                          item['label']!,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isSel ? FontWeight.w900 : FontWeight.w700,
                            color: isSel ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Apply Button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(modalCtx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF500913),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Apply Filters', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(bottom: 20),
            children: [
              const _AdminTopBar(),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _HeroBanner(onUploadComplete: _addNewAlbum),
              ),
              const SizedBox(height: 20),

            // Metrics Strip (4 Equal Columns - All Visible at Once Without Scrolling)
            Builder(builder: (context) {
              int totalPhotos = 128 + _albums.fold<int>(0, (sum, a) => sum + (a['count'] as int? ?? 0));
              int totalVideos = 16 + _albums.fold<int>(0, (sum, a) => sum + (a['category'] == 'VIDEO' ? 1 : 0));
              int totalLikes = 856 + _albums.fold<int>(0, (sum, a) => sum + (a['likes'] as int? ?? 0));

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            title: 'PHOTOS',
                            value: '$totalPhotos',
                            icon: Icons.image_rounded,
                            iconColor: const Color(0xFFE8622C),
                            iconBg: const Color(0xFFFBE0D2),
                          ),
                        ),
                        const VerticalDivider(width: 1, color: AppColors.border),
                        Expanded(
                          child: _MetricCard(
                            title: 'VIDEOS',
                            value: '$totalVideos',
                            icon: Icons.video_library_rounded,
                            iconColor: const Color(0xFF1565C0),
                            iconBg: const Color(0xFFE3F2FD),
                          ),
                        ),
                        const VerticalDivider(width: 1, color: AppColors.border),
                        Expanded(
                          child: _MetricCard(
                            title: 'LIKES',
                            value: '$totalLikes',
                            icon: Icons.favorite_rounded,
                            iconColor: const Color(0xFFD64F64),
                            iconBg: const Color(0xFFFDECEF),
                          ),
                        ),
                        const VerticalDivider(width: 1, color: AppColors.border),
                        const Expanded(
                          child: _MetricCard(
                            title: 'VIEWS',
                            value: '2.4K',
                            icon: Icons.visibility_rounded,
                            iconColor: Color(0xFFC4901E),
                            iconBg: Color(0xFFFCF7EB),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            // Clean Streamlined Search & Single Filter Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Real-time Search Input
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (val) => setState(() => _searchQuery = val),
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'Search photos, events & albums...',
                          hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textSecondary),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 16, color: Colors.grey),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: const BorderSide(color: Color(0xFF500913), width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Single Interactive Filter Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showGalleryFilterModal(context),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: _activeCategoryFilter != 'ALL' || _activeSortFilter != 'NEWEST'
                              ? const Color(0xFF500913)
                              : Colors.white,
                          border: Border.all(
                            color: _activeCategoryFilter != 'ALL' || _activeSortFilter != 'NEWEST'
                                ? const Color(0xFF500913)
                                : const Color(0xFFE8622C).withValues(alpha: 0.4),
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              color: _activeCategoryFilter != 'ALL' || _activeSortFilter != 'NEWEST'
                                  ? Colors.white
                                  : const Color(0xFFE8622C),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _activeCategoryFilter == 'ALL' ? 'Filter' : _activeCategoryFilter,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: _activeCategoryFilter != 'ALL' || _activeSortFilter != 'NEWEST'
                                    ? Colors.white
                                    : const Color(0xFFE8622C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Albums Grid or Empty State
            if (_filteredAlbums.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.photo_library_outlined, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      'No media found',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Try adjusting your search query or filter selection',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredAlbums.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    return _GalleryCard(item: _filteredAlbums[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String label) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(label, style: const TextStyle(color: Color(0xFF6B1216), fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

// ---------------------------------------------------------------------------
// TOP BAR WITH EXIT BUTTON
// ---------------------------------------------------------------------------
class _AdminTopBar extends StatelessWidget {
  const _AdminTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const NasLogo(size: 38),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nepal Agrawal Samaj',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Text(
                      'Kathmandu Branch',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 11.5, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Colors.grey.shade700),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () => context.go(AppConstants.home),
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(100)),
              child: Row(
                children: const [
                  Text('Exit', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  SizedBox(width: 2),
                  Icon(Icons.logout_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ULTRA-SLEEK COMPACT GALLERY HERO BANNER (TOP-RIGHT UPLOAD BUTTON)
// ---------------------------------------------------------------------------
class _HeroBanner extends StatelessWidget {
  final Function(Map<String, dynamic>) onUploadComplete;
  const _HeroBanner({required this.onUploadComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF500913), Color(0xFF700D15), Color(0xFF3C050C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF500913).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Ambient Background Accents
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              right: 80,
              bottom: -30,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFC4901E).withValues(alpha: 0.08),
                ),
              ),
            ),

            // Content Body
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Row: Tag & Top-Right Sleek + Upload Pill
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC4901E).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE5C8A6).withValues(alpha: 0.4), width: 0.8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.photo_library_rounded, size: 11, color: Color(0xFFE5C8A6)),
                            SizedBox(width: 4),
                            Text(
                              'MEDIA GALLERY',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFE5C8A6),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Compact Sleek + Upload Button in Top Right
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showUploadMediaModal(context, onUploadComplete),
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.add_a_photo_rounded, size: 13, color: Color(0xFF500913)),
                                SizedBox(width: 5),
                                Text(
                                  'Upload',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF500913),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Title & Subtitle
                  const Text(
                    'Branch Media Gallery',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Organize, celebrate & showcase community moments.',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showUploadMediaModal(BuildContext context, Function(Map<String, dynamic>) onUploadComplete) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (modalCtx) => _UploadMediaDialog(onUploadComplete: onUploadComplete),
  );
}

class _UploadMediaDialog extends StatefulWidget {
  final Function(Map<String, dynamic> newAlbum) onUploadComplete;

  const _UploadMediaDialog({required this.onUploadComplete});

  @override
  State<_UploadMediaDialog> createState() => _UploadMediaDialogState();
}

class _UploadMediaDialogState extends State<_UploadMediaDialog> {
  final TextEditingController _titleCtrl = TextEditingController();
  String _selectedType = 'PHOTO'; // 'PHOTO', 'VIDEO'
  String _selectedCategory = 'CULTURAL';
  int _attachedFileCount = 0;
  List<String> _attachedFileNames = [];
  bool _isUploading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  void _handleFileSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (pickerCtx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select ${_selectedType == "PHOTO" ? "Photo" : "Video"} Source',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose how you want to add ${_selectedType == "PHOTO" ? "photos" : "videos"} to this album',
              style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 18),

            // Option 1: Gallery
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(color: const Color(0xFFFCF7EB), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.photo_library_rounded, color: Color(0xFFC4901E), size: 22),
              ),
              title: const Text('Select from Gallery', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
              subtitle: Text('Pick ${_selectedType == "PHOTO" ? "photos" : "video clip"} from device gallery', style: const TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              onTap: () {
                Navigator.pop(pickerCtx);
                _attachSingleFile('Gallery');
              },
            ),
            const Divider(height: 1),

            // Option 2: Camera
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(color: const Color(0xFFE5F5E9), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.camera_alt_rounded, color: Color(0xFF2E7D32), size: 22),
              ),
              title: const Text('Take with Camera', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
              subtitle: Text('Capture new ${_selectedType == "PHOTO" ? "photo" : "video recording"}', style: const TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              onTap: () {
                Navigator.pop(pickerCtx);
                _attachSingleFile('Camera');
              },
            ),
            const Divider(height: 1),

            // Option 3: File Manager
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.folder_rounded, color: Color(0xFF1565C0), size: 22),
              ),
              title: const Text('Browse Files', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
              subtitle: const Text('Select file from device storage', style: TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              onTap: () {
                Navigator.pop(pickerCtx);
                _attachSingleFile('Storage');
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _attachSingleFile(String source) {
    setState(() {
      final nextIdx = _attachedFileNames.length + 1;
      final ext = _selectedType == 'PHOTO' ? 'jpg' : 'mp4';
      _attachedFileNames.add('${source}_${_selectedType}_0$nextIdx.$ext');
      _attachedFileCount = _attachedFileNames.length;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected ${_selectedType == "PHOTO" ? "photo" : "video"} from $source'),
        backgroundColor: const Color(0xFF500913),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removeFile(int index) {
    setState(() {
      _attachedFileNames.removeAt(index);
      _attachedFileCount = _attachedFileNames.length;
    });
  }

  void _clearFiles() {
    setState(() {
      _attachedFileNames.clear();
      _attachedFileCount = 0;
    });
  }

  void _handleUpload() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter an album title'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_attachedFileCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please attach at least one ${_selectedType == "PHOTO" ? "photo" : "video"} file'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final newAlbum = {
      'title': _titleCtrl.text.trim(),
      'date': 'Just now',
      'category': _selectedCategory,
      'count': _attachedFileCount,
      'likes': 0,
      'comments': 0,
      'views': '1',
      'color': const Color(0xFF500913),
    };

    widget.onUploadComplete(newAlbum);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text('${_selectedType == "PHOTO" ? "Photo Album" : "Video Reel"} with $_attachedFileCount files published!'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF3E7C4A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F6F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 14, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF500913), Color(0xFF700D15)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.cloud_upload_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Upload Branch Media',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Add photos & video highlights to Kathmandu Branch gallery',
                            style: TextStyle(fontSize: 11, color: Color(0xFFE5C8A6), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable Form Body
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type Selector: Photos vs Video
                  const Text('Select Media Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedType = 'PHOTO';
                              _attachedFileNames.clear();
                              _attachedFileCount = 0;
                            });
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
                            decoration: BoxDecoration(
                              color: _selectedType == 'PHOTO' ? const Color(0xFF500913) : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: _selectedType == 'PHOTO' ? const Color(0xFF500913) : const Color(0xFFEFE8E5)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.photo_library_rounded, size: 17, color: _selectedType == 'PHOTO' ? Colors.white : const Color(0xFF500913)),
                                const SizedBox(width: 6),
                                Text(
                                  'Photo Album',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: _selectedType == 'PHOTO' ? Colors.white : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedType = 'VIDEO';
                              _attachedFileNames.clear();
                              _attachedFileCount = 0;
                            });
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
                            decoration: BoxDecoration(
                              color: _selectedType == 'VIDEO' ? const Color(0xFF1565C0) : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: _selectedType == 'VIDEO' ? const Color(0xFF1565C0) : const Color(0xFFEFE8E5)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.video_library_rounded, size: 17, color: _selectedType == 'VIDEO' ? Colors.white : const Color(0xFF1565C0)),
                                const SizedBox(width: 6),
                                Text(
                                  'Video Reel',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: _selectedType == 'VIDEO' ? Colors.white : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Album Title Field
                  const Text('Title / Event Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _titleCtrl,
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      hintText: _selectedType == 'PHOTO' ? 'e.g. Teej Mahotsav 2026 Photos' : 'e.g. Cultural Program Highlight Clip',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEFE8E5))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEFE8E5))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF500913), width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Selector with Smooth AnimatedContainer Pills
                  const Text('Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['CULTURAL', 'CELEBRATIONS', 'MEETINGS', 'ACTIVITIES', 'EVENTS'].map(_buildCategoryPill).toList(),
                  ),
                  const SizedBox(height: 18),

                  // Interactive File Uploader Zone
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Upload Files', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      if (_attachedFileCount > 0)
                        TextButton(
                          onPressed: _clearFiles,
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: const Text('Clear all', style: TextStyle(fontSize: 11.5, color: Colors.red, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _handleFileSelection,
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                      decoration: BoxDecoration(
                        color: _attachedFileCount > 0 ? const Color(0xFFE5F5E9) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _attachedFileCount > 0 ? const Color(0xFF2E7D32) : const Color(0xFFD4C8C2),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _attachedFileCount > 0 ? const Color(0xFFC8E6C9) : const Color(0xFFFAEAEC),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _attachedFileCount > 0 ? Icons.check_circle_rounded : Icons.add_photo_alternate_rounded,
                              size: 26,
                              color: _attachedFileCount > 0 ? const Color(0xFF2E7D32) : const Color(0xFF500913),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _attachedFileCount > 0
                                ? '$_attachedFileCount ${_selectedType == "PHOTO" ? "Photos" : "Videos"} Attached'
                                : 'Tap to select ${_selectedType == "PHOTO" ? "photos" : "videos"} from device',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: _attachedFileCount > 0 ? const Color(0xFF2E7D32) : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _attachedFileCount > 0
                                ? 'Tap to attach more files'
                                : 'Supports JPG, PNG, MP4, MOV up to 50MB',
                            style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Display attached file chips when files are selected
                  if (_attachedFileCount > 0) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: List.generate(_attachedFileNames.length, (idx) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _selectedType == 'PHOTO' ? Icons.image_rounded : Icons.movie_rounded,
                                size: 12,
                                color: const Color(0xFF2E7D32),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _attachedFileNames[idx],
                                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () => _removeFile(idx),
                                child: const Icon(Icons.close_rounded, size: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Publish Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _handleUpload,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF500913),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 3,
                      ),
                      child: _isUploading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.cloud_upload_rounded, size: 19),
                                SizedBox(width: 8),
                                Text(
                                  'Publish to Branch Gallery',
                                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, letterSpacing: 0.2),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(String cat) {
    final isSel = _selectedCategory == cat;
    return InkWell(
      onTap: () => setState(() => _selectedCategory = cat),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFF500913) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSel ? const Color(0xFF500913) : const Color(0xFFEFE8E5),
            width: isSel ? 1.5 : 1.0,
          ),
          boxShadow: isSel
              ? [
                  BoxShadow(
                    color: const Color(0xFF500913).withValues(alpha: 0.22),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSel) ...[
              const Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFFE5C8A6)),
              const SizedBox(width: 5),
            ],
            Text(
              cat,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSel ? FontWeight.w900 : FontWeight.w700,
                color: isSel ? Colors.white : AppColors.textPrimary,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MINI METRIC CARD (CENTERED & COMPACT FOR 4-COLUMN ROW)
// ---------------------------------------------------------------------------
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 11),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF500913),
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// GALLERY CARD
// ---------------------------------------------------------------------------
class _GalleryCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _GalleryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showAlbumDetailModal(context, item),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: item['color'],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(Icons.photo_library_outlined, size: 40, color: AppColors.primary.withValues(alpha: 0.2)),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.image_outlined, size: 10, color: Colors.white),
                              const SizedBox(width: 4),
                              Text('${item['count']}', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF5A080D)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 11, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(item['date'], style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ALBUM / POST DETAIL MODAL (CLEAN SIMPLE PHOTO DISPLAY)
// ---------------------------------------------------------------------------
void _showAlbumDetailModal(BuildContext context, Map<String, dynamic> item) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (modalCtx) => Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle bar
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),

          // Clean Top Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] ?? 'Album Media',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF500913),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item['count'] ?? 12} Photos • ${item['date'] ?? 'Recent'}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(modalCtx),
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded, size: 18, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // Clean Image Grid Displaying All Photos
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: (item['count'] as int? ?? 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, idx) {
                final colors = [
                  const Color(0xFF5A080D),
                  const Color(0xFF2C3E50),
                  const Color(0xFF8E44AD),
                  const Color(0xFFD35400),
                  const Color(0xFF16A085),
                  const Color(0xFF2980B9),
                ];
                final tileColor = colors[idx % colors.length];

                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: tileColor,
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            item['category'] == 'VIDEO' ? Icons.play_circle_fill_rounded : Icons.image_rounded,
                            size: 42,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Photo #${idx + 1}',
                              style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}


