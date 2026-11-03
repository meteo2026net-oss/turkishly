import 'package:flutter/material.dart';
import '../data/course_catalog.dart';
import '../models/course_unit.dart';
import '../services/learning_progress.dart';
import '../services/lesson_content_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_mark.dart';
import 'json_lesson_screen.dart';
import 'vocabulary_screen.dart';
import 'quiz_screen.dart';
import 'missed_questions_screen.dart';
import 'performance_insights_screen.dart';
import 'learner_progress_dashboard.dart';
import 'level_assessment_screen.dart';
import 'conversation_practice_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  String query = '';
  Set<String> completedLessonIds = <String>{};
  List<CourseUnit> units = CourseCatalog.units;
  int learnedWordCount = 0;
  int bestQuiz = 0;
  int latestQuiz = 0;
  int quizAttempts = 0;
  Map<String, int> levelBestScores = <String, int>{};

  @override
  void initState() {
    super.initState();
    _loadCatalog();
    _loadProgress();
  }

  Future<void> _loadCatalog() async {
    final loadedUnits = await LessonContentRepository.loadUnits();
    if (!mounted) return;
    setState(() => units = loadedUnits);
  }

  Future<void> _loadProgress() async {
    final values = await Future.wait([
      LearningProgress.completedLessons(),
      LearningProgress.learnedWords(),
      LearningProgress.bestQuizScore(),
      LearningProgress.latestQuizScore(),
      LearningProgress.quizCount(),
      ...CourseCatalog.levels.map(LearningProgress.levelAssessmentBest),
    ]);
    if (!mounted) return;
    setState(() {
      completedLessonIds = values[0] as Set<String>;
      learnedWordCount = (values[1] as Set<String>).length;
      bestQuiz = values[2] as int;
      latestQuiz = values[3] as int;
      quizAttempts = values[4] as int;
      levelBestScores = <String, int>{
        for (var i = 0; i < CourseCatalog.levels.length; i++)
          CourseCatalog.levels[i]: values[5 + i] as int,
      };
    });
  }

  bool _unitIsComplete(CourseUnit unit) => unit.lessons.asMap().entries.every(
    (entry) => completedLessonIds.contains('${unit.id}-${entry.key + 1}'),
  );
  List<CourseUnit> get filtered => units.where((u) =>
    u.titleArabic.contains(query) || u.titleTurkish.toLowerCase().contains(query.toLowerCase()) || u.level.toLowerCase().contains(query.toLowerCase())
  ).toList();

  @override
  Widget build(BuildContext context) {
    final done = units.where(_unitIsComplete).length;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      body: SafeArea(bottom: false, child: IndexedStack(index: tab, children: [
        _home(done), _library(), const VocabularyScreen(), const QuizScreen(), _progress(done),
      ])),
      bottomNavigationBar: _nav(),
    );
  }

  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(19, 14, 19, 13),
    child: Row(children: [
      const BrandMark(size: 45),
      const SizedBox(width: 11),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('SARA HOCAM', textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 18, letterSpacing: 1.1, fontWeight: FontWeight.w900, color: AppColors.darkGreen)),
        SizedBox(height: 3),
        Text('تعلم مع الانسة ساره',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted)),
      ])),
      _circleButton(Icons.notifications_none_rounded, () {}),
      const SizedBox(width: 8),
      _circleButton(Icons.person_outline_rounded, () => setState(() => tab = 4)),
    ]),
  );

  Widget _home(int done) => CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
    SliverToBoxAdapter(child: _header()),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 17), child: _hero(done))),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: _heading('تابع رحلتك', 'خطوة صغيرة كل يوم تصنع فرقاً', action: 'كل الوحدات', onTap: () => setState(() => tab = 1)))),
    SliverToBoxAdapter(child: _continueCard()),
    SliverToBoxAdapter(child: _conversationPracticeCard()),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 25, 20, 12),
      child: _heading('استكشف المنهج', 'من الأساسيات إلى المحادثة'))),
    SliverPadding(padding: const EdgeInsets.fromLTRB(17, 0, 17, 28),
      sliver: SliverList(delegate: SliverChildBuilderDelegate((context, i) =>
        Padding(padding: const EdgeInsets.only(bottom: 10), child: _unitTile(context, units[i], i, onProgressChanged: _loadProgress)),
        childCount: units.length > 5 ? 5 : units.length))),
  ]);

  Widget _conversationPracticeCard() => Padding(
    padding: const EdgeInsets.fromLTRB(17, 12, 17, 0),
    child: Material(
      color: const Color(0xFFEAF2FF),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => const ConversationPracticeScreen(),
          ));
          _loadProgress();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD5E3F5)),
          ),
          child: Row(children: [
            const Icon(Icons.forum_rounded, color: AppColors.navy, size: 29),
            const SizedBox(width: 12),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('تدرّب على المحادثة', style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 14)),
              SizedBox(height: 4),
              Text('مواقف يومية وحوارات تركية مع ترجمة', style: TextStyle(color: AppColors.muted, fontSize: 11)),
            ])),
            const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.navy, size: 17),
          ]),
        ),
      ),
    ),
  );

  Widget _hero(int done) => Container(
    padding: const EdgeInsets.all(21),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(29),
      gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft,
        colors: [Color(0xFF102B52), Color(0xFF174E91), Color(0xFF2676B8)]),
      boxShadow: [BoxShadow(color: const Color(0xFF123D70).withValues(alpha: .2), blurRadius: 24, offset: const Offset(0, 12))],
    ),
    child: Stack(children: [
      Positioned(left: -15, top: -20, child: Icon(Icons.auto_awesome_rounded, size: 110, color: Colors.white.withValues(alpha: .06))),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .12), borderRadius: BorderRadius.circular(30)),
            child: const Text('MERHABA  •  أهلاً بك', textDirection: TextDirection.ltr,
              style: TextStyle(color: Color(0xFFFFD98A), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: .7))),
          const Spacer(), const Icon(Icons.waving_hand_rounded, color: Color(0xFFFFD98A), size: 22),
        ]),
        const SizedBox(height: 17),
        const Text('كل يوم كلمة،\nوكل درس يقربك.', style: TextStyle(color: Colors.white, fontSize: 27, height: 1.25, fontWeight: FontWeight.w900)),
        const SizedBox(height: 9),
        Text('ابدأ رحلتك في اللغة التركية بأسلوب واضح وممتع باللغة العربية.',
          style: TextStyle(color: Colors.white.withValues(alpha: .78), fontSize: 13, height: 1.7)),
        const SizedBox(height: 19),
        Row(children: [
          _stat(Icons.menu_book_rounded, '${units.length}', 'وحدة تعليمية'),
          const SizedBox(width: 9),
          _stat(Icons.check_circle_outline_rounded, '${done}', 'وحدات مكتملة'),
        ]),
      ]),
    ]),
  );

  Widget _stat(IconData icon, String value, String label) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .11), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: .1))),
    child: Row(children: [
      Icon(icon, color: const Color(0xFFFFD98A), size: 20), const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: .72), fontSize: 10)),
      ]),
    ]),
  ));

  Widget _continueCard() {
    final u = units.isEmpty ? null : units.first;
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 17), child: Material(
      color: Colors.white, borderRadius: BorderRadius.circular(23),
      child: InkWell(borderRadius: BorderRadius.circular(23), onTap: u == null ? null : () => _showUnit(u),
        child: Container(padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(23), border: Border.all(color: AppColors.border)),
          child: Row(children: [
            Container(width: 52, height: 56, decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.play_lesson_rounded, color: AppColors.navy, size: 28)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('ابدأ من هنا', style: TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(u?.titleArabic ?? 'استكشف الدروس', maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.darkGreen, fontSize: 15, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(u == null ? 'اكتشف منهجك' : '${u.lessonCount} درس • ${u.level}', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
            ])),
            Container(width: 37, height: 37, decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 19)),
          ]),
        ),
      ),
    ));
  }

  Widget _library() => CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
    SliverToBoxAdapter(child: _header()),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 12, 20, 15),
      child: _heading('مكتبة الدروس', 'اختر وحدتك وتعلم بالسرعة التي تناسبك'))),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 17), child: TextField(
      textDirection: TextDirection.rtl, onChanged: (v) => setState(() => query = v),
      decoration: InputDecoration(hintText: 'ابحث عن وحدة أو مستوى...', prefixIcon: const Icon(Icons.search_rounded),
        filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: const BorderSide(color: AppColors.border))),
    ))),
    SliverPadding(padding: const EdgeInsets.fromLTRB(17, 17, 17, 28),
      sliver: SliverList(delegate: SliverChildBuilderDelegate((context, i) =>
        Padding(padding: const EdgeInsets.only(bottom: 10), child: _unitTile(context, filtered[i], i, onProgressChanged: _loadProgress)),
        childCount: filtered.length))),
  ]);

  Widget _progress(int done) => CustomScrollView(slivers: [
    SliverToBoxAdapter(child: _header()),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 12, 20, 17),
      child: _heading('إنجازاتك', 'كل خطوة تقربك من التحدث بالتركية'))),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 17), child: Container(
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: AppColors.border)),
      child: Column(children: [
        SizedBox(width: 142, height: 142, child: Stack(alignment: Alignment.center, children: [
          SizedBox.expand(child: CircularProgressIndicator(value: units.isEmpty ? 0 : done / units.length, strokeWidth: 11,
            backgroundColor: const Color(0xFFE9EEF6), color: const Color(0xFF2E82C7), strokeCap: StrokeCap.round)),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text('${units.isEmpty ? 0 : done * 100 ~/ units.length}%', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.darkGreen)),
            const Text('نسبة الإنجاز', style: TextStyle(fontSize: 11, color: AppColors.muted)),
          ]),
        ])),
        const SizedBox(height: 18),
        Text('${done} من ${units.length} وحدة مكتملة', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.darkGreen, fontSize: 16)),
        const SizedBox(height: 6),
        const Text('استمر بالتعلم، فالتقدم يبدأ بخطوة صغيرة.', textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, height: 1.6, fontSize: 12)),
      ]),
    ))),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(17, 20, 17, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('ملخص تعلمك', textAlign: TextAlign.right,
          style: TextStyle(color: AppColors.darkGreen, fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        const Text('إحصاءات محفوظة على هذا الجهاز', textAlign: TextAlign.right,
          style: TextStyle(color: AppColors.muted, fontSize: 11)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _progressMetric(Icons.menu_book_rounded, '${completedLessonIds.length}', 'دروس مكتملة')),
          const SizedBox(width: 9),
          Expanded(child: _progressMetric(Icons.translate_rounded, '${learnedWordCount}', 'كلمات متقنة')),
        ]),
        const SizedBox(height: 9),
        Row(children: [
          Expanded(child: _progressMetric(Icons.emoji_events_rounded, '${bestQuiz}%', 'أفضل نتيجة')),
          const SizedBox(width: 9),
          Expanded(child: _progressMetric(Icons.quiz_rounded, '${quizAttempts}', 'اختبارات مكتملة')),
        ]),
        const SizedBox(height: 12),
        Material(
          color: const Color(0xFFFFF6E8),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => const MissedQuestionsScreen(),
              ));
              _loadProgress();
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                const Icon(Icons.history_edu_rounded, color: Color(0xFFB7791F), size: 25),
                const SizedBox(width: 10),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('مراجعة أخطائي', style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 13)),
                  SizedBox(height: 3),
                  Text('راجع إجاباتك وشروحاتها وانتقل إلى الدرس المرتبط.', style: TextStyle(color: AppColors.muted, fontSize: 10)),
                ])),
                const Icon(Icons.chevron_left_rounded, color: AppColors.navy),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Material(
          color: const Color(0xFFEAF2FF),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const PerformanceInsightsScreen(),
            )),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                const Icon(Icons.analytics_outlined, color: AppColors.navy, size: 25),
                const SizedBox(width: 10),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('تحليل الأداء', style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 13)),
                  SizedBox(height: 3),
                  Text('اكتشف الموضوعات الأكثر ظهوراً في سجل أخطائك.', style: TextStyle(color: AppColors.muted, fontSize: 10)),
                ])),
                const Icon(Icons.chevron_left_rounded, color: AppColors.navy),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Material(
          color: const Color(0xFFEAF2FF),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const LearnerProgressDashboard(),
            )),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Row(children: [
                Icon(Icons.insights_rounded, color: AppColors.navy, size: 25),
                SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('لوحة تقدم المتعلم', style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 13)),
                  SizedBox(height: 3),
                  Text('عرض تقدم كل مستوى والدروس والاختبارات في تقرير واحد.', style: TextStyle(color: AppColors.muted, fontSize: 10)),
                ])),
                Icon(Icons.chevron_left_rounded, color: AppColors.navy),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Container(padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            const Icon(Icons.trending_up_rounded, color: AppColors.navy),
            const SizedBox(width: 9),
            Expanded(child: Text('آخر نتيجة اختبار: ${latestQuiz}% — استمر في التدريب لتحسين مستواك.',
              textAlign: TextAlign.right, style: const TextStyle(color: AppColors.navy, fontSize: 11, height: 1.5, fontWeight: FontWeight.w700))),
          ]),
        ),
      ]))),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(17, 20, 17, 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft,
            colors: [Color(0xFF102B52), Color(0xFF2676B8)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(children: [
          const Icon(Icons.workspace_premium_rounded, color: Color(0xFFFFD98A), size: 31),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('تقييم المستوى A1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
            SizedBox(height: 4),
            Text('اختبر أساسياتك في 10 أسئلة واحصل على تقييمك.', style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.5)),
          ])),
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const LevelAssessmentScreen(level: 'A1'),
            )),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            tooltip: 'ابدأ التقييم',
          ),
        ]),
      ))),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      child: _heading('مستويات المنهج', 'تدرج منظم في اللغة التركية'))),
    SliverPadding(padding: const EdgeInsets.fromLTRB(17, 0, 17, 25),
      sliver: SliverList(delegate: SliverChildBuilderDelegate((context, i) =>
        Padding(padding: const EdgeInsets.only(bottom: 9), child: _levelTile(CourseCatalog.levels[i])),
        childCount: CourseCatalog.levels.length))),
  ]);

  Widget _progressMetric(IconData icon, String value, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17),
      border: Border.all(color: AppColors.border)),
    child: Row(children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(11)),
        child: Icon(icon, color: AppColors.navy, size: 19)),
      const SizedBox(width: 9),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(value, style: const TextStyle(color: AppColors.darkGreen, fontSize: 18, fontWeight: FontWeight.w900)),
        Text(label, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
      ])),
    ]),
  );

  Widget _levelTile(String level) {
    final levelUnits = units.where((u) => u.level == level).toList();
    final count = levelUnits.length;
    final totalLessons = levelUnits.fold<int>(0, (sum, unit) => sum + unit.lessons.length);
    final completed = levelUnits.fold<int>(0, (sum, unit) => sum +
      unit.lessons.asMap().entries.where((entry) =>
        completedLessonIds.contains('${unit.id}-${entry.key + 1}')).length);
    final percent = totalLessons == 0 ? 0 : completed * 100 ~/ totalLessons;
    final best = levelBestScores[level] ?? 0;
    final assessmentAvailable = level == 'A1';
    final passed = best >= 80;
    final status = !assessmentAvailable ? 'التقييم قيد الإعداد' :
      passed ? 'اجتاز التقييم التشخيصي' : best > 0 ? 'لديك محاولة محفوظة' : 'التقييم متاح';
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Container(width: 42, height: 42, alignment: Alignment.center,
            decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(13)),
            child: Text(level, textDirection: TextDirection.ltr,
              style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('المستوى $level', style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w800)),
            const SizedBox(height: 3),
            Text('$count وحدة • $completed من $totalLessons درس',
              style: const TextStyle(color: AppColors.muted, fontSize: 10)),
          ])),
          if (assessmentAvailable)
            Icon(passed ? Icons.verified_rounded : Icons.assignment_outlined,
              color: passed ? const Color(0xFF279765) : AppColors.navy, size: 22)
          else
            const Icon(Icons.lock_outline_rounded, color: AppColors.muted, size: 20),
        ]),
        const SizedBox(height: 12),
        ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(
          value: totalLessons == 0 ? 0 : completed / totalLessons,
          minHeight: 6, backgroundColor: const Color(0xFFE9EEF6), color: const Color(0xFF2E82C7))),
        const SizedBox(height: 7),
        Row(children: [
          Text('$percent% إنجاز الدروس', style: const TextStyle(color: AppColors.muted, fontSize: 10)),
          const Spacer(),
          Text(status, style: TextStyle(color: passed ? const Color(0xFF279765) : AppColors.muted,
            fontSize: 10, fontWeight: FontWeight.w800)),
        ]),
        if (assessmentAvailable) ...[
          const SizedBox(height: 9),
          Row(children: [
            Text(best > 0 ? 'أفضل نتيجة: $best%' : 'لم يُجرَ التقييم بعد',
              style: const TextStyle(color: AppColors.navy, fontSize: 11, fontWeight: FontWeight.w700)),
            const Spacer(),
            TextButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (_) => const LevelAssessmentScreen(level: 'A1')));
                _loadProgress();
              },
              child: Text(best > 0 ? 'إعادة التقييم' : 'ابدأ التقييم'),
            ),
          ]),
        ] else ...[
          const SizedBox(height: 5),
          const Text('المحتوى الدراسي ظاهر في المنهج، لكن اختبار تحديد المستوى لم يُفعّل بعد.',
            textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, fontSize: 10, height: 1.5)),
        ],
      ]),
    );
  }

  Widget _nav() => Container(
    decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: const Color(0xFF102B52).withValues(alpha: .08), blurRadius: 18, offset: const Offset(0, -5))]),
    child: SafeArea(top: false, child: Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 6), child: Row(children: [
      _navItem(0, Icons.home_rounded, 'الرئيسية'),
      _navItem(1, Icons.auto_stories_rounded, 'الدروس'),
      _navItem(2, Icons.translate_rounded, 'المفردات'),
      _navItem(3, Icons.quiz_rounded, 'اختبار'),
      _navItem(4, Icons.insights_rounded, 'إنجازي'),
    ]))),
  );

  Widget _navItem(int index, IconData icon, String label) {
    final active = tab == index;
    return Expanded(child: InkWell(borderRadius: BorderRadius.circular(16), onTap: () {
      setState(() => tab = index);
      if (index == 4) _loadProgress();
    },
      child: AnimatedContainer(duration: const Duration(milliseconds: 180), padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(color: active ? const Color(0xFFEAF2FF) : Colors.transparent, borderRadius: BorderRadius.circular(16)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: active ? AppColors.navy : AppColors.muted, size: 23),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(color: active ? AppColors.navy : AppColors.muted, fontSize: 10, fontWeight: active ? FontWeight.w900 : FontWeight.w600)),
        ]),
      ),
    ));
  }

  Widget _circleButton(IconData icon, VoidCallback action) => Material(color: Colors.white, shape: const CircleBorder(),
    child: InkWell(onTap: action, customBorder: const CircleBorder(),
      child: SizedBox(width: 39, height: 39, child: Icon(icon, color: AppColors.darkGreen, size: 20))));

  void _showUnit(CourseUnit unit) => showModalBottomSheet<void>(context: context, isScrollControlled: true,
    backgroundColor: Colors.transparent, builder: (_) => _UnitDetails(unit: unit, onProgressChanged: _loadProgress));
}

