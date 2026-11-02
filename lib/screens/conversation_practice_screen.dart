import 'package:flutter/material.dart';
import '../services/learning_progress.dart';
import '../theme/app_theme.dart';

class ConversationPracticeScreen extends StatefulWidget {
  const ConversationPracticeScreen({super.key});
  @override
  State<ConversationPracticeScreen> createState() => _ConversationPracticeScreenState();
}

class _Turn {
  const _Turn(this.speaker, this.tr, this.ar, {this.prompt, this.options = const [], this.answer, this.note});
  final String speaker, tr, ar;
  final String? prompt, note;
  final List<String> options;
  final int? answer;
}

class _Scenario {
  const _Scenario(this.title, this.subtitle, this.level, this.icon, this.turns);
  final String title, subtitle, level;
  final IconData icon;
  final List<_Turn> turns;
}

const _scenarios = <_Scenario>[
  _Scenario('التعارف لأول مرة', 'تقديم الاسم والسؤال عن الشخص الآخر', 'A1', Icons.waving_hand_rounded, [
    _Turn('Ayşe', 'Merhaba! Benim adım Ayşe. Senin adın ne?', 'مرحباً! اسمي عائشة. ما اسمك؟'),
    _Turn('أنت', 'Benim adım Ali.', 'اسمي علي.', prompt: 'كيف تسأل: من أين أنت؟', options: ['Nerelisin?', 'Kaç yaşındasın?', 'Nasılsın?'], answer: 0, note: 'Nerelisin? تعني: من أين أنت؟'),
    _Turn('Ayşe', 'Memnun oldum. Nasılsın?', 'تشرفت بمعرفتك. كيف حالك؟'),
    _Turn('أنت', 'İyiyim, teşekkür ederim.', 'أنا بخير، شكراً لك.', prompt: 'اختر الرد المناسب على Teşekkür ederim.', options: ['Günaydın.', 'Rica ederim.', 'Hoşça kal.'], answer: 1, note: 'Rica ederim تعني: العفو.'),
  ]),
  _Scenario('في المقهى', 'طلب مشروب واستخدام عبارات مهذبة', 'A1', Icons.local_cafe_rounded, [
    _Turn('Garson', 'Hoş geldiniz. Ne içersiniz?', 'أهلاً وسهلاً. ماذا تشرب؟'),
    _Turn('أنت', 'Bir çay lütfen.', 'شاي واحد من فضلك.', prompt: 'كيف تطلب القهوة؟', options: ['Bir kahve lütfen.', 'Bir ev lütfen.', 'Bir kitap lütfen.'], answer: 0, note: 'Kahve تعني قهوة، وlütfen تعني من فضلك.'),
    _Turn('Garson', 'Başka bir şey ister misiniz?', 'هل ترغب في شيء آخر؟'),
    _Turn('أنت', 'Hayır, teşekkürler.', 'لا، شكراً.', prompt: 'ما معنى Hesap lütfen؟', options: ['القائمة من فضلك', 'الحساب من فضلك', 'الماء من فضلك'], answer: 1, note: 'Hesap تعني الحساب، وتستخدم العبارة لطلب الفاتورة.'),
  ]),
  _Scenario('الاتجاهات والطريق', 'السؤال عن مكان والوصول إليه', 'A2', Icons.map_rounded, [
    _Turn('أنت', 'Affedersiniz, müze nerede?', 'عذراً، أين المتحف؟'),
    _Turn('Yolcu', 'Düz gidin, sonra sağa dönün.', 'اذهب مستقيماً، ثم انعطف يميناً.'),
    _Turn('أنت', 'Çok uzak mı?', 'هل هو بعيد جداً؟', prompt: 'ما معنى sola dönün؟', options: ['انعطف يميناً', 'انعطف يساراً', 'توقف هنا'], answer: 1, note: 'Sola تعني إلى اليسار، وdönün تعني انعطف.'),
    _Turn('Yolcu', 'Hayır, beş dakika uzaklıkta.', 'لا، يبعد خمس دقائق.'),
  ]),
];

class _ConversationPracticeScreenState extends State<ConversationPracticeScreen> {
  int? _scenarioIndex;
  int _turnIndex = 0, _score = 0, _answered = 0;
  int? _selected;
  bool _finished = false;
  bool _savingResult = false;
  _Scenario? get _scenario => _scenarioIndex == null ? null : _scenarios[_scenarioIndex!];
  _Turn? get _turn => _scenario == null ? null : _scenario!.turns[_turnIndex];

  Future<void> _start(int index) async {
    setState(() { _scenarioIndex = index; _turnIndex = 0; _score = 0; _answered = 0; _selected = null; _finished = false; _savingResult = false; });
    await LearningProgress.recordLearningActivity();
  }

  void _choose(int index) {
    if (_selected != null) return;
    setState(() { _selected = index; _answered++; if (index == _turn!.answer) _score++; });
  }

