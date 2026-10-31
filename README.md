# 🪶 कविता सागर (Hindi Kavita Platform)

A full-stack, distraction-free Hindi poetry ecosystem with an **Admin Web Dashboard** (for uploading and publishing poems) and a **Cross-Platform Mobile App** (optimized for authentic Devanagari typography with offline caching).

---

## 📁 Project Structure

```
d:\Hindi Kavita App\
├── admin-dashboard/
│   ├── index.html                   # Complete modern Admin Dashboard (HTML5 + Tailwind + JS)
│   └── firebase-config.example.js   # Reference Firebase web configuration
├── database/
│   ├── schema.json                  # JSON Schema for Hindi Kavita documents
│   ├── sample_poems.json            # Curated Hindi poems (Dinkar, Bachchan, Kabir)
│   └── firestore.rules              # Cloud Firestore security rules
├── mobile_app/
│   ├── pubspec.yaml                 # Flutter dependencies (Firebase, Google Fonts, etc.)
│   └── lib/
│       ├── main.dart                # App entry with offline disk persistence
│       ├── models/
│       │   └── poem_model.dart      # Poem model with Firestore serialization
│       └── screens/
│           ├── home_screen.dart     # Feed, Search & Category filters
│           └── reader_screen.dart   # Distraction-free reader with font size & themes
└── README.md
```

---

## 🚀 1. Admin Dashboard (Web)

The dashboard allows you to add, edit, categorize, and publish Hindi poems. It features:
* **Real-time Devanagari Preview**: View mobile layout changes as you type.
* **Hindi Punctuation Toolbar**: Quick insert buttons for `।`, `॥`, `ँ`, `ं`, `ः`.
* **Zero-Setup Demo Mode**: Operates immediately out-of-the-box using browser `LocalStorage`.
* **One-Click Cloud Sync**: Paste your Firebase Config JSON inside the UI (⚙️ *Firebase सेटिंग्स*) to switch to live Cloud Firestore.

### How to Run:
Simply double-click or open `admin-dashboard/index.html` in any modern web browser, or serve it using:
```bash
cd admin-dashboard
npx serve .
```

---

## 📱 2. Reader Mobile App (Flutter)

A distraction-free reading experience crafted specifically for Hindi literature.

### Key Capabilities:
* **Devanagari Typography Mastery**:
  * **Titles**: Styled with [`Rozha One`](https://fonts.google.com/specimen/Rozha+One) — classic display serif with Indian heritage.
  * **Poem Body**: Styled with [`Martel`](https://fonts.google.com/specimen/Martel) with `height: 2.15` — prevents consonant conjuncts (*संयुक्ताक्षर*) and vowel signs (*मात्राएँ* like `ी`, `ु`, `ै`, `ं`) from clipping.
* **Reading Customizations**:
  * Adjustable text size (A- / A+ slider).
  * 3 Reading Palettes: **भोजपत्र (Warm Parchment)**, **धवल (Pure White)**, **रात्रि (Night Mode)**.
  * **शांत वाचन मोड (Distraction-Free Mode)**: Hides all UI headers and controls for full-screen immersive reading.
* **Automatic Offline Caching**:
  * Backed by Firestore disk persistence (`persistenceEnabled: true`), poems loaded once remain readable without an internet connection.
* **Poem Sharing**: Share full poems with poet credits directly to WhatsApp or social platforms.

### How to Run the Mobile App:
1. Ensure Flutter is installed:
   ```bash
   cd mobile_app
   flutter pub get
   ```
2. Configure Firebase using the FlutterFire CLI:
   ```bash
   flutterfire configure
   ```
3. Run on your connected emulator or device:
   ```bash
   flutter run
   ```

---

## 🗄️ 3. Database & Security

### Categories (श्रेणियाँ):
- **वीर रस** (`Veer Ras`)
- **शृंगार / प्रेम** (`Prem`)
- **भक्ति रस** (`Bhakti`)
- **प्रकृति** (`Prakriti`)
- **जीवन और दर्शन** (`Philosophy`)
- **हास्य / व्यंग्य** (`Humor/Satire`)

### Firestore Security Rules:
Located in `database/firestore.rules`. Configured so readers can freely read published poems, while document creation, edits, and deletions require admin authentication.