Widget _heading(String title, String subtitle, {String? action, VoidCallback? onTap}) => Row(children: [
  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(color: AppColors.darkGreen, fontSize: 20, fontWeight: FontWeight.w900)),
    const SizedBox(height: 4),
    Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 11, height: 1.5)),
  ])),
  if (action != null) TextButton(onPressed: onTap, child: Text(action)),
]);

Widget _unitTile(BuildContext context, CourseUnit unit, int index, {VoidCallback? onProgressChanged}) {
  const tints = [Color(0xFFEAF2FF), Color(0xFFFFF4E3), Color(0xFFEAF7F2), Color(0xFFF2EDFF)];
  const icons = [Icons.translate_rounded, Icons.chat_bubble_outline_rounded, Icons.headphones_rounded, Icons.edit_note_rounded];
  return Material(color: Colors.white, borderRadius: BorderRadius.circular(20),
    child: InkWell(borderRadius: BorderRadius.circular(20), onTap: () => showModalBottomSheet<void>(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => _UnitDetails(unit: unit, onProgressChanged: onProgressChanged)),
      child: Container(padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
        child: Row(children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: tints[index % 4], borderRadius: BorderRadius.circular(15)),
            child: Icon(icons[index % 4], color: AppColors.navy, size: 24)),
          const SizedBox(width: 11),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(unit.titleArabic, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.darkGreen, fontSize: 14, fontWeight: FontWeight.w900))),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(8)),
                child: Text(unit.level, textDirection: TextDirection.ltr, style: const TextStyle(color: AppColors.navy, fontSize: 10, fontWeight: FontWeight.w900))),
            ]),
            const SizedBox(height: 4),
            Text(unit.titleTurkish, textDirection: TextDirection.ltr, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
            const SizedBox(height: 4),
            Text('${unit.lessonCount} درس تعليمي', style: const TextStyle(color: AppColors.muted, fontSize: 10)),
          ])),
          const SizedBox(width: 4), const Icon(Icons.chevron_left_rounded, color: AppColors.muted),
        ]),
      ),
    ),
  );
}

