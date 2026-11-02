import 'dart:math';
import 'package:flutter/material.dart';
import '../services/learning_progress.dart';
import '../theme/app_theme.dart';

class _AssessmentQuestion {
  const _AssessmentQuestion(this.prompt, this.options, this.answer, this.explanation);
  final String prompt;
  final List<String> options;
  final int answer;
  final String explanation;
}

class LevelAssessmentScreen extends StatefulWidget {
  const LevelAssessmentScreen({super.key, this.level = 'A1'});
  final String level;

  @override
  State<LevelAssessmentScreen> createState() => _LevelAssessmentScreenState();
}

class _LevelAssessmentScreenState extends State<LevelAssessmentScreen> {
  static const _questionBank = <_AssessmentQuestion>[
    _AssessmentQuestion('ما معنى Günaydın؟', ['مساء الخير', 'صباح الخير', 'إلى اللقاء', 'شكراً'], 1, 'Günaydın تعني صباح الخير.'),
    _AssessmentQuestion('اختر الضمير الذي يعني «نحن».', ['Ben', 'Sen', 'Biz', 'Onlar'], 2, 'Biz تعني نحن.'),
    _AssessmentQuestion('ما جمع كلمة kitap؟', ['kitaplar', 'kitapler', 'kitaplarım', 'kitaplerim'], 0, 'تأخذ kitap اللاحقة -lar بسبب الانسجام الصوتي.'),
    _AssessmentQuestion('أكمل: Ben ___ öğrenciyim.', ['bir', 'çok', 've', 'ama'], 0, 'يمكن استخدام bir هنا بمعنى طالب/واحد بحسب السياق.'),
    _AssessmentQuestion('ما معنى Nerede؟', ['متى؟', 'لماذا؟', 'أين؟', 'كيف؟'], 2, 'Nerede تعني أين؟'),
    _AssessmentQuestion('اختر العبارة الصحيحة: «منزلي كبير».', ['Ev büyük benim', 'Benim evim büyük', 'Büyük evim ben', 'Evim benim büyükler'], 1, 'Benim evim büyük تعني منزلي كبير.'),
    _AssessmentQuestion('ما معنى Su؟', ['خبز', 'ماء', 'كتاب', 'منزل'], 1, 'Su تعني ماء.'),
    _AssessmentQuestion('أي كلمة تعني «اليوم»؟', ['Yarın', 'Dün', 'Bugün', 'Sabah'], 2, 'Bugün تعني اليوم.'),
    _AssessmentQuestion('اختر الصفة قبل الاسم في «سيارة جديدة».', ['araba yeni', 'yeni araba', 'araba yeniler', 'yenim araba'], 1, 'الصفة تسبق الاسم: yeni araba.'),
    _AssessmentQuestion('كيف تسأل شخصاً عن اسمه؟', ['Nasılsın?', 'Adın ne?', 'Nerelisin?', 'Kaç yaşındasın?'], 1, 'Adın ne? تعني ما اسمك؟'),
    _AssessmentQuestion('ما معنى Teşekkür ederim؟', ['عفواً', 'شكراً لك', 'تصبح على خير', 'من فضلك'], 1, 'Teşekkür ederim تعني شكراً لك.'),
    _AssessmentQuestion('اختر الضمير الذي يعني «هم».', ['O', 'Biz', 'Siz', 'Onlar'], 3, 'Onlar تعني هم/هن.'),
    _AssessmentQuestion('ما معنى Yarın؟', ['أمس', 'اليوم', 'غداً', 'الآن'], 2, 'Yarın تعني غداً.'),
    _AssessmentQuestion('أكمل: Ben Türkçe ___.', ['konuşuyorum', 'konuşuyorsun', 'konuşuyoruz', 'konuşuyorlar'], 0, 'مع Ben نستخدم صيغة المتكلم: konuşuyorum.'),
    _AssessmentQuestion('ما معنى Kaç yaşındasın؟', ['أين تسكن؟', 'كم عمرك؟', 'ما اسمك؟', 'من أين أنت؟'], 1, 'Kaç yaşındasın؟ تعني كم عمرك؟'),
    _AssessmentQuestion('اختر النفي الصحيح: «لا أفهم».', ['Anlıyorum', 'Anlamıyorum', 'Anlamıyorsun', 'Anladım'], 1, 'Anlamıyorum تعني أنا لا أفهم.'),
    _AssessmentQuestion('ما معنى Lütfen؟', ['شكراً', 'نعم', 'من فضلك', 'لا'], 2, 'Lütfen تعني من فضلك.'),
    _AssessmentQuestion('اختر كلمة «كتاب».', ['Kalem', 'Defter', 'Kitap', 'Masa'], 2, 'Kitap تعني كتاب.'),
    _AssessmentQuestion('أكمل السؤال: Sen ner___?', ['ede', 'eden', 'eyim', 'eyiz'], 0, 'Nerede تعني أين؟ وتكتب كلمة واحدة.'),
    _AssessmentQuestion('ما معنى İyi akşamlar؟', ['صباح الخير', 'مساء الخير', 'إلى اللقاء', 'ليلة سعيدة'], 1, 'İyi akşamlar تعني مساء الخير.'),
  ];
  static const _questionsPerAttempt = 10;
  late List<_AssessmentQuestion> _questions;

  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _finished = false;
  bool _saving = false;
  int _best = 0;

  @override
  void initState() {
    super.initState();
    _newQuestionSet();
    _loadBest();
  }

