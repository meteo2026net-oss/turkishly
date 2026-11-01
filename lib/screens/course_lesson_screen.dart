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

    'a1-u4-1': LessonContent(goal: 'تعلّم أسماء أفراد العائلة الأساسية.', explanation: 'تُستخدم كلمات القرابة كثيراً في التعارف والحديث اليومي. احفظ الكلمة مع ضمير الملكية لتستطيع قول عائلتي وأمي وأبي.', examples: [LessonExample('aile', 'عائلة'), LessonExample('anne / baba', 'أم / أب'), LessonExample('kardeş', 'أخ أو أخت'), LessonExample('çocuk', 'طفل')], question: 'ما معنى anne؟', options: ['أب', 'أم', 'أخ', 'جد'], answer: 1, feedback: 'anne تعني الأم.'),
    'a1-u4-2': LessonContent(goal: 'التحدث عن أفراد الأسرة والعلاقات العائلية.', explanation: 'تعرّف إلى كلمات مثل abla الأخت الكبرى، ağabey أو abi الأخ الأكبر، kız kardeş الأخت، erkek kardeş الأخ، وçocuk الطفل. قد تختلف صيغة الاستخدام اليومية عن الصيغة الكاملة.', examples: [LessonExample('Benim bir kız kardeşim var.', 'لدي أخت.'), LessonExample('İki erkek kardeşim var.', 'لدي أخوان.'), LessonExample('Ağabeyim burada.', 'أخي الأكبر هنا.')], question: 'ماذا تعني kız kardeş؟', options: ['أخ أصغر', 'أخت', 'أم', 'ابنة'], answer: 1, feedback: 'kız kardeş تعني أخت.'),
    'a1-u4-3': LessonContent(goal: 'استخدام صفات بسيطة لوصف الأشخاص.', explanation: 'يمكن وصف الأشخاص بصفات أساسية مثل uzun طويل، kısa قصير، genç شاب، yaşlı كبير في السن، çalışkan مجتهد، sakin هادئ. تأتي الصفة قبل الاسم عندما تصفه مباشرة.', examples: [LessonExample('uzun boylu', 'طويل القامة'), LessonExample('genç bir kadın', 'امرأة شابة'), LessonExample('çalışkan öğrenci', 'طالب مجتهد')], question: 'ما معنى genç؟', options: ['قديم', 'شاب', 'متعب', 'سريع'], answer: 1, feedback: 'genç تعني شاب أو صغير السن.'),
    'a1-u4-4': LessonContent(goal: 'السؤال عن أفراد العائلة وتقديم معلومات بسيطة عنهم.', explanation: 'استخدم Kim؟ للسؤال عن الشخص، وBu kim؟ بمعنى من هذا؟، وKaç kardeşin var؟ للسؤال عن عدد إخوتك. أجب بجملة قصيرة مع اسم الشخص أو صلة القرابة.', examples: [LessonExample('Bu kim?', 'من هذا؟'), LessonExample('Bu benim annem.', 'هذه أمي.'), LessonExample('Kaç kardeşin var?', 'كم أخاً أو أختاً لديك؟')], question: 'كيف تسأل «من هذا؟»', options: ['Bu ne?', 'Bu kim?', 'Nerede?', 'Kaç yaşında?'], answer: 1, feedback: 'Bu kim؟ تعني من هذا؟'),
    'a1-u4-5': LessonContent(goal: 'التعبير عن العمر عند الحديث عن أفراد الأسرة.', explanation: 'للسؤال عن عمر شخص آخر نستخدم Kaç yaşında؟ أي كم عمره/عمرها؟ وللإجابة نقول Annem kırk yaşında (أمي عمرها أربعون عاماً). لاحظ الفرق بين yaşındayım للمتكلم وyaşında للغائب.', examples: [LessonExample('Annem kaç yaşında?', 'كم عمر أمي؟'), LessonExample('Babam elli yaşında.', 'أبي عمره خمسون عاماً.'), LessonExample('Kardeşim on yaşında.', 'أخي/أختي عمره عشرة أعوام.')], question: 'أكمل: Babam otuz yaş___ .', options: ['-ındayım', '-ında', '-sın', '-ız'], answer: 1, feedback: 'مع الغائب نستخدم yaşında: Babam otuz yaşında.'),
    'a1-u4-6': LessonContent(goal: 'استخدام ضمائر الملكية مع أسماء أفراد العائلة.', explanation: 'تظهر الملكية كثيراً مع أسماء الأسرة: annem أمي، baban أبوك، kardeşi أخوه/أخته، ailemiz عائلتنا. انتبه إلى أن لاحقة الملكية تتصل بالكلمة، وقد تختلف وفق الانسجام الصوتي.', examples: [LessonExample('annem', 'أمي'), LessonExample('baban', 'أبوك'), LessonExample('kardeşimiz', 'أخونا / أختنا'), LessonExample('aileleri', 'عائلتهم')], question: 'ما معنى annem؟', options: ['أمك', 'أمي', 'أمه', 'أمنا'], answer: 1, feedback: 'anne + m تصبح annem، أي أمي.'),
    'a1-u4-7': LessonContent(goal: 'التحدث عن المهن والأنشطة اليومية لأفراد الأسرة.', explanation: 'من أسماء المهن öğretmen معلّم، doktor طبيب، mühendis مهندس، öğrenci طالب. لتكوين جملة اسمية استخدم لاحقة الشخص المناسبة: Annem öğretmen (أمي معلمة)، Babam doktor (أبي طبيب).', examples: [LessonExample('Annem öğretmen.', 'أمي معلمة.'), LessonExample('Babam doktor.', 'أبي طبيب.'), LessonExample('Kardeşim öğrenci.', 'أخي/أختي طالب.')], question: 'ما معنى doktor؟', options: ['مهندس', 'طبيب', 'معلم', 'طالب'], answer: 1, feedback: 'doktor تعني طبيب.'),
    'a1-u4-8': LessonContent(goal: 'إجراء حوار بسيط للتعريف بالعائلة.', explanation: 'في الحوار ابدأ بالسؤال Ailen nasıl؟ (كيف حال عائلتك؟) أو Ailende kaç kişi var؟ (كم شخصاً في عائلتك؟). أجب بعدد أفراد الأسرة، ثم اذكر شخصاً أو اثنين مع أعمارهم أو مهنهم.', examples: [LessonExample('Ailende kaç kişi var?', 'كم شخصاً في عائلتك؟'), LessonExample('Ailemde dört kişi var.', 'في عائلتي أربعة أشخاص.'), LessonExample('Annem öğretmen, babam doktor.', 'أمي معلمة وأبي طبيب.')], question: 'ما معنى Ailemde dört kişi var؟', options: ['عائلتي كبيرة', 'في عائلتي أربعة أشخاص', 'لدي أربعة إخوة', 'أبي طبيب'], answer: 1, feedback: 'Ailemde dört kişi var تعني في عائلتي أربعة أشخاص.'),
    'a1-u4-9': LessonContent(goal: 'مراجعة مفردات العائلة والصفات والعمر والمهن والملكية.', explanation: 'كوّن فقرة قصيرة من أربع أو خمس جمل عن عائلتك. اذكر عدد أفرادها، وصلة القرابة، والعمر أو المهنة، واستخدم لاحقة ملكية واحدة على الأقل.', examples: [LessonExample('Bu benim ailem.', 'هذه عائلتي.'), LessonExample('Bir kız kardeşim var.', 'لدي أخت.'), LessonExample('Annem genç ve çalışkan.', 'أمي شابة ومجتهدة.')], question: 'أي جملة تعني «لدي أخ»؟', options: ['Ben kardeşim.', 'Bir erkek kardeşim var.', 'Babam var.', 'Ailem dört kişi.'], answer: 1, feedback: 'Bir erkek kardeşim var تعني لدي أخ.'),

    'a1-u5-1': LessonContent(goal: 'تعلّم أسماء الأطعمة والمكوّنات الشائعة.', explanation: 'ابدأ بأسماء الطعام الأساسية. احفظ الاسم مع مثال أو صورة ذهنية، وانتبه إلى أن بعض الكلمات تُستخدم كاسم عام للطعام وبعضها لوجبة أو مكوّن محدد.', examples: [LessonExample('ekmek', 'خبز'), LessonExample('peynir', 'جبن'), LessonExample('yumurta', 'بيضة'), LessonExample('et', 'لحم'), LessonExample('sebze', 'خضروات'), LessonExample('meyve', 'فاكهة')], question: 'ما معنى peynir؟', options: ['خبز', 'جبن', 'حليب', 'بيض'], answer: 1, feedback: 'peynir تعني جبن.'),
    'a1-u5-2': LessonContent(goal: 'التعرّف إلى المشروبات وطلبها بطريقة بسيطة.', explanation: 'من المشروبات الشائعة su ماء، çay شاي، kahve قهوة، süt حليب، meyve suyu عصير فواكه. يمكن استخدام Bir ... lütfen لطلب شيء بأدب، أي واحد من ... من فضلك.', examples: [LessonExample('Bir çay, lütfen.', 'شاي واحد، من فضلك.'), LessonExample('Su istiyorum.', 'أريد ماءً.'), LessonExample('Kahve içer misin?', 'هل تشرب القهوة؟')], question: 'أي كلمة تعني «ماء»؟', options: ['süt', 'çay', 'su', 'kahve'], answer: 2, feedback: 'su تعني ماء.'),
    'a1-u5-3': LessonContent(goal: 'التحدث عن الوجبات وأوقات تناول الطعام.', explanation: 'وجبات اليوم: kahvaltı الإفطار، öğle yemeği الغداء، akşam yemeği العشاء. الفعل yemek يعني يأكل أو طعام بحسب السياق، وiçmek يعني يشرب. استخدم هذه الكلمات لوصف ما تتناوله خلال اليوم.', examples: [LessonExample('Kahvaltı yapıyorum.', 'أتناول الإفطار.'), LessonExample('Öğle yemeği yiyorum.', 'أتناول الغداء.'), LessonExample('Akşam çorba içiyorum.', 'أشرب الحساء مساءً.')], question: 'ما معنى kahvaltı؟', options: ['العشاء', 'الإفطار', 'الغداء', 'الحلوى'], answer: 1, feedback: 'kahvaltı تعني وجبة الإفطار.'),
    'a1-u5-4': LessonContent(goal: 'استخدام أحب ولا أحب عند الحديث عن الطعام.', explanation: 'للتعبير عن الإعجاب بشيء نستخدم hoşlanmak أو sevmek. مثال: Elma seviyorum (أحب التفاح). وللنفي نقول sevmiyorum (لا أحب). تذكّر أن نهاية الفعل تتغير بحسب الضمير والزمن.', examples: [LessonExample('Balık seviyorum.', 'أحب السمك.'), LessonExample('Kahve sevmiyorum.', 'لا أحب القهوة.'), LessonExample('Sebzeleri seviyor musun?', 'هل تحب الخضروات؟')], question: 'ما معنى sevmiyorum؟', options: ['أحب', 'لا أحب', 'أشرب', 'آكل'], answer: 1, feedback: 'sevmiyorum تعني لا أحب.'),
    'a1-u5-5': LessonContent(goal: 'السؤال عن الرغبة والاختيار بين الأطعمة.', explanation: 'Ne istersiniz؟ سؤال مهذب معناه ماذا ترغب؟، وNe istersin؟ صيغة غير رسمية. ويمكن أن تسأل Hangisini istersin؟ أيهما تريد؟. للإجابة استخدم ... istiyorum أو ... alayım.', examples: [LessonExample('Ne istersiniz?', 'ماذا ترغب؟ بصيغة مهذبة'), LessonExample('Bir çorba istiyorum.', 'أريد حساءً.'), LessonExample('Elma mı, muz mu?', 'تفاحة أم موزة؟')], question: 'ما معنى Ne istersiniz؟', options: ['أين تذهب؟', 'ماذا ترغب؟', 'كم عمرك؟', 'ما هذا؟'], answer: 1, feedback: 'Ne istersiniz؟ تعني ماذا ترغب؟ بصيغة مهذبة.'),
    'a1-u5-6': LessonContent(goal: 'طلب الطعام والشراب في مقهى أو مطعم.', explanation: 'استخدم عبارات مهذبة عند الطلب: Bir menü alabilir miyim؟ (هل يمكنني الحصول على قائمة؟)، Bir kahve lütfen (قهوة من فضلك)، Hesap lütfen (الحساب من فضلك). كلمة lütfen تجعل الطلب أكثر تهذيباً.', examples: [LessonExample('Menü alabilir miyim?', 'هل يمكنني الحصول على قائمة؟'), LessonExample('Bir çorba lütfen.', 'حساء من فضلك.'), LessonExample('Hesap lütfen.', 'الحساب من فضلك.')], question: 'كيف تطلب الحساب؟', options: ['Menü lütfen.', 'Hesap lütfen.', 'Su nerede?', 'Günaydın.'], answer: 1, feedback: 'Hesap lütfen تعني الحساب من فضلك.'),
    'a1-u5-7': LessonContent(goal: 'فهم الأسعار والسؤال عن تكلفة الطعام.', explanation: 'للسؤال عن السعر استخدم Ne kadar؟ أي كم السعر؟ أو Bu kaç lira؟ أي بكم هذا بالليرة؟. كلمة lira هي الليرة، ويمكن أن تذكر الرقم قبلها. راجع الأرقام التي تعلمتها في الوحدة الثانية.', examples: [LessonExample('Bu ne kadar?', 'كم سعر هذا؟'), LessonExample('Kaç lira?', 'كم ليرة؟'), LessonExample('Elli lira.', 'خمسون ليرة.')], question: 'أي سؤال يعني «كم السعر؟»', options: ['Ne kadar?', 'Nerelisin?', 'Ne zaman?', 'Kim bu?'], answer: 0, feedback: 'Ne kadar؟ تُستخدم للسؤال عن السعر أو المقدار.'),
    'a1-u5-8': LessonContent(goal: 'فهم حوار قصير بين الزبون والعامل في المطعم.', explanation: 'استمع أو اقرأ الحوار وحدد من يطلب ومن يجيب. لاحظ كلمات القائمة والطلب والتفضيل والحساب. في المطعم قد يقول العامل Buyurun (تفضل)، ويجيب الزبون بطلبه مع lütfen.', examples: [LessonExample('Garson: Buyurun, ne istersiniz?', 'النادل: تفضل، ماذا ترغب؟'), LessonExample('Müşteri: Bir çorba ve su lütfen.', 'الزبون: حساء وماء من فضلك.'), LessonExample('Garson: Başka bir şey?', 'النادل: شيء آخر؟'), LessonExample('Müşteri: Hayır, teşekkürler.', 'الزبون: لا، شكراً.')], question: 'ماذا تعني Başka bir şey؟', options: ['شيء آخر؟', 'كم السعر؟', 'القائمة هنا', 'أنا جائع'], answer: 0, feedback: 'Başka bir şey؟ تعني هل تريد شيئاً آخر؟'),
    'a1-u5-9': LessonContent(goal: 'مراجعة الطعام والمشروبات والوجبات والطلب والأسعار.', explanation: 'تدرّب على تسمية ثلاثة أطعمة ومشروبين، وقل ما تحبه وما لا تحبه، ثم مثّل حواراً قصيراً في مطعم يتضمن الطلب والسؤال عن السعر وطلب الحساب.', examples: [LessonExample('Bir tost ve çay istiyorum.', 'أريد شطيرة محمصة وشاياً.'), LessonExample('Bu ne kadar?', 'كم سعر هذا؟'), LessonExample('Hesap lütfen.', 'الحساب من فضلك.')], question: 'اختر العبارة الصحيحة لطلب «ماء من فضلك».', options: ['Bir su lütfen.', 'Su nerelisin?', 'Su kaç yaşında?', 'Ben su değilim.'], answer: 0, feedback: 'Bir su lütfen طلب بسيط للماء: ماء واحد من فضلك.'),

    'a1-u6-1': LessonContent(goal: 'التعرّف إلى أيام الأسبوع واستخدامها في جمل بسيطة.', explanation: 'أيام الأسبوع بالتركية: pazartesi الاثنين، salı الثلاثاء، çarşamba الأربعاء، perşembe الخميس، cuma الجمعة، cumartesi السبت، pazar الأحد. كلمة bugün تعني اليوم، وyarın تعني غداً، وdün تعني أمس.', examples: [LessonExample('Bugün pazartesi.', 'اليوم الاثنين.'), LessonExample('Yarın salı.', 'غداً الثلاثاء.'), LessonExample('Pazar günü dinleniyorum.', 'أستريح يوم الأحد.')], question: 'ما معنى cuma؟', options: ['الاثنين', 'الأربعاء', 'الجمعة', 'الأحد'], answer: 2, feedback: 'cuma تعني الجمعة.'),
    'a1-u6-2': LessonContent(goal: 'تسمية أشهر السنة وفهم ترتيبها.', explanation: 'أشهر السنة: ocak يناير، şubat فبراير، mart مارس، nisan أبريل، mayıs مايو، haziran يونيو، temmuz يوليو، ağustos أغسطس، eylül سبتمبر، ekim أكتوبر، kasım نوفمبر، aralık ديسمبر. تُكتب أسماء الأشهر بحرف صغير عادةً داخل الجملة.', examples: [LessonExample('Ocak', 'يناير'), LessonExample('Mayıs', 'مايو'), LessonExample('Ağustos', 'أغسطس'), LessonExample('Aralık', 'ديسمبر')], question: 'أي شهر يعني eylül؟', options: ['يونيو', 'سبتمبر', 'نوفمبر', 'فبراير'], answer: 1, feedback: 'eylül هو شهر سبتمبر.'),
    'a1-u6-3': LessonContent(goal: 'قراءة التاريخ والسؤال عن اليوم والتاريخ.', explanation: 'للسؤال عن التاريخ قل Bugün ayın kaçı؟ أي كم تاريخ اليوم؟. ويمكن ذكر التاريخ بصيغة 5 Mayıs (5 مايو). كلمة tarih تعني التاريخ، وhangi gün؟ تعني أي يوم؟. عند كتابة التاريخ استخدم الأرقام واسم الشهر.', examples: [LessonExample('Bugün ayın kaçı?', 'كم تاريخ اليوم؟'), LessonExample('Bugün 5 Mayıs.', 'اليوم الخامس من مايو.'), LessonExample('Bugün hangi gün?', 'أي يوم اليوم؟')], question: 'ما معنى Bugün hangi gün؟', options: ['كم الساعة؟', 'أي يوم اليوم؟', 'ما الشهر القادم؟', 'أين تذهب؟'], answer: 1, feedback: 'Bugün hangi gün؟ تعني أي يوم اليوم؟'),
    'a1-u6-4': LessonContent(goal: 'السؤال عن الوقت وقراءة الساعة الكاملة.', explanation: 'للسؤال عن الوقت نقول Saat kaç؟ أي كم الساعة؟. للإجابة عن الساعة الكاملة نستخدم Saat üç (الساعة الثالثة)، Saat beş (الخامسة). كلمة saat تعني ساعة أو وقت بحسب السياق. تدرب على الأرقام من واحد إلى اثني عشر.', examples: [LessonExample('Saat kaç?', 'كم الساعة؟'), LessonExample('Saat bir.', 'الساعة الواحدة.'), LessonExample('Saat dokuz.', 'الساعة التاسعة.')], question: 'كيف تقول «كم الساعة؟»', options: ['Bugün ne?', 'Saat kaç?', 'Hangi gün?', 'Kaç yaşında?'], answer: 1, feedback: 'Saat kaç؟ هو السؤال الشائع عن الوقت.'),
    'a1-u6-5': LessonContent(goal: 'التعبير عن الدقائق والنصف والربع في الوقت.', explanation: 'بعد تعلم الساعة الكاملة، تعرّف إلى buçuk بمعنى النصف، çeyrek بمعنى ربع، geçiyor للدقائق التي تجاوزت الساعة، وvar للدقائق المتبقية حتى الساعة التالية. في هذه المرحلة ركّز على العبارات الشائعة مثل saat üç buçuk (الثالثة والنصف) وüçü çeyrek geçiyor (الثالثة والربع).', examples: [LessonExample('Saat iki buçuk.', 'الساعة الثانية والنصف.'), LessonExample('Saat dördü çeyrek geçiyor.', 'الساعة الرابعة والربع.'), LessonExample('Beşe çeyrek var.', 'بقي ربع ساعة على الخامسة.')], question: 'ما معنى Saat iki buçuk؟', options: ['الثانية تماماً', 'الثانية والنصف', 'الثالثة والنصف', 'الثانية والربع'], answer: 1, feedback: 'buçuk تعني النصف؛ أي الثانية والنصف.'),
    'a1-u6-6': LessonContent(goal: 'وصف الروتين اليومي باستخدام أفعال شائعة.', explanation: 'من أفعال الروتين uyanmak يستيقظ، kalkmak ينهض، kahvaltı yapmak يتناول الإفطار، çalışmak يعمل أو يدرس، gitmek يذهب، dönmek يعود، uyumak ينام. استخدم المضارع المستمر -yor للحديث عن نشاط يحدث الآن أو عن الروتين القريب بحسب السياق.', examples: [LessonExample('Saat yedide uyanıyorum.', 'أستيقظ في السابعة.'), LessonExample('Kahvaltı yapıyorum.', 'أتناول الإفطار.'), LessonExample('Okula gidiyorum.', 'أذهب إلى المدرسة.')], question: 'ما معنى uyumak؟', options: ['يستيقظ', 'يذهب', 'ينام', 'يعمل'], answer: 2, feedback: 'uyumak تعني ينام.'),
    'a1-u6-7': LessonContent(goal: 'استخدام كلمات التكرار لوصف العادات اليومية.', explanation: 'تساعدك كلمات التكرار على وصف الروتين: her gün كل يوم، genellikle عادةً، bazen أحياناً، sık sık كثيراً، nadiren نادراً، hiç أبداً في سياق النفي. ضع كلمة التكرار غالباً قبل الفعل أو في موضع يوضح معنى الجملة.', examples: [LessonExample('Her gün kitap okuyorum.', 'أقرأ كتاباً كل يوم.'), LessonExample('Bazen yürüyüş yapıyorum.', 'أحياناً أتمشى.'), LessonExample('Genellikle erken kalkıyorum.', 'عادةً أستيقظ مبكراً.')], question: 'ما معنى bazen؟', options: ['دائماً', 'أحياناً', 'أبداً', 'غداً'], answer: 1, feedback: 'bazen تعني أحياناً.'),
    'a1-u6-8': LessonContent(goal: 'السؤال عن المواعيد والاتفاق على وقت للقاء.', explanation: 'يمكن السؤال Ne zaman؟ (متى؟)، Saat kaçta؟ (في أي ساعة؟)، وHangi gün؟ (في أي يوم؟). للتعبير عن وقت وقوع الفعل نضيف لاحقة الحالة الزمنية -da/-de أو -ta/-te بحسب الانسجام الصوتي والتغيرات الصوتية، مثل saat üçte (في الساعة الثالثة) وpazartesi günü (يوم الاثنين).', examples: [LessonExample('Ne zaman buluşuyoruz?', 'متى نلتقي؟'), LessonExample('Saat kaçta?', 'في أي ساعة؟'), LessonExample('Saat beşte buluşalım.', 'لنلتقِ في الساعة الخامسة.')], question: 'أي عبارة تعني «في أي ساعة؟»', options: ['Saat kaçta?', 'Saat kaç?', 'Kaç yaşında?', 'Nerede?'], answer: 0, feedback: 'Saat kaçta؟ تسأل عن وقت حدوث النشاط.'),
    'a1-u6-9': LessonContent(goal: 'مراجعة الأيام والأشهر والتاريخ والساعة والروتين اليومي.', explanation: 'كوّن وصفاً ليومك من خمس جمل: اذكر اليوم، ووقت الاستيقاظ، ووجبة الإفطار، وموعد الذهاب إلى المدرسة أو العمل، ووقت النوم. أضف كلمة تكرار مثل her gün أو bazen.', examples: [LessonExample('Bugün cuma.', 'اليوم الجمعة.'), LessonExample('Saat yedide kalkıyorum.', 'أنهض في السابعة.'), LessonExample('Akşam saat onda uyuyorum.', 'أنام مساءً في الساعة العاشرة.')], question: 'اختر العبارة الصحيحة لمعنى «أستيقظ كل يوم في السابعة».', options: ['Her gün saat yedide uyanıyorum.', 'Yarın cuma.', 'Saat kaç?', 'Pazar günü dinleniyorum.'], answer: 0, feedback: 'Her gün تعني كل يوم، وsaat yedide تعني في السابعة، وuyanıyorum تعني أستيقظ.'),

    'a1-u7-1': LessonContent(goal: 'التعرّف إلى أسماء المنزل والغرف الأساسية.', explanation: 'كلمة ev تعني منزل أو بيت. من أسماء الغرف oda غرفة، oturma odası غرفة الجلوس، yatak odası غرفة النوم، mutfak مطبخ، banyo حمّام، balkon شرفة، bahçe حديقة. لاحظ أن بعض أسماء الغرف مركّبة من كلمتين.', examples: [LessonExample('ev', 'منزل'), LessonExample('mutfak', 'مطبخ'), LessonExample('yatak odası', 'غرفة نوم'), LessonExample('oturma odası', 'غرفة جلوس'), LessonExample('banyo', 'حمّام')], question: 'ما معنى mutfak؟', options: ['غرفة نوم', 'مطبخ', 'حديقة', 'شرفة'], answer: 1, feedback: 'mutfak تعني مطبخ.'),
    'a1-u7-2': LessonContent(goal: 'تسمية قطع الأثاث والأشياء الموجودة في المنزل.', explanation: 'تعلّم أسماء الأثاث الشائعة: masa طاولة، sandalye كرسي، koltuk أريكة، yatak سرير، dolap خزانة، lamba مصباح، halı سجادة، perde ستارة. اربط كل كلمة بالغرفة التي توجد فيها عادةً.', examples: [LessonExample('masa ve sandalye', 'طاولة وكرسي'), LessonExample('yatak', 'سرير'), LessonExample('koltuk', 'أريكة'), LessonExample('dolap', 'خزانة'), LessonExample('lamba', 'مصباح')], question: 'أي كلمة تعني «سرير»؟', options: ['yatak', 'perde', 'halı', 'masa'], answer: 0, feedback: 'yatak تعني سرير.'),
    'a1-u7-3': LessonContent(goal: 'وصف المنزل والغرف باستخدام الصفات الأساسية.', explanation: 'يمكن وصف المنزل بكلمات büyük كبير، küçük صغير، geniş واسع، dar ضيّق، güzel جميل، temiz نظيف، eski قديم، yeni جديد. تأتي الصفة قبل الاسم: büyük ev منزل كبير، temiz oda غرفة نظيفة.', examples: [LessonExample('büyük bir ev', 'منزل كبير'), LessonExample('küçük oda', 'غرفة صغيرة'), LessonExample('temiz mutfak', 'مطبخ نظيف'), LessonExample('geniş balkon', 'شرفة واسعة')], question: 'ما معنى geniş؟', options: ['ضيق', 'واسع', 'قديم', 'متسخ'], answer: 1, feedback: 'geniş تعني واسع.'),
    'a1-u7-4': LessonContent(goal: 'التعبير عن وجود الأشياء أو عدم وجودها باستخدام var وyok.', explanation: 'تُستخدم var للتعبير عن وجود شيء، وyok للتعبير عن عدم وجوده. مثال: Evde balkon var (يوجد شرفة في المنزل)، Evde garaj yok (لا يوجد مرآب في المنزل). ضع اسم المكان في صيغة -da/-de بحسب الانسجام الصوتي.', examples: [LessonExample('Evde üç oda var.', 'يوجد في المنزل ثلاث غرف.'), LessonExample('Mutfakta masa var.', 'توجد طاولة في المطبخ.'), LessonExample('Bahçede havuz yok.', 'لا يوجد مسبح في الحديقة.')], question: 'أي كلمة تعبّر عن عدم وجود شيء؟', options: ['var', 'yok', 'çok', 'ile'], answer: 1, feedback: 'yok تعني غير موجود أو لا يوجد.'),
    'a1-u7-5': LessonContent(goal: 'تحديد مكان الأشياء داخل المنزل.', explanation: 'استخدم كلمات المكان لوصف موقع الأثاث: içinde داخل، üstünde فوق، altında تحت، yanında بجانب، önünde أمام، arkasında خلف، arasında بين. أمثلة: kitap masanın üstünde (الكتاب فوق الطاولة)، koltuk pencerenin yanında (الأريكة بجانب النافذة).', examples: [LessonExample('Kitap masanın üstünde.', 'الكتاب فوق الطاولة.'), LessonExample('Kedi koltuğun altında.', 'القطة تحت الأريكة.'), LessonExample('Lamba yatağın yanında.', 'المصباح بجانب السرير.')], question: 'ما معنى yanında؟', options: ['داخل', 'خلف', 'بجانب', 'تحت'], answer: 2, feedback: 'yanında تعني بجانب.'),
    'a1-u7-6': LessonContent(goal: 'استخدام لاحقة المكان -da/-de/-ta/-te للسؤال والإجابة عن الموقع.', explanation: 'تُضاف لاحقة المكان إلى الاسم للإجابة عن سؤال Nerede؟ (أين؟). نختار -da أو -de وفق آخر حركة، وقد تتحول d إلى t بعد بعض الحروف المهموسة مثل ç, f, h, k, p, s, ş, t. أمثلة: evde في المنزل، okulda في المدرسة، parkta في الحديقة العامة.', examples: [LessonExample('Evdeyim.', 'أنا في المنزل.'), LessonExample('Kitap çantada.', 'الكتاب في الحقيبة.'), LessonExample('Çocuk parkta.', 'الطفل في الحديقة.')], question: 'ما الصيغة الصحيحة لمعنى «في المنزل»؟', options: ['evda', 'evde', 'evta', 'evte'], answer: 1, feedback: 'ev تنتهي بحركة أمامية e، لذلك نقول evde.'),
    'a1-u7-7': LessonContent(goal: 'السؤال عن الأماكن والاتجاهات الأساسية داخل المنزل.', explanation: 'للسؤال عن مكان شيء نستخدم Nerede؟ (أين؟)، وللسؤال عن الاتجاه Ne tarafta؟ (في أي جهة؟). من كلمات الاتجاه sağ يمين، sol يسار، ön أمام، arka خلف، yukarı أعلى، aşağı أسفل. يمكن الإجابة بجملة قصيرة مثل Mutfakta (في المطبخ).', examples: [LessonExample('Banyo nerede?', 'أين الحمّام؟'), LessonExample('Sağ tarafta.', 'في الجهة اليمنى.'), LessonExample('Merdivenler yukarıda.', 'السلالم في الأعلى.')], question: 'ما معنى sol؟', options: ['يمين', 'يسار', 'أمام', 'أعلى'], answer: 1, feedback: 'sol تعني يسار.'),
    'a1-u7-8': LessonContent(goal: 'إجراء حوار بسيط لوصف المنزل ومكان الأثاث.', explanation: 'في الحوار اسأل عن المنزل أو الغرفة: Evin nasıl؟ (كيف منزلك؟)، Kaç odası var؟ (كم غرفة فيه؟)، Mutfak nerede؟ (أين المطبخ؟). أجب بصفة أو عدد أو موقع، واستخدم var/yok لتذكر ما يوجد وما لا يوجد.', examples: [LessonExample('A: Evin büyük mü?', 'أ: هل منزلك كبير؟'), LessonExample('B: Hayır, küçük ama güzel.', 'ب: لا، إنه صغير لكنه جميل.'), LessonExample('A: Salonda ne var?', 'أ: ماذا يوجد في غرفة الجلوس؟'), LessonExample('B: Bir koltuk ve iki sandalye var.', 'ب: توجد أريكة واحدة وكرسيان.')], question: 'ماذا تعني Salonda ne var؟', options: ['أين غرفة الجلوس؟', 'ماذا يوجد في غرفة الجلوس؟', 'هل المنزل كبير؟', 'كم سعر الأريكة؟'], answer: 1, feedback: 'Salonda ne var؟ تسأل عمّا يوجد في غرفة الجلوس.'),
    'a1-u7-9': LessonContent(goal: 'مراجعة المنزل والغرف والأثاث والصفات والمواقع والاتجاهات.', explanation: 'صف منزلاً من خمس جمل: اذكر عدد الغرف، وصف غرفة واحدة، وسمّ قطعتين من الأثاث، ثم حدّد مكان شيء باستخدام üstünde أو yanında، واستخدم var أو yok في جملة.', examples: [LessonExample('Evimiz küçük ama güzel.', 'منزلنا صغير لكنه جميل.'), LessonExample('Mutfakta bir masa var.', 'توجد طاولة في المطبخ.'), LessonExample('Koltuk pencerenin yanında.', 'الأريكة بجانب النافذة.')], question: 'اختر الجملة التي تعني «يوجد سرير في غرفة النوم».', options: ['Yatak odasında yatak var.', 'Mutfakta masa yok.', 'Ev çok büyük.', 'Koltuk salonda.'], answer: 0, feedback: 'Yatak odasında تعني في غرفة النوم، وyatak var تعني يوجد سرير.'),
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