class _UnitDetails extends StatelessWidget {
  const _UnitDetails({required this.unit, this.onProgressChanged});
  final CourseUnit unit;
  final VoidCallback? onProgressChanged;
  @override
  Widget build(BuildContext context) => Container(
    height: MediaQuery.sizeOf(context).height * .84,
    decoration: const BoxDecoration(color: Color(0xFFF8FAFE), borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    child: SafeArea(child: Column(children: [
      Container(width: 42, height: 4, margin: const EdgeInsets.only(top: 10, bottom: 15),
        decoration: BoxDecoration(color: const Color(0xFFD7DFEA), borderRadius: BorderRadius.circular(5))),
      Padding(padding: const EdgeInsets.fromLTRB(20, 4, 20, 15), child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(unit.titleArabic, style: const TextStyle(color: AppColors.darkGreen, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text(unit.titleTurkish, textDirection: TextDirection.ltr, style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w700)),
        ])),
        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
      ])),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(unit.description, style: const TextStyle(color: AppColors.muted, height: 1.7, fontSize: 12))),
      const SizedBox(height: 14),
      Expanded(child: ListView.separated(padding: const EdgeInsets.fromLTRB(17, 0, 17, 20),
        itemCount: unit.lessons.length, separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) => Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => JsonLessonScreen(
                  unitId: unit.id,
                  unitTitle: unit.titleArabic,
                  lessonTitle: unit.lessons[i],
                  lessonNumber: i + 1,
                ),
              ));
              onProgressChanged?.call();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
              child: Row(children: [
                Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF2FF),
                    shape: BoxShape.circle,
                  ),
                  child: Text('${i + 1}', style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w900,
                  )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FutureBuilder<LessonRecord>(
                    future: LessonContentRepository.loadLesson(unit.id, i + 1),
                    builder: (context, snapshot) => Text(
                      snapshot.data?.titleArabic ?? unit.lessons[i],
                      style: const TextStyle(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.play_circle_outline_rounded,
                  color: AppColors.navy, size: 22),
              ]),
            ),
          ),
        ),
      )),
    ])),
  );
}