  void _newQuestionSet() {
    final pool = List<_AssessmentQuestion>.of(_questionBank)..shuffle(Random());
    _questions = pool.take(_questionsPerAttempt).toList(growable: false);
  }

  Future<void> _loadBest() async {
    final value = await LearningProgress.levelAssessmentBest(widget.level);
    if (mounted) setState(() => _best = value);
  }

  void _answer(int option) {
    if (_selected != null || _finished) return;
    setState(() {
      _selected = option;
      if (option == _questions[_index].answer) _score++;
    });
  }

  Future<void> _next() async {
    if (_selected == null || _saving) return;
    if (_index < _questions.length - 1) {
      setState(() { _index++; _selected = null; });
      return;
    }
    setState(() => _saving = true);
    final percent = _score * 100 ~/ _questions.length;
    await LearningProgress.recordLevelAssessment(widget.level, percent);
    final best = await LearningProgress.levelAssessmentBest(widget.level);
    if (!mounted) return;
    setState(() { _best = best; _finished = true; _saving = false; });
  }

  void _restart() {
    setState(() {
      _newQuestionSet();
      _index = 0;
      _score = 0;
      _selected = null;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F7FC),
    appBar: AppBar(
      backgroundColor: const Color(0xFFF5F7FC),
      foregroundColor: AppColors.darkGreen,
      elevation: 0,
      title: Text('تقييم المستوى ${widget.level}', style: const TextStyle(fontWeight: FontWeight.w900)),
    ),
    body: SafeArea(child: ListView(
      padding: const EdgeInsets.fromLTRB(17, 8, 17, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('اختبار تشخيصي للمستوى', style: TextStyle(color: AppColors.darkGreen, fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            const Text('10 أسئلة مختارة عشوائياً من بنك يضم 20 سؤالاً في المفردات والتراكيب والقواعد الأساسية. درجة الاجتياز 80%.', style: TextStyle(color: AppColors.muted, fontSize: 11, height: 1.6)),
            const SizedBox(height: 9),
            Text('أفضل نتيجة محفوظة: $_best%', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800)),
          ]),
        ),
        const SizedBox(height: 14),
        if (_finished) _result() else _questionCard(),
      ],
    )),
  );

  Widget _questionCard() {
    final q = _questions[_index];
    final answered = _selected != null;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Text('السؤال ${_index + 1} من ${_questions.length}', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900, fontSize: 12)),
          const Spacer(),
          Text('$_score صحيحة', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
        ]),
        const SizedBox(height: 10),
        LinearProgressIndicator(value: (_index + (answered ? 1 : 0)) / _questions.length, minHeight: 7,
          backgroundColor: const Color(0xFFE9EEF6), color: const Color(0xFF2E82C7)),
        const SizedBox(height: 22),
        Text(q.prompt, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.darkGreen, fontSize: 19, height: 1.5, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        ...List.generate(q.options.length, (i) {
          final correct = i == q.answer;
          final selected = i == _selected;
          final color = answered && correct ? const Color(0xFFE8F7EF) :
              answered && selected ? const Color(0xFFFFEEEE) : const Color(0xFFF7F9FC);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: color,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: answered ? null : () => _answer(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: answered && correct ? const Color(0xFF62B889) : AppColors.border)),
                  child: Text(q.options[i], textAlign: TextAlign.right, style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          );
        }),
        if (answered) Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(q.explanation, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.navy, fontSize: 12, height: 1.6)),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: answered && !_saving ? _next : null,
          style: FilledButton.styleFrom(backgroundColor: AppColors.navy, minimumSize: const Size.fromHeight(50)),
          child: _saving ? const CircularProgressIndicator(color: Colors.white) :
            Text(_index == _questions.length - 1 ? 'إنهاء التقييم' : 'السؤال التالي'),
        ),
      ]),
    );
  }

  Widget _result() {
    final percent = _score * 100 ~/ _questions.length;
    final passed = percent >= 80;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppColors.border)),
      child: Column(children: [
        Icon(passed ? Icons.workspace_premium_rounded : Icons.menu_book_rounded,
          color: passed ? const Color(0xFFE2A63B) : AppColors.navy, size: 54),
        const SizedBox(height: 12),
        Text(passed ? 'اجتزت التقييم!' : 'تحتاج إلى مراجعة إضافية',
          style: const TextStyle(color: AppColors.darkGreen, fontSize: 21, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        Text('$percent%', style: const TextStyle(color: AppColors.navy, fontSize: 36, fontWeight: FontWeight.w900)),
        Text('$_score من ${_questions.length} إجابات صحيحة', style: const TextStyle(color: AppColors.muted)),
        const SizedBox(height: 10),
        Text(passed ? 'حققت شرط الاجتياز لهذا التقييم التشخيصي.' : 'راجع الدروس الأساسية ثم أعد المحاولة. تحتاج إلى 80% للاجتياز.',
          textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted, height: 1.6, fontSize: 12)),
        const SizedBox(height: 8),
        Text('أفضل نتيجة محفوظة: $_best%', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800)),
        const SizedBox(height: 15),
        SizedBox(width: double.infinity, child: FilledButton.icon(
          onPressed: _restart, icon: const Icon(Icons.refresh_rounded), label: const Text('إعادة التقييم'),
          style: FilledButton.styleFrom(backgroundColor: AppColors.navy, minimumSize: const Size.fromHeight(50)),
        )),
      ]),
    );
  }
}
