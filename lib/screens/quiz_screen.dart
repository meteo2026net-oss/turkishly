import 'package:flutter/material.dart';
import '../services/learning_progress.dart';
import '../theme/app_theme.dart';

class _QuizQuestion {
  const _QuizQuestion(this.prompt, this.options, this.answer, this.explanation);
  final String prompt;
  final List<String> options;
  final int answer;
  final String explanation;
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const _questions = <_QuizQuestion>[
    _QuizQuestion('كم حرفاً في الأبجدية التركية الحديثة؟', ['26', '28', '29', '30'], 2, 'الأبجدية التركية الحديثة تتكوّن من 29 حرفاً.'),
    _QuizQuestion('ما معنى Merhaba؟', ['شكراً', 'مرحباً', 'إلى اللقاء', 'من فضلك'], 1, 'Merhaba تعني مرحباً، وتستخدم للتحية.'),
    _QuizQuestion('ما جمع كلمة ev؟', ['evlar', 'evler', 'evlerı', 'evlerlar'], 1, 'آخر حركة في ev هي e، لذلك نستخدم لاحقة الجمع -ler.'),
    _QuizQuestion('أي حرف تركي صوته قريب من sh في الإنجليزية؟', ['c', 'ş', 'ç', 'j'], 1, 'الحرف ş يُنطق قريباً من sh.'),
    _QuizQuestion('ما معنى Teşekkürler؟', ['عفواً', 'صباح الخير', 'شكراً', 'تصبح على خير'], 2, 'Teşekkürler تعني شكراً.'),
    _QuizQuestion('اختر الترتيب الصحيح لعبارة «سيارة زرقاء».', ['araba mavi', 'mavi araba', 'araba mavil', 'mavi bir'], 1, 'الصفة تأتي قبل الاسم في التركية: mavi araba.'),
    _QuizQuestion('ما معنى Lütfen؟', ['من فضلك', 'نعم', 'لا', 'اليوم'], 0, 'Lütfen تعني من فضلك أو رجاءً.'),
    _QuizQuestion('أي مجموعة تتكوّن من حركات خلفية؟', ['e, i, ö, ü', 'a, ı, o, u', 'a, e, i, o', 'ı, i, u, ü'], 1, 'الحركات الخلفية هي a, ı, o, u.'),
    _QuizQuestion('ما معنى Bugün؟', ['غداً', 'أمس', 'اليوم', 'الآن'], 2, 'Bugün تعني اليوم.'),
    _QuizQuestion('ما معنى Bu؟', ['ذلك البعيد', 'هذا/هذه للقريب', 'أين', 'من؟'], 1, 'Bu تستخدم للإشارة إلى شيء قريب: هذا أو هذه.'),
    _QuizQuestion('كيف نقول «أنا أيضاً بخير»؟', ['Ben öğrenciyim.', 'Ben de iyiyim.', 'İyi geceler.', 'Adın ne?'], 1, 'Ben de iyiyim تعني أنا أيضاً بخير.'),
    _QuizQuestion('ما معنى kitap؟', ['قلم', 'باب', 'كتاب', 'منزل'], 2, 'kitap تعني كتاب.'),
  ];

  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _finished = false;
  bool _saving = false;
  int _best = 0;
  int _count = 0;
  List<String> _missedQuestions = <String>[];
  List<Map<String, dynamic>> _missedDetails = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final values = await Future.wait([
      LearningProgress.bestQuizScore(),
      LearningProgress.quizCount(),
    ]);
    if (mounted) setState(() { _best = values[0]; _count = values[1]; });
  }

  Future<void> _choose(int option) async {
    if (_selected != null || _finished) return;
    final question = _questions[_index];
    setState(() {
      _selected = option;
      if (option == question.answer) _score++;
    });
    if (option != question.answer) {
      await LearningProgress.recordMissedQuestionDetails(
        prompt: question.prompt,
        selectedAnswer: question.options[option],
        correctAnswer: question.options[question.answer],
        explanation: question.explanation,
        topic: _topicFor(_index),
        source: 'الاختبار الشامل',
        unitId: _lessonFor(_index)['unitId'] as String,
        lessonNumber: _lessonFor(_index)['lessonNumber'] as int,
        lessonTitle: _lessonFor(_index)['lessonTitle'] as String,
      );
      final saved = await Future.wait([
        LearningProgress.missedQuestions(),
        LearningProgress.missedQuestionDetails(),
      ]);
      if (mounted) {
        setState(() {
          _missedQuestions = saved[0] as List<String>;
          _missedDetails = saved[1] as List<Map<String, dynamic>>;
        });
      }
    }
  }

  void _next() {
    if (_selected == null) return;
    if (_index == _questions.length - 1) {
      _finish();
    } else {
      setState(() { _index++; _selected = null; });
    }
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    await LearningProgress.recordQuizResult(score: _score, total: _questions.length, source: 'الاختبار الشامل');
    final missed = await LearningProgress.missedQuestions();
    final missedDetails = await LearningProgress.missedQuestionDetails();
    final values = await Future.wait([
      LearningProgress.bestQuizScore(),
      LearningProgress.quizCount(),
    ]);
    if (!mounted) return;
    setState(() {
      _best = values[0];
      _count = values[1];
      _missedQuestions = missed;
      _missedDetails = missedDetails;
      _finished = true;
      _saving = false;
    });
  }

  Map<String, dynamic> _lessonFor(int index) {
    switch (index) {
      case 0:
      case 3:
        return {'unitId': 'a1-u1', 'lessonNumber': 1, 'lessonTitle': 'الحروف التركية وطريقة نطقها'};
      case 1:
      case 4:
      case 6:
        return {'unitId': 'a1-u2', 'lessonNumber': 1, 'lessonTitle': 'التحيات في المواقف اليومية'};
      case 2:
        return {'unitId': 'a1-u1', 'lessonNumber': 3, 'lessonTitle': 'الانسجام الصوتي الأساسي'};
      case 7:
        return {'unitId': 'a1-u1', 'lessonNumber': 2, 'lessonTitle': 'الحروف المتحركة والثقيلة والخفيفة'};
      case 5:
        return {'unitId': 'a1-u3', 'lessonNumber': 5, 'lessonTitle': 'وصف الأشياء بالألوان والصفات'};
      case 9:
        return {'unitId': 'a1-u3', 'lessonNumber': 4, 'lessonTitle': 'أسماء الإشارة: هذا وهذه وهؤلاء'};
      case 11:
        return {'unitId': 'a1-u3', 'lessonNumber': 1, 'lessonTitle': 'أسماء الأشياء والأدوات اليومية'};
      case 8:
        return {'unitId': 'a1-u6', 'lessonNumber': 1, 'lessonTitle': 'أيام الأسبوع والتعبير عن اليوم'};
      case 10:
        return {'unitId': 'a1-u2', 'lessonNumber': 2, 'lessonTitle': 'التعريف بالنفس'};
      default:
        return {'unitId': 'a1-u2', 'lessonNumber': 1, 'lessonTitle': 'التحيات في المواقف اليومية'};
    }
  }

  String _topicFor(int index) {
    if (index == 0 || index == 3 || index == 7) return 'الأبجدية والأصوات';
    if (index == 1 || index == 4 || index == 6) return 'التحيات والعبارات اليومية';
    if (index == 2) return 'الجمع والانسجام الصوتي';
    if (index == 5) return 'الألوان وترتيب الصفات';
    if (index == 8) return 'الأيام والتعبير عن الزمن';
    if (index == 9) return 'أسماء الإشارة';
    if (index == 11) return 'مفردات الأشياء';
    if (index == 10) return 'العبارات والتعارف';
    return 'التحيات والعبارات اليومية';
  }

  void _restart() {
    setState(() { _index = 0; _score = 0; _selected = null; _finished = false; });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFFFAF3),
    body: SafeArea(child: CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('الاختبار الشامل', style: TextStyle(color: AppColors.darkGreen, fontSize: 25, fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            const Text('اختبر ما تعلمته من المفردات والقواعد الأساسية.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
            const SizedBox(height: 17),
            _stats(),
          ]),
        )),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(17, 10, 17, 28),
          child: _finished ? _result() : _questionCard(),
        )),
      ],
    )),
  );

  Widget _stats() => Row(children: [
    _statCard('أفضل نتيجة', '$_best%', Icons.emoji_events_rounded),
    const SizedBox(width: 9),
    _statCard('عدد الاختبارات', '$_count', Icons.quiz_rounded),
    const SizedBox(width: 9),
    _statCard('عدد الأسئلة', '${_questions.length}', Icons.help_outline_rounded),
  ]);

  Widget _statCard(String label, String value, IconData icon) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
    child: Column(children: [
      Icon(icon, color: AppColors.navy, size: 20),
      const SizedBox(height: 7),
      Text(value, style: const TextStyle(color: AppColors.darkGreen, fontSize: 18, fontWeight: FontWeight.w900)),
      const SizedBox(height: 3),
      Text(label, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted, fontSize: 9)),
    ]),
  ));

  Widget _questionCard() {
    final q = _questions[_index];
    final answered = _selected != null;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Text('السؤال ${_index + 1} / ${_questions.length}', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900, fontSize: 12)),
          const Spacer(),
          Text('$_score إجابة صحيحة', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(
          value: (_index + (answered ? 1 : 0)) / _questions.length,
          minHeight: 7, backgroundColor: const Color(0xFFE2F5F2), color: const Color(0xFF0F9D9A))),
        const SizedBox(height: 23),
        Text(q.prompt, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.darkGreen, fontSize: 19, height: 1.5, fontWeight: FontWeight.w900)),
        const SizedBox(height: 18),
        ...List.generate(q.options.length, (i) {
          final isCorrect = i == q.answer;
          final isSelected = i == _selected;
          Color bg = const Color(0xFFFFFAF3);
          Color border = AppColors.border;
          Color fg = AppColors.darkGreen;
          IconData? trailing;
          if (answered && isCorrect) {
            bg = const Color(0xFFE8F7EF); border = const Color(0xFF62B889);
            fg = const Color(0xFF187347); trailing = Icons.check_circle_rounded;
          } else if (answered && isSelected) {
            bg = const Color(0xFFFFEEEE); border = const Color(0xFFE69A9A);
            fg = const Color(0xFFB33B3B); trailing = Icons.cancel_rounded;
          }
          return Padding(padding: const EdgeInsets.only(bottom: 9), child: Material(
            color: bg, borderRadius: BorderRadius.circular(15),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: answered ? null : () => _choose(i),
              child: Container(
                constraints: const BoxConstraints(minHeight: 53),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: border)),
                child: Row(children: [
                  Expanded(child: Text(q.options[i], textAlign: TextAlign.right, style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 14))),
                  if (trailing != null) ...[const SizedBox(width: 8), Icon(trailing, color: fg, size: 19)],
                ]),
              ),
            ),
          ));
        }),
        if (answered) Container(
          margin: const EdgeInsets.only(top: 7, bottom: 12),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: const Color(0xFFE2F5F2), borderRadius: BorderRadius.circular(14)),
          child: Text(q.explanation, textAlign: TextAlign.right,
            style: const TextStyle(color: AppColors.navy, height: 1.6, fontSize: 12, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: !answered || _saving ? null : _next,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52), backgroundColor: AppColors.navy,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(_index == _questions.length - 1 ? 'عرض النتيجة' : 'السؤال التالي'),
        ),
        const SizedBox(height: 4),
        const Text('لا يوجد مؤقت؛ خذ وقتك في التفكير والتعلم.', textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 10)),
      ]),
    );
  }

  Widget _result() {
    final percent = _score * 100 ~/ _questions.length;
    final message = percent >= 90 ? 'ممتاز! إتقان رائع.' : percent >= 70 ? 'أداء جيد جداً، واصل التقدم.' : percent >= 50 ? 'بداية جيدة، راجع الشروحات وحاول مجدداً.' : 'هذه فرصة للتعلم؛ راجع الدروس ثم أعد المحاولة.';
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: AppColors.border)),
      child: Column(children: [
        const Icon(Icons.workspace_premium_rounded, size: 55, color: Color(0xFFE2A63B)),
        const SizedBox(height: 13),
        const Text('اكتمل الاختبار', style: TextStyle(color: AppColors.darkGreen, fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 17),
        SizedBox(width: 150, height: 150, child: Stack(alignment: Alignment.center, children: [
          SizedBox.expand(child: CircularProgressIndicator(value: percent / 100, strokeWidth: 11,
            backgroundColor: const Color(0xFFE2F5F2), color: const Color(0xFF0F9D9A), strokeCap: StrokeCap.round)),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text('$percent%', style: const TextStyle(color: AppColors.darkGreen, fontSize: 30, fontWeight: FontWeight.w900)),
            const Text('نتيجتك', style: TextStyle(color: AppColors.muted, fontSize: 11)),
          ]),
        ])),
        const SizedBox(height: 17),
        Text('$_score من ${_questions.length} إجابة صحيحة', style: const TextStyle(color: AppColors.navy, fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.6)),
        if (_missedQuestions.isNotEmpty || _missedDetails.isNotEmpty) ...[
          const SizedBox(height: 20),
          Align(alignment: Alignment.centerRight, child: Text('أسئلة تحتاج إلى مراجعة (${_missedQuestions.length})',
            style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 15))),
          const SizedBox(height: 8),
          if (_missedDetails.isNotEmpty)
            ..._missedDetails.reversed.map((item) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF0DDBB)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(item['prompt']?.toString() ?? '',
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: AppColors.darkGreen, fontSize: 13, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text('إجابتك: ${item['selectedAnswer'] ?? '—'}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Color(0xFFB33B3B), fontSize: 11)),
                const SizedBox(height: 4),
                Text('الإجابة الصحيحة: ${item['correctAnswer'] ?? '—'}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Color(0xFF187347), fontSize: 11, fontWeight: FontWeight.w800)),
                const SizedBox(height: 7),
                Text('الموضوع: ${item['topic'] ?? 'مراجعة عامة'}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: AppColors.muted, fontSize: 10)),
                const SizedBox(height: 5),
                Text(item['explanation']?.toString() ?? '',
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: AppColors.navy, fontSize: 11, height: 1.6)),
              ]),
            ))
          else
            ..._missedQuestions.map((item) => Container(
              width: double.infinity, margin: const EdgeInsets.only(bottom: 7),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFFFF7E5), borderRadius: BorderRadius.circular(13)),
              child: Text(item, textAlign: TextAlign.right,
                style: const TextStyle(color: AppColors.darkGreen, fontSize: 12, fontWeight: FontWeight.w700)),
            )),
          Align(alignment: Alignment.centerLeft, child: TextButton.icon(
            onPressed: () async {
              await LearningProgress.clearMissedQuestions();
              if (mounted) setState(() => _missedQuestions = <String>[]);
            }, icon: const Icon(Icons.done_all_rounded), label: const Text('مسح قائمة المراجعة'),
          )),
        ],
        const SizedBox(height: 19),
        SizedBox(width: double.infinity, child: FilledButton.icon(
          onPressed: _restart, icon: const Icon(Icons.refresh_rounded), label: const Text('إعادة الاختبار'),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(51), backgroundColor: AppColors.navy,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        )),
      ]),
    );
  }
}
