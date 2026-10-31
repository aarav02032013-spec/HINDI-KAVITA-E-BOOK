import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/poem_model.dart';
import 'reader_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'सभी';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'सभी',
    'वीर रस',
    'प्रेम',
    'भक्ति',
    'प्रकृति',
    'जीवन और दर्शन',
    'हास्य / व्यंग्य',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'कविता सागर',
          style: GoogleFonts.rozhaOne(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF78350F),
          ),
        ),
        backgroundColor: const Color(0xFFFAF7F2),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
              style: GoogleFonts.notoSansDevanagari(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'शीर्षक या कवि के नाम से खोजें...',
                hintStyle: GoogleFonts.notoSansDevanagari(fontSize: 14, color: Colors.grey.shade500),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF78350F)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF78350F), width: 1.5),
                ),
              ),
            ),
          ),

          // Categories Horizontal Chip List
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(
                      cat,
                      style: GoogleFonts.notoSansDevanagari(
                        color: isSelected ? Colors.white : Colors.stone.shade800,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF78350F),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF78350F) : Colors.grey.shade300,
                      ),
                    ),
                    onSelected: (bool selected) {
                      setState(() => _selectedCategory = cat);
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 6),

          // Real-time Firestore Stream Builder (Works seamlessly online & offline)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('poems')
                  .where('is_published', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF78350F)));
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'कविताएँ लोड करने में समस्या: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSansDevanagari(color: Colors.red),
                      ),
                    ),
                  );
                }

                final allDocs = snapshot.data?.docs ?? [];
                if (allDocs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('📜', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          'कोई प्रकाशित कविता नहीं मिली',
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.stone.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'व्यवस्थापक डैशबोर्ड से कविताएँ प्रकाशित करें',
                          style: GoogleFonts.notoSansDevanagari(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final poems = allDocs.map((d) => Poem.fromFirestore(d)).toList();

                // Apply Search & Category Filtering
                final filtered = poems.where((p) {
                  final matchesCat = _selectedCategory == 'सभी' || p.category == _selectedCategory;
                  final matchesSearch = _searchQuery.isEmpty ||
                      p.title.toLowerCase().contains(_searchQuery) ||
                      p.poetName.toLowerCase().contains(_searchQuery);
                  return matchesCat && matchesSearch;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'इस खोज के लिए कोई कविता नहीं मिली',
                      style: GoogleFonts.notoSansDevanagari(fontSize: 15, color: Colors.grey.shade600),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final poem = filtered[index];
                    return _PoemFeedCard(poem: poem);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PoemFeedCard extends StatelessWidget {
  final Poem poem;
  const _PoemFeedCard({required this.poem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ReaderScreen(poem: poem)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF4ED),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      poem.category,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF78350F),
                      ),
                    ),
                  ),
                  Text(
                    '~${poem.readingTimeMinutes} मि. पाठ',
                    style: GoogleFonts.notoSansDevanagari(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                poem.title,
                style: GoogleFonts.rozhaOne(
                  fontSize: 21,
                  color: const Color(0xFF2C241D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '— ${poem.poetName}',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                poem.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.martel(
                  fontSize: 14,
                  height: 1.7,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

