import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class A1Unit3Lesson7Screen extends StatefulWidget {
  const A1Unit3Lesson7Screen({super.key});

  @override
  State<A1Unit3Lesson7Screen> createState() => _A1Unit3Lesson7ScreenState();
}

class _A1Unit3Lesson7ScreenState extends State<A1Unit3Lesson7Screen> {
  static const questions = <_Question>[
    _Question(
      prompt: 'كيف نقول: كتابي؟',
      options: ['Kitabın', 'Kitabım', 'Kitabı', 'Kitabımız'],
      correctIndex: 1,
      explanation: 'لاحقة المتكلم المفرد هنا هي -ım: kitap تصبح kitabım.',
    ),
    _Question(
      prompt: 'اختر الترجمة الصحيحة: هذه حقيبتك.',
      options: ['Bu benim çantam.', 'Bu onun çantası.', 'Bu senin çantan.', 'Bu bizim çantamız.'],
      correctIndex: 2,
      explanation: 'senin تعني لك، وçantan تعني حقيبتك.',
    ),
    _Question(
      prompt: 'أكمل: Benim bir kalem___ var. (لدي قلم)',
      options: ['-in', '-imiz', '-im', '-i'],
      correctIndex: 2,
      explanation: 'مع benim نستخدم لاحقة المتكلم: kalemim.',
    ),
    _Question(
      prompt: 'ما معنى: Onun evi büyük.',
      options: ['بيتي كبير.', 'بيتك كبير.', 'بيته/بيتها كبير.', 'بيتنا كبير.'],
      correctIndex: 2,
      explanation: 'onun تعني له/لها، وevi تعني بيته أو بيتها.',
    ),
  ];

  final Map<int, int> answers = {};
  bool submitted = false;