  Future<void> _next() async {
    if (_savingResult || _finished) return;
    if (_turnIndex == _scenario!.turns.length - 1) {
      final scenario = _scenario!;
      setState(() => _savingResult = true);
      try {
        await LearningProgress.recordConversationResult(
          scenarioId: scenario.title,
          title: scenario.title,
          level: scenario.level,
          score: _score,
          total: _answered,
        );
      } finally {
        if (mounted) setState(() { _savingResult = false; _finished = true; });
    } else {
      setState(() { _turnIndex++; _selected = null; });
    }
  }

  void _back() => setState(() { _scenarioIndex = null; _turnIndex = 0; _selected = null; _finished = false; _savingResult = false; });

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F7FC),
    appBar: AppBar(backgroundColor: const Color(0xFFF5F7FC), foregroundColor: AppColors.darkGreen, elevation: 0,
      title: const Text('تدريب المحادثة', style: TextStyle(fontWeight: FontWeight.w900))),
    body: SafeArea(child: _scenario == null ? _list() : _finished ? _result() : _practice()),
  );

  Widget _list() => ListView(padding: const EdgeInsets.all(17), children: [
    const Text('تحدث بالتركية في مواقف يومية', textAlign: TextAlign.right,
      style: TextStyle(color: AppColors.darkGreen, fontSize: 21, fontWeight: FontWeight.w900)),
    const SizedBox(height: 7),
    const Text('اقرأ الحوار، اختر الرد المناسب، وتعرّف على معنى العبارات.', textAlign: TextAlign.right,
      style: TextStyle(color: AppColors.muted, height: 1.6, fontSize: 12)),
    const SizedBox(height: 17),
    for (var i = 0; i < _scenarios.length; i++)
      Padding(padding: const EdgeInsets.only(bottom: 11), child: Material(
        color: Colors.white, borderRadius: BorderRadius.circular(19),
        child: InkWell(borderRadius: BorderRadius.circular(19), onTap: () => _start(i),
          child: Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(19), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(15)),
                child: Icon(_scenarios[i].icon, color: AppColors.navy, size: 24)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_scenarios[i].title, style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 15)),
                const SizedBox(height: 4),
                Text(_scenarios[i].subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
              ])),
              Text(_scenarios[i].level, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900)),
              const Icon(Icons.chevron_left_rounded, color: AppColors.muted),
            ]),
          ),
        ),
      )),
    const SizedBox(height: 8),
    const Text('تدريب محلي تفاعلي؛ لا يتطلب اتصالاً بخدمة محادثة أو تسجيلاً صوتياً.', textAlign: TextAlign.center,
      style: TextStyle(color: AppColors.muted, fontSize: 10)),
  ]);

  Widget _practice() {
    final scenario = _scenario!, turn = _turn!;
    final hasQuestion = turn.options.isNotEmpty, answered = _selected != null;
    return ListView(padding: const EdgeInsets.all(17), children: [
      Row(children: [
        Expanded(child: Text(scenario.title, textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 17))),
        Text('${_turnIndex + 1}/${scenario.turns.length}', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900)),
      ]),
      const SizedBox(height: 10),
      ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(
        value: (_turnIndex + 1) / scenario.turns.length, minHeight: 7,
        backgroundColor: const Color(0xFFE4EAF2), color: AppColors.navy)),
      const SizedBox(height: 18),
      Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppColors.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(turn.speaker, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w800, fontSize: 11)),
          const SizedBox(height: 9),
          Text(turn.tr, textDirection: TextDirection.ltr, textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 21, height: 1.5)),
          const SizedBox(height: 8),
          Text(turn.ar, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
        ]),
      ),
      if (hasQuestion) ...[
        const SizedBox(height: 17),
        Text(turn.prompt!, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 15)),
        const SizedBox(height: 10),
        for (var i = 0; i < turn.options.length; i++) _option(turn, i, answered),
        if (answered) Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(13)),
          child: Text(turn.note!, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.navy, fontSize: 12, height: 1.6))),
      ],
      const SizedBox(height: 18),
      FilledButton(onPressed: _savingResult || (hasQuestion && !answered) ? null : _next,
        style: FilledButton.styleFrom(backgroundColor: AppColors.navy, minimumSize: const Size.fromHeight(50)),
        child: Text(_savingResult ? 'جارٍ حفظ النتيجة…' : _turnIndex == scenario.turns.length - 1 ? 'إنهاء المحادثة' : 'متابعة الحوار')),
      TextButton(onPressed: _back, child: const Text('العودة إلى المواقف')),
    ]);
  }

  Widget _option(_Turn turn, int index, bool answered) {
    final correct = index == turn.answer, selected = index == _selected;
    final right = answered && correct, wrong = answered && selected && !correct;
    final bg = right ? const Color(0xFFE8F7EF) : wrong ? const Color(0xFFFFEEEE) : const Color(0xFFF7F9FC);
    final border = right ? const Color(0xFF62B889) : wrong ? const Color(0xFFE69A9A) : AppColors.border;
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Material(color: bg, borderRadius: BorderRadius.circular(14),
      child: InkWell(borderRadius: BorderRadius.circular(14), onTap: answered ? null : () => _choose(index),
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
          child: Row(children: [
            Expanded(child: Text(turn.options[index], textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w800))),
            if (right) const Icon(Icons.check_circle_rounded, color: Color(0xFF187347), size: 19),
            if (wrong) const Icon(Icons.cancel_rounded, color: Color(0xFFB33B3B), size: 19),
          ]),
        ),
      ),
    ));
  }

  Widget _result() {
    final percent = _answered == 0 ? 100 : _score * 100 ~/ _answered;
    return Center(child: SingleChildScrollView(padding: const EdgeInsets.all(22),
      child: Container(width: double.infinity, padding: const EdgeInsets.all(23),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border)),
        child: Column(children: [
          const Icon(Icons.forum_rounded, color: AppColors.navy, size: 52),
          const SizedBox(height: 12),
          const Text('أحسنت! أنهيت المحادثة', textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.darkGreen, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Text('$_score من $_answered إجابات صحيحة', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 6),
          Text('$percent%', style: const TextStyle(color: AppColors.darkGreen, fontSize: 32, fontWeight: FontWeight.w900)),
          const SizedBox(height: 18),
          FilledButton(onPressed: _back, style: FilledButton.styleFrom(backgroundColor: AppColors.navy,
            minimumSize: const Size.fromHeight(49)), child: const Text('اختيار موقف آخر')),
        ]),
      ),
    ));
  }
}
