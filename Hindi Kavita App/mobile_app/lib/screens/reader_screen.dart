import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../models/poem_model.dart';

enum ReadingTheme { parchment, night, pureWhite }

class ReaderScreen extends StatefulWidget {
  final Poem poem;
  const ReaderScreen({super.key, required this.poem});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  double _fontSize = 19.0;
  ReadingTheme _theme = ReadingTheme.parchment;
  bool _isDistractionFree = false;

  Color get _backgroundColor {
    switch (_theme) {
      case ReadingTheme.night:
        return const Color(0xFF18181B); // Zinc 900
      case ReadingTheme.pureWhite:
        return const Color(0xFFFFFFFF);
      case ReadingTheme.parchment:
      default:
        return const Color(0xFFFBF8F2); // Warm vintage parchment
    }
  }

  Color get _textColor {
    switch (_theme) {
      case ReadingTheme.night:
        return const Color(0xFFE4E4E7);
      case ReadingTheme.pureWhite:
        return const Color(0xFF18181B);
      case ReadingTheme.parchment:
      default:
        return const Color(0xFF2E241E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _isDistractionFree
          ? null
          : AppBar(
              backgroundColor: _backgroundColor,
              elevation: 0,
              iconTheme: IconThemeData(color: _textColor),
              actions: [
                IconButton(
                  icon: const Icon(Icons.format_size_rounded),
                  tooltip: 'फ़ॉन्ट आकार',
                  onPressed: _showTypographySettings,
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  tooltip: 'साझा करें',
                  onPressed: () {
                    Share.share(
                      '${widget.poem.title}\n— ${widget.poem.poetName}\n\n${widget.poem.body}\n\n(कविता सागर ऐप से)',
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.fullscreen_rounded),
                  tooltip: 'शांत वाचन मोड',
                  onPressed: () {
                    setState(() => _isDistractionFree = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('मेनू वापस लाने के लिए स्क्रीन पर कहीं भी टैप करें।'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_isDistractionFree) {
            setState(() => _isDistractionFree = false);
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: _textColor.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.poem.category,
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 12,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w600,
                    color: _textColor.withOpacity(0.75),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Title in Rozha One
              Text(
                widget.poem.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.rozhaOne(
                  fontSize: _fontSize + 8,
                  height: 1.35,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 8),

              // Poet Attribution
              Text(
                '— ${widget.poem.poetName}',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: _textColor.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),

              // Classic floral ornament divider
              Text(
                '❖  ❖  ❖',
                style: TextStyle(
                  color: _textColor.withOpacity(0.35),
                  fontSize: 15,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 28),

              // Poem Body in Martel (Devanagari Serif with ample line height)
              SelectableText(
                widget.poem.body,
                textAlign: TextAlign.center,
                style: GoogleFonts.martel(
                  fontSize: _fontSize,
                  height: 2.15, // Optimal line height to prevent vowel-sign / matra overlap
                  letterSpacing: 0.35,
                  fontWeight: FontWeight.w400,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 70),

              if (_isDistractionFree)
                Text(
                  'मेनू देखने के लिए स्क्रीन पर टैप करें',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 12,
                    color: _textColor.withOpacity(0.35),
                  ),
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showTypographySettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'वाचन सेटिंग्स (Reading Settings)',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Font Size Slider
                  Row(
                    children: [
                      Text('अ', style: TextStyle(fontSize: 14, color: _textColor)),
                      Expanded(
                        child: Slider(
                          value: _fontSize,
                          min: 15.0,
                          max: 30.0,
                          activeColor: const Color(0xFF78350F),
                          onChanged: (val) {
                            setModalState(() => _fontSize = val);
                            setState(() => _fontSize = val);
                          },
                        ),
                      ),
                      Text('अ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textColor)),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Background Theme Selector
                  Text(
                    'पृष्ठभूमि थीम (Color Theme)',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _themeButton('भोजपत्र (Warm)', ReadingTheme.parchment, const Color(0xFFFBF8F2), Colors.black87),
                      _themeButton('धवल (White)', ReadingTheme.pureWhite, Colors.white, Colors.black87),
                      _themeButton('रात्रि (Night)', ReadingTheme.night, const Color(0xFF18181B), Colors.white),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _themeButton(String label, ReadingTheme theme, Color bg, Color text) {
    final isSelected = _theme == theme;
    return GestureDetector(
      onTap: () {
        setState(() => _theme = theme);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(
            color: isSelected ? const Color(0xFF78350F) : Colors.grey.shade400,
            width: isSelected ? 2.5 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF78350F).withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(color: text, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