  int get score {
    var total = 0;
    for (var i = 0; i < questions.length; i++) {
      if (answers[i] == questions[i].correctIndex) total++;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدرس 7: الملكية')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _header(),
          const SizedBox(height: 20),
          _section(
            title: 'هدف الدرس',
            child: const Text(
              'في هذا الدرس ستتعلم كيف تقول: كتابي، حقيبتك، بيته، ومدرستنا، وكيف تسأل عن صاحب الشيء.',
              style: TextStyle(height: 1.7),
            ),
          ),
          _section(
            title: '1. ضمائر الملكية',
            child: Column(
              children: const [
                _Pair('Benim', 'لي / خاصتي'),
                _Pair('Senin', 'لك / خاصتك'),
                _Pair('Onun', 'له أو لها'),
                _Pair('Bizim', 'لنا / خاصتنا'),
                _Pair('Sizin', 'لكم أو لحضرتك'),
                _Pair('Onların', 'لهم / خاصتهم'),
              ],
            ),
          ),
          _section(
            title: '2. لاحقة الملكية مع الاسم',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'في التركية غالباً نضيف لاحقة إلى نهاية الاسم لتوضيح صاحب الشيء. شكل اللاحقة يتغير بحسب آخر حرف متحرك في الكلمة.',
                  style: TextStyle(height: 1.7),
                ),
                SizedBox(height: 12),
                _Pair('kitap → kitabım', 'كتابي'),
                _Pair('ev → evin', 'بيتك'),
                _Pair('araba → arabası', 'سيارته / سيارتها'),
                _Pair('okul → okulumuz', 'مدرستنا'),
                _Pair('kalem → kaleminiz', 'قلمكم / قلم حضرتك'),
                _Pair('kitap → kitapları', 'كتبهم أو كتبها بحسب السياق'),
              ],
            ),
          ),
          _section(
            title: '3. انتبه إلى التغيّر الصوتي',
            child: const Text(
              'بعض الأسماء التي تنتهي بحرف صامت مهموس يتغير آخرها عند إضافة لاحقة تبدأ بحرف متحرك. مثال: kitap تصبح kitabım، وağaç تصبح ağacım. احفظ الكلمة مع مثالها.',
              style: TextStyle(height: 1.7),
            ),
          ),
          _section(
            title: '4. أمثلة في جمل',
            child: Column(
              children: const [
                _Pair('Bu benim kitabım.', 'هذا كتابي.'),
                _Pair('Bu senin çantan mı?', 'هل هذه حقيبتك؟'),
                _Pair('Onun evi büyük.', 'بيته / بيتها كبير.'),
                _Pair('Bizim okulumuz yeni.', 'مدرستنا جديدة.'),
                _Pair('Benim bir kalemim var.', 'لدي قلم.'),
              ],
            ),
          ),
          _section(
            title: '5. حوار قصير',
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.softGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DialogueLine('A: Bu kimin kitabı?', 'لمن هذا الكتاب؟'),
                  _DialogueLine('B: Bu benim kitabım.', 'هذا كتابي.'),
                  _DialogueLine('A: Şu çanta senin mi?', 'هل تلك الحقيبة لك؟'),
                  _DialogueLine('B: Hayır, o onun çantası.', 'لا، إنها حقيبته / حقيبتها.'),
                ],
              ),
            ),
          ),
          _section(
            title: '6. اختبر فهمك',
            child: Column(
              children: [
                ...List.generate(questions.length, _buildQuestion),
                const SizedBox(height: 12),
                if (!submitted)
                  FilledButton(
                    onPressed: answers.length == questions.length
                        ? () => setState(() => submitted = true)
                        : null,
                    child: const Text('تصحيح الإجابات'),
                  )
                else
                  Column(
                    children: [
                      Text(
                        'نتيجتك: $score من ${questions.length}',
                        style: const TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () => setState(() {
                          answers.clear();
                          submitted = false;
                        }),
                        icon: const Icon(Icons.refresh),
                        label: const Text('إعادة الاختبار'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'تذكّر: لاحقة الملكية ترتبط بالاسم نفسه، أما ضمير الملكية مثل benim أو senin فيأتي قبله للتوضيح أو التأكيد.',
            style: TextStyle(
              color: AppColors.muted,
              height: 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF3D9069), Color(0xFF246044)],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('A1  •  الوحدة 3  •  الدرس 7',
              style: TextStyle(color: Colors.white70)),
          SizedBox(height: 10),
          Text(
            'التعبير عن الملكية ووصف ما نملكه',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          SizedBox(height: 6),
          Text('İyelik ve Sahiplik İfadeleri',
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Colors.white, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                )),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(int index) {
    final question = questions[index];
    final selected = answers[index];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${index + 1}. ${question.prompt}',
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...List.generate(question.options.length, (optionIndex) {
            final isCorrect = submitted && optionIndex == question.correctIndex;
            final isWrong = submitted &&
                selected == optionIndex &&
                optionIndex != question.correctIndex;
            return RadioListTile<int>(
              value: optionIndex,
              groupValue: selected,
              dense: true,
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.green,
              title: Text(question.options[optionIndex],
                  textDirection: TextDirection.rtl),
              onChanged: submitted
                  ? null
                  : (value) => setState(() => answers[index] = value!),
              tileColor: isCorrect
                  ? AppColors.softGreen
                  : isWrong
                      ? const Color(0xFFFFE4E1)
                      : null,
            );
          }),
          if (submitted)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                question.explanation,
                style: const TextStyle(
                    color: AppColors.darkGreen, height: 1.5),
              ),
            ),
        ],
      ),
    );
  }
}

class _Pair extends StatelessWidget {
  const _Pair(this.turkish, this.arabic);
  final String turkish;
  final String arabic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(turkish,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                    color: AppColors.green, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(arabic,
                textAlign: TextAlign.start,
                style: const TextStyle(color: AppColors.darkGreen)),
          ),
        ],
      ),
    );
  }
}

class _DialogueLine extends StatelessWidget {
  const _DialogueLine(this.turkish, this.arabic);
  final String turkish;
  final String arabic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(turkish,
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                  color: AppColors.darkGreen, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(arabic, style: const TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _Question {
  const _Question({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}
