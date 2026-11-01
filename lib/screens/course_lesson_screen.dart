import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LessonExample {
  const LessonExample(this.turkish, this.arabic);
  final String turkish;
  final String arabic;
}

class LessonContent {
  const LessonContent({
    required this.goal,
    required this.explanation,
    required this.examples,
    required this.question,
    required this.options,
    required this.answer,
    required this.feedback,
  });

  final String goal;
  final String explanation;
  final List<LessonExample> examples;
  final String question;
  final List<String> options;
  final int answer;
  final String feedback;

  static LessonContent? find(String unitId, int lessonIndex) =>
      _lessons['$unitId-${lessonIndex + 1}'];

  static const Map<String, LessonContent> _lessons = {
    'a1-u1-1': LessonContent(goal: 'التعرّف إلى الحروف التركية وقراءة الأبجدية كاملة.', explanation: 'تتكوّن الأبجدية التركية الحديثة من 29 حرفاً. تُكتب من اليسار إلى اليمين، ولكل حرف صوت ثابت غالباً. انتبه إلى الحروف الخاصة: Ç ç، Ğ ğ، I ı، İ i، Ö ö، Ş ş، Ü ü.', examples: [LessonExample('A a – Araba', 'أ – سيارة'), LessonExample('Ç ç – Çay', 'تش – شاي'), LessonExample('Ş ş – Şeker', 'ش – سكر')], question: 'كم حرفاً في الأبجدية التركية؟', options: ['26', '28', '29', '30'], answer: 2, feedback: 'الأبجدية التركية تتكوّن من 29 حرفاً.'),
    'a1-u1-2': LessonContent(goal: 'تمييز الحروف المتحركة وتصنيفها إلى مجموعات.', explanation: 'الحروف المتحركة التركية هي: a, e, ı, i, o, ö, u, ü. وتنقسم إلى حروف خلفية (a, ı, o, u) وأمامية (e, i, ö, ü). هذا التصنيف مهم لفهم انسجام اللواحق.', examples: [LessonExample('a – kapı', 'a حرف خلفي في كلمة باب'), LessonExample('e – ev', 'e حرف أمامي في كلمة بيت'), LessonExample('ü – üzüm', 'ü حرف أمامي مستدير في كلمة عنب')], question: 'أي مجموعة تتكوّن من حروف متحركة خلفية؟', options: ['e, i, ö, ü', 'a, ı, o, u', 'a, e, i, o', 'ı, i, u, ü'], answer: 1, feedback: 'الحروف الخلفية الأربعة هي a, ı, o, u.'),
    'a1-u1-3': LessonContent(goal: 'فهم فكرة الانسجام الصوتي الأساسي في اللواحق.', explanation: 'غالباً ما تتغير حركة اللاحقة لتنسجم مع آخر حركة في الكلمة. في الانسجام الثنائي نستخدم a بعد الحركات الخلفية وe بعد الأمامية، مثل -lar/-ler للجمع. توجد قواعد أخرى أكثر تفصيلاً ستتعلمها تدريجياً.', examples: [LessonExample('ev → evler', 'بيوت: آخر حركة أمامية، لذلك -ler'), LessonExample('araba → arabalar', 'سيارات: آخر حركة خلفية، لذلك -lar'), LessonExample('gül → güller', 'ورود: آخر حركة أمامية، لذلك -ler')], question: 'ما جمع كلمة ev؟', options: ['evlar', 'evler', 'evlerı', 'evlerlar'], answer: 1, feedback: 'ev تنتهي بحركة أمامية e، لذلك نضيف -ler.'),
    'a1-u1-4': LessonContent(goal: 'التعرّف إلى أصوات تركية قد لا توجد بالطريقة نفسها في العربية.', explanation: 'تحتاج بعض الحروف إلى تدريب خاص: c يُنطق مثل j في كلمة journal، وç مثل ch في chair، وş مثل sh في ship. أما ı فصوت مستقل غير منقوط، ويختلف عن i المنقوط.', examples: [LessonExample('cam', 'زجاج – يبدأ بصوت j'), LessonExample('çocuk', 'طفل – يبدأ بصوت ch'), LessonExample('şapka', 'قبعة – يبدأ بصوت sh')], question: 'أي حرف تركي يُنطق قريباً من sh الإنجليزية؟', options: ['c', 'ş', 'ç', 'j'], answer: 1, feedback: 'الحرف ş صوته قريب من sh في الإنجليزية.'),
    'a1-u1-5': LessonContent(goal: 'تقسيم الكلمات إلى مقاطع وقراءتها بوضوح.', explanation: 'في التركية تحتوي كل مقطعية عادةً على حركة واحدة، ويمكن استخدام عدد الحركات لتقدير عدد المقاطع. اقرأ ببطء، ولا تحذف الحركات، وحافظ على وضوح كل مقطع.', examples: [LessonExample('a-ra-ba', 'سيارة – ثلاثة مقاطع'), LessonExample('ki-tap', 'كتاب – مقطعان'), LessonExample('o-kul', 'مدرسة – مقطعان')], question: 'كم مقطعاً في كلمة araba؟', options: ['مقطع واحد', 'مقطعان', 'ثلاثة مقاطع', 'أربعة مقاطع'], answer: 2, feedback: 'a-ra-ba تتكوّن من ثلاثة مقاطع.'),
    'a1-u1-6': LessonContent(goal: 'تطبيق النطق على كلمات يومية قصيرة.', explanation: 'اقرأ الكلمة كاملة ثم قسّمها إلى مقاطع، وانتبه إلى الحروف المنقوطة وغير المنقوطة. لا تعتمد على شكل الحرف وحده؛ استمع إلى نطقه وكرره.', examples: [LessonExample('merhaba', 'مرحباً'), LessonExample('teşekkür', 'شكراً'), LessonExample('lütfen', 'من فضلك')], question: 'أي كلمة تعني «من فضلك»؟', options: ['Merhaba', 'Lütfen', 'Teşekkür', 'Günaydın'], answer: 1, feedback: 'Lütfen تعني من فضلك.'),
    'a1-u1-7': LessonContent(goal: 'تمييز الكلمات المتقاربة في الصوت والكتابة.', explanation: 'قد يؤدي اختلاف نقطة أو علامة صغيرة إلى اختلاف الحرف والكلمة. قارن بين I وİ، وبين o وö، وبين u وü. كرر الكلمات بصوت واضح ولا تستبدل الحروف الخاصة بحروف عربية تقريبية.', examples: [LessonExample('Işık', 'ضوء'), LessonExample('İsim', 'اسم'), LessonExample('Göl', 'بحيرة')], question: 'أي حرف هو i المنقوط الكبير؟', options: ['I', 'İ', 'ı', 'j'], answer: 1, feedback: 'الحرف İ كبير ومنقوط، ويختلف عن I غير المنقوط.'),
    'a1-u1-8': LessonContent(goal: 'قراءة عبارات قصيرة تجمع الحروف التي تعلمتها.', explanation: 'ابدأ بقراءة الكلمات منفردة، ثم اقرأ العبارة كاملة. لاحظ أن التركية تستخدم علامات مثل ş وç وğ، وأن الحرف ğ غالباً يطيل الحركة السابقة أو يسهّل الانتقال بين الحركات.', examples: [LessonExample('Güzel bir gün.', 'إنه يوم جميل.'), LessonExample('Çay çok sıcak.', 'الشاي ساخن جداً.'), LessonExample('Üç küçük kuş.', 'ثلاثة طيور صغيرة.')], question: 'ما معنى Güzel؟', options: ['كبير', 'جميل', 'بارد', 'سريع'], answer: 1, feedback: 'Güzel تعني جميل أو جميلة.'),
    'a1-u1-9': LessonContent(goal: 'مراجعة الحروف والأصوات والقراءة الأساسية.', explanation: 'راجع الحروف المتحركة الثمانية، والحروف الخاصة، والتمييز بين c/ç وs/ş وı/i. استخدم القراءة المتدرجة: حرف، ثم مقطع، ثم كلمة، ثم جملة قصيرة.', examples: [LessonExample('çanta', 'حقيبة'), LessonExample('öğrenci', 'طالب'), LessonExample('üzüm', 'عنب')], question: 'أي كلمة تبدأ بالحرف ş؟', options: ['Çanta', 'Şeker', 'Öğrenci', 'Üzüm'], answer: 1, feedback: 'Şeker تبدأ بالحرف ş.'),
    'a1-u2-1': LessonContent(goal: 'استخدام التحيات المناسبة في أوقات ومواقف مختلفة.', explanation: 'تختلف التحية التركية بحسب الوقت والرسمية. Merhaba تحية عامة، Günaydın للصباح، İyi akşamlar للمساء. عند المغادرة نقول Hoşça kal أو Güle güle بحسب المتحدث والسياق.', examples: [LessonExample('Merhaba!', 'مرحباً!'), LessonExample('Günaydın!', 'صباح الخير!'), LessonExample('İyi akşamlar.', 'مساء الخير.')], question: 'ما التحية المناسبة في الصباح؟', options: ['İyi geceler', 'Günaydın', 'Hoşça kal', 'Güle güle'], answer: 1, feedback: 'Günaydın تعني صباح الخير.'),
    'a1-u2-2': LessonContent(goal: 'تقديم نفسك بجمل قصيرة وبسيطة.', explanation: 'يمكنك استخدام Benim adım ... بمعنى اسمي ...، أو Ben ... بمعنى أنا ... . ولذكر المهنة أو الصفة نستخدم جملة اسمية بسيطة مثل Ben öğrenciyim (أنا طالب/طالبة).', examples: [LessonExample('Benim adım Ali.', 'اسمي علي.'), LessonExample('Ben öğrenciyim.', 'أنا طالب/طالبة.'), LessonExample('Memnun oldum.', 'سعيد/سعيدة بلقائك.')], question: 'كيف تقول «اسمي سارة»؟', options: ['Benim adım Sara.', 'Senin adın Sara.', 'Nerelisin Sara?', 'Hoşça kal Sara.'], answer: 0, feedback: 'Benim adım Sara تعني اسمي سارة.'),
    'a1-u2-3': LessonContent(goal: 'السؤال عن الاسم والبلد والأصل والإجابة عنها.', explanation: 'للسؤال عن الاسم نقول Adın ne؟ وللسؤال عن البلد أو الأصل Nerelisin؟. يمكن الإجابة بـ Ben Suriyeliyim (أنا سوري/سورية) أو Suriyeliyim.', examples: [LessonExample('Adın ne?', 'ما اسمك؟'), LessonExample('Nerelisin?', 'من أين أنت؟'), LessonExample('Ben Suriyeliyim.', 'أنا سوري/سورية.')], question: 'أي سؤال يعني «من أين أنت؟»', options: ['Kaç yaşındasın?', 'Nerelisin?', 'Adın ne?', 'Nasılsın?'], answer: 1, feedback: 'Nerelisin تعني من أين أنت؟'),
    'a1-u2-4': LessonContent(goal: 'استخدام الضمائر الشخصية الأساسية.', explanation: 'الضمائر هي Ben أنا، Sen أنت، O هو/هي، Biz نحن، Siz أنتم أو حضرتك، Onlar هم. كثيراً ما يُحذف الضمير في التركية لأن نهاية الفعل أو الجملة قد تدل على الشخص.', examples: [LessonExample('Ben', 'أنا'), LessonExample('Biz', 'نحن'), LessonExample('Onlar', 'هم / هن')], question: 'ما الضمير التركي الذي يعني «نحن»؟', options: ['Ben', 'Sen', 'Biz', 'Siz'], answer: 2, feedback: 'Biz تعني نحن.'),
    'a1-u2-5': LessonContent(goal: 'تكوين جمل اسمية بسيطة للتعريف بالهوية والصفة.', explanation: 'في التركية تُضاف نهايات إلى الاسم أو الصفة لتدل على الشخص. مثال: Ben öğrenciyim (أنا طالب)، Sen öğrencisin (أنت طالب)، O öğrenci (هو/هي طالب). تتغير النهاية بحسب الضمير والانسجام الصوتي.', examples: [LessonExample('Ben öğretmenim.', 'أنا معلّم/معلّمة.'), LessonExample('Sen yorgunsun.', 'أنت متعب/متعبة.'), LessonExample('O doktor.', 'هو/هي طبيب.')], question: 'أكمل: Ben öğrenci___ .', options: ['-sin', '-yim', '-siniz', 'لا شيء دائماً'], answer: 1, feedback: 'مع Ben نستخدم هنا -yim: Ben öğrenciyim.'),
    'a1-u2-6': LessonContent(goal: 'طرح سؤال بسيط وصياغة النفي في الجمل الاسمية.', explanation: 'أداة السؤال mı/mi/mu/mü تُكتب منفصلة وتتغير حركتها حسب الانسجام الصوتي. للنفي في الجمل الاسمية نستخدم değil، مثل Ben doktor değilim (أنا لست طبيباً).', examples: [LessonExample('Öğrenci misin?', 'هل أنت طالب؟'), LessonExample('Mutlu musun?', 'هل أنت سعيد؟'), LessonExample('Ben öğretmen değilim.', 'أنا لست معلماً.')], question: 'أي كلمة تُستخدم للنفي في الجملة الاسمية؟', options: ['var', 'değil', 'mi', 've'], answer: 1, feedback: 'değil أداة النفي في الجمل الاسمية.'),
    'a1-u2-7': LessonContent(goal: 'قراءة الأرقام والسؤال عن العمر والإجابة عنه.', explanation: 'الأرقام الأساسية: bir واحد، iki اثنان، üç ثلاثة، dört أربعة، beş خمسة، on عشرة، yirmi عشرون. للسؤال عن العمر نقول Kaç yaşındasın؟ والإجابة Ben ... yaşındayım.', examples: [LessonExample('Kaç yaşındasın?', 'كم عمرك؟'), LessonExample('On sekiz yaşındayım.', 'عمري ثمانية عشر عاماً.'), LessonExample('Yirmi bir', 'واحد وعشرون')], question: 'ما معنى üç؟', options: ['اثنان', 'ثلاثة', 'أربعة', 'خمسة'], answer: 1, feedback: 'üç تعني ثلاثة.'),
    'a1-u2-8': LessonContent(goal: 'إجراء حوار تعارف قصير من التحية حتى الوداع.', explanation: 'اجمع ما تعلمته في حوار مرتب: التحية، السؤال عن الحال، الاسم، البلد أو المهنة، ثم عبارة المجاملة والوداع. استخدم Sen عند الحديث غير الرسمي وSiz في السياق الرسمي أو الاحترام.', examples: [LessonExample('A: Merhaba, nasılsın?', 'أ: مرحباً، كيف حالك؟'), LessonExample('B: İyiyim, teşekkürler. Ya sen?', 'ب: أنا بخير، شكراً. وأنت؟'), LessonExample('A: Ben de iyiyim.', 'أ: أنا أيضاً بخير.')], question: 'ما الرد الشائع على Nasılsın؟', options: ['İyiyim, teşekkürler.', 'Benim adım.', 'Güle güle.', 'Nerelisin?'], answer: 0, feedback: 'İyiyim, teşekkürler تعني أنا بخير، شكراً.'),
    'a1-u2-9': LessonContent(goal: 'مراجعة التحيات والتعارف والضمائر والأرقام.', explanation: 'تأكد من قدرتك على بدء التعارف، ذكر اسمك وبلدك، السؤال عن شخص آخر، استخدام الضمائر، وتكوين سؤال بسيط وجواب منفي. حاول أن تنشئ حواراً من أربع إلى ست جمل.', examples: [LessonExample('Benim adım Lina.', 'اسمي لينا.'), LessonExample('Nerelisin? – Mısırlıyım.', 'من أين أنت؟ – أنا مصري/مصرية.'), LessonExample('Kaç yaşındasın? – Yirmi yaşındayım.', 'كم عمرك؟ – عمري عشرون عاماً.')], question: 'اختر العبارة التي تعني «أنا أيضاً بخير».', options: ['Ben de iyiyim.', 'Ben öğrenciyim.', 'İyi geceler.', 'Adın ne?'], answer: 0, feedback: 'Ben de iyiyim تعني أنا أيضاً بخير.'),
    'a1-u3-1': LessonContent(goal: 'تسمية الأشياء والأدوات الشائعة في المنزل والدراسة.', explanation: 'ابدأ بحفظ أسماء الأشياء مع أداة التعريف العربية ومع مثال بسيط. الأسماء التركية لا تتغير بحسب المذكر والمؤنث كما في العربية.', examples: [LessonExample('kitap', 'كتاب'), LessonExample('kalem', 'قلم'), LessonExample('masa', 'طاولة'), LessonExample('kapı', 'باب'), LessonExample('telefon', 'هاتف')], question: 'ما معنى kalem؟', options: ['كتاب', 'قلم', 'باب', 'كرسي'], answer: 1, feedback: 'kalem تعني قلم.'),
    'a1-u3-2': LessonContent(goal: 'وصف الأشياء باستخدام الألوان والصفات الأساسية.', explanation: 'تأتي الصفة عادة قبل الاسم في التركية. من الألوان: kırmızı أحمر، mavi أزرق، beyaz أبيض، siyah أسود. ومن الصفات: büyük كبير، küçük صغير، güzel جميل، yeni جديد.', examples: [LessonExample('kırmızı araba', 'سيارة حمراء'), LessonExample('büyük ev', 'بيت كبير'), LessonExample('mavi kalem', 'قلم أزرق')], question: 'ما معنى beyaz؟', options: ['أسود', 'أحمر', 'أبيض', 'أزرق'], answer: 2, feedback: 'beyaz تعني أبيض.'),
    'a1-u3-3': LessonContent(goal: 'تكوين جمع الأسماء باستخدام -lar و-ler.', explanation: 'نضيف -lar أو -ler إلى الاسم بحسب آخر حركة: بعد a, ı, o, u نستخدم -lar، وبعد e, i, ö, ü نستخدم -ler. لا نضيف لاحقة الجمع عادةً إذا كان العدد مذكوراً.', examples: [LessonExample('kitap → kitaplar', 'كتب'), LessonExample('ev → evler', 'بيوت'), LessonExample('kalem → kalemler', 'أقلام')], question: 'ما جمع كلمة araba؟', options: ['arabaler', 'arabalar', 'arabalarlar', 'arabas'], answer: 1, feedback: 'آخر حركة في araba هي a، لذلك نضيف -lar.'),
    'a1-u3-4': LessonContent(goal: 'استخدام أسماء الإشارة هذا وذاك وهؤلاء.', explanation: 'Bu تعني هذا/هذه للقريب، Şu للإشارة إلى شيء محدد عادةً، وO تعني ذلك/تلك للبعيد. للجمع نستخدم Bunlar (هؤلاء/هذه الأشياء) وOnlar (أولئك/هم).', examples: [LessonExample('Bu bir kitap.', 'هذا كتاب.'), LessonExample('Şu kalem.', 'ذلك القلم المشار إليه.'), LessonExample('Bunlar kitaplar.', 'هذه كتب.')], question: 'أي كلمة تعني «هذا/هذه» للقريب؟', options: ['O', 'Bu', 'Onlar', 'Nerede'], answer: 1, feedback: 'Bu تستخدم للإشارة إلى القريب.'),
    'a1-u3-5': LessonContent(goal: 'تركيب جمل لوصف الأشياء باللون والحجم والصفة.', explanation: 'ضع الصفة قبل الاسم، ثم استخدم Bu أو Şu لتكوين جملة. مثال: Bu büyük bir masa (هذه طاولة كبيرة). لاحظ أن bir تأتي غالباً قبل الاسم المفرد المعدود في هذا التركيب.', examples: [LessonExample('Bu kırmızı bir çanta.', 'هذه حقيبة حمراء.'), LessonExample('Şu küçük ev.', 'ذلك البيت الصغير.'), LessonExample('Bu yeni telefon.', 'هذا هاتف جديد.')], question: 'اختر الترتيب الصحيح لعبارة «سيارة زرقاء».', options: ['araba mavi', 'mavi araba', 'araba mavil', 'mavi bir'], answer: 1, feedback: 'الصفة تسبق الاسم: mavi araba.'),
    'a1-u3-6': LessonContent(goal: 'وصف الغرفة وتحديد مكان الأشياء.', explanation: 'تعلّم كلمات المكان: içinde داخل، üstünde فوق، altında تحت، yanında بجانب، önünde أمام، arkasında خلف. للسؤال عن المكان نقول Nerede؟ أي أين؟', examples: [LessonExample('Kitap masanın üstünde.', 'الكتاب فوق الطاولة.'), LessonExample('Çanta sandalyenin yanında.', 'الحقيبة بجانب الكرسي.'), LessonExample('Telefon çantanın içinde.', 'الهاتف داخل الحقيبة.')], question: 'ما معنى altında؟', options: ['فوق', 'تحت', 'بجانب', 'أمام'], answer: 1, feedback: 'altında تعني تحت.'),
    'a1-u3-7': LessonContent(goal: 'التعبير عن الملكية باستخدام الضمائر واللواحق.', explanation: 'يمكن أن نذكر ضمير الملكية مثل benim أو senin، ثم نضيف لاحقة الملكية إلى الاسم. تتغير اللاحقة بحسب آخر حركة، وقد يتغير آخر حرف في بعض الأسماء مثل kitap → kitabım.', examples: [LessonExample('Benim kitabım.', 'كتابي.'), LessonExample('Senin çantan.', 'حقيبتك.'), LessonExample('Bizim evimiz.', 'بيتنا.')], question: 'كيف نقول «كتابي»؟', options: ['kitabın', 'kitabım', 'kitabı', 'kitabımız'], answer: 1, feedback: 'لاحقة المتكلم المفرد هنا -ım: kitabım.'),
    'a1-u3-8': LessonContent(goal: 'السؤال عن الأشياء ومالكها ووصفها في حوار يومي.', explanation: 'للسؤال عن ماهية الشيء نقول Bu ne؟ (ما هذا؟)، وعن صاحبه Bu kimin؟ (لمن هذا؟)، وعن مكانه Nerede؟ (أين؟). وللسؤال عن السعر Ne kadar؟ (كم السعر؟).', examples: [LessonExample('Bu ne?', 'ما هذا؟'), LessonExample('Bu kimin çantası?', 'لمن هذه الحقيبة؟'), LessonExample('Ne kadar?', 'كم السعر؟'), LessonExample('Çanta nerede?', 'أين الحقيبة؟')], question: 'كيف تسأل «لمن هذا؟»', options: ['Bu ne?', 'Bu kimin?', 'Nerede?', 'Ne kadar?'], answer: 1, feedback: 'Bu kimin؟ تعني لمن هذا؟'),
    'a1-u3-9': LessonContent(goal: 'مراجعة مفردات الأشياء والألوان والجمع والإشارة والمكان والملكية.', explanation: 'استخدم ما تعلمته لوصف غرفة أو حقيبة أو مكتب. اذكر اسم الشيء ولونه وحجمه ومكانه وصاحبه. كوّن خمس جمل مترابطة ثم أجب عن أسئلة المراجعة.', examples: [LessonExample('Bu benim mavi çantam.', 'هذه حقيبتي الزرقاء.'), LessonExample('Kitap masanın üstünde.', 'الكتاب فوق الطاولة.'), LessonExample('Bunlar yeni kalemler.', 'هذه أقلام جديدة.')], question: 'أي جملة تعني «هذه حقيبتي الزرقاء»؟', options: ['Bu benim mavi çantam.', 'Bu senin kırmızı evin.', 'O benim kitabım.', 'Bunlar küçük masalar.'], answer: 0, feedback: 'Bu benim mavi çantam تعني هذه حقيبتي الزرقاء.'),
  };
}

