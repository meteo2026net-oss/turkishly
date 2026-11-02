import 'package:flutter/material.dart';
import '../services/learning_progress.dart';
import '../theme/app_theme.dart';

class _Word {
  const _Word(this.id, this.tr, this.ar, this.example, this.translation);
  final String id, tr, ar, example, translation;
}

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});
  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  static const _words = <_Word>[
    _Word('merhaba', 'Merhaba', 'مرحباً', 'Merhaba, nasılsın?', 'مرحباً، كيف حالك؟'),
    _Word('tesekkurler', 'Teşekkürler', 'شكراً', 'Yardımın için teşekkürler.', 'شكراً على مساعدتك.'),
    _Word('lutfen', 'Lütfen', 'من فضلك', 'Bir kahve, lütfen.', 'قهوة من فضلك.'),
    _Word('evet', 'Evet', 'نعم', 'Evet, anladım.', 'نعم، فهمت.'),
    _Word('hayir', 'Hayır', 'لا', 'Hayır, teşekkür ederim.', 'لا، شكراً لك.'),
    _Word('gunaydin', 'Günaydın', 'صباح الخير', 'Günaydın, öğretmenim.', 'صباح الخير يا أستاذي.'),
    _Word('iyiaksamlar', 'İyi akşamlar', 'مساء الخير', 'İyi akşamlar, hoş geldiniz.', 'مساء الخير، أهلاً وسهلاً.'),
    _Word('hoscakalin', 'Hoşça kalın', 'إلى اللقاء', 'Yarın görüşürüz, hoşça kalın.', 'نلتقي غداً، إلى اللقاء.'),
    _Word('su', 'Su', 'ماء', 'Bir bardak su istiyorum.', 'أريد كأس ماء.'),
    _Word('ekmek', 'Ekmek', 'خبز', 'Taze ekmek aldım.', 'اشتريت خبزاً طازجاً.'),
    _Word('ev', 'Ev', 'منزل', 'Benim evim küçük.', 'منزلي صغير.'),
    _Word('kitap', 'Kitap', 'كتاب', 'Bu kitap çok güzel.', 'هذا الكتاب جميل جداً.'),
    _Word('arkadas', 'Arkadaş', 'صديق', 'O benim arkadaşım.', 'هو صديقي.'),
    _Word('bugun', 'Bugün', 'اليوم', 'Bugün hava güzel.', 'الطقس جميل اليوم.'),
    _Word('yarin', 'Yarın', 'غداً', 'Yarın okula gidiyorum.', 'سأذهب إلى المدرسة غداً.'),
    _Word('sevgi', 'Sevgi', 'محبة', 'Sevgi çok önemlidir.', 'المحبة مهمة جداً.'),
  ];

  Set<String> _learned = <String>{};
  int _index = 0;
  bool _showMeaning = false;
  bool _loading = true;
  Map<String, int> _dueAt = <String, int>{};

  List<_Word> get _reviewQueue {
    final items = List<_Word>.of(_words);
    items.sort((a, b) {
      final aDue = _dueAt[a.id] ?? 0;
      final bDue = _dueAt[b.id] ?? 0;
      final byDue = aDue.compareTo(bDue);
      if (byDue != 0) return byDue;
      final aLearned = _learned.contains(a.id);
      final bLearned = _learned.contains(b.id);
      return aLearned == bLearned ? 0 : (aLearned ? 1 : -1);
    });
    return items;
  }

  _Word get _currentWord => _reviewQueue[_index];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final saved = await LearningProgress.learnedWords();
    final due = <String, int>{};
    for (final word in _words) {
      final date = await LearningProgress.wordReviewDueAt(word.id);
      if (date != null) due[word.id] = date.millisecondsSinceEpoch;
    }
    if (!mounted) return;
    setState(() { _learned = saved; _dueAt = due; _loading = false; });
  }

  Future<void> _recordRecall(bool recalled) async {
    final word = _currentWord;
    await LearningProgress.recordWordReview(word.id, recalled: recalled);
    if (recalled) {
      _learned.add(word.id);
    } else {
      _learned.remove(word.id);
    }
    await LearningProgress.setWordLearned(word.id, recalled);
    final due = await LearningProgress.wordReviewDueAt(word.id);
    if (!mounted) return;
    setState(() {
      if (due != null) _dueAt[word.id] = due.millisecondsSinceEpoch;
      _showMeaning = false;
      _index = (_index + 1) % _words.length;
    });
  }

  void _move(int delta) {
    setState(() {
      _index = (_index + delta + _words.length) % _words.length;
      _showMeaning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final word = _currentWord;
    final learned = _learned.contains(word.id);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      body: SafeArea(child: _loading
        ? const Center(child: CircularProgressIndicator())
        : CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('مراجعة المفردات', style: TextStyle(color: AppColors.darkGreen, fontSize: 25, fontWeight: FontWeight.w900)),
              const SizedBox(height: 5),
              const Text('تعلم كلمة، افهم استخدامها، ثم اختبر ذاكرتك.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
              const SizedBox(height: 18),
              _progress(),
            ]),
          )),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(17, 10, 17, 25),
            child: Column(children: [
              Row(children: [
                Text('بطاقة ${_index + 1} من ${_words.length} • مراجعة ذكية', style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
                const Spacer(),
                if (learned) const Icon(Icons.check_circle_rounded, color: Color(0xFF29945F), size: 18),
                if (learned) const SizedBox(width: 5),
                Text(learned ? 'تم إتقانها' : 'قيد المراجعة', style: TextStyle(color: learned ? const Color(0xFF29945F) : AppColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => setState(() => _showMeaning = !_showMeaning),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 265),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft,
                      colors: [Color(0xFF102B52), Color(0xFF2676B8)]),
                    boxShadow: [BoxShadow(color: const Color(0xFF123D70).withValues(alpha: .18), blurRadius: 22, offset: const Offset(0, 10))],
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(_showMeaning ? Icons.translate_rounded : Icons.style_rounded, color: const Color(0xFFFFD98A), size: 28),
                    const SizedBox(height: 17),
                    Text(_showMeaning ? word.ar : word.tr,
                      textDirection: _showMeaning ? TextDirection.rtl : TextDirection.ltr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 31, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    if (_showMeaning) ...[
                      Container(height: 1, width: 70, color: Colors.white24),
                      const SizedBox(height: 14),
                      Text(word.example, textDirection: TextDirection.ltr, textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFFFFD98A), fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 7),
                      Text(word.translation, textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withValues(alpha: .8), fontSize: 12)),
                    ] else
                      Text('فكّر في المعنى أولاً، ثم اضغط للكشف', style: TextStyle(color: Colors.white.withValues(alpha: .72), fontSize: 12)),
                  ]),
                ),
              ),
              const SizedBox(height: 15),
              if (_showMeaning) ...[
                Row(children: [
                  Expanded(child: OutlinedButton.icon(
                    onPressed: () => _recordRecall(false),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('لم أتذكرها'),
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50),
                      foregroundColor: const Color(0xFFB45309), side: const BorderSide(color: Color(0xFFE8C58B))),
                  )),
                  const SizedBox(width: 9),
                  Expanded(child: FilledButton.icon(
                    onPressed: () => _recordRecall(true),
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('تذكرتها'),
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50),
                      backgroundColor: AppColors.navy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  )),
                ]),
              ] else
                SizedBox(width: double.infinity, child: OutlinedButton.icon(
                  onPressed: () => setState(() => _showMeaning = true),
                  icon: const Icon(Icons.visibility_rounded),
                  label: const Text('إظهار المعنى بعد المحاولة'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50), foregroundColor: AppColors.navy),
                )),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: OutlinedButton.icon(onPressed: () => _move(-1),
                  icon: const Icon(Icons.arrow_forward_rounded), label: const Text('السابقة'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(47), foregroundColor: AppColors.navy))),
                const SizedBox(width: 10),
                Expanded(child: OutlinedButton.icon(onPressed: () => _move(1),
                  icon: const Icon(Icons.arrow_back_rounded), label: const Text('التالية'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(47), foregroundColor: AppColors.navy))),
              ]),
              const SizedBox(height: 20),
              Align(alignment: Alignment.centerRight, child: Text('كلمات تحتاج إلى مراجعة',
                style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 16))),
              const SizedBox(height: 9),
              ..._reviewQueue.where((w) => !_learned.contains(w.id)).take(5).map((w) => Container(
                margin: const EdgeInsets.only(bottom: 7),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: Row(children: [
                  Expanded(child: Text(w.tr, textDirection: TextDirection.ltr,
                    style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900))),
                  Text(w.ar, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                ]),
              )),
              if (_learned.length >= _words.length)
                const Padding(padding: EdgeInsets.all(16), child: Text('رائع! أتقنت جميع كلمات هذه المجموعة.',
                  style: TextStyle(color: Color(0xFF29945F), fontWeight: FontWeight.w800))),
            ]),
          )),
        ])),
    );
  }

  Widget _progress() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Icon(Icons.auto_awesome_rounded, color: AppColors.navy),
        const SizedBox(width: 8),
        const Expanded(child: Text('تقدم حفظ الكلمات', style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900))),
        Text('${_learned.length} / ${_words.length}', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900)),
      ]),
      const SizedBox(height: 12),
      ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(
        value: _learned.length / _words.length, minHeight: 9,
        backgroundColor: const Color(0xFFE9EEF6), color: const Color(0xFF2E82C7))),
    ]),
  );
}