class CourseLessonScreen extends StatefulWidget {
  const CourseLessonScreen({
    super.key,
    required this.unitId,
    required this.unitTitle,
    required this.lessonTitle,
    required this.lessonNumber,
  });

  final String unitId;
  final String unitTitle;
  final String lessonTitle;
  final int lessonNumber;

  @override
  State<CourseLessonScreen> createState() => _CourseLessonScreenState();
}

class _CourseLessonScreenState extends State<CourseLessonScreen> {
  int? selected;
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    final lesson = LessonContent.find(widget.unitId, widget.lessonNumber - 1);
    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(title: Text('الدرس ${widget.lessonNumber}')),
        body: const Center(child: Text('محتوى هذا الدرس غير متاح حالياً.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('الدرس ${widget.lessonNumber}')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF3D9069), Color(0xFF246044)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('A1 • ${widget.unitTitle} • الدرس ${widget.lessonNumber}',
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                Text(widget.lessonTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800, height: 1.5)),
                const SizedBox(height: 12),
                const Text('هدف الدرس', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(height: 5),
                Text(lesson.goal, style: const TextStyle(color: Colors.white, height: 1.6)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section('الشرح', Text(lesson.explanation, style: const TextStyle(height: 1.8))),
          _section('أمثلة وتطبيقات', Column(
            children: lesson.examples.map((example) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(example.turkish, textDirection: TextDirection.ltr,
                    style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w800))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(example.arabic, style: const TextStyle(color: AppColors.darkGreen))),
                ],
              ),
            )).toList(),
          )),
          _section('اختبر فهمك', Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lesson.question, style: const TextStyle(fontWeight: FontWeight.w800, height: 1.6)),
              const SizedBox(height: 8),
              ...List.generate(lesson.options.length, (index) => RadioListTile<int>(
                value: index,
                groupValue: selected,
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.green,
                title: Text(lesson.options[index]),
                onChanged: checked ? null : (value) => setState(() => selected = value),
              )),
              const SizedBox(height: 8),
              if (!checked)
                FilledButton(
                  onPressed: selected == null ? null : () => setState(() => checked = true),
                  child: const Text('تحقق من الإجابة'),
                )
              else ...[
                Text(
                  selected == lesson.answer ? 'إجابة صحيحة! أحسنت.' : 'ليست الإجابة الصحيحة. راجع الشرح ثم حاول مرة أخرى.',
                  style: TextStyle(
                    color: selected == lesson.answer ? AppColors.green : Colors.red.shade700,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(lesson.feedback, style: const TextStyle(height: 1.6)),
                TextButton.icon(
                  onPressed: () => setState(() { selected = null; checked = false; }),
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ],
          )),
          const SizedBox(height: 10),
          const Text('نصيحة: اقرأ الأمثلة التركية بصوت مسموع، ثم حاول تكوين جملة جديدة بنفس النمط.',
              style: TextStyle(color: AppColors.muted, height: 1.7)),
        ],
      ),
    );
  }

  Widget _section(String title, Widget child) => Card(
    margin: const EdgeInsets.only(bottom: 14),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: AppColors.darkGreen, fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        child,
      ]),
    ),
  );
}
